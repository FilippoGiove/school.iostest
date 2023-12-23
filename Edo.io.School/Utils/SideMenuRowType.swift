//
//  SideMenuRowType.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
enum SideMenuRowType: Int, CaseIterable{
    case logout = 0


    var title: String{
        switch self {
        case .logout:
            return "LOGOUT".localized
        }
    }

    var iconName: String{
        switch self {
        case .logout:
            return "logout"
        }
    }
}
