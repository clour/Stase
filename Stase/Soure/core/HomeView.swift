//
//  HomeView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/5/9.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static func moveAndScale(edge: Edge) -> AnyTransition {
        AnyTransition.move(edge: edge).combined(with: .scale)
    }
    
    static func moveOrFade(edge: Edge) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: edge),
            removal: .opacity
        )
    }
}

struct HomeView: View {
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    @State var isAnimating = false
    
    @State private var isButtonVisible = true

    var body: some View {
        VStack {
          TopBarView()
.modifier(HomeAnimationStyle(isAnimating: $isAnimating))
          SplitterView().modifier(HomeAnimationStyle(isAnimating: $isAnimating, delay: 0.2))
          TopMenuView().modifier(HomeAnimationStyle(isAnimating: $isAnimating, delay: 0.4))
            
          PieChartView().modifier(HomeAnimationStyle(isAnimating: $isAnimating, delay: 0.6))
            
          CountryListView().modifier(HomeAnimationStyle(isAnimating: $isAnimating, delay: 0.8))
        }.onAppear() {
        self.isAnimating = true
        }
        
    }
    
    
}

struct TopBarView: View {
    
    @ObservedObject var remote = RemoteLink.instance
    
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "list.bullet.indent")
        Spacer()
        Text("经济指标").bold().onTapGesture {
            self.remote.logout()
        }
        Spacer()
        Button(action: {
            self.remote.logout()
        }){
            Image(systemName: "magnifyingglass")
        }
        
      }.padding(.horizontal, 30)
      .foregroundColor(.primary)
    }
  }
}

struct SplitterView: View {
  var body: some View {
    Rectangle()
        .fill(inactiveColor)
      .frame(width: screenWidth, height: 1)
  }
}

struct TopMenuView: View {
  @State private var currentIndex = 1
  
  var body: some View {
    VStack {
      HStack {
        MenuItemView(currentIndex: $currentIndex, currentItem: (1, "日"))
        MenuItemView(currentIndex: $currentIndex, currentItem: (2, "周"))
        MenuItemView(currentIndex: $currentIndex, currentItem: (3, "月"))
        MenuItemView(currentIndex: $currentIndex, currentItem: (4, "总"))
      }
      ZStack(alignment: .leading) {
        SplitterView()
        Rectangle()
          .fill(activeColor)
          .frame(width: screenWidth / 4, height: 1)
          .offset(x: menuWidth * CGFloat(currentIndex - 1), y: 0)
          .animation(.spring())
      }
    }
  }
}

struct MenuItemView: View {
  @Binding var currentIndex: Int
  var currentItem: (Int, String)
  
  var body: some View {
    Button(action: {
      self.currentIndex = self.currentItem.0
    }) {
      Text(currentItem.1)
        .font(.system(size: regularFontSize))
        .frame(width: menuWidth, height: 40)
        .foregroundColor(
          currentIndex == currentItem.0 ? activeColor : regularColor
        )
    }
  }
}

struct StatCircleView: View {
  var diameter: CGFloat
  var color: Color
  
  var startPoint: CGFloat
  var endPoint: CGFloat
  
  var angle: Double
  
  @State var isAnimating = false
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 2)
        .fill(inactiveColor)
        .frame(width: diameter, height: diameter)
      Circle()
        .trim(from: isAnimating ? startPoint : 0, to: isAnimating ? endPoint : 0)
        .stroke(lineWidth: 4)
        .fill(color)
        .frame(width: diameter, height: diameter)
        .rotationEffect(.degrees(isAnimating ? angle : -720))
        .animation(.easeInOut(duration: 3))
    }.onAppear() {
      self.isAnimating = true
    }
  }
}

struct PieChartView: View {
  var body: some View {
    ZStack {
      StatCircleView(
        diameter: chartWidth,
        color: activeColor,
        startPoint: 0,
        endPoint: 0.5,
        angle: -45
      )
      StatCircleView(
        diameter: chartWidth - 40,
        color: .purple,
        startPoint: 0,
        endPoint: 0.4,
        angle: 70
      )
      StatCircleView(
        diameter: chartWidth - 80,
        color: .green,
        startPoint: 0,
        endPoint: 0.3,
        angle: 190
      )
      StatCircleView(
        diameter: chartWidth - 120,
        color: .yellow,
        startPoint: 0,
        endPoint: 0.2,
        angle: 135
      )
      VStack {
        Text("1383")
          .font(.system(size: 32))
          .foregroundColor(.primary)
        Text("GDP")
          .font(.system(size: 14))
          .foregroundColor(Color.primary.opacity(0.5))
      }
    }.padding(.vertical, 15)
  }
}

struct CountryListView: View {
  @State var isAnimating = false
  
  var body: some View {
    ScrollView {
      VStack {
        ForEach(country) { country in
          VStack {
            HStack {
              Circle()
                .fill(country.color)
                .frame(width: 10, height: 10)
              Text(country.title)
              Spacer()
              Text("\(country.visit)")
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .foregroundColor(.primary)
            .modifier(LogInAnimationStyle(
              isAnimating: self.$isAnimating,
              delay: Double(country.id) * 0.2 + 0.8
            ))
            Rectangle()
              .fill(inactiveColor)
              .frame(width: screenWidth - 40, height: 1)
          }
        }
      }
    }.onAppear() {
      self.isAnimating = true
    }
  }
}

struct HomeAnimationStyle: ViewModifier {
  @Binding var isAnimating: Bool
  var delay = 0.0
  
  func body(content: Content) -> some View {
    content
      .opacity(isAnimating ? 1 : 0)
      .animation(Animation.spring().delay(delay))
  }
}

struct HomeProfile_Previews: PreviewProvider {
        static var previews: some View {
        HomeView()
    }
}
