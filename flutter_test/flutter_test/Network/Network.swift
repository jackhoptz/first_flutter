//
//  Network.swift
//  flutter_test
//
//  Created by Jack Hopkins on 12/04/2019.
//  Copyright © 2019 Hoptz. All rights reserved.
//

import Foundation

struct NetworkInteractor {
	
	static var shared: NetworkInteractor = NetworkInteractor(network: Network(), networkDetails: TmdbNetworkDetails())
	
	var network: Network
	var networkDetails: NetworkDetails
	
	public func sendRequest(path: String, body: [String:Any] = [:], headers: [String:Any] = [:], queries: [String:Any] = [:], method: String = "POST", completion: ((Any?)->())? = nil) {
		let urlString = networkDetails.baseUrl + path
		var hdrs = headers
		var qrs = queries
		
//		if !path.contains("/app-auth") {
//			if let authorization = user?.authorization {
//				hdrs.updateValue(authorization, forKey: "Authorization")
//			}
//			if let providerId = user?.providerId, !path.contains("/send-notification") {
//				hdrs.updateValue(providerId, forKey: "X-Auth-Provider-Id")
//			}
//		}
		
		for (k, v) in networkDetails.defaultHeaders { hdrs.updateValue(v, forKey: k) }
		for (k, v) in networkDetails.defaultQueries { qrs.updateValue(v, forKey: k) }
		
		let request = network.createRequest(urlString: urlString, headers: hdrs, body: body, method: method, queries: qrs)
		network.sendRequest(request, completion: completion)
	}
}

class Network {
	
	private var operationQueue = OperationQueue()
	
	fileprivate func createRequest(urlString: String, headers: [String: Any] = [:], body: [String : Any] = [:], method: String = "GET", queries: [String : Any] = [:]) -> URLRequest {
		
		let urlComps = NSURLComponents(string: urlString)
		
		// Queries
		var queryItems: [URLQueryItem] = []
		if !queries.isEmpty {
			for item in queries {
				queryItems.append(URLQueryItem(name: item.key, value: String(describing: item.value)))
			}
			urlComps?.queryItems = queryItems
		}
		
		// URL, Method, Body
		let url: URL! = urlComps?.url
		var request : URLRequest = URLRequest(url: url)
		request.httpMethod = method
		request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
		
		// Headers
		request.addValue(String(describing: "application/json, text/plain, */*"), forHTTPHeaderField: "Accept")
		request.addValue(String(describing: "application/json;charset=utf-8"), forHTTPHeaderField: "Content-Type")
		if !headers.isEmpty {
			for header in headers {
				request.addValue(String(describing: header.value), forHTTPHeaderField: header.key)
			}
		}
		
		return request
	}
	
	fileprivate func sendRequest(_ request: URLRequest, completion: ((Any?)->())? = nil) {
		
		NSURLConnection.sendAsynchronousRequest(request, queue: operationQueue) { (res, data, err) in
			guard let data = data else {
				completion?(err)
				return
			}
						
			if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) {
				completion?(jsonResult)
			} else if let res = res {
				completion?(res)
			} else {
				completion?(err)
			}
		}
	}
}
