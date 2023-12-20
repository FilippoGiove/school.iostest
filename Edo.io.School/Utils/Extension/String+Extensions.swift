//
//  String+Extensions.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
}
