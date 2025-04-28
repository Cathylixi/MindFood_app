//
//  WelcomeView.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/13.
//

import Foundation
import SwiftUI


// MARK: - Welcome View
struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()

                // App Logo / Image
                Image("product_plot")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 10)

                // Title & Description
                VStack(spacing: 8) {
                    Text("Mindfood")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: "#4A5568"))

                    Text("Your personal diet\nmanagement assistant")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#6B7280"))
                        .font(.system(size: 16))
                        .padding(.top, 10)
                }

                // Get Started Button
                NavigationLink(destination: LoginView()) {
                    Text("Get Started")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#FFBE98"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(.system(size: 18, weight: .semibold))
                }
                .padding(.horizontal, 40)

                // Log In
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))

                    NavigationLink(destination: RegistrationView()) {
                        Text("Sign Up")
                            .foregroundColor(Color(hex: "#FFBE98"))
                            .font(.system(size: 14, weight: .semibold))
                    }
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: - Preview
#Preview {
    WelcomeView()
}
