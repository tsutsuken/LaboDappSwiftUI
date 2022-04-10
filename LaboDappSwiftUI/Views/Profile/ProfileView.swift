//
//  ProfileView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    
    init(walletManager: WalletManager) {
        let viewModel = ProfileViewModel(walletManager: walletManager)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Address")
                        .bold()
                    Text("\(viewModel.walletManager.address() ?? "No Address")")
                }
            }
            .navigationTitle("Profile")
        }
    }
}
