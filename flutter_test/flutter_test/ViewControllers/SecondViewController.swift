//
//  SecondViewController.swift
//  FlutterPluginRegistrant
//
//  Created by Jack Hopkins on 15/04/2019.
//

import UIKit

class SecondViewController: UIViewController {
	
	var bodyTitle: String?
	
	@IBOutlet weak var txtTitle: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		txtTitle.text = bodyTitle
		
		title = "Second VC"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func onBtnDoneClicked(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
