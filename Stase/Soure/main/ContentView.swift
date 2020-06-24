//
//  ContentView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/4/29.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var remote = RemoteLink.instance
    
    init() {
        self.remote.getToken()
    }
    
    var body: some View {
        ZStack{
            if remote.state != nil {
                if remote.state ?? false {
                    MainStaseView()
                }
                else{
                    LogInView()
                }
            }
            else{
                EmptyView()
            }
        }.onAppear(){
            self.remote.getToken()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let contentView = ContentView().colorScheme(.dark)
        
        return contentView
    }
}
