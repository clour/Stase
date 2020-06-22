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

enum UserDefaultKey: String {
    case login = "LoginDefaultKey"
}

class RemoteLink: ObservableObject {
    
    @Published var state: Bool = false  //是否需要登录    false需要    true 不需要
    
    static let instance = RemoteLink()
    
        
    func login(username: String, password: String){
        
        let url_access_token = URL(string: "http://gate.czxbe.net:8060/auth/oauth/token")
        
        let headers: HTTPHeaders = [
          "Authorization": "Basic YXBwOmFwcA==",
          "Accept": "application/json"
        ]
                //参数
                let parameters:Dictionary = ["username":username,"password":password,
                "grant_type": "password"]
        
        Alamofire.request(url_access_token as! URLConvertible, method: .post, parameters: parameters,encoding: URLEncoding.default,headers:headers).responseJSON { response
            in
            
            print(response)
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value{
                    
                    print("Success-----")
                    print(value)
                    
                    let token_json = JSON(value)
                    print("Token_json-----")
                    print(token_json)
                    /*self.imgageData = []
                    //获取返回的值,转为json对象
                    let img_json = JSON(value)
                    //json转字符串
                    let json_str = img_json.rawString()
                    let zhu_url = "http://47.92.107.28:8000"
                    //遍历json数据
                    for(key,item) in img_json["imgs"] {
                        //print("src的值:\(item["src"])")
                        //如果取得的 src 的值为 String类型的话就添加到数组中
                        if let img_url = item["src"].string{
                            //将图片路径添加到数组中
                            self.imgageData.append(zhu_url+img_url)
                        }
                    }
                    //将数组转为字符串
                    let str = self.imgageData.joined()
                    //print("请求到返回的数据\(json_str)")*/
                }
                break;
            case false:
                print("Error-----")
                print(response.result.error)
            }
        }
        self.state = true
    }
    
    func logout(){
        self.state = false
    }
    
    func getLoginFlag() -> Bool{
        let b = UserDefaults.standard.bool(forKey: UserDefaultKey.login.rawValue)
        print("\(b ? "true: Home": "false: Login")")
        return b
    }
    
    func setLoginFlag(flag: Bool){
        UserDefaults.standard.set(flag, forKey: UserDefaultKey.login.rawValue)
        if(UserDefaults.standard.synchronize()){
            print("\(flag ? "true: 登录成功跳到主界面": "false: 登出成功跳到登录界面")")
            self.state = flag
        }else{
            print("存储失败")
            self.state = !flag
        }
        
    }
}
