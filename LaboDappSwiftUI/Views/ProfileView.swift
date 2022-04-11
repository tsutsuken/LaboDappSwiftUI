//
//  ProfileView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var walletManager: WalletManager
    
    init(walletManager: WalletManager) {
        _walletManager = StateObject(wrappedValue: walletManager)
    }
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Address")
                        .bold()
                    Text("\(walletManager.address() ?? "No Address")")
                }
            }
            .navigationTitle("Profile")
        }
    }
}
