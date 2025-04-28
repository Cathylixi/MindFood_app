//
//  Community.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/15.
//

import SwiftUI

struct CommunityView: View {
    @State private var selectedTab: String = "All Posts"

    var body: some View {
        PageWithTab(selectedTab: "Community") {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("MIND FOOD")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#FF914D"))
                        Spacer()
                        Button(action: {
                            print("Add tapped")
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(Color(hex: "#FF914D"))
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    // Stories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            Button(action: {
                                print("Your Story tapped")
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.1))
                                            .frame(width: 66, height: 66)
                                        Image(systemName: "plus")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.orange)
                                    }
                                    Text("Your Story")
                                        .font(.caption2)
                                        .foregroundColor(.black)
                                }
                            }
                            ForEach(["Sarah", "Lisa", "John"], id: \.self) { name in
                                Button(action: {
                                    print("\(name) tapped")
                                }) {
                                    VStack {
                                        Image(name.lowercased())
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                                        Text(name)
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)

                    // Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(["All Posts", "Recipes", "Diet Plans"], id: \.self) { tab in
                                Button(action: {
                                    selectedTab = tab
                                }) {
                                    Text(tab)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedTab == tab ? Color.orange.opacity(0.3) : Color.gray.opacity(0.1))
                                        .cornerRadius(20)
                                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.top)
                        .padding(.horizontal)
                    }

                    // Post
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image("sarah")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                            VStack(alignment: .leading) {
                                Text("Sarah Johnson")
                                    .fontWeight(.semibold)
                                Text("Posted 2 hours ago")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }

                        Text("Just made this amazing low-carb breakfast bowl that helped me maintain my glucose levels all morning! #PreDiabetesMeal #HealthyEating")

                        Image("meal_post")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .clipped()

                        HStack(spacing: 24) {
                            Button(action: {
                                print("Like tapped")
                            }) {
                                Label("128 likes", systemImage: "heart")
                            }

                            Button(action: {
                                print("Comments tapped")
                            }) {
                                Label("24 comments", systemImage: "bubble.right")
                            }

                            Button(action: {
                                print("Share tapped")
                            }) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding()

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image("john")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 2))
                            VStack(alignment: .leading) {
                                Text("John Davis")
                                    .fontWeight(.semibold)
                                Text("Posted yesterday")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }

                        Text("I've been following the Mediterranean diet plan on Mindfood for 3 months now, and my A1C levels have improved significantly! Here's my latest checkup results 📊")

                        HStack(spacing: 24) {
                            Button(action: {
                                print("Like tapped for John")
                            }) {
                                Label("96 likes", systemImage: "heart")
                            }

                            Button(action: {
                                print("Comments tapped for John")
                            }) {
                                Label("18 comments", systemImage: "bubble.right")
                            }

                            Button(action: {
                                print("Share tapped for John")
                            }) {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.05)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
            }
        }
    }
}


// MARK: - Preview
#Preview {
    CommunityView()
}
