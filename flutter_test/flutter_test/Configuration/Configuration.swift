//
//  Configuration.swift
//  flutter_test
//
//  Created by Jack Hopkins on 12/04/2019.
//  Copyright © 2019 Hoptz. All rights reserved.
//

import Foundation

enum ConfigurationName : String {
	case development = "Debug"
	case release = "Release"
}

class Configuration {
	
	static let shared: Configuration = Configuration()
	private var configurationVars: [String : AnyObject] = [:]
	let name: ConfigurationName
	private let currentConfigurationName: String
	
	init() {
		// Get current configuration
		currentConfigurationName = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
		name = ConfigurationName(rawValue: currentConfigurationName)!
		setup()
	}
	
	init(name: ConfigurationName) {
		self.name = name
		currentConfigurationName = name.rawValue
		setup()
	}
	
	private func setup() {
		// Load configuration
		// TODO: - Provide 'form_base_url' in Release configurations
		let path = Bundle.main.path(forResource: "Configuration", ofType: "plist")!
		let configurations = NSDictionary(contentsOfFile: path)!
		
		print("Loading configuration: ", currentConfigurationName)
		
		configurationVars = configurations.object(forKey: currentConfigurationName) as! [String : AnyObject]
	}
	
	var baseURL: URL? {
		let urlStr = configurationVars["api_base_url"] as? String ?? ""
		return URL(string: urlStr)
	}
	
	var apiKey: String? {
		return configurationVars["api_key"] as? String
	}
	
	
	var isDebug: Bool {
		return name == .development
	}
}
