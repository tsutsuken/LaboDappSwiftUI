//
//  RequestsViewModel.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import Foundation

class RequestsViewModel: ObservableObject {
    public let walletManager: WalletManager
    private let chainLinkRepository: ChainLinkRepositoryProtocol
    
    init(walletManager: WalletManager) {
        self.walletManager = walletManager
        self.chainLinkRepository = ChainLinkRepository(walletManager: walletManager)
    }
    
    public func transferLink() {
        chainLinkRepository.transfer(amount: 1)
    }
}
