//
// LoginView.swift
// Favourites
//
// Created by Peter Friese on 08.07.2022
// Copyright © 2022 Google LLC.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI
import Combine
import AuthenticationServices

private enum FocusableField: Hashable {
  case email
  case password
}

struct LoginView: View {
  @EnvironmentObject var viewModel: Authentication
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.dismiss) var dismiss

    @State private var navigateToHome = false
    
  @FocusState private var focus: FocusableField?

  private func signInWithEmailPassword() {
    Task {
        if await viewModel.signInWithEmailPassword() == true {
            // Update the authentication state to trigger navigation
            viewModel.authenticationState = .authenticated
            navigateToHome = true
        }
    }
  }
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() == true {
                viewModel.authenticationState = .authenticated
                navigateToHome = true
            }
        }
    }
    
    

    var body: some View {
        if (!navigateToHome) {
            VStack {
                Image("Login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: 300, maxHeight: 400)
                Text(viewModel.flow == .login ? "Login" : "Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "at")
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            self.focus = .password
                        }
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 4)
                
                HStack {
                    Image(systemName: "lock")
                    SecureField("Password", text: $viewModel.password)
                        .focused($focus, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            signInWithEmailPassword()
                        }
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 8)
                
                if !viewModel.errorMessage.isEmpty {
                    VStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color(UIColor.systemRed))
                    }
                }
                
                Button(action: (viewModel.flow == .login ?  signInWithEmailPassword : signUpWithEmailPassword)) {
                    if viewModel.authenticationState != .authenticating {
                        Text(viewModel.flow == .login ? "Login" : "Sign Up")
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                    else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(!viewModel.isValid)
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                
                HStack {
                    VStack { Divider() }
                    Text("or")
                    VStack { Divider() }
                }
                
                SignInWithAppleButton(.signIn) { request in
                    viewModel.handleSignInWithAppleRequest(request)
                } onCompletion: { result in
                    viewModel.handleSignInWithAppleCompletion(result)
                }
                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(8)
                
                HStack {
                    Text("Don't have an account yet?")
                    Button(action: { viewModel.switchFlow() }) {
                        Text("Sign up")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding([.top, .bottom], 50)
                
            }
            .listStyle(.plain)
            .padding()
//            .navigationDestination(isPresented: $navigateToHome) {
//                HomeScreenView()
//            }
        }
        else {
            HomeScreenView()
                .transition(.opacity)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LoginView()
      LoginView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(Authentication())
  }
}
