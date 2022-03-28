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
    
    public func sendRequest() {
        print("WalletManager sendRequest")
        guard let session = session else {
            return
        }
        
        let method = Array(methods)[0]
        let requestParams = getRequestParams(for: method)
        let chainId = Array(chainIds)[0]
        let request = Request(topic: session.topic, method: method, params: requestParams, chainId: chainId)
        client.request(params: request)
    }
    
    public func getSessionRequestRecord(id: Int64) -> WalletConnectUtils.JsonRpcRecord? {
        let record = client.getSessionRequestRecord(id: id)
        return record
    }
}

// MARK: - Private Functions

extension WalletManager {
    private func getRequestParams(for method: String) -> AnyCodable {
        let account = "0x9b2055d370f73ec7d8a03e965129118dc8f5bf83"
        if method == "eth_sendTransaction" {
            let tx = Stub.tx
            return AnyCodable(tx)
        } else if method == "personal_sign" {
            return AnyCodable(["0xdeadbeaf", account])
        }
        fatalError("not implemented")
    }

    fileprivate enum Stub {
        static let tx = [Transaction(from: "0x9b2055d370f73ec7d8a03e965129118dc8f5bf83",
                                    to: "0x9b2055d370f73ec7d8a03e965129118dc8f5bf83",
                                    data: "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675",
                                    gas: "0x76c0",
                                    gasPrice: "0x9184e72a000",
                                    value: "0x9184e72a",
                                    nonce: "0x117")]
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
