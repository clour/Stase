//
//  ContentView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/4/29.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var logState = false
    
    @ObservedObject var remote = RemoteLink.instance
    
    init() {
        //remote.login()
        logState = remote.state
        print(logState)
    }
    
    var body: some View {
        ZStack{
        if remote.state {
            MainStaseView()
            }
        else{
            LogInView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let contentView = ContentView().colorScheme(.dark)
        
        return contentView
    }
}
