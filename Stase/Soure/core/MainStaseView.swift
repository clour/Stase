//
//  MainView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/20.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct MainStaseView: View {
    
    @State private var selection = 0
    @State private var step = "经济平台"
    @ObservedObject var remote = RemoteLink.instance
    
    init(){
        //UITabView
        
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection){
            
            HomeView().navigationBarTitle("首页").navigationBarHidden(true)
            .tabItem() {
                VStack {
                    Image(systemName: selection == 0 ? "house.fill": "house").font(.system(size: UIFont.labelFontSize, weight: Font.Weight.thin))
                    Text("首页")
                }
                }
            .tag(0)
                
                    EnterView().navigationBarTitle("企业").navigationBarHidden(true)
                .tabItem {
                    VStack {
                        Image(systemName: selection == 1 ? "flag.fill": "flag").font(Font.system(size: UIFont.labelFontSize, weight: Font.Weight.thin))
                        Text("企业")
                    }
                }
            .tag(1)
                FindView().navigationBarHidden(true)
                .tabItem {
                    VStack {
                        Image(systemName: selection == 2 ? "cloud.fill": "cloud").font(Font.system(size: UIFont.labelFontSize, weight: Font.Weight.thin))
                        Text("分析")
                    }
            }
            .tag(2)
                
                UserView().navigationBarTitle("我的").tabItem {
                    VStack {
                        Image(systemName: selection == 3 ? "person.fill": "person").font(Font.system(size: UIFont.labelFontSize, weight: Font.Weight.thin))
                        Text("我的")
                    }
                }
                .tag(3).navigationBarHidden(true).navigationBarTitle("")
            
            }
        }
    }
}

struct MainStaseView_Previews: PreviewProvider {
    static var previews: some View {
        let mainStaseView = MainStaseView().colorScheme(.dark)
        
        return mainStaseView
    }
}
