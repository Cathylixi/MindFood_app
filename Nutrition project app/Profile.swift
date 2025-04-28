//
//  Profile.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/15.
//

import SwiftUI

struct ProfileView: View {
    @State private var showQuestionnaire = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Header with profile image and info
                        HStack(alignment: .center, spacing: 16) {
                            Image("profile_avatar") // Replace with actual image asset name
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("David Chen")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("david.chen@example.com")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 8) {
                                    Text("Pre-diabetes")
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.2))
                                        .foregroundColor(.green)
                                        .cornerRadius(20)
                                    
                                    Text("Since Apr 2023")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }
                        .padding(.horizontal)

                        // Health Stats Card
                        VStack(spacing: 16) {
                            HStack {
                                Text("Health Stats")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                            }

                            HStack {
                                VStack {
                                    ZStack {
                                        Circle()
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 4)
                                            .frame(width: 50, height: 50)
                                        Text("82%")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                    }
                                    Text("Diet Score")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                VStack {
                                    Text("110")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Text("mg/dL")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    Text("Avg. Glucose")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                VStack {
                                    Text("5.4%")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Text("HbA1c")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .padding(.horizontal, 32)

                        // Questionnaire
                        NavigationLink(destination: QuestionnaireView()) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Complete Health Questionnaire")
                                        .font(.headline)
                                        .foregroundColor(Color.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.orange)
                                }
                                Text("Essential for personalized diet recommendations")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                // Progress bar
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 6)
                                        .foregroundColor(Color.gray.opacity(0.3))
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 80, height: 6) // 25% progress
                                        .foregroundColor(.orange)
                                }
                                Text("25%")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 32)

                        // Profile Settings
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Profile Settings")
                                .font(.headline)
                                .padding(.bottom, 4)

                            Button(action: {}) {
                                HStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Image(systemName: "person.fill").foregroundColor(.blue))
                                    VStack(alignment: .leading) {
                                        Text("Personal Information")
                                            .fontWeight(.semibold)
                                        Text("Update your profile details")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            .buttonStyle(ProfileSettingButtonStyle())
                            
                            Button(action: {}) {
                                HStack {
                                    Circle()
                                        .fill(Color.green.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Image(systemName: "lock.fill").foregroundColor(.green))
                                    VStack(alignment: .leading) {
                                        Text("Privacy & Security")
                                            .fontWeight(.semibold)
                                        Text("Manage account security")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            .buttonStyle(ProfileSettingButtonStyle())
                            
                            Button(action: {}) {
                                HStack {
                                    Circle()
                                        .fill(Color.purple.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Image(systemName: "target").foregroundColor(.purple))
                                    VStack(alignment: .leading) {
                                        Text("Health Goals")
                                            .fontWeight(.semibold)
                                        Text("Set your health targets")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            .buttonStyle(ProfileSettingButtonStyle())
                            
                            Button(action: {}) {
                                HStack {
                                    Circle()
                                        .fill(Color.yellow.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Image(systemName: "gearshape.fill").foregroundColor(.yellow))
                                    VStack(alignment: .leading) {
                                        Text("App Settings")
                                            .fontWeight(.semibold)
                                        Text("Notifications, appearance, etc.")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            .buttonStyle(ProfileSettingButtonStyle())
                            
                            Button(action: {}) {
                                HStack {
                                    Circle()
                                        .fill(Color.red.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Image(systemName: "questionmark.circle.fill").foregroundColor(.red))
                                    VStack(alignment: .leading) {
                                        Text("Help & Support")
                                            .fontWeight(.semibold)
                                        Text("Get assistance and FAQs")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            .buttonStyle(ProfileSettingButtonStyle())
                            
                            Button(action: {}) {
                                HStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                        .overlay(Image(systemName: "doc.text").foregroundColor(.blue))
                                    VStack(alignment: .leading) {
                                        Text("Health Questionnaire")
                                            .fontWeight(.semibold)
                                        Text("Complete your health questionnaire")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            .buttonStyle(ProfileSettingButtonStyle())
                        }
                        .padding(.horizontal, 32)

                        // Log Out Button and App Version
                        VStack(spacing: 12) {
                            Button(action: {
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let window = windowScene.windows.first {
                                    window.rootViewController = UIHostingController(rootView: WelcomeView())
                                    window.makeKeyAndVisible()
                                }
                            }) {
                                Text("Log Out")
                                    .foregroundColor(Color(hex: "#FF914D"))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    )
                            }
                            .padding(.top, 8)

                            Text("App version 1.2.0")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.8))
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.top)
                    .padding(.bottom, 50) // more padding to prevent overlap with TabBar
                }

            }
        }
    }
}

struct ProfileSettingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 6)
            .background(configuration.isPressed ? Color.white : Color.clear)
            .cornerRadius(20)
            .shadow(color: configuration.isPressed ? Color.black.opacity(0.05) : Color.clear, radius: 5, x: 0, y: 2)
    }
}
 
#Preview {
    ProfileView()
}
