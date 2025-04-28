//
//  RegistrationView.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/16.
//

import Foundation
import SwiftUI


struct RegistrationView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer().frame(height: 40)

                Text("Create Account")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(hex: "#4A5568"))

                VStack(alignment: .leading, spacing: 6) {
                    Text("Full Name")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Enter your full name", text: $fullName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }.frame(width: 300)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }.frame(width: 300)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    SecureField("Create a password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }.frame(width: 300)

                Button(action: {
                    print("Register tapped")
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#FFBE98"))
                        .cornerRadius(28)
                }
                .frame(width: 300)

                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Log In")
                            .foregroundColor(Color(hex: "#FFBE98"))
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 28)
            .background(Color.white.ignoresSafeArea())
        }
    }
}


#Preview {
    RegistrationView()
}
