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
  static final String name = "flutuate.io/plugins/mixpanel";

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
		getInstance(call, result);
    }
    else if (call.method.equals("flush")) {
      flush(result);
    }
    else if (call.method.equals("track")) {
        track(call, result);
    }
    else if (call.method.equals("trackMap")) {
        trackMap(call, result);
    }
	else if(call.method.equals("getDeviceInfo"))  {
      getDeviceInfo(result);
	}		
	else if (call.method.equals("getDistinctId")) {
      getDistinctId(result);
	}
	else if (call.method.equals("optInTracking")) {
		optInTracking(result);
	}
	else if (call.method.equals("optOutTracking")) {
		optOutTracking(result);
	}
	else if (call.method.equals("reset")) {
		reset(result);
	}
    else {
      result.notImplemented();
    }
  }

    private void getInstance(MethodCall call, Result result) {
        String token = call.<String>argument("token");
        if( call.hasArgument("optOutTrackingDefault") ) {
            boolean optOutTrackingDefault = call.<Boolean>argument("optOutTrackingDefault");
            mixpanel = MixpanelAPI.getInstance(registrar.context(), token, optOutTrackingDefault);
        }
        else
            mixpanel = MixpanelAPI.getInstance(registrar.context(), token);
        result.success(mixpanel.hashCode());
    }

  private void flush(Result result) {
    mixpanel.flush();
    result.success(null);
  }

    private void track(MethodCall call, Result result) {
        String eventName = call.<String>argument("eventName");
        Map<String, Object> mapProperties = call.<HashMap<String, Object>>argument("properties");
        JSONObject properties = null;
        try {
            properties = extractJSONObject(mapProperties);
        }
        catch (JSONException e) {
            result.error(e.getClass().getName(), e.toString(), "");
            return;
        }

        mixpanel.track(eventName, properties);

        result.success(null);
    }

    private void trackMap(MethodCall call, Result result) {
        String eventName = call.<String>argument("eventName");
        Map<String, Object> properties = call.<HashMap<String, Object>>argument("properties");
        mixpanel.trackMap(eventName, properties);
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

  private void getDeviceInfo(Result result) {
    Map<String,String> map = mixpanel.getDeviceInfo();
    result.success(map);
  }

  private void getDistinctId(Result result) {
    result.success(mixpanel.getDistinctId());
  }

  private void optInTracking(Result result) {
    mixpanel.optInTracking();
    result.success(null);
  }

  private void optOutTracking(Result result) {
    mixpanel.optOutTracking();
    result.success(null);
  }

  private void reset(Result result) {
    mixpanel.reset();
    result.success(null);
  }
  
}
