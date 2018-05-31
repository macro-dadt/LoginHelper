//
//  GoogleService.swift
//  LoginHelper
//
//  Created by Do Thanh Dat on 2018/05/30.
//  Copyright © 2018 DT Dat. All rights reserved.
//

import Foundation
import GoogleSignIn

public typealias GoogleCompletion = (GoogleResult) -> Void

public enum GoogleResult {
    
    case success(GoogleProfile)
    case error(Error)
    case missingPermissions
    case unknownError
    case cancelled
    
}
public struct GoogleProfile {
    
    public let googleId: String
    public let firstName: String
    public let lastName: String
    public let email: String
    public var fullName: String {
        return firstName + " " + lastName
    }
    
}
public class GoogleService {
    
}
extension GoogleService {
    func getUserInfo(){
        
    }
}
