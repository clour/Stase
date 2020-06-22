//
//  EnterDetailView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/17.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI
import MapKit

struct EnterDetailView: View {
    
    var item: EnterItem
    
    // 打开第三方地图
    private func openMap(_ urlString: NSString) -> Bool {

        let url = NSURL(string:urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)

        if UIApplication.shared.canOpenURL(url! as URL) == true {
            UIApplication.shared.openURL(url! as URL)
            return true
        } else {
            return false
        }
    }
    
    // 打开高德地图
    func amap(dlat:Double,dlon:Double,dname:String,way:Int) {
        let appName = "Stase"
        
        let urlString = "iosamap://path?sourceApplication=\(appName)&dname=\(dname)&dlat=\(dlat)&dlon=\(dlon)&t=\(way)" as NSString
        
        if self.openMap(urlString) == false {
            print("您还没有安装高德地图")

        }
    }
    
    var body: some View{
        VStack {
            MapView()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300).onTapGesture {
                    self.amap(dlat: 31.86376485854748, dlon: 120.03423292849348, dname: "璜土公园", way: 0)
            }
            
            CircleImage(image: Image("girlPicture"))
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(item.name)
                        .font(.title)
                    
                    Button(action: {
                        
                    }) {
                        if self.item.hinech == "是"{
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    Text(item.address)
                        .font(.subheadline)
                    Spacer()
                    Text(item.state)
                        .font(.subheadline)
                }
            }
            .padding()
            
            Spacer()
        }.navigationBarBackButtonHidden(false).navigationBarTitle("")
    }
}

struct EnterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EnterDetailView(item: enter[0])
    }
}
