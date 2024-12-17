//
//  File.swift
//  swift-markdown-ui
//
//  Created by aterzhang on 2024/12/17.
//

import Foundation

public func parseMarkdownLink(_ inputString: String?) -> (String, String)? {
    guard let markdown = inputString else {
        return nil
    }
    let pattern = "\\[(.*?)\\]\\((.*?)\\)"
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    
    if let match = regex?.firstMatch(in: markdown, options: [], range: NSRange(location: 0, length: markdown.utf16.count)) {
        let textRange = Range(match.range(at: 1), in: markdown)
        let urlRange = Range(match.range(at: 2), in: markdown)
        
        if let textRange = textRange, let urlRange = urlRange {
            let textContent = String(markdown[textRange])
            let urlContent = String(markdown[urlRange])
            return (textContent, urlContent)
        }
    }
    
    return nil
}
