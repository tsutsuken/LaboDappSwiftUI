//
//  ChainLinkRepository.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/03.
//

import Foundation
import web3
import BigInt

class ChainLinkRepository {
    let walletManager: WalletManager
    
    init(walletManager: WalletManager) {
        self.walletManager = walletManager
    }
    
    public func transfer() {
        print("ChainLinkRepository transfer")
        guard let address = walletManager.address else {
            return
        }
        
        let chainLinkAddressRinkeby = "0x01BE23585060835E02B77ef475b0Cc51aA1e0709"
        let function = ERC20Functions.transfer(contract: EthereumAddress(chainLinkAddressRinkeby),
                                               from: EthereumAddress(address),
                                               to: EthereumAddress("0x42b6fC88867383dDd507b40CD6E0DDe32C05891a"),
                                               value: BigUInt(1000000000000000000))
        guard let transactionData = try? function.transaction().data else {
            return
        }
        
        let transaction = Transaction(from: "0xf962d9666517Abd683b32342bC4DCDDEfd40546B",
                                      to: chainLinkAddressRinkeby, // set contract address
                                      data: transactionData.web3.hexString,
                                      gas: "0x", // autofilled in wallet
                                      gasPrice: "0x", // autofilled in wallet
                                      value: "0x",
                                      nonce: "0x" // autofilled in wallet
        )
        walletManager.sendTransaction(transaction: transaction)
    }
}
