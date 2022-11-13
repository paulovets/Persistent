//
//  KeychainService.swift
//  Persistent
//
//  Created by Yauheni Paulavets on 2.10.22.
//

import Foundation
import KeychainAccess

public protocol KeychainService {
    
    func set<KeychainModel: KeychainItemProtocol>(_ item: KeychainModel)
    
    func get<KeychainModel: KeychainItemProtocol>() -> KeychainModel?
    
    func delete<KeychainModel: KeychainItemProtocol>(_ item: KeychainModel.Type)
}

class KeychainServiceImpl: KeychainService {
    
    public static let shared = KeychainServiceImpl()
    
    private static let service = Bundle(for: KeychainServiceImpl.self).bundleIdentifier ?? "persistent"
    
    private let keychain: Keychain
    
    private init() {
        self.keychain = Keychain(service: Self.service)
    }
    
    public func set<KeychainModel>(_ item: KeychainModel) where KeychainModel : KeychainItemProtocol {
        guard let jsonData = try? JSONEncoder().encode(item),
              let json = String(data: jsonData, encoding: .utf8) else {
            return
        }
        
        try? keychain.set(json, key: KeychainModel.key)
    }
    
    public func get<KeychainModel>() -> KeychainModel? where KeychainModel : KeychainItemProtocol {
        guard let json = try? keychain.get(KeychainModel.key) else {
            return nil
        }
        
        return try? JSONDecoder().decode(KeychainModel.self, from: Data(json.utf8))
    }
    
    public func delete<KeychainModel>(_ item: KeychainModel.Type) where KeychainModel : KeychainItemProtocol {
        try? keychain.remove(item.key)
    }
}
