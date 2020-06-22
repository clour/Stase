//
//  UserView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/5/9.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct UserView: View {
    
    @State private var isOride = false
    
    init() {
        //UITableView.appearance().tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 8))
        //UITableView.appearance().tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //UITableView.appearance().sectionHeaderHeight = 3
        //UITableView.appearance().sectionFooterHeight = 3
        //UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
        
    }
    
    
    
    var body: some View{

            ScrollView(showsIndicators: false){
                VStack(spacing: 8){
            NavigationLink(destination: MapView().edgesIgnoringSafeArea(.all).navigationBarTitle(""))
                {
                 UserTitleView(nickname: "宋志勇", depart: "常州市新北自然资源和规划技术保障中心", avatar: Image("girlPicture").renderingMode(.original)).foregroundColor(.primary)
                }
                
                Section{
                    
                    NavigationLink(destination: MapView().edgesIgnoringSafeArea(.top).edgesIgnoringSafeArea(.bottom).navigationBarBackButtonHidden(false).navigationBarHidden(false))
                    {
                        UserViewRow(title: "设置", icon: "gear", iColor: Color.blue).padding(.vertical,3)
                    }
                    }.background(Color(.secondarySystemGroupedBackground))
                    VStack(alignment: .trailing, spacing: 0){
                    NavigationLink(destination: MapView().edgesIgnoringSafeArea(.top).edgesIgnoringSafeArea(.bottom).navigationBarBackButtonHidden(false).navigationBarHidden(false))
                    {
                        UserViewRow(title: "收藏", icon: "heart", iColor: Color.red).padding(.vertical,3)
                    }
                    Divider().frame(width: screenWidth - 60, height: 1, alignment: .trailing)
                    UserViewRow(title: "关注", icon: "flag", iColor: Color.blue).padding(.vertical,3)
                    Divider().frame(width: screenWidth - 60, height: 1, alignment: .trailing)
                    UserViewRow(title: "修改密码", icon: "square.and.pencil", iColor: Color.orange).padding(.vertical,3)
                    Divider().frame(width: screenWidth - 60, height: 1, alignment: .trailing)
                    UserViewRow(title: "联系我们", icon: "phone", iColor: Color.green).padding(.vertical,3)
                }.background(Color(.secondarySystemGroupedBackground)).padding(.vertical,0)
                
                Section{
                    UserViewRow(title: "退出登录", icon: "escape", iColor: Color.blue).padding(.vertical,3)
                    
                }.background(Color(.secondarySystemGroupedBackground)).padding(.vertical,0)
                
                }
            }.background(VStack{Rectangle().frame(height: 150).background(Color(.secondarySystemGroupedBackground))
                Spacer()
            }).background(Color(.systemGroupedBackground)).edgesIgnoringSafeArea(.top).navigationBarTitle("").navigationBarHidden(true).onAppear(){
                UIScrollView.appearance().bounces = false
            }.onDisappear(){
                UIScrollView.appearance().bounces = true
        }
    }
}

struct UserTitleView: View {
    
    @State var nickname: String
    @State var depart: String
    @State var avatar: Image

    var body: some View {
        ZStack(alignment: .bottom){
            Rectangle().fill(Color.clear)
                .frame(height: 150+UIApplication.shared.statusBarFrame.height, alignment: .center).overlay(Divider().frame(height: 3, alignment: .bottom), alignment: .bottom)
            
            HStack(spacing: 20) {
                avatar.resizable().frame(width: 65, height: 65).mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                VStack(alignment: .leading){
                    Text(nickname).bold().padding(.bottom, 7.5)
                        .font(.system(size: 22))
                    
                    Text(depart).font(.system(size: 14))
                }
                
                Image(systemName: "chevron.right")
                
                
                }.padding(EdgeInsets(top: 20+UIApplication.shared.statusBarFrame.height, leading: 20, bottom: 25, trailing: 20))
            
        }.background(Color(.secondarySystemGroupedBackground))
    }
}


struct UserViewRow: View {
    
    var title: String
    var icon: String
    var iColor: Color
    
    var body: some View {
        
        HStack(spacing: 20) {
            Image(systemName: icon)
                .foregroundColor(iColor)
                .font(.system(size: 20, weight: Font.Weight.thin)).frame(width: 20)
            Text(title).foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right").foregroundColor(.primary)
            
            
        }.padding(.horizontal, 20)
            .frame(height: 45)
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserView().colorScheme(.light)
    }
}
