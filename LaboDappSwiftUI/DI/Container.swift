//
//  Container.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/12.
//

import Foundation
import SwiftUI
import web3

struct Container: EnvironmentKey {
    let walletManager: WalletManager
    let repositories: Repositories
    static private let ethereumRpcUrl = "https://eth-rinkeby.alchemyapi.io/v2/ir0s0Edh0BEmt9rO-uv0sVjObYGUQGka"
    
    init(walletManager: WalletManager, repositories: Repositories) {
        self.walletManager = walletManager
        self.repositories = repositories
    }
    
    static func make(walletManager: WalletManager) -> Container {
        let ethereumClient = EthereumClient(url: URL(string: ethereumRpcUrl)!)
        let chainLinkRepository = ChainLinkRepository(walletManager: walletManager)
        let purposeRepository = PurposeRepository(walletManager: walletManager ,ethereumClient: ethereumClient)
        let repositories = Repositories(chainLinkRepository: chainLinkRepository, purposeRepository: purposeRepository)
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
