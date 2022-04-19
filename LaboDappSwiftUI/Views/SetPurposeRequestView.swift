//
//  SetPurposeRequestView.swift
//  LaboDappSwiftUI
//
//  Created by Ken Tsutsumi on 2022/04/19.
//

import SwiftUI

struct SetPurposeRequestView: View {
    @Environment(\.container) var container: Container
    @State private var purpose: String = ""
    @State private var isPresentedRequestSentAlert = false
    
    private func setPurpose(purpose: String) {
        container.repositories.purposeRepository.setPurpose(purpose: purpose)
    }
    
    private func presentRequestSentAlert() {
        isPresentedRequestSentAlert = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Purpose")
                        .padding(.leading, 24)
                    TextField("Purpose", text: $purpose)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                }
                Button("Send request", action: {
                    setPurpose(purpose: purpose)
                    presentRequestSentAlert()
                })
                    .buttonStyle(.bordered)
                Spacer()
            }
            .navigationTitle("Set Purpose")
            .alert(isPresented: $isPresentedRequestSentAlert) {
                Alert(title: Text("Request sent"),
                      message: Text("Confirm request on connected wallet")
                )
            }
        }
    }
}

struct SetPurposeRequestView_Previews: PreviewProvider {
    static var previews: some View {
        SetPurposeRequestView()
    }
}
