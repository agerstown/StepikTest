//
//  String+HtmlDecoding.swift
//  StepikTest
//
//  Created by Natalia Nikitina on 5/8/17.
//  Copyright © 2017 Natalia Nikitina. All rights reserved.
//

import UIKit

extension String {
    
    func decodedFromHtml() -> String {
        if let data = self.data(using: String.Encoding.unicode) {
            let decodedString = try? NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil).string
            return decodedString ?? ""
        }
        return ""
    }
    
}
