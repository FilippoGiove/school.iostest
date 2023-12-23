//
//  Endpoint.swift
//  Edo.io.School
//
//  Created by Filippo Giove on 21/12/23.
//

import Foundation
enum APPEnvironment {
    case test//,qa,prod<--example for adding new environments
}
let environment: APPEnvironment = .test

struct Endpoint {

    public static func getBaseurl()->String{
        if(environment == .test){
            return  "https://servicetest3.edo.io/school"
        }
        else{
            return ""
        }
    }

    public static func getBearerToken()->String{
        if(environment == .test){
            return  "V9AwxnQXsQYU"
        }
        else{
            return ""
        }
    }


    public static func getEnvironment() -> APPEnvironment {
        return environment
    }
}

//MARK: API urls
extension Endpoint{
    public static func getlistClassroomUrl()->String{
        return "\(getBaseurl())/classrooms"
    }
    public static func getCreateClassroomUrl(withId id:String)->String{
        return "\(getBaseurl())/classroom/\(id)"
    }
}

