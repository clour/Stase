//
//  LocalStore.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/24.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import Foundation

class LocalStore{
    
    static let instance = LocalStore()
    
    func getToken() -> Any? {
        return UserDefaults.standard.value(forKey: UserDefaultKey.token.rawValue)
    }
    
    func saveToken(token: Token?){
        if let localToken = token {
            UserDefaults.standard.set(localToken.dictionary(), forKey: UserDefaultKey.token.rawValue)
        }
    }
    
    func removeToken(){
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.token.rawValue)
    }
}
