package io.flutuate.flutuate_mixpanel;

import android.content.Context;

import androidx.annotation.NonNull;

import com.mixpanel.android.mpmetrics.MixpanelAPI;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class FlutuateMixpanelPlugin
        implements FlutterPlugin, MethodCallHandler {
    public  static final String name = "flutuate_mixpanel";
    private static final Map<String, Object> EMPTY_HASHMAP = new HashMap<>();

    private MethodChannel channel;
    private Context context;
    private MixpanelAPI mixpanel;

    public FlutuateMixpanelPlugin() {
    }

    public FlutuateMixpanelPlugin(Context context) {
        this.context = context;
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

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        //channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), FlutuateMixpanelPlugin.name);
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), FlutuateMixpanelPlugin.name);
        context = flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
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
            case "registerSuperProperties":
                registerSuperProperties(call, result);
                break;
            case "registerSuperPropertiesOnce":
                registerSuperPropertiesOnce(call, result);
                break;
            case "clearSuperProperties":
                clearSuperProperties(result);
                break;
            case "alias":
                alias(call, result);
                break;
            case "people":
                handlePeopleMethods(call, result);
                break;
            case "timeEvent":
                timeEvent(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void getInstance(MethodCall call, Result result) {
        final String token = call.argument("token");
        if (token == null) {
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

    private void timeEvent(MethodCall call, Result result) {
        String eventName = call.argument("eventName");
        mixpanel.timeEvent(eventName);
        result.success(null);
    }

    private void trackMap(MethodCall call, Result result) {
        String eventName = call.argument("eventName");
        Map<String, Object> properties = call.<HashMap<String, Object>>argument("properties");
        mixpanel.trackMap(eventName, properties);
        result.success(null);
    }

    private void registerSuperProperties(MethodCall call, Result result) {
        Map<String, Object> mapProperties = call.<HashMap<String, Object>>argument("properties");
        JSONObject properties;
        try {
            properties = extractJSONObject(mapProperties == null ? EMPTY_HASHMAP : mapProperties);
        } catch (JSONException e) {
            result.error(e.getClass().getName(), e.toString(), "");
            return;
        }
        mixpanel.registerSuperProperties(properties);
        result.success(null);
    }

    private void registerSuperPropertiesOnce(MethodCall call, Result result) {
        Map<String, Object> mapProperties = call.<HashMap<String, Object>>argument("properties");
        JSONObject properties;
        try {
            properties = extractJSONObject(mapProperties == null ? EMPTY_HASHMAP : mapProperties);
        } catch (JSONException e) {
            result.error(e.getClass().getName(), e.toString(), "");
            return;
        }
        mixpanel.registerSuperPropertiesOnce(properties);
        result.success(null);
    }

    private void clearSuperProperties(Result result) {
        mixpanel.clearSuperProperties();
        result.success(null);
    }

    private void alias(MethodCall call, Result result) {
        String alias = call.argument("alias");
        String distinctId = call.argument("distinctId");
        mixpanel.alias(alias, distinctId);
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


    // People methods

    private void handlePeopleMethods(MethodCall call, Result result) {
        MixpanelAPI.People people = mixpanel.getPeople();
        Map<String, Object> params = call.<HashMap<String, Object>>argument("params");
        String method = call.argument("method");
        if (method != null) {
            switch (method) {
                case "addPushDeviceToken":
                    addPushToken(params, people);
                    break;
                case "removeAllPushDeviceTokens":
                    people.clearPushRegistrationId();
                    break;
                case "removePushDeviceToken":
                    removePushToken(params, people);
                    break;
                case "set":
                    people.set(propertiesFromArguments(params));
                    break;
                case "setOnce":
                    people.setOnce(propertiesFromArguments(params));
                    break;
                case "unset":
                    unset(params, people);
                    break;
                case "increment":
                    increment(params, people);
                    break;
                case "incrementBy":
                    incrementBy(params, people);
                    break;
                case "append":
                    append(params, people);
                    break;
                case "remove":
                    remove(params, people);
                    break;
                case "trackCharge":
                    trackCharge(params, people);
                    break;
                case "clearCharges":
                    people.clearCharges();
                    break;
                case "deleteUser":
                    people.deleteUser();
                    break;

            }
        }
    }

    private void trackCharge(Map<String, Object> params, MixpanelAPI.People people) {
        if (params == null) {
            return;
        }
        try {
            double value = Double.parseDouble(params.get("ammount").toString());
            JSONObject props = new JSONObject();
            if (params.containsKey("properties") && params.get("properties") instanceof Map) {
                props = extractJSONObject((Map<String, Object>) params.get("properties"));
            }
            people.trackCharge(value, props);
        } catch (NumberFormatException e) {

        } catch (JSONException e) {
            e.printStackTrace();
        }
        for (String key : params.keySet()) {
            people.remove(key, params.get(key));
        }
    }


    private void unset(Map<String, Object> params, MixpanelAPI.People people) {
        if (params == null) {
            return;
        }
        if (params.containsKey("names") && params.get("names") instanceof List) {
            List<Object> names = (List<Object>) params.get("names");
            for (Object name : names) {
                if (name instanceof String) {
                    people.unset(name.toString());
                }
            }


        }
    }

    private void remove(Map<String, Object> params, MixpanelAPI.People people) {
        if (params == null) {
            return;
        }
        for (String key : params.keySet()) {
            people.remove(key, params.get(key));
        }
    }

    private void append(Map<String, Object> params, MixpanelAPI.People people) {
        if (params == null) {
            return;
        }
        for (String key : params.keySet()) {
            people.append(key, params.get(key));
        }
    }

    private void incrementBy(Map<String, Object> params, MixpanelAPI.People people) {
        if (params == null) {
            return;
        }
        if (!params.containsKey("property") || !params.containsKey("by")) {
            return;
        }

        String property = params.get("property").toString();
        try {

            double value = Double.parseDouble(params.get("by").toString());
            people.increment(property, value);
        } catch (NumberFormatException e) {

        }
    }

    private void increment(Map<String, Object> params, MixpanelAPI.People people) {
        if (params == null) {
            return;
        }
        for (String key : params.keySet()) {
            Object value = params.get(key);
            try {
                people.increment(key, Double.parseDouble(value.toString()));
            } catch (NumberFormatException e) {
            }
        }
    }

    private void addPushToken(Map<String, Object> params, MixpanelAPI.People people) {
        String token = pushTokenFromArguments(params);
        if (token != null) {
            people.setPushRegistrationId(token);
        }
    }

    private void removePushToken(Map<String, Object> params, MixpanelAPI.People people) {
        String token = pushTokenFromArguments(params);
        if (token != null) {
            people.clearPushRegistrationId(token);
        }
    }

    private JSONObject propertiesFromArguments(Map<String, Object> properties) {
        if (properties == null) {
            return new JSONObject();
        }
        try {
            return extractJSONObject(properties);
        } catch (JSONException e) {
            e.printStackTrace();
            return new JSONObject();
        }
    }


    private String pushTokenFromArguments(Map<String, Object> params) {
        if (params.containsKey("token")) {
            return params.get("token").toString();
        }
        return null;
    }
}
