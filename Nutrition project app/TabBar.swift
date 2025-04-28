//
//  TabBar.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/14.
//

import Foundation
import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: String // to choose HOME, LOGS, COMMUNITY, PROFILE

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                Button(action: {
                    selectedTab = "Home"
                }) {
                    tabItem(title: "Home", icon: "house.fill")
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    selectedTab = "Logs"
                }) {
                    tabItem(title: "Logs", icon: "calendar")
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    selectedTab = "Scan"
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#FFBE98"))
                                .frame(width: 72, height: 72)
                                .shadow(radius: 6)
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }

                        Text("Scan")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 80)
                    .offset(y: -24)
                }

                Button(action: {
                    selectedTab = "Community"
                }) {
                    tabItem(title: "Community", icon: "person.3.fill")
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    selectedTab = "Profile"
                }) {
                    tabItem(title: "Profile", icon: "person.circle")
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 2)
            .padding(.bottom, 4)
            .padding(.horizontal, 20)
            .background(Color.white)
        }
    }

    func tabItem(title: String, icon: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(selectedTab == title ? Color(hex: "#FFBE98") : .gray)
            Text(title)
                .font(.caption2)
                .foregroundColor(selectedTab == title ? Color(hex: "#FFBE98") : .gray)
        }
        .padding(.vertical, 8)
    }
}
