//
//  WalletManager.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/09.
//

import Foundation
import WalletConnect
import WalletConnectUtils
import Relayer
import web3
import BigInt

class WalletManager: ObservableObject {
    @Published private(set) var client: WalletConnectClient
    @Published private(set) var session: Session?
    @Published private(set) var unconfirmedResponses = [Response]()
    public var address: String? {
        guard let session = session else {
            return nil
        }
        
        guard session.accounts.count > 0 else {
            return nil
        }
        
        let account = Array(session.accounts)[0]
        let splits = account.split(separator: ":", omittingEmptySubsequences: false)
        guard splits.count == 3 else {
            return nil
        }
        
        let address = String(splits[2])
        return address
    }
    public var shouldDisplayResponseView: Bool {
        get {
            let shouldDisplay = unconfirmedResponses.count > 0
            print("shouldDisplayResponseView get: \(shouldDisplay)")
            return shouldDisplay
        }
        
        set(shouldDisplay) {
            // called when dismissing WalletResponseView
            print("shouldDisplayResponseView set: \(shouldDisplay)")
            if shouldDisplay == false {
                unconfirmedResponses = [Response]()
            }
        }
    }
    public let chainIds = Set([Chain.testnetRinkeby.chainId])
    public let methods = Set(["eth_sendTransaction", "personal_sign"])
    private var selectedChainId: String {
        return Array(chainIds)[0]
    }
    
    init() {
        print("WalletManager init")
        
        let metadata = AppMetadata(
            name: "LaboDappSwiftUI",
            description: "description",
            url: "wallet.connect",
            icons: ["https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media"])
        let relayer = Relayer(relayHost: "relay.walletconnect.com", projectId: "a0a2645554ae53fbbce8dceb8fe3ea06")
        self.client = WalletConnectClient(metadata: metadata, relayer: relayer)
        client.delegate = self
        
        if let session = client.getSettledSessions().first {
            print("session exist: \(session)")
            self.session = session
        } else {
            print("session not exist")
        }
    }
}

// MARK: - Public Functions

extension WalletManager {
    public func generateParingUri() throws -> String? {
        let permissions = Session.Permissions(
            blockchains: chainIds,
            methods: methods,
            notifications: []
        )
        return try client.connect(sessionPermissions: permissions)
    }
    
    public func disconnect() {
        guard let session = session else {
            return
        }
        
        client.disconnect(topic: session.topic, reason: Reason(code: 0, message: "disconnect"))
        self.session = nil
    }
    
    public func sendTransaction(transaction: Transaction) {
        print("WalletManager sendTransaction")
        guard let session = session else {
            return
        }
        
        let method = "eth_sendTransaction"
        let requestParams = AnyCodable([transaction])
        let request = Request(topic: session.topic, method: method, params: requestParams, chainId: selectedChainId)
        client.request(params: request)
        print("WalletManager sendTransaction: \(request)")
    }
    
    public func sendRequestPersonalSign() {
        print("WalletManager sendRequest")
        guard let session = session else {
            return
        }
        
        guard let address = address else {
            return
        }
        
        let method = Array(methods)[1]
        let requestParams = getRequestParams(for: method, myAddress: address)
        let request = Request(topic: session.topic, method: method, params: requestParams, chainId: selectedChainId)
        client.request(params: request)
        print("WalletManager sendRequest: \(request)")
    }
    
    public func sendRequestTransferEth() {
        print("WalletManager sendRequestTransferEth")
        guard let address = address else {
            return
        }
        
        let transaction = Transaction(from: address,
                                      to: "0x42b6fC88867383dDd507b40CD6E0DDe32C05891a",
                                      data: "0x",
                                      gas: "0x", // autofilled in wallet
                                      gasPrice: "0x", // autofilled in wallet
                                      value: "0x5AF3107A4000", // 0.0001eth
                                      nonce: "0x" // autofilled in wallet
        )
        sendTransaction(transaction: transaction)
    }
    
    public func getSessionRequestRecord(id: Int64) -> WalletConnectUtils.JsonRpcRecord? {
        let record = client.getSessionRequestRecord(id: id)
        return record
    }
    
    public func sessionRequestResponse(record: JsonRpcRecord?) -> String {
        guard let record = record else {
            return ""
        }
        
        let encoder = JSONEncoder()
        let jsonString: String
        do {
            let data = try encoder.encode(record)
            jsonString = String(data: data, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
            jsonString = error.localizedDescription
        }
        print("WalletManager sessionRequestResponse: \(jsonString)")
        return jsonString
    }
}

// MARK: - Private Functions

extension WalletManager {
    private func getRequestParams(for method: String, myAddress: String) -> AnyCodable {
        if method == "eth_sendTransaction" {
            let tx = Stub.tx
            return AnyCodable(tx)
        } else if method == "personal_sign" {
            return AnyCodable(["TestSign", address])
        }
        fatalError("not implemented")
    }

    fileprivate enum Stub {
        static let tx = [Transaction(from: "0xf962d9666517Abd683b32342bC4DCDDEfd40546B",
                                    to: "0x42b6fC88867383dDd507b40CD6E0DDe32C05891a",
                                    data: "0x",
                                    gas: "0x", // autofilled in wallet
                                    gasPrice: "0x", // autofilled in wallet
                                    value: "0x5AF3107A4000", // 0.0001eth
                                    nonce: "0x" // autofilled in wallet
                                    )]
    }
}

// MARK: - WalletConnectClientDelegate

extension WalletManager: WalletConnectClientDelegate {
    func didSettle(session: Session) {
        print("WalletManager didSettle session: \(session)")
        DispatchQueue.main.async {
            self.session = session
        }
    }

    func didDelete(sessionTopic: String, reason: Reason) {
        print("WalletManager didDelete sessionTopic: \(sessionTopic), reason: \(reason)")
        DispatchQueue.main.async {
            self.session = nil
        }
    }

    func didReceive(sessionResponse: Response) {
        print("WalletManager didReceive sessionResponse: \(sessionResponse)")
        DispatchQueue.main.async {
            self.unconfirmedResponses.append(sessionResponse)
            print("unconfirmedResponses: \(self.unconfirmedResponses.count)")
        }
    }

    func didUpdate(sessionTopic: String, accounts: Set<Account>) {
        print("WalletManager didUpdate")
    }

    func didUpgrade(sessionTopic: String, permissions: Session.Permissions) {
        print("WalletManager didUpgrade")
    }
}
