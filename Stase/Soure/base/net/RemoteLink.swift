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
               parameters: Parameters? = nil, call: ((_ success: Bool? , _ result: Any? , _ error: Error? )  -> Void)? = nil){
        tokenRequest(method: method, parameters: parameters).responseJSON { response
            in
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value{
                    let token_json = JSON(value).dictionaryValue
                    if let error = token_json[ErrorKey.error.rawValue] {
                        if let error_description = token_json[ErrorKey.error_description.rawValue]{
                            if let localCall = call {
                                localCall(false, nil, Error(error: error.stringValue, error_description: error_description.stringValue))
                            }
                        }
                        else{
                            if let localCall = call {
                                localCall(false, nil, Error(error: error.stringValue, error_description: "用户验证失败"))
                            }
                        }
                    }
                    else{
                        if token_json[TokenKey.access_token.rawValue] != nil {
                            self.token = Token(token_json: token_json)
                            LocalStore.instance.saveToken(token: self.token)
                            if let localCall = call {
                                localCall(true, nil, nil)
                            }
                        }
                        else{
                            if let localCall = call {
                                localCall(false, nil, Error(error: "link_error", error_description: "网络连接失败"))
                            }
                        }
                    }
                }
                break;
            case false:
                if let localCall = call {
                    localCall(false, nil, Error(error: "net_error", error_description: "网络请求失败"))
                }
            }
        }
    }
    
    /**
     登录回调
     */
    func loginout(success: Bool? = nil, result: Any? = nil, error: Error? = nil) {
        if success ?? false {
            self.state = true
        }
        else{
            self.loginError = error
            self.isError = true
            self.state = false
        }
    }
    
    /**
     当Token过期时调用此方法，用来刷行Token
     */
    func refreshToken(call: ((_ success: Bool? , _ result: Any? , _ error: Error? )  -> Void)? = nil) {
        var processer: ((_ success: Bool? , _ result: Any? , _ error: Error? )  -> Void) = loginout
        if let param = call {
            processer = param
        }
        if let localToken = token {
            let parameters:Dictionary = ["grant_type": "refresh_token", "refresh_token": localToken.refresh_token]
            
            self.token(parameters: parameters, call: processer)
        }
        else{
            processer(false, nil, Error(error: "expired_error", error_description: "登录过期，请重新登录！"))
        }
    }
    
    /**
     验证Token是否有效
     */
    func validate(call: ((_ success: Bool? , _ result: Any? , _ error: Error? )  -> Void)? = nil) {
        func processer(success: Bool? = nil, result: Any? = nil, error: Error? = nil) {
            if success ?? false {
                (call ?? loginout)(success, result, error)
            }
            else{
                self.loginError = error
                self.isError = true
                self.state = false
            }
        }
        
        if let localToken = token{
            if(localToken.isExpired()){
                refreshToken(call: processer)
            }
            else{
                processer(success: true, result: nil, error: nil)
            }
        }
        else{
            self.loginError = Error(error: "expired_error", error_description: "匿名用户，请重新登录！")
            self.isError = true
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
        self.token(parameters: parameters, call: loginout)
    }
    
    func authPost(url: String, parameters: Parameters? = nil, call: ((_ success: Bool? , _ result: Any? , _ error: Error? )  -> Void)? = nil) {
        
        func processer(success: Bool? = nil, result: Any? = nil, error: Error? = nil) {
            if success ?? false {
                if let localToken = token {
                    let headers: HTTPHeaders = [
                        AuthKey.Authorization.rawValue: AuthKey.Bearer.rawValue + localToken.access_token,
                        "Accept": "application/json"
                    ]
                    print(headers)
                    print(AuthKey.host.rawValue + url)
                    print(parameters)
                    Alamofire.request(AuthKey.host.rawValue + url, method: .post, parameters: parameters,encoding: URLEncoding.default,headers:headers).responseJSON { response
                        in
                        switch response.result.isSuccess {
                        case true:
                            if let value = response.result.value{
                                if let localCall = call {
                                    localCall(true, JSON(value), nil)
                                }
                                break;
                            }
                        case false:
                            if let localCall = call {
                                localCall(false, nil, Error(error: "net_error", error_description: "网络请求失败"))
                            }
                        }
                    }
                }
                else{
                    self.state = false
                }
            }
            else{
                self.loginError = error
                self.isError = true
                self.state = false
            }
        }
        
        validate(call: processer)
    }
    
    func authGet(url: String, parameters: Parameters? = nil, call: ((_ success: Bool? , _ result: Any? , _ error: Error? )  -> Void)? = nil) {
        func processer(success: Bool? = nil, result: Any? = nil, error: Error? = nil) {
            if success ?? false {
                if let localToken = token {
                    
                    let headers: HTTPHeaders = [
                        AuthKey.Authorization.rawValue: AuthKey.Bearer.rawValue + localToken.access_token,
                        "Accept": "application/json"
                    ]
                    Alamofire.request(AuthKey.host.rawValue + url, method: .get, parameters: parameters,encoding: URLEncoding.default,headers:headers).responseJSON { response
                        in
                        switch response.result.isSuccess {
                        case true:
                            if let value = response.result.value{
                                if let localCall = call {
                                    localCall(true, JSON(value), nil)
                                }
                                break;
                            }
                        case false:
                            if let localCall = call {
                                localCall(false, nil, Error(error: "net_error", error_description: "网络请求失败"))
                            }
                        }
                    }
                }
                else{
                    self.state = false
                }
            }
            else{
                self.loginError = error
                self.isError = true
                self.state = false
            }
        }
        
        validate(call: processer)
    }
    
    /**
     退出登录
     */
    func logout(){
        func processer(success: Bool? = nil, result: Any? = nil, error: Error? = nil) {
            token = nil
            LocalStore.instance.removeToken()
            self.state = false
        }
        
        if let localToken = token {
            let url = "auth/auth/removeToken"
            let parameters:Dictionary = [AuthKey.accesstoken.rawValue: localToken.access_token]
            self.authPost(url: url, parameters: parameters, call: processer)
        }
        else{
            token = nil
            LocalStore.instance.removeToken()
            self.state = false
        }
        
    }
    
    func getToken() {
        if let dictoken = LocalStore.instance.getToken() {
            self.token = Token(token_json: dictoken as! Dictionary<String, Any>)
            
            validate()
        }
        else{
            self.token = nil
            self.state = false
        }
    }
    
}
