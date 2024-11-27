//
// LoginView.swift
//
// Heavily sourced from Peter Friese, created on 08.07.2022

import SwiftUI
import Combine
import AuthenticationServices

private enum FocusableField: Hashable {
    case email
    case password
}

struct LoginView: View {
    @EnvironmentObject var viewModel: Authentication
    @State private var loggedIn = false
    @FocusState private var focus: FocusableField?
    
    private func signIn() {
        Task {
            let isSignedIn = await viewModel.signInWithEmailPassword()
            if isSignedIn {
                viewModel.authenticationState = .authenticated
                loggedIn = true
                viewModel.errorMessage = ""
            }
        }
    }
    private func signUp() {
        Task {
            let isSignedUp = await viewModel.signUpWithEmailPassword()
            if isSignedUp {
                viewModel.authenticationState = .authenticated
                loggedIn = true
            }
        }
    }
    
    
    var body: some View {
        if (!loggedIn) {
            VStack {
                VStack {
                    Image(systemName: "basket")
                        .font(.system(size: 65))
                        .foregroundStyle(Color.theme.accent)
                        .padding(.bottom, 10)
                    Text("Budget Basket")
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }
                Text(viewModel.flow == .login ? "Login" : "Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Get Name when logging in for the first time
                if (viewModel.flow == .signUp) {
                    
                    // First Name
                    HStack {
                        Image(systemName: "person").foregroundStyle(Color.theme.accent)
                        TextField("First Name", text: $viewModel.firstName)
                            .disableAutocorrection(true)
                            .submitLabel(.next)
                    }
                    .padding(.vertical, 6)
                    .background(Divider(), alignment: .bottom)
                    .padding(.bottom, 4)
                    
                    // Last Name
                    HStack {
                        Image(systemName: "person").foregroundStyle(Color.theme.accent)
                        TextField("Last Name", text: $viewModel.lastName)
                            .disableAutocorrection(true)
                            .submitLabel(.next)
                    }
                    .padding(.vertical, 6)
                    .background(Divider(), alignment: .bottom)
                    .padding(.bottom, 4)
                }
                
                // Email
                HStack {
                    Image(systemName: "at").foregroundStyle(Color.theme.accent)
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .email)
                        .submitLabel(.next)
                }
                .padding(.vertical, 6)
                .background(Divider(), alignment: .bottom)
                .padding(.bottom, 4)
                
                // Password
                HStack {
                    Image(systemName: "lock").foregroundStyle(Color.theme.accent)
                    SecureField("Password", text: $viewModel.password)
                        .focused($focus, equals: .password)
                        .submitLabel(.go)
                        .onSubmit {
                            if viewModel.flow == .login {
                                signIn()
                            } else {
                                signUp()
                            }
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
                
                // Button
                Button(action: (viewModel.flow == .login ?  signIn : signUp)) {
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
                .disabled((viewModel.flow == .login) ? !viewModel.isValid : (!viewModel.isValid || viewModel.firstName.count < 1 || viewModel.lastName.count < 1))
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                
                HStack {
                    Text(viewModel.flow == .login ? "Don't have an account?" : "Already have an account?")
                    Button(action: { viewModel.switchFlow() }) {
                        Text(viewModel.flow == .login ? "Sign up" : "Login")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding([.top, .bottom], 50)
                
            }
            .listStyle(.plain)
            .padding()
        }
        else {
            HomeScreenView()
                .transition(.opacity).environmentObject(viewModel)
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
