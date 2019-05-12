package io.flutuate.plugin.mixpanel;

import com.mixpanel.android.mpmetrics.MixpanelAPI;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class MixpanelPlugin
implements MethodCallHandler
{
  public static final String name = "flutuate.io/plugins/mixpanel";

  private final PluginRegistry.Registrar registrar;
  private MixpanelAPI mixpanel;

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), MixpanelPlugin.name);
    channel.setMethodCallHandler(new MixpanelPlugin(registrar));
  }

  private MixpanelPlugin(PluginRegistry.Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getInstance")) {
      getInstance(call.<String>argument("token"), result);
    }
    else if (call.method.equals("flush")) {
      flush(result);
    }
    else if (call.method.equals("track")) {
      String eventName = call.<String>argument("eventName");
      Map<String, Object> properties = call.<HashMap<String, Object>>argument("properties");
      track(eventName, properties, result);
    }
    else {
      result.notImplemented();
    }
  }

  private void getInstance(String token, Result result) {
    mixpanel = MixpanelAPI.getInstance(registrar.context(), token);
    result.success(mixpanel.hashCode());
  }

  private void flush(Result result) {
    mixpanel.flush();
    result.success(null);
  }

  private void track(String eventName, Map<String, Object> properties, Result result) {
    JSONObject jsonObject;
    try {
      jsonObject = extractJSONObject(properties);
      mixpanel.track(eventName, jsonObject);
    }
    catch (JSONException e) {
      result.error(e.getClass().getName(), e.toString(), "");
      return;
    }
    result.success(null);
  }

  private JSONObject extractJSONObject(Map<String, Object> properties) throws JSONException {
    JSONObject jsonObject = new JSONObject();
    for (String key : properties.keySet()) {
      Object value = properties.get(key);
      if (value instanceof Map<?, ?>) {
        value = extractJSONObject((Map<String, Object>) value);
      }
      jsonObject.put(key, value);
    }
    return jsonObject;
  }
}
