//
//  File.swift
//  swift-markdown-ui
//
//  Created by aterzhang on 2024/12/17.
//

import SwiftUI

public extension EnvironmentValues {
  var textReplacer: ((String) -> String)? {
    get { self[TextReplacerKey.self] }
    set { self[TextReplacerKey.self] = newValue }
  }
}

public struct TextReplacerKey: EnvironmentKey {
    public static var defaultValue: ((String) -> String)? = nil
}

