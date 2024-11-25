//
// LogoutView.swift
//
// Heavily sourced from Peter Friese, created on 08.07.2022

import SwiftUI
import Combine
import AuthenticationServices

struct LogoutView: View {
  @EnvironmentObject var viewModel: Authentication
  @State private var loggedOut = false
    
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
                Image(" ")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: 300, maxHeight: 400)
                Text("Logout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "at")
                    Text(viewModel.email)
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
