//
//  YourContractRepository.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/18.
//

import Foundation
import web3
import BigInt

protocol YourContractRepositoryProtocol {
    func purpose() async throws -> String
    func setPurpose(purpose: String)
}

struct YourContractRepositoryStub: YourContractRepositoryProtocol {
    func purpose() async throws -> String {
        return "stub purpose"
    }
    func setPurpose(purpose: String) {
        print("YourContractRepositoryStub setPurpose: \(purpose)")
    }
}

struct YourContractRepository: YourContractRepositoryProtocol {
    private let walletManager: WalletManager
    private let ethereumClient: EthereumClient
    let contractAddressGoerli = "0x488521020C3FF1CBC687D291e333cA029E671c0A"
    // Contract info on Etherscan
    // https://goerli.etherscan.io/address/0x488521020C3FF1CBC687D291e333cA029E671c0A
    
    init(walletManager: WalletManager, ethereumClient: EthereumClient) {
        self.walletManager = walletManager
        self.ethereumClient = ethereumClient
    }
    
    func purpose() async throws -> String {
        print("YourContractRepository purpose")
        guard let address = walletManager.address() else {
            throw WalletManagerError.addressError
        }
        
        let function = YourContractFunction.getPurpose(contract: EthereumAddress(contractAddressGoerli),
                                                   from: EthereumAddress(address))
        guard let response = try? await function.call(withClient: ethereumClient, responseType: YourContractResponse.purposeResponse.self) else {
            throw EthereumClientError.callError
        }
        
        let purpose = response.value
        return purpose
    }
    
    func setPurpose(purpose: String) {
        print("YourContractRepository setPurpose: \(purpose)")
        guard let address = walletManager.address() else {
            return
        }
        
        let function = YourContractFunction.setPurpose(contract: EthereumAddress(contractAddressGoerli),
                                                   from: EthereumAddress(address),
                                                   purpose: purpose)
        guard let transactionData = try? function.transaction().data else {
            return
        }

        let transaction = Transaction(from: address,
                                      to: contractAddressGoerli, // set contract address
                                      data: transactionData.web3.hexString
        )
        walletManager.sendTransaction(transaction: transaction)
    }
}
