//
//  HomeView.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/14.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var showAiChat = false // 添加状态变量控制导航
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()

            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    TopSearchBar(showAiChat: $showAiChat) // 传递绑定
                        .padding(.horizontal, 32)
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            GreetingSection()
                            ScenarioButtons()
                            RecommendationsSection()
                        }
                        .padding(.top)
                        .padding(.bottom, 50) // Add padding to make space for TabBar
                    }
                }

            }
        }
        .navigationDestination(isPresented: $showAiChat) {
            AiChatBox() // 导航到AiChatBox
                .navigationBarBackButtonHidden(true) // 隐藏默认的返回按钮
        }
    }
}

struct TopSearchBar: View {
    @State private var searchText: String = ""
    @Binding var showAiChat: Bool // 添加binding接收导航状态
    @State private var showScanMenu = false // 添加扫描菜单状态
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                showAiChat = true // 点击闪电图标时触发导航
            }) {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.orange)
                    .padding(10)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Circle())
            }

            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for food nutrition.", text: $searchText)
                    .foregroundColor(.black)
                   // Ensure TextField doesn't push other elements off-screen
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .layoutPriority(1) // Give TextField higher priority to expand

            // 添加扫描按钮
            Button(action: {
                showScanMenu = true
            }) {
                Image(systemName: "camera.viewfinder")
                    .foregroundColor(.orange)
                    .padding(8)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Circle())
            }

            Button(action: {
                print("Bell tapped")
            }) {
                Image(systemName: "bell")
                    .padding(.leading, 4) // Add some padding if needed
            }
        }
        .fullScreenCover(isPresented: $showScanMenu) {
            Scan()
        }
    }
}

struct GreetingSection: View {
    // 添加根据当前时间计算的问候语和食谱类型
    private var timeBasedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<14:
            return "Good Noon"
        case 14..<18:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
    
    private var mealType: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Breakfast"
        case 12..<14:
            return "Lunch"
        case 14..<18:
            return "Snack"
        default:
            return "Dinner"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(timeBasedGreeting)
                .font(.title2).bold()
                .padding(.horizontal) // Use relative padding

            VStack(alignment: .leading, spacing: 12) {
                Image("salmon") // Replace with your actual image asset
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // Use max height instead of fixed height for flexibility
                    .frame(maxHeight: 200)
                    .clipped()
                    .cornerRadius(16)

                Text("\(mealType) Recipe Collection")
                    .font(.headline)

                Text("Delicious and balanced \(mealType.lowercased()) recipes perfect for today, based on your preferences.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true) // Allow text wrapping

                Button(action: {}) {
                    Text("See \(mealType.lowercased()) recipes")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.2))
                        .foregroundColor(.orange)
                        .cornerRadius(16)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            .padding(.horizontal) // Use relative padding
        }
        .padding(.horizontal) // Add padding for the entire section
    }
}

struct ScenarioButtons: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("What's your dining scenario?")
                .font(.headline)
                .padding(.horizontal) // Use relative padding

            HStack(spacing: 16) {
                // Allow buttons to take available space
                ScenarioButton(label: "Home", icon: "house.fill", color: .orange.opacity(0.2))
                ScenarioButton(label: "Dining Out", icon: "person.2.fill", color: .blue.opacity(0.2))
                ScenarioButton(label: "Party", icon: "person.3.fill", color: .green.opacity(0.2))
            }
            .padding(.horizontal) // Use relative padding
        }
        .padding(.horizontal) // Add padding for the entire section
    }
}

struct ScenarioButton: View {
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        Button(action: {
            print("\(label) tapped")
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                         // Make circle adaptive? Consider fixed size for consistency or adaptive
                        .frame(width: 60, height: 60) // Slightly smaller fixed size
                    Image(systemName: icon)
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold)) // Slightly smaller icon
                }

                Text(label)
                    .font(.caption)
                    .foregroundColor(.black)
                    .lineLimit(1) // Prevent label wrapping
            }
            .padding(.vertical, 12) // Adjust padding
            .padding(.horizontal, 8) // Adjust padding
            .frame(maxWidth: .infinity) // Allow horizontal expansion
            .frame(minHeight: 120) // Set a minimum height
            .background(color)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct RecommendationsSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recommendations for you")
                    .font(.headline)
                Spacer()
                Button("View more") {
                    // action
                }
                .font(.subheadline)
                .foregroundColor(.orange)
            }
            .padding(.horizontal) // Use relative padding

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    RecommendationCard(title: "Avocado Salad")
                    RecommendationCard(title: "Oatmeal Bowl")
                    // Add more cards if needed
                }
                .padding(.horizontal) // Use relative padding
                .padding(.bottom) // Add padding at the bottom of the scroll view
            }
        }
        .padding(.horizontal) // Add padding for the entire section
    }
}

struct RecommendationCard: View {
    let title: String

    var body: some View {
        Button(action: {
            print("\(title) tapped")
        }) {
            VStack(alignment: .leading) {
                Image("meal") // Replace with actual image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // Use max width for flexibility within the horizontal scroll view
                    .frame(width: 150, height: 100) // Keep a reasonable fixed size for cards
                    .clipped()
                    .cornerRadius(12)
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
                    .lineLimit(1) // Prevent title wrapping
                    .padding(.top, 4)
                Text("Balanced & low-sugar")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true) // Allow description wrapping
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
            // Ensure the card itself has a maximum width if needed,
            // but the ScrollView should handle the content size.
            // .frame(width: 180) // Set width on the card container if needed
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
