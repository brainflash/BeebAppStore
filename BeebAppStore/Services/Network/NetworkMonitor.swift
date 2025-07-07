//
//  NetworkMonitor.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Network

protocol NetworkMonitorDelegate {
	func reportNoInternetConnection()
}

class NetworkMonitor {
	static let shared = NetworkMonitor()

	var delegate: NetworkMonitorDelegate?
	
	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue(label: "NetworkMonitor")

	private(set) var isConnected: Bool = true

	func startMonitoring() {
		monitor.pathUpdateHandler = { [weak self] path in
			self?.isConnected = path.status == .satisfied
			DispatchQueue.main.async {
				if path.status != .satisfied {
					self?.delegate?.reportNoInternetConnection()
				}
			}
		}
		monitor.start(queue: queue)
	}

	func stopMonitoring() {
		monitor.cancel()
	}
}
