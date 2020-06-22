//
//  EnterView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/5/9.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI
import MAMapKit

struct EnterItem: Identifiable {
    //基本信息
    var id: String
    var name: String
    var leprent: String
    var capital: String
    var esdate: String
    var address: String
    var scope: String
    
    //经营信息
    var state: String
    var scale: String
    var hinech: String
    //上市
    var listed: String
    //拟IPO
    var pripo: String
    //新三板挂牌
    var threbole: String
    //新三板后备
    var threbore: String
    //500强
    var topive: String
    //销售上亿
    var saoumle: String
    
    
}

struct SearchParam: Identifiable {
    var id: String
    var key: String
    var title: String
    var value: String
}

struct EnterView: View {
    
    @State var key = "edbName"
    @State var param = ""
    @State var editParam = false
    @State private var isSearching = false
    @State private var isEditing = false
    @State private var isOride = false
    @State private var searchParam = [SearchParam(id: "1", key: "name",title: "企业名",value: "edbName"),SearchParam(id: "2", key: "leprent",title: "人名",value: "edbPerson"),SearchParam(id: "3", key: "address",title: "地址",value: "edbAddress"),SearchParam(id: "4", key: "scope",title: "经营范围",value: "edbScope")]
    @State private var searchHistory = ["天合","梅特勒","千红","硅密","小松"]
    
    var body: some View {
        

        VStack(alignment: .leading) {
            
            HStack(spacing: 0) {
                
                SearchBar(param: $param, placeholder: "请输入企业名、人名、地址等", editParam: $editParam, isOride: $isOride)
                
                if !editParam {
                    Image("arrow.up.arrow.down").animation(.easeInOut).onAppear(){
                        self.isOride = false
                    }.onDisappear(){
                        self.isOride = true
                    }
                }
                
                }.padding(.horizontal, 10)
            
            if !self.isOride {
                VStack(spacing: 0) {
                    SplitterLine()
                   
ScrollView{
    
                ForEach(enter){
                    item in
                    Section{
                        
                        
                        EnterItemView(item: item)
                    
                    }.background(Color(.secondarySystemGroupedBackground))
                }
    }.background(Color(.systemGroupedBackground))
                    
                }
                
            }
            
            if self.isOride {
                
                VStack {
                    SplitterLine()
                    VStack(spacing: 0) {
                        HStack{
                            Text("搜索类型").foregroundColor(Color.secondary)
                            Spacer()
                        }
                        ScrollView(.horizontal){
                            HStack(alignment: .center, spacing: 30){
                                ForEach(searchParam){
                                    item in
                                    Button(action: {
                                        self.key = item.value
                                    }) {
                                        Text(item.title).frame(width: 75, height: 25).foregroundColor(self.key == item.value ? Color.white: Color.secondary).background(self.key == item.value ?  Color.accentColor:Color.secondary.opacity(0.1)).cornerRadius(5)
                                    }
                                }
                                
                            }.padding(.horizontal, 25).padding(.bottom, 20)
                        }.padding(.top, 10)
                        
                        HStack{
                            Text("历史搜索").foregroundColor(Color.secondary)
                            Spacer()
                            Image(systemName: "trash").foregroundColor(Color.secondary.opacity(0.75))
                        }.padding(.top, 5)
                        List{
                            ForEach(searchHistory, id: \.self){
                                item in
                                Text(item).onTapGesture {
                                    self.param = item
                                }.foregroundColor(Color(UIColor.systemGroupedBackground.invertColor())).frame(height: 20)
                            }.onDelete {
                                if let first = $0.first {
                                    self.searchHistory.remove(at: first)
                                }
                            }
                        }.environment(\.defaultMinListRowHeight, 10).onAppear { UITableView.appearance().separatorStyle = .none }
                            .onDisappear { UITableView.appearance().separatorStyle = .singleLine }
                    }.padding(.horizontal,15)
                    
                }.background(Color(.systemBackground))

                
            }        }.font(.system(size: 15)).padding(.top,UIApplication.shared.statusBarFrame.height).background(Color(.secondarySystemGroupedBackground)).edgesIgnoringSafeArea(.top)
        
    }
}

struct SplitterLine: View {
    var body: some View {
        Rectangle().foregroundColor(Color.secondary.opacity(0.1))
            .frame(height: 1)
    }
}

extension Color {
    
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
    
    static func stateColor(state: String) -> Color {
        switch state {
        case "营业","开业","存续","在业":
            return Color(red: 0/255.0, green: 151.98/255.0, blue: 68.122/255.0, opacity: 1)
        case "迁入":
            return Color.blue
        case "停业":
            return Color.orange
        case "注销","迁出":
            return Color.gray
        case "吊销","清算":
            return Color.red
        default:
            return Color.gray
        }
    }
}

extension UIColor {
    //获取反色(补色)
    func invertColor() -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a: CGFloat = 1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red:1.0-r, green: 1.0-g, blue: 1.0-b, alpha: a)
    }
}

struct EnterItemView: View {
    
