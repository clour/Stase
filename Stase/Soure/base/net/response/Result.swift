//
//  Result.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/24.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import Foundation
import SwiftyJSON

enum UserDefaultKey: String {
    case token = "LocalToken"
}

enum TokenKey: String{
    case access_token = "access_token"
    case scope = "scope"
    case token_type = "token_type"
    case license = "license"
    case jti = "jti"
    case refresh_token = "refresh_token"
    case expires_in = "expires_in"
    case userId = "userId"
}

enum ErrorKey: String{
    case error = "error"
    case error_description = "error_description"
}

enum AuthKey: String{
    case Authorization = "Authorization"
    case Bearer = "Bearer "
    case accesstoken = "accesstoken"
    case access_token = "access_token"
    case host = "http://gate.czxbe.net:8060/"
}

struct Token {
    
    var access_token: String
    var scope: String
    var token_type: String
    var license: String
    var jti: String
    var refresh_token: String
    var expires_in: Int
    var userId: String
    var expires: Date
    
    init(access_token: String = ""
        , scope: String = ""
        , token_type: String = ""
        , license: String = ""
        , jti: String = ""
        , refresh_token: String = ""
        , expires_in: Int = -1
        , userId: String = ""
        , expires: Date = Date()
    ){
        self.access_token = access_token
        self.scope = scope
        self.token_type = token_type
        self.license = license
        self.jti = jti
        self.refresh_token = refresh_token
        self.expires_in = expires_in
        self.userId = userId
        self.expires = expires
    }
    
    init(token_json: Dictionary<String, JSON>
    ){
        if let access_token = token_json[TokenKey.access_token.rawValue] {
            self.access_token = access_token.stringValue
        }
        else{
            self.access_token = ""
        }
        if let scope = token_json[TokenKey.scope.rawValue] {
            self.scope = scope.stringValue
        }
        else{
            self.scope = ""
        }
        if let token_type = token_json[TokenKey.token_type.rawValue] {
            self.token_type = token_type.stringValue
        }
        else{
            self.token_type = ""
        }
        if let license = token_json[TokenKey.license.rawValue] {
            self.license = license.stringValue
        }
        else{
            self.license = ""
        }
        if let jti = token_json[TokenKey.jti.rawValue] {
            self.jti = jti.stringValue
        }
        else{
            self.jti = ""
        }
        if let refresh_token = token_json[TokenKey.refresh_token.rawValue] {
            self.refresh_token = refresh_token.stringValue
        }
        else{
            self.refresh_token = ""
        }
        if let expires_in = token_json[TokenKey.expires_in.rawValue] {
            self.expires_in = expires_in.intValue
            
            let calendar = Calendar.current
            
            self.expires = calendar.date(byAdding: Calendar.Component.second, value: self.expires_in - 100, to: Date()) ?? Date()
        }
        else{
            self.expires_in = -1
            self.expires = Date()
        }
        if let userId = token_json[TokenKey.userId.rawValue]{
            self.userId = userId.stringValue
        }
        else{
            self.userId = ""
        }
        
        
    }
    
    init(token_json: Dictionary<String, Any>
    ){
        if let access_token = token_json[TokenKey.access_token.rawValue] {
            self.access_token = access_token as! String
        }
        else{
            self.access_token = ""
        }
        if let scope = token_json[TokenKey.scope.rawValue] {
            self.scope = scope as! String
        }
        else{
            self.scope = ""
        }
        if let token_type = token_json[TokenKey.token_type.rawValue] {
            self.token_type = token_type as! String
        }
        else{
            self.token_type = ""
        }
        if let license = token_json[TokenKey.license.rawValue] {
            self.license = license as! String
        }
        else{
            self.license = ""
        }
        if let jti = token_json[TokenKey.jti.rawValue] {
            self.jti = jti as! String
        }
        else{
            self.jti = ""
        }
        if let refresh_token = token_json[TokenKey.refresh_token.rawValue] {
            self.refresh_token = refresh_token as! String
        }
        else{
            self.refresh_token = ""
        }
        if let expires_in = token_json[TokenKey.expires_in.rawValue] {
            self.expires_in = expires_in as! Int
            
            let calendar = Calendar.current
            
            self.expires = calendar.date(byAdding: Calendar.Component.second, value: self.expires_in - 100, to: Date()) ?? Date()
        }
        else{
            self.expires_in = -1
            self.expires = Date()
        }
        if let userId = token_json[TokenKey.userId.rawValue]{
            self.userId = userId as! String
        }
        else{
            self.userId = ""
        }
    }
    
    func isExpired() -> Bool {
        return expires.compare(Date()) == ComparisonResult.orderedAscending
    }
    
    func dictionary() -> Dictionary<String, Any> {
        return ["access_token": access_token,
                "scope": scope,
                "token_type": token_type,
                "license": license,
                "jti": jti,
                "refresh_token": refresh_token,
                "expires_in": expires_in,
                "userId": userId,
                "expires": expires]
    }
}

struct Error {
    
    var error: String
    var error_description: String
    
    init(error: String = ""
        , error_description: String = ""
    ){
        self.error = error
        self.error_description = error_description
    }
}
