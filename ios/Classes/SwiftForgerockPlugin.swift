import Flutter
import UIKit

public class SwiftForgerockPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "forgerock_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftForgerockPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    switch (call.method)  {
        case "initSdk":
            let res = ForgerockAuth.initSdk()
            result("Sdk initialized = " + res)
        break

        case "login":
            guard let args = call.arguments as? Dictionary<String, Any> else {return}
            guard let email = args["email"] as? String else {return}
            guard let password = args["password"] as? String else {return}
            let res = ForgerockAuth.login(email: email, password: password, switchButton: "0")
            result("Login value = " + res)
        break

        case "getToken":
            let res = ForgerockAuth.getToken()
            result("Token = " + res)
        break

        case "logOut":
            let res = ForgerockAuth.logOut()
            result ("Deconnection" + res)
        break

        case "sendDataFlutterToIOS":
            /* guard let args = call.arguments as? Dictionary<String, Any> else {return}
            guard let login = args["login"] as? String else {return}
            guard let password = args["password"] as? String else {return}
            guard let adress = args["adress"] as? String else {return}
            guard let tokenId = args["tokenId"] as? String else {return}
            DataModel.shared.login = login
            DataModel.shared.password = password
            DataModel.shared.data["login"] = login
            DataModel.shared.data["password"] = password
            DataModel.shared.data["adress"] = adress
            DataModel.shared.data["tokenId"] = tokenId */
        break

        case "incrementCount":
            //DataModel.shared.count = DataModel.shared.count + 1
        break

        case "tokenId":
            //DataModel.shared.tokenId = DataModel.shared.tokenId
        break

        case "fromHostToClient":
            /* var dictonary:NSDictionary? = call.arguments as? NSDictionary
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            jsonObject.setValue("firstName", forKey: "first")
            jsonObject.setValue("lastName", forKey: "second")
            var convertedString: String? = nil
            do{
                let data1 =  try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions.prettyPrinted)
                convertedString = String(data: data1, encoding: String.Encoding.utf8)
            } catch let myJSONError {
                print(myJSONError)
            }
            self.channel!.invokeMethod("fromHostToClient", arguments: convertedString) */
            break
        case "alertWithReturnValue":
            /* DispatchQueue.main.async {
                let alert = UIAlertController(title: "Félicitations", message: "Appuyez sur Ok pour terminer votre inscription", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                // add data
                result(nil)
            } */
            break
    // navigation
        case "next":
            /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NativeViewCount")
            navController?.pushViewController(vc, animated: true)
            result(nil) */
            break
        case "goToFidelityCardScreen":
            //print("")
            break
        case "dismiss":
           //self.dismiss(animated: true)
            break
        default:
            result("default iOS " + UIDevice.current.systemVersion)
            break
    }
  }
}
