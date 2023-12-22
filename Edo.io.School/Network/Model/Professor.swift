//
//  Professor.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
import RealmSwift

class Professor: Object,Identifiable, Codable  {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var beIdentifier: String
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var avatar: String
    @Persisted var subjects: List<String>
    enum CodingKeys: String, CodingKey {
        case beIdentifier = "_id"
        case name = "name"
        case email = "email"
        case avatar = "avatar"
        case subjects = "subjects"
    }

    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(beIdentifier, forKey: .beIdentifier)
            try container.encode(name, forKey: .name)
            try container.encode(email, forKey: .email)
            try container.encode(avatar, forKey: .avatar)
            try container.encode(subjects, forKey: .subjects)

        }

        required init(from decoder: Decoder) throws {
            super.init()
            let container = try decoder.container(keyedBy: CodingKeys.self)

            beIdentifier = try container.decode(String.self, forKey: .beIdentifier)
            name = try container.decode(String.self, forKey: .name)
            email = try container.decode(String.self, forKey: .email)
            avatar = try container.decode(String.self, forKey: .avatar)
            let subjectsList = try container.decode(List<String>.self, forKey: .subjects)
            subjects.append(objectsIn: subjectsList)
        }

    public override init() {
        super.init()
    }

    convenience init(_id: String,
                     name: String,
                     email: String,
                     avatar:String,
                     subjects: [String]
            ) {
        self.init()
        self.beIdentifier = _id
        self.name = name
        self.email = email
        self.avatar = avatar
        self.subjects = List<String>()
        for s in subjects{
            self.subjects.append(s)
        }
     }
}
