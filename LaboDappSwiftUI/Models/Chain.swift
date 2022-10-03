//
//  Chain.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/11.
//

import Foundation

enum Chain {
    case mainnetEthereum
    case mainnetPolygon
    case testnetGoerli
    
    var chainId: String {
        switch self {
        case .mainnetEthereum:
            return "eip155:1"
        case .mainnetPolygon:
            return "eip155:137"
        case .testnetGoerli:
            return "eip155:5"
        }
    }
}
