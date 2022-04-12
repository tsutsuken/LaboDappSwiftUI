//
//  ProfileView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/10.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.container) var container: Container
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Address")
                        .bold()
                    Text("\(container.walletManager.address() ?? "No Address")")
                }
            }
            .navigationTitle("Profile")
        }
    }
}