    var item: EnterItem
    
    init(item: EnterItem) {
        self.item = item
        if item.state.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.item.state = "未知"
        }
    }
        
    var body: some View {
            VStack {
                NavigationLink(destination: EnterDetailView(
                    item: item
                ).edgesIgnoringSafeArea(.top).edgesIgnoringSafeArea(.bottom).navigationBarBackButtonHidden(false).navigationBarTitle("")
                ){
                    VStack{
                HStack(alignment: .top){
                    if item.hinech == "是" {
                        Image("huoju").renderingMode(.original).resizable().frame(width:20,height: 20).padding(.trailing,-3)
                        
                    }
                else{
                        Image(systemName: "flag.fill").foregroundColor(.blue).padding(.top, 5)
                    
                }
                    VStack(alignment: .leading, spacing: 10){
                        Text(item.name)
                            .font(.system(size: 17)).foregroundColor(Color.primary)
                        HStack(spacing: 5){
                            if item.scale != "" {
                                Text(item.scale).font(.system(size: 11.5)).foregroundColor(.blue).overlay(RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.blue.opacity(0.3)).padding(.horizontal,-3.5).padding(.vertical,-2))
                                    .padding(.trailing,4)
                            }
                            if item.topive == "是" {
                                Image("firt").renderingMode(.original).resizable().frame(width: 20.3, height: 16).clipShape(RoundedRectangle(cornerRadius: 3.5))
                            }
                            if item.listed == "是" {
                                Image("listed").renderingMode(.original).resizable().frame(width: 16, height: 16).clipShape(RoundedRectangle(cornerRadius: 3.5))
                            }
                            if item.pripo == "是" {
                                Image("pripo").renderingMode(.original).resizable().frame(width: 16, height: 16).clipShape(RoundedRectangle(cornerRadius: 3.5))
                            }
                            if item.threbole == "是" {
                                Image("netle").renderingMode(.original).resizable().frame(width: 16, height: 16).clipShape(RoundedRectangle(cornerRadius: 3.5))
                            }
                            if item.threbore == "是" {
                                Image("neter").renderingMode(.original).resizable().frame(width: 16, height: 16).clipShape(RoundedRectangle(cornerRadius: 3.5))
                            }
                            if item.saoumle == "是" {
                                Image("sarm").renderingMode(.original).resizable().frame(width: 16, height: 16).clipShape(RoundedRectangle(cornerRadius: 2.5))
                            }
                        }.padding(.leading, 5)
                        
                    }
                    Spacer()
                    Text(item.state)
                        .font(.system(size: 11.5)).foregroundColor(Color.stateColor(state: item.state)).overlay(RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .stroke(Color.stateColor(state: item.state), lineWidth: 1).padding(.horizontal,-3.5).padding(.vertical,-2)
                    ).padding(.top, 4.5)

                }
                HStack {
                    VStack{
                        Text("法定代表人").padding(.bottom,5)
                            .font(.system(size: 12.5)).foregroundColor(Color.secondary.opacity(0.8))
                        Text(item.leprent).font(.system(size: 13)).foregroundColor(.blue)
                    }
                    Divider().frame(height: 16.5)
                    VStack{
                        Text("注册资本").padding(.bottom,5)
                            .font(.system(size: 12.5)).foregroundColor(Color.secondary.opacity(0.8))
                        Text(item.capital).font(.system(size: 13)).foregroundColor(Color.primary)
                                            }
                    Divider().frame(height: 16.5)
                    VStack{
                        
                        Text("成立日期").padding(.bottom,5)
                            .font(.system(size: 12.5)).foregroundColor(Color.secondary.opacity(0.8))
                        Text(item.esdate).font(.system(size: 13)).foregroundColor(Color.primary)

                    }

                }
                        if item.scope != "" {HStack{
                    Text("经营范围：").font(.system(size: 13)).foregroundColor(Color.secondary.opacity(0.8))
                    Text(item.scope).font(.system(size: 13)).foregroundColor(Color.secondary).lineLimit(1)
                }.padding(.leading,20)
                }
                    }
        }
                if item.address != "" {
                    VStack(alignment: .leading, spacing: 5){
                        SplitterLine()
                        NavigationLink(destination: MapView(
                            ).edgesIgnoringSafeArea(.top).edgesIgnoringSafeArea(.bottom).navigationBarBackButtonHidden(false).navigationBarTitle("")){
                            HStack{
                                        Image(systemName: "mappin.and.ellipse").font(.system(size: 13)).foregroundColor(.blue)
                                        Text("地址：").font(.system(size: 13)).foregroundColor(Color.secondary.opacity(0.8))
                                Text(item.address).font(.system(size: 13)).lineLimit(1).foregroundColor(Color.secondary)
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right").font(.system(size: 11.5)).foregroundColor(Color.secondary.opacity(0.5))
                                }
                        }
                                            }
                }
            }.padding(10)

    }
}

struct EnterView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        EnterView().colorScheme(.dark)
    }
}
