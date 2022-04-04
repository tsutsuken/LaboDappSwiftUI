//
//  ContentViewModel.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/03.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
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
