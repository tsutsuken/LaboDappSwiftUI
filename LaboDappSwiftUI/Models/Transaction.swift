//
//  Transaction.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/10.
//

import Foundation

struct Transaction: Codable {
    let from: String
    let to: String
    var data: String = "0x"
    var gas: String = "0x" // autofilled in wallet
    var gasPrice: String = "0x" // autofilled in wallet
    var value: String = "0x"
    var nonce: String = "0x" // autofilled in wallet
}
