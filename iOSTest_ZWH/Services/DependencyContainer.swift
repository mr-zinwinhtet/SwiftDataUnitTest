//
//  DependencyContainer.swift
//  iOSTest_ZWH
//
//  Created by Zwin on 02/09/2024.
//

import Foundation

protocol DependencyContainerProtocol {
    func register<Service>(type: Service.Type, component: Any)
    func resolve<Service>(type: Service.Type) -> Service?
}

class DependencyContainer: DependencyContainerProtocol {
    
    static let shared = DependencyContainer()
    private var services: [ObjectIdentifier: Any] = [:]
    private let lock = NSLock()
    
    init() {}
    
    func register<Service>(type: Service.Type, component: Any) {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer {
            lock.unlock()
        }
        services[key] = component
    }
    
    func resolve<Service>(type: Service.Type) -> Service? {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer {
            lock.unlock()
        }
        return services[key] as? Service
    }
}
