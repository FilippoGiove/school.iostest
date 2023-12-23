//
//  ProfessorViewModel.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 23/12/23.
//

import Foundation
import Foundation
import SwiftUI
import Foundation
import RealmSwift
class ProfessorViewModel: ObservableObject {
    @Published var professor: Professor

    init(professor: Professor) {
        self.professor = professor
    }
}
