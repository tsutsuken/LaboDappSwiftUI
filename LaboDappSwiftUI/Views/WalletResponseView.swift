//
//  WalletResponseView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/10.
//

import SwiftUI
import WalletConnect

struct WalletResponseView: View {
    @Environment(\.container) var container: Container
    
    var body: some View {
        NavigationView {
            List {
                ForEach(container.walletManager.unconfirmedResponses, id: \.topic) { response in
                    let record = container.walletManager.getSessionRequestRecord(id: response.result.id)
                    let responseJson = container.walletManager.sessionRequestResponse(record: record)
                    
                    Text("Method: \(record?.request.method ?? "") \nResponse: \(responseJson)")
                }
            }
            .navigationTitle("Response")
        }
    }
}
