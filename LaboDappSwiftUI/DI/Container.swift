//
//  Container.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/12.
//

import Foundation
import SwiftUI

struct Container: EnvironmentKey {
    let walletManager: WalletManager
    let repositories: Repositories
    
    init(walletManager: WalletManager, repositories: Repositories) {
        self.walletManager = walletManager
        self.repositories = repositories
    }
    
    static func make(walletManager: WalletManager) -> Container {
        let chainLinkRepository = ChainLinkRepository(walletManager: walletManager)
        let repositories = Repositories(chainLinkRepository: chainLinkRepository)
        let container = Container(walletManager: walletManager, repositories: repositories)
        return container
    }
    
    static let defaultValue = Container(walletManager: WalletManager(), repositories: Repositories.stub)
}

extension EnvironmentValues {
    var container: Container {
        get { self[Container.self] }
        set { self[Container.self] = newValue }
    }
}
