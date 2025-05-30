import Foundation

extension Sequence where Element == InlineNode {
  /// 解析引号内的文本并将其标记为特殊的quoted节点
  func parseQuotes() -> [InlineNode] {
    return self.flatMap { node in
      switch node {
      case .text(let content):
        return parseQuotesInText(content)
      default:
        // 递归处理子节点
        var newNode = node
        newNode.children = newNode.children.parseQuotes()
        return [newNode]
      }
    }
  }
}

private func parseQuotesInText(_ text: String) -> [InlineNode] {
  var result: [InlineNode] = []
  var currentIndex = text.startIndex
  
  // 定义引号字符对
  let quoteChars = [
    "\"",
    "\u{201E}", // „
    "\u{00AB}", // «
    "\u{300C}", // 「
    "\u{201C}", // "
    "\u{00BB}", // »
    "\u{201D}", // "
    "\u{300D}", // 」
    "\u{300E}", // 『
    "\u{300F}"  // 』
  ]
  
  while currentIndex < text.endIndex {
    // 查找任何引号字符的开始位置
    var earliestQuoteRange: Range<String.Index>? = nil
    var foundOpenQuote: String = ""
    
    for quoteChar in quoteChars {
      if let range = text.range(of: quoteChar, range: currentIndex..<text.endIndex) {
        if earliestQuoteRange == nil || range.lowerBound < earliestQuoteRange!.lowerBound {
          earliestQuoteRange = range
          foundOpenQuote = quoteChar
        }
      }
    }
    
    guard let quoteStartRange = earliestQuoteRange else {
      // 没有更多引号，添加剩余文本
      let remainingText = String(text[currentIndex...])
      if !remainingText.isEmpty {
        result.append(.text(remainingText))
      }
      break
    }
    
    // 添加引号前的文本
    if currentIndex < quoteStartRange.lowerBound {
      let beforeQuote = String(text[currentIndex..<quoteStartRange.lowerBound])
      if !beforeQuote.isEmpty {
        result.append(.text(beforeQuote))
      }
    }
    
    let closeQuote = getMatchingCloseQuote(foundOpenQuote)
    
    // 查找对应的结束引号
    let searchStart = quoteStartRange.upperBound
    if let quoteEndRange = text.range(of: closeQuote, range: searchStart..<text.endIndex) {
      // 获取引号内的内容（包括引号本身）
      let quotedContent = String(text[quoteStartRange.lowerBound..<quoteEndRange.upperBound])
      if !quotedContent.isEmpty {
        result.append(.quoted(children: [.text(quotedContent)]))
      }
      currentIndex = quoteEndRange.upperBound
    } else {
      // 没有找到匹配的结束引号，将开始引号作为普通文本处理
      result.append(.text(foundOpenQuote))
      currentIndex = quoteStartRange.upperBound
    }
  }
  
  return result.isEmpty ? [.text(text)] : result
}

private func getMatchingCloseQuote(_ openQuote: String) -> String {
  switch openQuote {
  case "\"":
    return "\""
  case "\u{201E}": // „
    return "\u{201D}" // "
  case "\u{00AB}": // «
    return "\u{00BB}" // »
  case "\u{300C}": // 「
    return "\u{300D}" // 」
  case "\u{201C}": // "
    return "\u{201D}" // "
  case "\u{00BB}": // »
    return "\u{00AB}" // «
  case "\u{201D}": // "
    return "\u{201C}" // "
  case "\u{300D}": // 」
    return "\u{300C}" // 「
  case "\u{300E}": // 『
    return "\u{300F}" // 』
  case "\u{300F}": // 』
    return "\u{300E}" // 『
  default:
    return openQuote // 对于其他情况，使用相同的字符作为结束引号
  }
} 
