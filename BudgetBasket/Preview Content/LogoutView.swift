//
// LogoutView.swift
//
// Heavily sourced from Peter Friese, created on 08.07.2022

import SwiftUI
import Combine
import AuthenticationServices

private enum FocusableField: Hashable {
  case email
  //case password
}

struct LogoutView: View {
  @EnvironmentObject var viewModel: Authentication
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.dismiss) var dismiss
  @State private var navigateToLogin = false
  @FocusState private var focus: FocusableField?
  //@State var loggedOut = false
    
    private func signOut() {
        viewModel.signOut()
        viewModel.email = ""
        viewModel.password = ""
        viewModel.authenticationState = .unauthenticated
        navigateToLogin = true
        //exit(0)
        //loggedOut = true
        
    }
    
    var body: some View {
        if (!navigateToLogin) {
            VStack {
                Image("Login")
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
                //.background(Divider(), alignment: .bottom)
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
        else {
            //NavBarView.init(dismiss: _dismiss)
            //StartScreenView()
            //NavigationView() {
                //StartScreenView()
            //}
            //StartScreenView()
                //.transition(.opacity)
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
