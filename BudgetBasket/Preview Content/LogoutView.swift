//
// LogoutView.swift
//
// Heavily sourced from Peter Friese, created on 08.07.2022

import SwiftUI
import Combine
import AuthenticationServices
import FirebaseFirestore

struct LogoutView: View {
    @EnvironmentObject var viewModel: Authentication
    @State private var loggedOut = false
    @State private var name = ""
    
    private func getName() {
        Task {
            let query = try await Firestore.firestore().collection("users").whereField("email", isEqualTo: viewModel.email).getDocuments()
            let document = query.documents.first
            if (document == nil) {
                name = ""
            }
            else {
                name = ("\(document!.data()["firstName"] as! String) \(document!.data()["lastName"] as! String)")
            }
        }
    }
    
    private func signOut() {
        viewModel.signOut()
        viewModel.email = ""
        viewModel.password = ""
        viewModel.authenticationState = .unauthenticated
        loggedOut = true
        
    }
    
    var body: some View {
        if (!loggedOut) {
            VStack {
                Text("Logout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "at").foregroundStyle(Color.theme.accent)
                    Text(viewModel.email)
                }
                .padding(.vertical, 6)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "person").foregroundStyle(Color.theme.accent)
                    Text(name)
                }
                .padding(.vertical, 6)
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !viewModel.errorMessage.isEmpty {
                    VStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color(UIColor.systemRed))
                    }
                }
                
                Button(action: signOut) {
                    Text("Sign out")
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                
            }
            .onAppear() {
                getName()
            }
            .listStyle(.plain)
            .padding()
        }
        
    }
}

struct LogoutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LogoutView()
            LogoutView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(Authentication())
    }
}
