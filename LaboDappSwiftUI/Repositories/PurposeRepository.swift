//
//  PurposeRepository.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/18.
//

import Foundation
import web3
import BigInt

protocol PurposeRepositoryProtocol {
    func setPurpose(purpose: String)
}

struct PurposeRepositoryStub: PurposeRepositoryProtocol {
    func setPurpose(purpose: String) {
        print("PurposeRepositoryStub setPurpose: \(purpose)")
    }
}

struct PurposeRepository: PurposeRepositoryProtocol {
    private let walletManager: WalletManager
    let contractAddressRinkeby = "0x05211F6B121DD6f507aE72a2882787949eb43153"
    
    init(walletManager: WalletManager) {
        self.walletManager = walletManager
    }
    
    func setPurpose(purpose: String) {
        print("PurposeRepository setPurpose: \(purpose)")
        guard let address = walletManager.address() else {
            return
        }
        
        let function = PurposeFunctions.setPurpose(contract: EthereumAddress(contractAddressRinkeby),
                                                   from: EthereumAddress(address),
                                                   purpose: purpose)
        guard let transactionData = try? function.transaction().data else {
            return
        }

        let transaction = Transaction(from: address,
                                      to: contractAddressRinkeby, // set contract address
                                      data: transactionData.web3.hexString
        )
        walletManager.sendTransaction(transaction: transaction)
    }
}


enum PurposeFunctions {
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
