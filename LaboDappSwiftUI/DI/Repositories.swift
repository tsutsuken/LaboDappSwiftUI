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
        
        init(chainLinkRepository: ChainLinkRepositoryProtocol) {
            self.chainLinkRepository = chainLinkRepository
        }
        
        static var stub: Repositories {
            self.init(chainLinkRepository: ChainLinkRepositoryStub())
        }
    }
}
