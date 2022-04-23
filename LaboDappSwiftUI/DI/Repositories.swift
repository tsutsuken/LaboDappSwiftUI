//
//  Repositories.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/12.
//

import Foundation

extension Container {
    struct Repositories {
        let chainLinkRepository: ChainLinkRepositoryProtocol
        let yourContractRepository: YourContractRepositoryProtocol
        
        init(chainLinkRepository: ChainLinkRepositoryProtocol, yourContractRepository: YourContractRepositoryProtocol) {
            self.chainLinkRepository = chainLinkRepository
            self.yourContractRepository = yourContractRepository
        }
        
        static var stub: Repositories {
            self.init(chainLinkRepository: ChainLinkRepositoryStub(), yourContractRepository: YourContractRepositoryStub())
        }
    }
}
