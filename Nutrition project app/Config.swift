//
//  Config.swift
//  Nutrition project app
//
//  Created for API configuration
//

import Foundation

// 全局配置常量
struct AppConfig {
    // 替换为您的实际API密钥
    static let apiKey = "your-openai-api-key-here"
    
    // API模型配置
    static let modelName = "gpt-4o"
    static let temperature: Float = 0.7
    static let maxTokens: Int = 1000
    
    // 应用信息
    static let appName = "Mindfood AI"
    static let version = "1.0.0"
}

// 使用示例:
// let service = ChatGPTService(apiKey: Config.OpenAI.apiKey)

