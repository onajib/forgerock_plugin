//
//  ForgerockToFlutter.swift
//  ForgeRockV1
//
//  Created by VINCENT BOULANGER on 03/12/2021.
//

import Foundation
import FRAuth

class ForgerockAuth {

	public static func initSdk() -> String {
		FRLog.setLogLevel([.error, .network])
		do {
			try FRAuth.start()
			print("SDK initialized successfully")
			return "true"
		}
		catch {
			  print(error)
			return "false"
		}
	}

	public static func login (email:String, password: String, switchButton:String) -> String {
        FRUser.login {(user: FRUser?, node, error) in
            self.handleNode(user: user, node: node, error: error, email:email, password:password, switchButton: switchButton)
        }
        return "email" + email + " password " + password
	}
	
	public static func handleNode(user: FRUser?, node: Node?, error: Error?, email: String, password:String, switchButton: String) {
		if let _ = user {
			print("User is authenticated")

		} else if let node = node {
			print("Node object received, handle the node")
			DispatchQueue.main.async {
				var tab = [String]()
				tab.append(email)
				tab.append(password)
				tab.append(switchButton)
				for i in 0..<tab.count {
					let value = tab[i]
					let thisCallback: SingleValueCallback = node.callbacks[i] as!
						SingleValueCallback
					thisCallback.setValue(value)
				}
				node.next { (user: FRUser?, node, error) in
					self.handleNode(user: user, node: node, error: error, email: email, password: password, switchButton: switchButton)
				}
			}
		} else {
			print ("Something went wrong: \(String(describing: error))")
		}
	}
	
	public static func logOut() -> String {
		guard let user = FRUser.currentUser else { return ""}
		do {
            try user.logout()
            print("user.logout successfully")
            return "true"
        }
        catch {
              print(error)
            return "false"
        }
	}
	public static func dismissNav() -> String {
        guard let user = FRUser.currentUser else { return ""}
        do {
            try user.logout()
            print("dismiss successfully")
            return "true"
        }
        catch {
              print(error)
            return "false"
        }
    }
	public static func getToken() -> String {
		guard let user = FRUser.currentUser else { return ""}
		return user.token?.value ?? ""
	}
}
