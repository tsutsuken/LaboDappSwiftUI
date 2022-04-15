//
//  WalletConnectMethods.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/05.
//

import Foundation

enum WalletConnectMethods: String, CaseIterable {
    case ethSendTransaction = "eth_sendTransaction"
    case personalSign = "personal_sign"
    
    static func allMethodsSet() -> Set<String> {
        let methods = WalletConnectMethods.allCases.map { $0.rawValue }
        return Set(methods)
    }
}
