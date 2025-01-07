//
//  MDEventManager.swift
//  MarkdownTest
//
//  Created by Ericmao on 2025/1/4.
//

import Foundation
import UIKit

class MDEventManager {
    static let shared = MDEventManager()

    private init() {
        
    }
    
    //点击 Markdown 中的数字索引
    @objc func onIndexClicked(_ tapgr: UITapGestureRecognizer) {
        if let label = tapgr.view as? UILabel {
            let text = label.text
            let frame = label.frame
            
            print("On Link Index clicked:\(String(describing: text)) \(frame)")
        }
    }
    
}
