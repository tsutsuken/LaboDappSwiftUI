//
//  PurposeView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/20.
//

import SwiftUI

struct PurposeView: View {
    @Environment(\.container) var container: Container
    
    var body: some View {
        NavigationView {
            VStack {
                if container.walletManager.session == nil {
                    Text("Wallet not connected")
                } else {
                    List {
                        NavigationLink(destination: SetPurposeRequestView()) {
                            HStack {
                                Text("Set Purpose")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Purpose")
        }
    }
}

struct PurposeView_Previews: PreviewProvider {
    static var previews: some View {
        PurposeView()
    }
}
