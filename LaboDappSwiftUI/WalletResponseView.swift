//
//  WalletResponseView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/03/10.
//

import SwiftUI
import WalletConnect

struct WalletResponseView: View {
    @State var responses: [Response]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(responses, id: \.topic) { response in
                    Text("Topic: \(response.topic)")
                }
            }
            .navigationTitle("Response")
        }
    }
}
