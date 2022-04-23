//
//  YourContractResponse.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/22.
//

import Foundation
import web3

public enum YourContractResponse {
    public struct purposeResponse: ABIResponse, MulticallDecodableResponse {
        public static var types: [ABIType.Type] = [ String.self ]
        public let value: String
        
        public init?(values: [ABIDecoder.DecodedValue]) throws {
            self.value = try values[0].decoded()
        }
    }
}
