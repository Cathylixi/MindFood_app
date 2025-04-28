//
//  AiChatBox.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/14.
//

import Foundation
import SwiftUI
import PhotosUI // 添加PhotosUI库

struct AiChatBox: View {
    @StateObject private var chatService = ChatGPTService(apiKey: "sk-t9Ckmg0u6-bJbGxhr3XQaaxvdTpuEYX9CWTcc3g3_cT3BlbkFJUI8GlLsj_TSWltvXGyxSf5-pN5zdVHuxmLgBsNEOwA")
    @State private var newMessage: String = ""
    @State private var screenWidth: CGFloat = UIScreen.main.bounds.width
    @Environment(\.dismiss) private var dismiss
    
    // 添加图片选择相关状态
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingFullScreenImage: Bool = false
    
    // Predefined initial messages
    private let initialMessages: [Message] = [
        Message(content: "Hello! I'm your Mindfood AI assistant. I can help you manage your pre-diabetes with diet recommendations, glucose tracking insights, and more. How can I assist you today?", isUserMessage: false),
        Message(content: "I can help you with:", isUserMessage: false, tags: ["Diet tips", "Glucose tracking", "Recipe ideas", "Exercise advice"])
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            HStack(spacing: 8) {
                // 将左侧图标修改为返回按钮
                Button(action: {
                    dismiss() // 点击返回上一页
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.orange)
                    .padding(10)
                        .background(Color.orange.opacity(0.1))
                    .clipShape(Circle())
                }
                
                Text("Mindfood AI")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#4A4A4A"))
                
                Spacer()
                
                // 添加清空聊天按钮
                Button(action: {
                    // 清空聊天记录，恢复到初始状态
                    chatService.clearChat()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.orange)
                        .padding(10)
                        .background(Color.orange.opacity(0.1))
                        .clipShape(Circle())
                }
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

            // Chat history view
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(spacing: 15) {
                        // 始终显示初始引导信息和功能选项
                        // Add "Today" separator
                        Text("Today")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(UIColor.systemGray5))
                            .clipShape(Capsule())
                            .padding(.vertical, 10)
                        
                        // 显示初始欢迎消息（不包括"I can help you with"消息）
                        if let welcomeMessage = initialMessages.first {
                            ChatBubble(
                                text: welcomeMessage.content,
                                isUser: welcomeMessage.isUserMessage,
                                tags: welcomeMessage.tags,
                                onTagTapped: { tag in
                                    sendMessage(tag)
                                },
                                screenWidth: screenWidth
                            )
                            .transition(.opacity)
                            .id(welcomeMessage.id)
                        }
                        
                        // 始终显示"I can help you with"消息及其标签
                        if initialMessages.count > 1 {
                            let helpMessage = initialMessages[1]
                            ChatBubble(
                                text: helpMessage.content,
                                isUser: helpMessage.isUserMessage,
                                tags: helpMessage.tags,
                                onTagTapped: { tag in
                                    sendMessage(tag)
                                },
                                screenWidth: screenWidth
                            )
                            .transition(.opacity)
                            .id(helpMessage.id)
                        }
                        
                        // 显示功能建议和健康数据分析
                        chatSuggestions()
                            .padding(.top, 10)
                        
                        // 显示用户和AI之间的对话消息
                        if !chatService.messages.isEmpty {
                            Divider()
                                .padding(.vertical, 10)
                            
                            ForEach(chatService.messages) { message in
                                ChatBubble(
                                    text: message.content,
                                    isUser: message.isUserMessage,
                                    tags: message.tags,
                                    image: message.image,
                                    onTagTapped: { tag in
                                        sendMessage(tag)
                                    },
                                    screenWidth: screenWidth
                                )
                                .transition(.opacity)
                                .id(message.id)
                            }
                        }
                        
                        // 显示加载指示器
                        if chatService.isLoading {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                Text("Thinking...")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .id("loading")
                        }
                        
                        // 显示错误信息
                        if let errorMessage = chatService.errorMessage {
                            Text("Error: \(errorMessage)")
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id("error")
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                .onChange(of: chatService.messages.count) { _ in
                    // Scroll to the latest message
                    if let lastMessageId = chatService.messages.last?.id {
                        withAnimation {
                            scrollView.scrollTo(lastMessageId, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: chatService.isLoading) { isLoading in
                    if isLoading {
                        withAnimation {
                            scrollView.scrollTo("loading", anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            VStack(spacing: 0) {
                Divider()
                
                // 如果选择了图片，显示图片预览
                if let selectedImage = selectedImage {
                    HStack {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 60)
                            .frame(maxWidth: 100)
                            .cornerRadius(8)
                            .padding(.leading)
                            .onTapGesture {
                                isShowingFullScreenImage = true
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            self.selectedImage = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                                .font(.system(size: 20))
                        }
                        .padding(.trailing)
                    }
                    .padding(.vertical, 6)
                    .background(Color(UIColor.systemGray6).opacity(0.5))
                }
                
                HStack(spacing: 12) {
                    // Add (+) Button - 修改为打开图片选择器
                    Button(action: {
                        isImagePickerPresented = true // 显示图片选择器
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.gray)
                    }
                    
                    // Text input field with placeholder smiley
                    ZStack(alignment: .trailing) {
                        TextField("Type your question...", text: $newMessage)
                            .padding(.leading, 12)
                            .padding(.trailing, 35) // Space for the smiley
                            .padding(.vertical, 10)
                            .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                        
                        // Placeholder for Smiley icon
                        Image(systemName: "face.smiling")
                             .foregroundColor(.gray)
                             .padding(.trailing, 12)
                             .opacity(newMessage.isEmpty ? 0.6 : 0) // Show only when empty
                    }
                    
                    // Send button (Updated style)
                    Button(action: {
                        if selectedImage != nil || !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            sendMessage(newMessage)
                        }
                    }) {
                    Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                            .padding(8)
                            .background(Color(hex: "#FFBE98")) // Use theme color
                        .clipShape(Circle())
                            
                    }
                    .disabled(selectedImage == nil && newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity((selectedImage == nil && newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? 0.5 : 1.0) // Dim when disabled

                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                 .padding(.bottom, 5) // Add padding for home indicator area if needed
            }
            .background(Color(UIColor.systemBackground)) // Use system background
           // Removed shadow from input area to match design
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.orange.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .onAppear {
            screenWidth = UIScreen.main.bounds.width
            // 清空聊天服务中的消息，确保每次打开页面都从初始状态开始
            chatService.clearChat()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .fullScreenCover(isPresented: $isShowingFullScreenImage) {
            if let image = selectedImage {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                isShowingFullScreenImage = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                }
                .statusBar(hidden: true)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // Prevent keyboard overlap
    }
    
    // Function to send message
    private func sendMessage(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 创建用户消息，包含图片
        let userMessage = Message(content: trimmedText, isUserMessage: true, tags: [], image: selectedImage)
        
        withAnimation {
            // 添加用户消息到聊天记录
            chatService.messages.append(userMessage)
            
            // 如果有图片，模拟AI回复关于图片的消息
            if let _ = selectedImage {
                let imageResponseContent = "I've received your image. "
                    + (trimmedText.isEmpty ? "What would you like to know about this?" : "Analyzing it along with your message.")
                
                // 模拟加载
                chatService.isLoading = true
                
                // 延迟1.5秒后回复，模拟分析时间
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    let aiResponse = Message(
                        content: imageResponseContent,
                        isUserMessage: false,
                        tags: ["Food analysis", "Nutrition info"]
                    )
                    chatService.messages.append(aiResponse)
                    chatService.isLoading = false
                }
            }
            // 如果没有图片，正常发送文本消息
            else if !trimmedText.isEmpty {
                chatService.sendMessage(trimmedText)
            }
            
            // 清空输入
            newMessage = ""
            selectedImage = nil
        }
    }
    
    // Quick access buttons for common queries
    private func chatSuggestions() -> some View {
        VStack(spacing: 16) {
            // Add the label above the grid
            Text("Tap a question to get started")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 8)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                FeatureTile(
                    title: "Food recommendations", 
                    subtitle: "What can I eat?",    
                    screenWidth: screenWidth,
                    onTap: { sendMessage("What food can I eat for pre-diabetes?") }
                )

                FeatureTile(
                    title: "Exercise impacts",  
                    subtitle: "How does it help?", 
                    screenWidth: screenWidth,
                    onTap: { sendMessage("How does exercise help manage pre-diabetes?") }
                )

                FeatureTile(
                    title: "Meal planning",      
                    subtitle: "Low-glycemic options", 
                    screenWidth: screenWidth,
                    onTap: { sendMessage("Suggest a low-glycemic meal plan") }
                )

                FeatureTile(
                    title: "Healthy snacks",    
                    subtitle: "Blood sugar friendly", 
                    screenWidth: screenWidth,
                    onTap: { sendMessage("What are some healthy snacks for pre-diabetes?") }
                )
            }
            
            // 添加健康数据分析组件
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    // 图表图标
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(Color.orange.opacity(0.8))
                        .font(.title2)
                    
                    Text("Your health data")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#4A4A4A"))
                }
                
                Text("I can analyze your recent glucose readings and diet logs to provide personalized insights.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                
                Button(action: {
                    print("Analyze data tapped")
                    // 可以添加实际的数据分析动作
                }) {
                    Text("Analyze my data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#FFBE98").opacity(0.75))
                        .cornerRadius(16)
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding()
            .background(Color.orange.opacity(0.03)) // 降低透明度，使背景非常透明，只有一点点颜色
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .padding()
    }
}

// Chat bubble component for displaying messages
struct ChatBubble: View {
    let text: String
    var isUser: Bool = false
    var tags: [String] = []
    var image: UIImage? = nil // 添加图片属性
    var onTagTapped: ((String) -> Void)? = nil
    var screenWidth: CGFloat
    
    // 是否为"I can help you with:"消息
    private var isHelpMessage: Bool {
        return text.contains("I can help you with") && !isUser && !tags.isEmpty
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // 显示AI助手头像（仅非用户消息显示）
            if !isUser {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.orange)
                    .padding(10)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Circle())
            }
            
            VStack(alignment: isUser ? .trailing : .leading, spacing: 8) {
                // Message content
        VStack(alignment: .leading, spacing: 8) {
                    // 如果有图片，显示图片
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: screenWidth * 0.6)
                            .cornerRadius(12)
                            .padding(.horizontal, 8)
                            .padding(.top, 8)
                    }
                    
                    // 如果有文本内容，显示文本
                    if !text.isEmpty {
            Text(text)
                            .lineSpacing(4) 
                            .padding(.horizontal, isHelpMessage ? 16 : 16)
                            .padding(.vertical, isHelpMessage ? 12 : 12)
                            .padding(.bottom, isHelpMessage ? 0 : 12)
                    }
                    
                    // 如果是"I can help you with"消息，直接在气泡内显示标签
                    if isHelpMessage {
                        // 第一行标签
                        HStack(spacing: 8) {
                            ForEach(Array(tags.prefix(2)), id: \.self) { tag in
                                Button(action: {
                                    onTagTapped?(tag)
                                }) {
                                    Text(tag)
                                        .font(.system(size: 13))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(hex: "#FFBE98").opacity(0.2))
                                        .foregroundColor(Color(hex: "#FF9E62"))
                                        .cornerRadius(15)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        .padding(.top, 4)
                        
                        // 第二行标签
                        if tags.count > 2 {
                            HStack(spacing: 8) {
                                ForEach(Array(tags.suffix(from: 2)), id: \.self) { tag in
                                    Button(action: {
                                        onTagTapped?(tag)
                                    }) {
                                        Text(tag)
                                            .font(.system(size: 13))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color(hex: "#FFBE98").opacity(0.2))
                                            .foregroundColor(Color(hex: "#FF9E62"))
                                            .cornerRadius(15)
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                            }
                            .padding(.bottom, 12)
                        }
                    }
                }
                .padding(2)
                .background(isUser ? Color(hex: "#FFBE98").opacity(0.2) : Color(UIColor.systemBackground)) 
                .foregroundColor(isUser ? .primary : .primary)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 1)
                .frame(maxWidth: screenWidth * 0.8, alignment: isUser ? .trailing : .leading)

                // 只有非帮助消息且非用户消息时才在气泡外显示标签
                if !isUser && !tags.isEmpty && !isHelpMessage {
                    // Organize tags in two rows
                    VStack(alignment: .leading, spacing: 8) {
                        // First row: first two tags or fewer
                        HStack(spacing: 8) {
                            ForEach(Array(tags.prefix(2)), id: \.self) { tag in
                                Button(action: {
                                    onTagTapped?(tag)
                                }) {
                                    Text(tag)
                                        .font(.system(size: 13))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(hex: "#FFBE98").opacity(0.2))
                                        .foregroundColor(Color(hex: "#FF9E62"))
                                        .cornerRadius(15)
                                }
                                .buttonStyle(ScaleButtonStyle())
                            }
                        }
                        
                        // Second row: remaining tags (if any)
                        if tags.count > 2 {
                            HStack(spacing: 8) {
                                ForEach(Array(tags.suffix(from: 2)), id: \.self) { tag in
                                    Button(action: {
                                        onTagTapped?(tag)
                                    }) {
                    Text(tag)
                                            .font(.system(size: 13))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                                            .background(Color(hex: "#FFBE98").opacity(0.2))
                                            .foregroundColor(Color(hex: "#FF9E62"))
                                            .cornerRadius(15)
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                }
                            }
                        }
                    }
                    .frame(maxWidth: screenWidth * 0.8, alignment: .leading)
                    .padding(.leading, isUser ? 0 : 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
            
            // 用户头像（仅用户消息显示）
            if isUser {
                Image(systemName: "person.fill")
                    .foregroundColor(Color(UIColor.systemGray))
                    .padding(9)
                    .background(Color(UIColor.systemGray5))
                    .clipShape(Circle())
                    .frame(width: 36, height: 36)
            } else {
                // 为非用户消息预留相同的空间以保持对称
                Spacer()
                    .frame(width: 36)
            }
        }
        .padding(.vertical, 2)
    }
}

// Feature tile component for suggested queries
struct FeatureTile: View {
    let title: String
    let subtitle: String
    let screenWidth: CGFloat
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
            Text(title)
                    .font(.system(size: 15, weight: .medium)) // Keep title line limit if desired, or remove
                .foregroundColor(.black)
                    .lineLimit(1)

            Text(subtitle)
                    .font(.system(size: 12))
                .foregroundColor(.gray)
                    // .lineLimit(1) // Removed line limit for subtitle
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12) // Adjusted corner radius slightly if needed
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2) // Adjusted shadow slightly if needed
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Custom button style for subtle scale animation
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Extension for initializing Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// 添加图片选择器
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
            
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else { return }
                    self.parent.selectedImage = image
                }
            }
        }
    }
}

#Preview {
    AiChatBox()
}
