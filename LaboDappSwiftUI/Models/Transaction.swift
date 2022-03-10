//
//  Transaction.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/10.
//

import Foundation

struct Transaction: Codable {
    let from, to, data, gas: String
    let gasPrice, value, nonce: String
}
