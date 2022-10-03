//
//  ChainLinkRepository.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/03.
//

import Foundation
import web3
import BigInt

protocol ChainLinkRepositoryProtocol {
    func transfer(toAddress: String, amount: UInt)
}

struct ChainLinkRepositoryStub: ChainLinkRepositoryProtocol {
    func transfer(toAddress: String, amount: UInt) {
        print("ChainLinkRepositoryStub transfer toAddress: \(toAddress), amount: \(amount)")
    }
}

class ChainLinkRepository: ChainLinkRepositoryProtocol {
    let walletManager: WalletManager
    private let decimals = 18
    
    init(walletManager: WalletManager) {
        self.walletManager = walletManager
    }
    
    func transfer(toAddress: String, amount: UInt) {
        print("ChainLinkRepository transfer")
        guard let address = walletManager.address() else {
            return
        }
        
        // power the amount by decimals
        let poweredAmount = BigUInt(amount) * BigUInt(10).power(18)
        
        let chainLinkAddressGoerli = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB"
        let function = ERC20Functions.transfer(contract: EthereumAddress(chainLinkAddressGoerli),
                                               from: EthereumAddress(address),
                                               to: EthereumAddress(toAddress),
                                               value: poweredAmount)
        guard let transactionData = try? function.transaction().data else {
            return
        }
        
        let transaction = Transaction(from: address,
                                      to: chainLinkAddressGoerli, // set contract address
                                      data: transactionData.web3.hexString
        )
        walletManager.sendTransaction(transaction: transaction)
    }
}
