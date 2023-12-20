//
//  Font+Extension.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import SwiftUI
extension Font{
    public static var titleFont: Font {
        Font.system(size: 18,weight: .bold)
    }
    public static var contentFont: Font {
        Font.system(size: 14)
    }
}
