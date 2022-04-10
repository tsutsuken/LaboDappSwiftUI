//
//  ProfileViewModel.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import Foundation

class ProfileViewModel: ObservableObject {
    public let walletManager: WalletManager
    
    init(walletManager: WalletManager) {
        self.walletManager = walletManager
    }
}
