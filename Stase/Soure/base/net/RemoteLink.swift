//
//  User.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/20.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import Foundation

import Alamofire

import SwiftyJSON

class RemoteLink: ObservableObject {
    
    @Published var state: Bool? = nil  //是否需要登录    false需要    true 不需要
    @Published var loginError: Error? = nil
    @Published var isError: Bool = false
    
    var token: Token? = nil
    
    static let instance = RemoteLink()
    
    /**
     原始Token请求
     */
    func tokenRequest(method: HTTPMethod = .post,
                      parameters: Parameters? = nil) -> DataRequest {
        let url_access_token = "http://gate.czxbe.net:8060/auth/oauth/token"
        let headers: HTTPHeaders = [
            "Authorization": "Basic YXBwOmFwcA==",
            "Accept": "application/json"
        ]
        return Alamofire.request(url_access_token, method: method, parameters: parameters,encoding: URLEncoding.default,headers:headers)
    }
    
    /**
     直接Token请求
     */
    func token(method: HTTPMethod = .post,
               parameters: Parameters? = nil) {
        tokenRequest(method: method, parameters: parameters).responseJSON { response
            in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value{
                    
                    let token_json = JSON(value).dictionaryValue
                    
                    if let error = token_json[ErrorKey.error.rawValue] {
                        if let error_description = token_json[ErrorKey.error_description.rawValue]{
                            //print(error_description)
                            self.loginError = Error(error: error.stringValue, error_description: error_description.stringValue)
                        }
                        else{
                            self.loginError = Error(error: error.stringValue, error_description: "登录失败")
                        }
                        self.isError = true
                        return
                    }
                    else{
                        if token_json[TokenKey.access_token.rawValue] != nil {
                            self.token = Token(token_json: token_json)
                            LocalStore.instance.saveToken(token: self.token)
                            self.loginError = nil
                            self.isError = false
                            self.state = true
                            return
                        }
                        else{
                            self.loginError = Error(error: "link_error", error_description: "登录失败")
                            self.isError = true
                            self.state = false
                            return
                        }
                    }
                }
                break;
            case false:
                self.loginError = Error(error: "net_error", error_description: "登录失败")
                self.isError = true
                return
            }
        }
    }
    
    /**
     当Token过期时调用此方法，用来刷行Token
     */
    func refreshToken(){
        if let localToken = token {
            let parameters:Dictionary = ["grant_type": "refresh_token", "refresh_token": localToken.refresh_token]
            self.token(parameters: parameters)
        }
        else{
            token = nil
            self.state = false
        }
    }
    
    /**
     用户名、密码形式请求Token
     */
    func login(username: String, password: String) {
        
        if username.trimmingCharacters(in: .whitespaces) == "" {
            self.loginError = Error(error: "input_error", error_description: "用户名不能为空")
            self.isError = true
            return
        }
        if password.trimmingCharacters(in: .whitespaces) == "" {
            self.loginError = Error(error: "input_error", error_description: "密码不能为空")
            self.isError = true
            return
        }
        
        //参数
        let parameters:Dictionary = ["username":username,"password":password,
                                     "grant_type": "password"]
        self.token(parameters: parameters)
    }
    
    func authPost(url: String, parameters: Parameters? = nil) -> JSON? {
        var result: JSON? = nil
        if let localToken = token{
            if(localToken.isExpired()){
                refreshToken()
            }
            let headers: HTTPHeaders = [
                AuthKey.Authorization.rawValue: AuthKey.Bearer.rawValue + localToken.access_token,
                "Accept": "application/json"
            ]
            Alamofire.request(AuthKey.host.rawValue + url, method: .post, parameters: parameters,encoding: URLEncoding.default,headers:headers).responseJSON { response
                in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value{
                        
                        result = JSON(value)
                        break;
                    }
                case false:
                    result = nil
                }
            }
        }
        else{
            self.state = false
        }
        return result
    }
    
    func authGet(url: String, parameters: Parameters? = nil) -> JSON? {
        var result: JSON? = nil
        if let localToken = token{
            if(localToken.isExpired()){
                refreshToken()
            }
            let headers: HTTPHeaders = [
                AuthKey.Authorization.rawValue: AuthKey.Bearer.rawValue + localToken.access_token,
                "Accept": "application/json"
            ]
            Alamofire.request(AuthKey.host.rawValue + url, method: .get, parameters: parameters,encoding: URLEncoding.default,headers:headers).responseJSON { response
                in
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value{
                        
                        result = JSON(value)
                        break;
                        
                    }
                    case false:
                    result = nil
                }
            }
        }
        else{
            self.state = false
        }
        return result
    }
    
    /**
     退出登录
     */
    func logout(){
        LocalStore.instance.removeToken()
        if let localToken = token {
            let url = "auth/removeToken"
            let parameters:Dictionary = [AuthKey.accesstoken.rawValue: localToken.access_token]
            if let result = self.authPost(url: url, parameters: parameters) {
                print(result)
            }
            token = nil
        }
        
        self.state = false
    }
    
    func getToken() {
        if let dictoken = LocalStore.instance.getToken() {
            self.token = Token(token_json: dictoken as! Dictionary<String, Any>)
            
            if let localToken = token {
                if localToken.isExpired() {
                    refreshToken()
                }
                else{
                    self.state = true
                }
            }
            else{
                self.state = false
            }
        }
        else{
            self.token = nil
            self.state = false
        }
    }
    
}
