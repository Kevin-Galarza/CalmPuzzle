//
//  NetworkReachability.swift
//  CalmPuzzle
//
//  Created by Kevin Galarza on 6/14/24.
//

import Network

class NetworkReachability {
    static let shared = NetworkReachability()

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    var isCellular: Bool {
        return monitor.currentPath.isExpensive
    }

    var isWiFi: Bool {
        return monitor.currentPath.availableInterfaces.contains { $0.type == .wifi }
    }

    init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.handleNetworkChange(path)
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    private func handleNetworkChange(_ path: NWPath) {
        if path.status == .satisfied {
            print("We're connected!")
            if path.isExpensive {
                print("The connection is cellular.")
            } else {
                print("The connection is WiFi")
            }
        } else {
            print("No connection.")
        }
    }
}

