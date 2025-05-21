//
//  ContentView.swift
//  SnacktacularUI
//
//  Created by Gary Erickson on 5/19/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    enum Field {
        case email,password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    var body: some View {
        VStack {
            Image("logo")
                .imageScale(.large)
                .scaledToFit()
            Group {
                TextField("email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) {
                        enableButtons()
                    }
                
                SecureField("password", text: $password)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                        
                    }
                    .onChange(of: password) {
                        enableButtons()
                    }
                
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            HStack {
                Button("Sign Up") {
                    register()
                }
                .padding(.trailing)
                Button("Log In") {
                    login()
                }
                .padding(.leading)
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.snack)
            .font(.title2)
            .padding(.top)
            .disabled(buttonDisabled)
        }
        .padding()
        .alert(alertMessage, isPresented: $showingAlert)  {
            Button("OK", role: .cancel) { }
        }
        .onAppear() {
            if Auth.auth().currentUser != nil {
                print("🪵 Log in successful!")
                presentSheet = true
            }
        }
        .fullScreenCover(isPresented: $presentSheet)    {
            ListView()
            
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count > 6 && email.contains("@")
        let passwordIsGood = password.count > 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register() {
        
        
        Auth.auth().createUser(withEmail: email, password: password) { result,
            error in
            if let error = error {
                print("😡 Registration error: \(error.localizedDescription)")
                alertMessage = "Registration Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎Registration success!")
                presentSheet = true
            }
            
        }
    }
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 Login error: \(error.localizedDescription)")
                alertMessage = "Login Error: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("😎Login success!")
                presentSheet = true
            }
        }
    }
    
}

#Preview {
    LoginView()
}
