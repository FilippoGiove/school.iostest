//
//  Student.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 20/12/23.
//

import Foundation
import RealmSwift
class Student: Object,Identifiable, Codable  {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var beIdentifier: String
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var avatar: String
    @Persisted var notes: String
    @Persisted var classroom: String
    enum CodingKeys: String, CodingKey {
        case beIdentifier = "_id"
        case name = "name"
        case email = "email"
        case avatar = "avatar"
        case notes = "notes"
        case classroom = "classroom"
    }
    public override init() {
        super.init()
    }

    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(beIdentifier, forKey: .beIdentifier)
            try container.encode(name, forKey: .name)
            try container.encode(email, forKey: .email)
            try container.encode(avatar, forKey: .avatar)
            try container.encode(notes, forKey: .notes)
            try container.encode(classroom, forKey: .classroom)

        }

        required init(from decoder: Decoder) throws {
            super.init()
            let container = try decoder.container(keyedBy: CodingKeys.self)

            beIdentifier = try container.decode(String.self, forKey: .beIdentifier)
            name = try container.decode(String.self, forKey: .name)
            email = try container.decode(String.self, forKey: .email)
            avatar = try container.decode(String.self, forKey: .avatar)
            classroom = try container.decode(String.self, forKey: .classroom)

        }

    convenience init(_id: String,
                     name: String,
                     email: String,
                     avatar:String,
                     notes:String,
                     classroom: String
            ) {
        self.init()
        self.beIdentifier = _id
        self.name = name
        self.email = email
        self.avatar = avatar
        self.notes = notes
        self.classroom = classroom
     }
}
