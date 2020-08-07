//
//  FindView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/5/9.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct FindView: View {
    
    @State var title = "对标苏高新"
    
    var body: some View {
        VStack {
            BarView(leading: Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                Image(systemName: "list.bullet.indent")
            }, title: Text(title).bold(), trailing: Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                Image(systemName: "slider.horizontal.3")
            })
            ScrollView{
                BemarkView()
            }
        }
    }
    
    
}

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}
