
//
// AuthenticationViewModel.swift
//
// Heavily sourced from Peter Friese, created on 08.07.2022
// Copyright © 2022 Google LLC.

import Foundation
import FirebaseAuth

// For Sign in with Apple
//import AuthenticationServices
//import CryptoKit

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class Authentication: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""

  @Published var flow: AuthenticationFlow = .login

  @Published var isValid = false
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var displayName = ""

  private var currentNonce: String?

  init() {
    registerAuthStateHandler()
    //verifySignInWithAppleAuthenticationState()

    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
        ? !(email.isEmpty || password.isEmpty)
        : !(email.isEmpty || password.isEmpty) // || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)
  }

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.authenticationState = user == nil ? .unauthenticated : .authenticated
        self.displayName = user?.displayName ?? user?.email ?? ""
      }
    }
  }

  func switchFlow() {
    flow = flow == .login ? .signUp : .login
    errorMessage = ""
  }

  private func wait() async {
    do {
      print("Wait")
      try await Task.sleep(nanoseconds: 1_000_000_000)
      print("Done")
    }
    catch {
      print(error.localizedDescription)
    }
  }

  func reset() {
    flow = .login
    email = ""
    password = ""
    confirmPassword = ""
  }
}

// MARK: - Email and Password Authentication

extension Authentication {
  func signInWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do {
      try await Auth.auth().signIn(withEmail: self.email, password: self.password)
      return true
    }
    catch  {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do  {
      try await Auth.auth().createUser(withEmail: email, password: password)
      return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

  func signOut() {
    do {
      try Auth.auth().signOut()
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func deleteAccount() async -> Bool {
    do {
      try await user?.delete()
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
//private func randomNonceString(length: Int = 32) -> String {
  //precondition(length > 0)
  //let charset: [Character] =
  //Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  //var result = ""
  //var remainingLength = length

  //while remainingLength > 0 {
    //let randoms: [UInt8] = (0 ..< 16).map { _ in
      //var random: UInt8 = 0
      //let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      //if errorCode != errSecSuccess {
        //fatalError(
          //"Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        //)
      //}
      //return random
    //}

    //randoms.forEach { random in
      //if remainingLength == 0 {
        //return
      //}

      //if random < charset.count {
        //result.append(charset[Int(random)])
        //remainingLength -= 1
      //}
    //}
  //}

  //return result
//}

//private func sha256(_ input: String) -> String {
  //let inputData = Data(input.utf8)
  //let hashedData = SHA256.hash(data: inputData)
  //let hashString = hashedData.compactMap {
    //String(format: "%02x", $0)
  //}.joined()

  //return hashString
//}
