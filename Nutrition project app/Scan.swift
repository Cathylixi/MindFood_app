//
//  Scan.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/14.
//

import SwiftUI

// 超简化版本 - 纯静态UI，无任何实际功能
struct Scan: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 背景色
            Color.black.edgesIgnoringSafeArea(.all)
            
            // 主要内容
            VStack(spacing: 20) {
                // 顶部栏
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    
                    Spacer()
                    
                    Text("Scan Menu")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // 平衡左侧按钮的空间
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.clear)
                        .padding(10)
                }
                .padding(.top, 30)
                
                // 模拟相机取景框
                VStack {
                    Spacer()
                    
                    // 模拟相机取景框
                    ZStack {
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 250, height: 250)
                        
                        // 角标记
                        VStack {
                            HStack {
                                L_shape().foregroundColor(.white)
                                Spacer()
                                L_shape().rotationEffect(.degrees(90)).foregroundColor(.white)
                            }
                            Spacer()
                            HStack {
                                L_shape().rotationEffect(.degrees(270)).foregroundColor(.white)
                                Spacer()
                                L_shape().rotationEffect(.degrees(180)).foregroundColor(.white)
                            }
                        }
                        .frame(width: 260, height: 260)
                    }
                    
                    Spacer()
                    
                    // 指导文本
                    Text("Position menu in frame")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(10)
                }
                .frame(maxHeight: .infinity)
                
                // 底部工具栏
                HStack(spacing: 50) {
                    // 左侧按钮
                    Button(action: {}) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    
                    // 中间拍摄按钮
                    Button(action: {}) {
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 62, height: 62)
                            )
                    }
                    
                    // 右侧按钮
                    Button(action: {}) {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal)
        }
    }
}

// 相机取景框的L形标记
struct L_shape: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 20, height: 4)
            Rectangle()
                .frame(width: 4, height: 20)
                .offset(x: -8, y: 8)
        }
    }
}

#Preview {
    Scan()
}
