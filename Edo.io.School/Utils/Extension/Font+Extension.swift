//
//  Font+Extension.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import SwiftUI
extension Font{
    public static var titleFont: Font {
        Font.custom("Roboto-Bold", size: 18)
    }
    public static var contentFont: Font {
        Font.custom("Roboto-Regular", size: 14)
    }
    public static var contentFontBold: Font {
        Font.custom("Roboto-Bold", size: 14)
    }
    public static var smallFont: Font {
        Font.custom("Roboto-Light", size: 12)
    }
}
