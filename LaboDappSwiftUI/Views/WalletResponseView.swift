//
//  WalletResponseView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/10.
//

import SwiftUI
import WalletConnect

struct WalletResponseView: View {
    @State var walletManager: WalletManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(walletManager.unconfirmedResponses, id: \.topic) { response in
                    let record = walletManager.getSessionRequestRecord(id: response.result.id)
                    let responseJson = walletManager.sessionRequestResponse(record: record)
                    
                    Text("Method: \(record?.request.method ?? "") \nResponse: \(responseJson)")
                }
            }
            .navigationTitle("Response")
        }
    }
}
