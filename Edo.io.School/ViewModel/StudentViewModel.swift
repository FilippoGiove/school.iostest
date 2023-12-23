//
//  StudentViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 23/12/23.
//

import Foundation
import SwiftUI
import Foundation
import RealmSwift
class StudentViewModel: ObservableObject {
    @Published var student: Student

    init(student: Student) {
        self.student = student
    }
}
