    import Flutter
    import UIKit
    import Mixpanel

    public class SwiftFlutuateMixpanelPlugin: NSObject, FlutterPlugin {
        public static func register(with registrar: FlutterPluginRegistrar) {
            let channel = FlutterMethodChannel(name: "flutuate_mixpanel",
                                               binaryMessenger: registrar.messenger())
            let instance = SwiftFlutuateMixpanelPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
        }

        public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            switch call.method {
            case "getInstance":
                self.getInstance(call: call, result: result)
                break
            case "flush":
                self.flush(result: result)
                break
            case "track":
                self.track(call: call, result: result)
                break
            case "trackMap":
                self.trackMap(call: call, result: result)
                break
            case "getDeviceInfo":
                self.getDeviceInfo(result: result)
                break
            case "getDistinctId":
                self.getDistinctId(result: result)
                break
            case "optInTracking":
                self.optInTracking(result: result)
                break
            case "optOutTracking":
                self.optOutTracking(result: result)
                break
            case "reset":
                self.reset(result: result)
                break
            case "identify":
                self.identify(call: call, result: result)
                break
            case "registerSuperProperties":
                self.registerSuperProperties(call: call, result: result)
                break;
            case "registerSuperPropertiesOnce":
                self.registerSuperPropertiesOnce(call: call, result: result)
                break;
            case "clearSuperProperties":
                self.clearSuperProperties(result: result)
                break;
            case "alias":
                self.alias(call: call, result: result)
                break
            case "people":
                self.handlePeopleApi(call: call, result: result)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
            return
        }

        //http://online.swiftplayground.run/
        //https://developer.mixpanel.com/docs/swift
        //https://api.flutter.dev/objcdoc/Classes/FlutterMethodChannel.html
        //https://stackoverflow.com/questions/50078947/how-to-implement-a-flutterplugins-method-handler-in-swift
        //https://stackoverflow.com/questions/57664458/how-to-use-passed-parameters-in-swift-setmethodcallhandler-self-methodnamere
        private func getInstance(call: FlutterMethodCall, result: @escaping FlutterResult)
        {
            var instance: MixpanelInstance;
            if let arguments = call.arguments as? [String:Any] {
                if let token = arguments["token"] as? String {
                    if let optOutTrackingDefault = arguments["optOutTrackingDefault"] as? Bool {
                        instance = Mixpanel.initialize(token: token, optOutTrackingByDefault: optOutTrackingDefault)
                    } else {
                        instance = Mixpanel.initialize(token: token)
                    }
                    Mixpanel.mainInstance().loggingEnabled = true
                    return result(instance.name)
                }
            }
        }

        private func flush(result: @escaping FlutterResult) {
            Mixpanel.mainInstance().flush()
        }

        private func track(call: FlutterMethodCall, result: @escaping FlutterResult) {
            let arguments = call.arguments as? [String:Any]
            let eventName = arguments?["eventName"] as? String
            let properties = arguments?["properties"] as? [String: Any]
            let mappedProperties = mapDictionary(properties: properties)
            Mixpanel.mainInstance().track(event: eventName, properties: mappedProperties);
        }

        private func mapDictionary(properties: [String: Any]?) -> Properties? {
            guard let properties = properties else { return nil }
            return properties.compactMapValues { property -> MixpanelType? in
                return map(property: property)
            }
        }

        private func mapArray(properties: [Any]?) -> MixpanelType? {
            guard let properties = properties else { return nil }
            return properties.compactMap { property -> MixpanelType? in
                return map(property: property)
            }
        }

        private func map(property: Any) -> MixpanelType? {
            if let property = property as? String {
                return property as MixpanelType
            } else if let property = property as? Int {
                return property as MixpanelType
            } else if let property = property as? UInt {
                return property as MixpanelType
            } else if let property = property as? Double {
                return property as MixpanelType
            } else if let property = property as? Float {
                return property as MixpanelType
            } else if let property = property as? Bool {
                return property as MixpanelType
            } else if let property = property as? Date {
                return property as MixpanelType
            } else if let property = property as? URL {
                return property as MixpanelType
            } else if let property = property as? NSNull {
                return property as MixpanelType
            } else if let arrayProperties = property as? [Any] {
                return mapArray(properties: arrayProperties)
            } else if let dictProperties = property as? [String: Any] {
                return mapDictionary(properties: dictProperties)
            }
            return nil
        }

        private func trackMap(call: FlutterMethodCall, result: @escaping FlutterResult) {
            track(call: call, result: result)
        }

        private func getDeviceInfo(result: @escaping FlutterResult) {
            //TODO verify is exists// let map = Mixpanel.mainInstance().getDeviceInfo() as? Dictionary<String, String>
            let map : [String:String] = [:]
            result(map);
        }

        private func getDistinctId(result: @escaping FlutterResult) {
            result(Mixpanel.mainInstance().distinctId);
        }

        private func optInTracking(result: @escaping FlutterResult) {
            Mixpanel.mainInstance().optInTracking()
        }

        private func optOutTracking(result: @escaping FlutterResult) {
            Mixpanel.mainInstance().optOutTracking()
        }

        private func reset(result: @escaping FlutterResult) {
            Mixpanel.mainInstance().reset()
        }

        private func identify(call: FlutterMethodCall, result: @escaping FlutterResult) {
            let arguments = call.arguments as? [String : Any]
            let distinctId = (arguments?["distinctId"] as? String)!
            Mixpanel.mainInstance().identify(distinctId: distinctId);
        }
        
        private func registerSuperProperties(call: FlutterMethodCall, result: @escaping FlutterResult) {
            let arguments = call.arguments as? [String:Any]
            let properties = arguments?["properties"] as? [String: Any]
            let mappedProperties = mapDictionary(properties: properties)
            Mixpanel.mainInstance().registerSuperProperties(mappedProperties!)
        }

        private func registerSuperPropertiesOnce(call: FlutterMethodCall, result: @escaping FlutterResult) {
            let arguments = call.arguments as? [String:Any]
            let properties = arguments?["properties"] as? [String: Any]
            let mappedProperties = mapDictionary(properties: properties)
            Mixpanel.mainInstance().registerSuperPropertiesOnce(mappedProperties!)
        }

        private func clearSuperProperties(result: @escaping FlutterResult) {
            Mixpanel.mainInstance().clearSuperProperties()
        }
        
        private func alias(call: FlutterMethodCall, result: @escaping FlutterResult) {
            let arguments = call.arguments as? [String : Any]
            let alias = (arguments?["alias"] as? String)!
            let distinctId = (arguments?["distinctId"] as? String)!
            Mixpanel.mainInstance().createAlias(alias, distinctId: distinctId)
        }

        // MARK: People API

        private func handlePeopleApi(call: FlutterMethodCall, result: @escaping  FlutterResult) {
            let arguments = call.arguments as? [String:Any]
            let peopleMethod = arguments?["method"] as? String
            let peopleArguments = arguments?["params"] as? [String: Any]

            guard peopleMethod != nil else {return}

            switch peopleMethod {
            case "addPushDeviceToken":
                self.addPushToken(arguments: peopleArguments)
            case "removeAllPushDeviceTokens":
                Mixpanel.mainInstance().people.removeAllPushDeviceTokens()
            case "removePushDeviceToken":
                self.removePushToken(arguments: peopleArguments)
            case "set":
                self.toMixpanelProperties(properties: peopleArguments) { mixPanelProperties  in
                    Mixpanel.mainInstance().people.set(properties: mixPanelProperties)
                }
            case "setOnce":
                self.toMixpanelProperties(properties: peopleArguments) { mixPanelProperties  in
                    Mixpanel.mainInstance().people.setOnce(properties: mixPanelProperties)
                }
            case "unset":
                if let arguments = arguments,
                    let names = arguments["names"] as? [String] {
                    Mixpanel.mainInstance().people.unset(properties: names)
                }
            case "increment":
                self.incrementBy(arguments: peopleArguments)
            case "append":
                self.toMixpanelProperties(properties: peopleArguments) { mixPanelProperties  in
                    Mixpanel.mainInstance().people.append(properties: mixPanelProperties)
                }
            case "remove":
                self.toMixpanelProperties(properties: peopleArguments) { mixPanelProperties  in
                    Mixpanel.mainInstance().people.remove(properties: mixPanelProperties)
                }
            case "union":
                self.toMixpanelProperties(properties: peopleArguments) { mixPanelProperties  in
                    Mixpanel.mainInstance().people.union(properties: mixPanelProperties)
                }
            case "trackCharge":
                self.trackCharges(arguments: peopleArguments)
            case "clearCharges":
                Mixpanel.mainInstance().people.clearCharges()
            case "deleteUser":
                Mixpanel.mainInstance().people.deleteUser()
            default: break

            }

            result(nil)
        }

        private func trackCharges(arguments:[String: Any]?) {
            var properties: Properties? = nil
            if let arguments = arguments {
                if let props = arguments["properties"] as? [String: Any] {
                    properties = mapDictionary(properties: props)
                }
                if let ammount = arguments["ammount"] as? Double {
                    Mixpanel.mainInstance().people.trackCharge(amount: ammount, properties: properties)
                }
            }
        }

        private func incrementBy(arguments:[String: Any]?) {
            if let arguments = arguments,
                let property = arguments["property"] as? String,
                let by = arguments["by"] as? Double {

                Mixpanel.mainInstance().people.increment(property: property, by: by)
            }
        }


        private func addPushToken(arguments: [String: Any]?) {
            if let arguments = arguments,
                let token = arguments["token"] as? String,
                let data = token.data(using: .utf8){
                Mixpanel.mainInstance().people.addPushDeviceToken(data)
            }
        }

        private func removePushToken(arguments: [String: Any]?) {
            if let arguments = arguments,
                let token = arguments["token"] as? String,
                let data = token.data(using: .utf8){
                Mixpanel.mainInstance().people.removePushDeviceToken(data)
            }
        }

        private func toMixpanelProperties(properties: [String: Any]?,  execute: (Properties) -> ()) {
            if let properties = properties, let mixPanelProperties = mapDictionary(properties: properties) {
                execute(mixPanelProperties)
            }
        }
    }
