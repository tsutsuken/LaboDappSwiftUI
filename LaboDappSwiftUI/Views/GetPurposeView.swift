//
//  GetPurposeView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/20.
//

import SwiftUI

struct GetPurposeView: View {
    @Environment(\.container) var container: Container
    @State private var purpose = ""
    
    private func fetchPurpose() async {
        guard let purpose = try? await container.repositories.purposeRepository.purpose() else {
            return
        }
        self.purpose = purpose
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Purpose: \(purpose)")
            }
            .navigationTitle("Get Purpose")
        }
        .task {
            await fetchPurpose()
        }
    }
}

struct GetPurposeView_Previews: PreviewProvider {
    static var previews: some View {
        GetPurposeView()
    }
}
