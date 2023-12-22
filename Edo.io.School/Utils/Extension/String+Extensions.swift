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

    public func createIndentifier()->String{
        return "\(Date().timeIntervalSince1970)\(self)".toBase64()
    }

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    func splitSubjects()->[String]{
        return self.components(separatedBy: ",")
    }

}
