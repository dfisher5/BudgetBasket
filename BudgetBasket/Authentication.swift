
//
// AuthenticationViewModel.swift
//
// Heavily sourced from Peter Friese, created on 08.07.2022
// https://github.com/FirebaseExtended/firebase-video-samples/tree/main
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var flow: AuthenticationFlow = .login
    @Published var isValid = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: User?
    
    init() {
        registerAuthStateHandler()
        
        // Validation for button disabling
        $flow
            .combineLatest($email, $password)
            .map { flow, email, password in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
            }
        }
    }
    
    // Change from sign in to sign up
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
        // Try to make authenticated user
        do  {
            try await Auth.auth().createUser(withEmail: email, password: password)
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
        
        // Add user info to user collection
        var userInfo = [String : Any]()
        userInfo["email"] = email
        userInfo["firstName"] = firstName
        userInfo["lastName"] = lastName
        
        Firestore.firestore().collection("users").addDocument(data: userInfo) { error in
            if let error = error {
                print("Error writing to Firestore: \(error.localizedDescription)")
            } else {
                print("success")
            }
        }
        return true
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
