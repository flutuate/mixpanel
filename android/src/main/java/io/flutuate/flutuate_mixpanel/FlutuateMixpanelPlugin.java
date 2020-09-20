package io.flutuate.flutuate_mixpanel;

import android.content.Context;

import androidx.annotation.NonNull;

import com.mixpanel.android.mpmetrics.MixpanelAPI;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutuateMixpanelPlugin
implements FlutterPlugin, MethodCallHandler
{
    private static final String name = "flutuate_mixpanel";
    private static final Map<String, Object> EMPTY_HASHMAP = new HashMap<>();

    private MethodChannel channel;
    private Context context;
    private MixpanelAPI mixpanel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        //channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), FlutuateMixpanelPlugin.name);
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), FlutuateMixpanelPlugin.name);
		context = flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), FlutuateMixpanelPlugin.name);
        channel.setMethodCallHandler(new FlutuateMixpanelPlugin(registrar.context()));
    }

	public FlutuateMixpanelPlugin() 
	{}

	public FlutuateMixpanelPlugin(Context context) {
        this.context = context;
	}

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getInstance":
                getInstance(call, result);
                break;
            case "flush":
                flush(result);
                break;
            case "track":
                track(call, result);
                break;
            case "trackMap":
                trackMap(call, result);
                break;
            case "getDeviceInfo":
                getDeviceInfo(result);
                break;
            case "getDistinctId":
                getDistinctId(result);
                break;
            case "optInTracking":
                optInTracking(result);
                break;
            case "optOutTracking":
                optOutTracking(result);
                break;
            case "reset":
                reset(result);
                break;
            case "identify":
                identify(call, result);
                break;
            case "setIdentifiedProperties":
                setIdentifiedProperties(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void getInstance(MethodCall call, Result result) {
        final String token = call.argument("token");
        if( token == null ) {
            throw new RuntimeException("Your Mixpanel Token was not informed");
        }

        if (call.hasArgument("optOutTrackingDefault")) {
            Boolean optOutTrackingDefault = call.<Boolean>argument("optOutTrackingDefault");
            mixpanel = MixpanelAPI.getInstance(context, token, optOutTrackingDefault == null ? false : optOutTrackingDefault);
        } else {
            mixpanel = MixpanelAPI.getInstance(context, token);
		}
        result.success(Integer.toString(mixpanel.hashCode()));
    }

    private void flush(Result result) {
        mixpanel.flush();
        result.success(null);
    }

    private void track(MethodCall call, Result result) {
        String eventName = call.argument("eventName");
        Map<String, Object> mapProperties = call.<HashMap<String, Object>>argument("properties");
        JSONObject properties;
        try {
            properties = extractJSONObject(mapProperties == null ? EMPTY_HASHMAP : mapProperties);
        } catch (JSONException e) {
            result.error(e.getClass().getName(), e.toString(), "");
            return;
        }

        mixpanel.track(eventName, properties);

        result.success(null);
    }

    private void trackMap(MethodCall call, Result result) {
        String eventName = call.argument("eventName");
        Map<String, Object> properties = call.<HashMap<String, Object>>argument("properties");
        mixpanel.trackMap(eventName, properties);
        result.success(null);
    }

    private void setIdentifiedProperties(MethodCall call, Result result) {
        Map<String, Object> mapProperties = call.<HashMap<String, Object>>argument("properties");
        JSONObject properties;
        try {
            properties = extractJSONObject(mapProperties == null ? EMPTY_HASHMAP : mapProperties);
            mixpanel.getPeople().set(properties);
    
        } catch (JSONException e) {
            result.error(e.getClass().getName(), e.toString(), "");
            return;
        }
        result.success(null);
    }

    @SuppressWarnings("unchecked")
    private JSONObject extractJSONObject(Map<String, Object> properties) throws JSONException {
        JSONObject jsonObject = new JSONObject();
        if (properties != null) {
            for (String key : properties.keySet()) {
                Object value = properties.get(key);
                if (value instanceof Map<?, ?>) {
                    value = extractJSONObject((Map<String, Object>) value);
                }
                jsonObject.put(key, value);
            }
        }
        return jsonObject;
    }

    private void getDeviceInfo(Result result) {
        Map<String, String> map = mixpanel.getDeviceInfo();
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

    private void identify(MethodCall call, Result result) {
        String distinctId = call.argument("distinctId");
        mixpanel.identify(distinctId);
        mixpanel.getPeople().identify(distinctId);
        result.success(null);
    }
}
