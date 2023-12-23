//
//  View+Extension.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import SwiftUI
extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}
