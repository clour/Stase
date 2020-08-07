//
//  TopBarView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/7/13.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct BarView: View {
    
    private let leading: AnyView?
    private let title: AnyView?
    private let trailing: AnyView?
    
    init<L,C,T>(leading: L, title: C, trailing: T) where L: View, C: View, T: View{
        self.leading = AnyView(leading)
        self.title = AnyView(title)
        self.trailing = AnyView(trailing)
    }
    
    init<C>(title: C) where C: View{
        self.leading = nil
        self.title = AnyView(title)
        self.trailing = nil
    }
    
    init<L,C>(leading: L, title: C) where L: View, C: View{
        self.leading = AnyView(leading)
        self.title = AnyView(title)
        self.trailing = nil
    }
    
    init<C,T>(title: C, trailing: T) where C: View, T: View{
        self.leading = nil
        self.title = AnyView(title)
        self.trailing = AnyView(trailing)
    }
    
  var body: some View {
    
      HStack {
        if let leadingView = leading{
            leadingView
        }
        //leading
        Spacer()
        if let titleView = title{
            titleView
        }
        //title
        Spacer()
        if let trailingView = trailing{
            trailingView
        }
        //trailing
        
      }.padding(.horizontal, 30)
      .foregroundColor(.primary)
    
  }
}
