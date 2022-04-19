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
        let purposeRepository: PurposeRepositoryProtocol
        
        init(chainLinkRepository: ChainLinkRepositoryProtocol, purposeRepository: PurposeRepositoryProtocol) {
            self.chainLinkRepository = chainLinkRepository
            self.purposeRepository = purposeRepository
        }
        
        static var stub: Repositories {
            self.init(chainLinkRepository: ChainLinkRepositoryStub(), purposeRepository: PurposeRepositoryStub())
        }
    }
}
