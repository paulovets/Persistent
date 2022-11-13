//
//  KeychainItem.swift
//  Persistent
//
//  Created by Yauheni Paulavets on 1.10.22.
//

import Foundation

public protocol KeychainItemProtocol: Codable {
    
    static var key: String { get }
}
