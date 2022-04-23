//
//  PurposeFunction.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/22.
//

import Foundation
import web3
import BigInt

enum YourContractFunction {
    public struct getPurpose: ABIFunction {
        public static let name = "purpose"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        public init(contract: EthereumAddress,
                    from: EthereumAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {}
    }
    
    public struct setPurpose: ABIFunction {
        public static let name = "setPurpose"
        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        public let purpose: String
        
        public init(contract: EthereumAddress,
                    from: EthereumAddress? = nil,
                    gasPrice: BigUInt? = nil,
                    gasLimit: BigUInt? = nil,
                    purpose: String) {
            self.contract = contract
            self.from = from
            self.gasPrice = gasPrice
            self.gasLimit = gasLimit
            self.purpose = purpose
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(purpose)
        }
    }
}
