//
//  ChatGPTService.swift
//  Nutrition project app
//
//  Created by xixi on 2025/4/26.
//

import Foundation
import Combine
import UIKit // 添加UIKit导入以支持UIImage

// Message model to represent chat messages
struct Message: Identifiable, Codable {
    let id: UUID
    let content: String
    let isUserMessage: Bool
    let timestamp: Date
    var tags: [String] = []
    var image: UIImage? = nil // 添加图片属性，但不参与编解码
    
    init(id: UUID = UUID(), content: String, isUserMessage: Bool, timestamp: Date = Date(), tags: [String] = [], image: UIImage? = nil) {
        self.id = id
        self.content = content
        self.isUserMessage = isUserMessage
        self.timestamp = timestamp
        self.tags = tags
        self.image = image
    }
    
    // 实现编码方法，排除image属性
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(isUserMessage, forKey: .isUserMessage)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(tags, forKey: .tags)
        // image属性不参与编码
    }
    
    // 实现解码方法，只解码可序列化的属性
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        isUserMessage = try container.decode(Bool.self, forKey: .isUserMessage)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        tags = try container.decode([String].self, forKey: .tags)
        image = nil // 解码时image为nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, content, isUserMessage, timestamp, tags
    }
}

// Request and response models for OpenAI API
struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Float?
    let max_tokens: Int?
    let top_p: Float?
    let frequency_penalty: Float?
    let presence_penalty: Float?
    let response_format: ResponseFormat?
    
    init(model: String = "gpt-4o", 
         messages: [ChatMessage], 
         temperature: Float = 0.7, 
         max_tokens: Int = 1000) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.top_p = 1.0
        self.frequency_penalty = 0.0
        self.presence_penalty = 0.0
        self.response_format = ResponseFormat(type: "text")
    }
}

struct ResponseFormat: Codable {
    let type: String
}

struct ChatMessage: Codable {
    let role: String
    let content: MessageContent
    
    init(role: String, textContent: String) {
        self.role = role
        self.content = .text(textContent)
    }
    
    init(role: String, contentItems: [ContentItem]) {
        self.role = role
        self.content = .array(contentItems)
    }
}

enum MessageContent: Codable {
    case text(String)
    case array([ContentItem])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self = .text(string)
            return
        }
        
        if let array = try? container.decode([ContentItem].self) {
            self = .array(array)
            return
        }
        
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Could not decode MessageContent"
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .text(let string):
            try container.encode(string)
        case .array(let array):
            try container.encode(array)
        }
    }
}

struct ContentItem: Codable {
    let type: String
    let text: String?
    let imageUrl: ImageUrl?
    
    init(type: String, text: String? = nil, imageUrl: ImageUrl? = nil) {
        self.type = type
        self.text = text
        self.imageUrl = imageUrl
    }
    
    // Convenience initializer for text content
    static func text(_ content: String) -> ContentItem {
        return ContentItem(type: "text", text: content)
    }
    
    // Convenience initializer for image URL content
    static func imageUrl(_ urlString: String) -> ContentItem {
        return ContentItem(type: "image_url", imageUrl: ImageUrl(url: urlString))
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case text
        case imageUrl = "image_url"
    }
}

struct ImageUrl: Codable {
    let url: String
}

struct ChatCompletionResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    
    struct Choice: Codable {
        let index: Int
        let message: ChatMessage
        let finish_reason: String
    }
}

class ChatGPTService: ObservableObject {
    // Published properties for UI binding
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // API configuration
    private let apiKey: String
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    // System prompt that helps define the assistant's behavior
    private let systemPrompt = """
    You are a nutrition assistant specialized in helping people with pre-diabetes manage their diet and health. 
    Focus on providing actionable nutrition advice, meal suggestions, and explanations about how different foods affect blood sugar levels.
    When users ask about specific foods, provide detailed nutritional information and glycemic index values when available.
    Recommend balanced meal plans that help maintain stable blood sugar levels.
    Always be supportive and encouraging, offering practical tips that are easy to implement.
    Keep responses concise and focused on nutrition and pre-diabetes management.
    """
    
    init(apiKey: String = "sk-t9Ckmg0u6-bJbGxhr3XQaaxvdTpuEYX9CWTcc3g3_cT3BlbkFJUI8GlLsj_TSWltvXGyxSf5-pN5zdVHuxmLgBsNEOwA") {
        self.apiKey = apiKey
    }
    
    // Send a message to ChatGPT and handle the response
    func sendMessage(_ content: String) {
        // Create and add user message
        let userMessage = Message(content: content, isUserMessage: true)
        messages.append(userMessage)
        
        isLoading = true
        errorMessage = nil
        
        // Prepare message history for API request
        let apiMessages = prepareAPIMessages()
        
        // Create request
        let requestBody = ChatCompletionRequest(messages: apiMessages)
        
        // Convert request to JSON
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            self.handleError("Failed to encode request")
            return
        }
        
        // Create URL request
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // Make API call
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.handleError("Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.handleError("Invalid response")
                    return
                }
                
