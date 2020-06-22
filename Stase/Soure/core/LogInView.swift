//
//  LoginView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/3.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

enum PageType {
  case signin
  case signup
}

struct LogInView: View {
  
  @State var isAnimating = false
    
    @State var username = ""
    @State var password = ""
  
  var body: some View {
    ZStack{
        Rectangle().fill(Color.init(red: 76/255, green: 158/255, blue: 234/255))
    VStack {
      LogTitleView()
        .modifier(LogInAnimationStyle(isAnimating: $isAnimating)).padding(.bottom, 80)
      
      LogFormView(username: $username, password: $password)
        .modifier(LogInAnimationStyle(isAnimating: $isAnimating, delay: 0.4))
        SignInView(username: $username, password: $password)
        .modifier(LogInAnimationStyle(isAnimating: $isAnimating, delay: 0.6))
      Spacer()
      
    }.padding(.horizontal, 40).padding(.top, 125)
    .onAppear() {
      self.isAnimating = true
    }
    }.edgesIgnoringSafeArea(.all)
  }
}

struct LogInView_Previews: PreviewProvider {
  static var previews: some View {
    LogInView()
  }
}

struct LogTitleView: View {
  
  var body: some View {
    HStack(alignment: .top){
        Image("ctp").resizable()
            .frame(width: 55, height: 55)
        VStack(alignment: .leading, spacing: 7.5) {
        Text("新北区")
          .bold()
          .font(.system(size: 40))
            Text("经济社会发展信息平台")
            .bold()
                .font(.system(size: 26))
        }.padding(.leading, 5).padding(.top,5)
        
      Spacer()
    }.padding(.top, 20).foregroundColor(.white)
  }
}

struct LogFormView: View {
  private let distance: CGFloat = 40
  
  @Binding var username: String
  @Binding var password: String
  @State var number = ""
  
  var body: some View {
    ZStack{
        Rectangle().fill(Color.white).frame(width: screenWidth-30, height: 100).cornerRadius(10)
    VStack{
      //Text("用户名")
        TextField("用户名", text: $username).colorScheme(.light)
      
      Rectangle()
        .fill(Color.black.opacity(0.2))
        .frame(height: 1)
      //Text("密码").padding(.top, 20)
      
        SecureField("密码", text: $password).colorScheme(.light)

    }.padding()
    }
  }
}

struct SignInView: View {
    
    @ObservedObject var remote = RemoteLink.instance
    
    @Binding var username: String
    @Binding var password: String
    
  var body: some View {
    VStack {
      
      Button(action: {
        self.remote.login(username: self.username, password: self.password)
      }) {
        HStack {
          Text("登录")
            .bold()
          
        }.frame(width: UIScreen.main.bounds.width - 15 * 2, height: 50)
        .background(Color.white.opacity(0.1))
        .foregroundColor(.white)
        .cornerRadius(10)
      }
    }.padding(.top, 5)
  }
}

struct LogInAnimationStyle: ViewModifier {
  @Binding var isAnimating: Bool
  var delay = 0.0
  
  func body(content: Content) -> some View {
    content
      .opacity(isAnimating ? 1 : 0)
      .animation(Animation.spring().delay(delay))
  }
}
