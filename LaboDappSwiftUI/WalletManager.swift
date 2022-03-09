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
    public let chainIds = Set(["eip155:137"])
    public let methods = Set(["eth_sendTransaction", "personal_sign", "eth_signTypedData"])
    
    init() {
        print("WalletManager init")
        
        let metadata = AppMetadata(
            name: "LaboDappSwiftUI",
            description: "description",
            url: "wallet.connect",
            icons: ["https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media"])
        let relayer = Relayer(relayHost: "relay.dev.walletconnect.com", projectId: "52af113ee0c1e1a20f4995730196c13e")
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
    }

    func didUpdate(sessionTopic: String, accounts: Set<Account>) {
        print("WalletManager didUpdate")
    }

    func didUpgrade(sessionTopic: String, permissions: Session.Permissions) {
        print("WalletManager didUpgrade")
    }
}
