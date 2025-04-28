//
//  ContentView.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/12.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: String = "Home"
    @State private var showCameraTest: Bool = false // 添加状态变量来控制测试相机

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 添加测试按钮
                Button("Test Camera Directly") {
                    showCameraTest = true
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top)
                
                // Display the selected view
                Group {
                    switch selectedTab {
                    case "Home":
                        HomeView()
                    case "Logs":
                        LogsView()
                    case "Scan":
                        Scan()
                    case "Community":
                        CommunityView()
                    case "Profile":
                        ProfileView()
                    default:
                        HomeView()
                    }
                }

                // Tab bar
                TabBar(selectedTab: $selectedTab)
                    .frame(height: 80)
            }
            .fullScreenCover(isPresented: $showCameraTest) {
                Scan()
            }
        }
    }
}

#Preview {
    ContentView()
}
