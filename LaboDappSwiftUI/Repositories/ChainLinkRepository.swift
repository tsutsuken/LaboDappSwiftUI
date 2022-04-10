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
    func transfer(amount: UInt)
}

class ChainLinkRepository: ChainLinkRepositoryProtocol {
    let walletManager: WalletManager
    private let decimals = 18
    
    init(walletManager: WalletManager) {
        self.walletManager = walletManager
    }
    
    func transfer(amount: UInt) {
        print("ChainLinkRepository transfer")
        guard let address = walletManager.address() else {
            return
        }
        
        // power the amount by decimals
        let poweredAmount = BigUInt(amount) * BigUInt(10).power(18)
        
        let chainLinkAddressRinkeby = "0x01BE23585060835E02B77ef475b0Cc51aA1e0709"
        let function = ERC20Functions.transfer(contract: EthereumAddress(chainLinkAddressRinkeby),
                                               from: EthereumAddress(address),
                                               to: EthereumAddress("0x42b6fC88867383dDd507b40CD6E0DDe32C05891a"),
                                               value: poweredAmount)
        guard let transactionData = try? function.transaction().data else {
            return
        }
        
        let transaction = Transaction(from: "0xf962d9666517Abd683b32342bC4DCDDEfd40546B",
                                      to: chainLinkAddressRinkeby, // set contract address
                                      data: transactionData.web3.hexString
        )
        walletManager.sendTransaction(transaction: transaction)
    }
}