                if httpResponse.statusCode != 200 {
                    if let data = data, let errorResponse = String(data: data, encoding: .utf8) {
                        self.handleError("API error: \(errorResponse)")
                    } else {
                        self.handleError("API error: Status code \(httpResponse.statusCode)")
                    }
                    return
                }
                
                guard let data = data else {
                    self.handleError("No data received")
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
                    if let assistantMessage = decodedResponse.choices.first?.message {
                        // Process the response and extract tags
                        let content = self.extractTextContent(from: assistantMessage.content)
                        self.processResponse(content)
                    } else {
                        self.handleError("No message in response")
                    }
                } catch {
                    self.handleError("Failed to decode response: \(error.localizedDescription)")
                    print("Decode error details: \(error)")
                }
            }
        }.resume()
    }
    
    // Process assistant's response and extract potential tags
    private func processResponse(_ content: String) {
        // Simple keyword extraction for tags
        let nutritionKeywords = ["carbohydrates", "protein", "fat", "fiber", "glycemic index", 
                                "sugar", "calories", "portion", "meal plan", "blood sugar",
                                "diabetes", "insulin", "whole grains", "vegetables", "fruits"]
        
        var extractedTags: [String] = []
        
        // Simple tag extraction based on keyword presence
        for keyword in nutritionKeywords {
            if content.lowercased().contains(keyword) && !extractedTags.contains(keyword) {
                extractedTags.append(keyword)
            }
            
            // Limit to 4 tags maximum
            if extractedTags.count >= 4 {
                break
            }
        }
        
        // Create and add assistant message with extracted tags
        let assistantMessage = Message(content: content, isUserMessage: false, tags: extractedTags)
        messages.append(assistantMessage)
    }
    
    // Clear chat history
    func clearChat() {
        messages.removeAll()
    }
    
    // Handle errors
    private func handleError(_ message: String) {
        print("ChatGPT Service Error: \(message)")
        errorMessage = message
        isLoading = false
    }
    
    // Modified version of prepare message for API
    private func prepareAPIMessages() -> [ChatMessage] {
        var apiMessages = [ChatMessage(role: "system", textContent: systemPrompt)]
        
        // Add conversation history (limited to last 10 messages for context)
        let recentMessages = messages.suffix(10)
        for message in recentMessages {
            let role = message.isUserMessage ? "user" : "assistant"
            apiMessages.append(ChatMessage(role: role, textContent: message.content))
        }
        
        return apiMessages
    }
    
    // Helper method to extract text content from MessageContent
    private func extractTextContent(from content: MessageContent) -> String {
        switch content {
        case .text(let text):
            return text
        case .array(let items):
            // For multimodal content, concatenate all text items
            return items.compactMap { item in
                if item.type == "text" {
                    return item.text
                }
                return nil
            }.joined(separator: "\n")
        }
    }
    
    // Send a multimodal message with text and optional image URLs
    func sendMultimodalMessage(text: String, imageURLs: [URL] = []) {
        // Create and add user message (for UI display, we'll just show the text)
        let userMessage = Message(content: text, isUserMessage: true)
        messages.append(userMessage)
        
        isLoading = true
        errorMessage = nil
        
        // Get base history messages
        var apiMessages = prepareAPIMessages()
        
        // Replace the last message with multimodal content
        if let lastIndex = apiMessages.indices.last, apiMessages[lastIndex].role == "user" {
            // Remove the simple text message we just added
            apiMessages.remove(at: lastIndex)
            
            // Create content items
            var contentItems: [ContentItem] = [ContentItem.text(text)]
            
            // Add image URLs if any
            for imageURL in imageURLs {
                contentItems.append(ContentItem.imageUrl(imageURL.absoluteString))
            }
            
            // Add the multimodal message
            let multimodalMessage = createMultimodalMessage(role: "user", contentItems: contentItems)
            apiMessages.append(multimodalMessage)
        }
        
        // Create request
        let requestBody = ChatCompletionRequest(messages: apiMessages)
        
        // Convert request to JSON
        guard let jsonData = try? JSONEncoder().encode(requestBody) else {
            self.handleError("Failed to encode multimodal request")
            return
        }
        
        // Create URL request
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // Make API call
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.handleError("Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.handleError("Invalid response")
                    return
                }
                
                if httpResponse.statusCode != 200 {
                    if let data = data, let errorResponse = String(data: data, encoding: .utf8) {
                        self.handleError("API error: \(errorResponse)")
                    } else {
                        self.handleError("API error: Status code \(httpResponse.statusCode)")
                    }
                    return
                }
                
                guard let data = data else {
                    self.handleError("No data received")
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
                    if let assistantMessage = decodedResponse.choices.first?.message {
                        // Process the response and extract tags
                        let content = self.extractTextContent(from: assistantMessage.content)
                        self.processResponse(content)
                    } else {
                        self.handleError("No message in response")
                    }
                } catch {
                    self.handleError("Failed to decode response: \(error.localizedDescription)")
                    print("Decode error details: \(error)")
                }
            }
        }.resume()
    }
    
    // Helper method to create a multimodal message
    private func createMultimodalMessage(role: String, contentItems: [ContentItem]) -> ChatMessage {
        return ChatMessage(role: role, contentItems: contentItems)
    }
}

