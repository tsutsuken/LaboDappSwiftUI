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
    func purpose() async throws -> String
    func setPurpose(purpose: String)
}

struct PurposeRepositoryStub: PurposeRepositoryProtocol {
    func purpose() async throws -> String {
        return "stub purpose"
    }
    func setPurpose(purpose: String) {
        print("PurposeRepositoryStub setPurpose: \(purpose)")
    }
}

struct PurposeRepository: PurposeRepositoryProtocol {
    private let walletManager: WalletManager
    private let ethereumClient: EthereumClient
    let contractAddressRinkeby = "0x05211F6B121DD6f507aE72a2882787949eb43153"
    
    init(walletManager: WalletManager, ethereumClient: EthereumClient) {
        self.walletManager = walletManager
        self.ethereumClient = ethereumClient
    }
    
    func purpose() async throws -> String {
        print("PurposeRepository purpose")
        guard let address = walletManager.address() else {
            throw WalletManagerError.addressError
        }
        
        let function = PurposeFunction.getPurpose(contract: EthereumAddress(contractAddressRinkeby),
                                                   from: EthereumAddress(address))
        guard let response = try? await function.call(withClient: ethereumClient, responseType: PurposeResponse.purposeResponse.self) else {
            throw EthereumClientError.callError
        }
        
        let purpose = response.value
        return purpose
    }
    
    func setPurpose(purpose: String) {
        print("PurposeRepository setPurpose: \(purpose)")
        guard let address = walletManager.address() else {
            return
        }
        
        let function = PurposeFunction.setPurpose(contract: EthereumAddress(contractAddressRinkeby),
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
