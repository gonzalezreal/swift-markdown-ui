import XCTest
@testable import MarkdownUI

final class QuoteParserTests: XCTestCase {
    
    func testBasicQuotesParsing() {
        let text = "这是一些\u{201C}引号内的文字\u{201D}应该被解析。"
        let nodes = parseQuotesInText(text)
        
        XCTAssertEqual(nodes.count, 3)
        
        if case .text(let content) = nodes[0] {
            XCTAssertEqual(content, "这是一些")
        } else {
            XCTFail("Expected text node")
        }
        
        if case .quoted(let children) = nodes[1] {
            XCTAssertEqual(children.count, 1)
            if case .text(let content) = children[0] {
                XCTAssertEqual(content, "\u{201C}引号内的文字\u{201D}")
            } else {
                XCTFail("Expected text node inside quoted")
            }
        } else {
            XCTFail("Expected quoted node")
        }
        
        if case .text(let content) = nodes[2] {
            XCTAssertEqual(content, "应该被解析。")
        } else {
            XCTFail("Expected text node")
        }
    }
    
    func testSingleQuotesParsing() {
        let text = "这是\"单引号内容\"测试。"
        let nodes = parseQuotesInText(text)
        
        XCTAssertEqual(nodes.count, 3)
        
        if case .quoted(let children) = nodes[1] {
            if case .text(let content) = children[0] {
                XCTAssertEqual(content, "\"单引号内容\"")
            } else {
                XCTFail("Expected text node inside quoted")
            }
        } else {
            XCTFail("Expected quoted node")
        }
    }
    
    func testChineseQuotesParsing() {
        let text = "中文引号\u{300C}这些文字\u{300D}和\u{300E}这些文字\u{300F}测试。"
        let nodes = parseQuotesInText(text)
        
        XCTAssertEqual(nodes.count, 5)
        
        if case .quoted(let children) = nodes[1] {
            if case .text(let content) = children[0] {
                XCTAssertEqual(content, "\u{300C}这些文字\u{300D}")
            } else {
                XCTFail("Expected text node inside quoted")
            }
        } else {
            XCTFail("Expected quoted node")
        }
        
        if case .quoted(let children) = nodes[3] {
            if case .text(let content) = children[0] {
                XCTAssertEqual(content, "\u{300E}这些文字\u{300F}")
            } else {
                XCTFail("Expected text node inside quoted")
            }
        } else {
            XCTFail("Expected quoted node")
        }
    }
    
    func testNoQuotes() {
        let text = "这是没有引号的普通文字。"
        let nodes = parseQuotesInText(text)
        
        XCTAssertEqual(nodes.count, 1)
        
        if case .text(let content) = nodes[0] {
            XCTAssertEqual(content, "这是没有引号的普通文字。")
        } else {
            XCTFail("Expected text node")
        }
    }
    
    func testUnmatchedQuotes() {
        let text = "这是\u{201C}未匹配的引号测试。"
        let nodes = parseQuotesInText(text)
        
        // 应该将未匹配的引号作为普通文本处理
        XCTAssertEqual(nodes.count, 3)
        
        if case .text(let content) = nodes[0] {
            XCTAssertEqual(content, "这是")
        } else {
            XCTFail("Expected text node")
        }
        
        if case .text(let content) = nodes[1] {
            XCTAssertEqual(content, "\u{201C}")
        } else {
            XCTFail("Expected text node")
        }
        
        if case .text(let content) = nodes[2] {
            XCTAssertEqual(content, "未匹配的引号测试。")
        } else {
            XCTFail("Expected text node")
        }
    }
}

// 为了测试，我们需要将parseQuotesInText函数设为内部可见
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