//
//  NetworkDetails.swift
//  flutter_test
//
//  Created by Jack Hopkins on 12/04/2019.
//  Copyright © 2019 Hoptz. All rights reserved.
//

import Foundation

public protocol NetworkDetails {
	var baseUrl: String { get set }
	var defaultHeaders: [String : Any] { get set }
	var defaultQueries: [String : Any] { get set }
}

struct TmdbNetworkDetails: NetworkDetails {
	var baseUrl: String = Configuration.shared.baseURL?.absoluteString ?? ""
	var defaultHeaders: [String : Any] = [:]
	var defaultQueries: [String : Any] = [:]
}
