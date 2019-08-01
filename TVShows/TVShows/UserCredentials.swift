//
//  UserCredentials.swift
//  TVShows
//
//  Created by Borna on 30/07/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import Foundation
import KeychainAccess

class UserCredentials {
    
    private let keychain = Keychain(service: "com.borna.TVShows")
    private let EMAIL_KEY = "email"
    private let PASSWORD_KEY = "password"
    var userToken:String?
    var showId: String?
    
    private init(){}
    static let shared = UserCredentials()
    
    func saveUser(userName:String, password:String, completion:(Bool)->()) {
        keychain[EMAIL_KEY] = userName
        keychain[PASSWORD_KEY] = password
    }
    
    func deleteUser(completion:(Bool)->()) {
        do {
            try keychain.remove(EMAIL_KEY)
            try keychain.remove(PASSWORD_KEY)
            completion(true)
        } catch let error {
            completion(false)
            print("Error \(error)")
        }
    }
    
    func loggedUser() -> (username: String, password: String)? {
        guard let email = keychain[EMAIL_KEY], let password = keychain[PASSWORD_KEY] else { return nil }
        return (email, password)
    }
}
