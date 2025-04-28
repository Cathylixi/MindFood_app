//
//  LoginView.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/14.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    
    let validEmail = "xixili@bu.edu"
    let validPassword = "CHenlinong@2019"

    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 24) {
                    Spacer().frame(height: 40)

                    // Title
                    Text("Welcome Back")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "#4A5568"))

                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Enter your email", text: $email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }.frame(width: 300)

                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("Enter your password", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                // Add action here
                            }
                            .font(.footnote)
                            .foregroundColor(Color(hex: "#FFBE98"))
                        }
                    }.frame(width: 300)

                    // Log In button
                    Button(action: {
                        if email == validEmail && password == validPassword {
                            isLoggedIn = true
                        }
                    }) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#FFBE98"))
                            .cornerRadius(28)
                    }.frame(width: 300)

                    // OR Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                        Text("or")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                    }

                    // Google Button
                    Button(action: {}) {
                        HStack {
                            Image("googleLogo2")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Continue with Google")
                                .foregroundColor(Color(hex: "#4A5568"))
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray.opacity(0.2))
                            .frame(height: 50))
                    }.frame(width: 300)

                    // Apple Button
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "applelogo")
                                .foregroundColor(.black)
                            Text("Continue with Apple")
                                .foregroundColor(Color(hex: "#4A5568"))
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray.opacity(0.2))
                            .frame(height: 50))
                    }.frame(width: 300)

                    // NavigationLink to Home Page
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isLoggedIn) {
                        EmptyView()
                    }

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(.horizontal, 28)
        .background(Color.white.ignoresSafeArea())
    }
}


// MARK: - Preview
#Preview {
    NavigationStack {
        LoginView()
    }
}
