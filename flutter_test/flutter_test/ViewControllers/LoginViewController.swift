//
//  LoginViewController.swift
//  flutter_test
//
//  Created by Jack Hopkins on 11/04/2019.
//  Copyright © 2019 Hoptz. All rights reserved.
//

import UIKit
import UKFLayouts
import Flutter
import Alamofire
import JGProgressHUD


class LoginViewController: UIViewController {
	
	var flutterVC: FlutterViewController? {
		return self.presentedViewController as? FlutterViewController
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let btn = UIButton()
		btn.setTitle("Press Here", for: .normal)
		view.addSubview(btn)
		btn.setCenter()
		btn.setHeight(100.0)
		btn.setWidth(100.0)
		btn.backgroundColor = .red
		btn.addTarget(self, action: #selector(buttonTarget), for: .touchUpInside)
	}
	
	func setUpChannel() {
		guard let flutterVC = flutterVC else { return }
		let channel = FlutterMethodChannel(name: "flutter.testfairy.com/hello", binaryMessenger: flutterVC)
		
		channel.setMethodCallHandler { [unowned self] (methodCall, result) in
			guard let arg = (methodCall.arguments as! [String]).first else { return }
			switch methodCall.method {
			case "openPage":
				self.openSecondPage(param: arg)
			case "showDialog":
				self.openAlert(param: arg, result: result)
			case "request":
				self.callApi(url: arg, result: result)
			default:
				debugPrint(methodCall.method)
				result(methodCall.method)
			}
		}
	}
	
	@objc func buttonTarget(_ button: UIButton) {
		
		//		createRequestToken { [weak self] _ in
		//			self?.login(username: "hoptz", password: "FireIce123", { res in
		//				print(res)
		//			})
		//		}
		
		DispatchQueue.main.async { [weak self] in
			
			let flutterEngine = (UIApplication.shared.delegate as? AppDelegate)?.flutterEngine
			guard let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil) else { return }
			self?.present(flutterViewController, animated: true, completion: {
				self?.setUpChannel()
			})
			
		}
	}
	
	private func openSecondPage(param: String) {
		guard let vc = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as? SecondViewController else { return }
		let nav = UINavigationController(rootViewController: vc)
		
		vc.bodyTitle = param
		flutterVC?.present(nav, animated: true, completion: nil)
	}
	private func openAlert(param: String, result: @escaping FlutterResult) {
		let alert = UIAlertController(title: "Native Alert", message: param, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
			result("Ok was pressed")
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
			result("Cancel was pressed")
		}
		alert.addAction(cancelAction)
		alert.addAction(okAction)
		flutterVC?.present(alert, animated: true, completion: nil)
	}
	
	private func callApi(url: String, result: @escaping FlutterResult) {
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Loading"
		if let vc = flutterVC {
			hud.show(in: vc.view)
		}
		guard let fullUrl = "\(url)search_all_teams.php?l=English Premier League".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
		Alamofire.request(fullUrl).responseJSON { (response) in
			hud.dismiss()
			if let data = response.result.value {
				JSONSerialization()
				let json = data as? [String: Any]
				result(json?["teams"])
			}
		}
	}
	
	func createRequestToken(_ completion: @escaping (AuthTokenResponse?)->()) {
		let path = "/authentication/token/new"
		let queries = ["api_key":Configuration.shared.apiKey ?? ""]
		
		NetworkInteractor.shared.sendRequest(path: path, queries: queries, method: "GET") { res in
			AuthTokenResponse.shared = AuthTokenResponse(response: res as? [String: Any])
			completion(AuthTokenResponse.shared)
		}
	}
	
	func login(username: String, password: String, _ completion: @escaping (AuthTokenResponse?)->()) {
		let path = "/authentication/token/validate_with_login"
		let queries = ["api_key":Configuration.shared.apiKey ?? ""]
		let body = [
			"username": username,
			"password": password,
			"request_token": AuthTokenResponse.shared?.requestToken ?? ""
		]
		
		NetworkInteractor.shared.sendRequest(path: path, body: body, queries: queries, method: "POST") { res in
			AuthTokenResponse.shared = AuthTokenResponse(response: res as? [String: Any])
			completion(AuthTokenResponse.shared)
		}
	}
}

class AuthTokenResponse {
	
	static var shared: AuthTokenResponse? = nil
	
	private var successNum: Int
	
	var expiresAt: String
	var requestToken: String
	var success: Bool { return successNum == 1 }
	
	init?(response: [String: Any]?) {
		guard let exp = response?["expires_at"] as? String,
			let tok = response?["request_token"] as? String,
			let suc = response?["success"] as? Int else { return nil }
		self.expiresAt = exp
		self.requestToken = tok
		self.successNum = suc
	}
}

