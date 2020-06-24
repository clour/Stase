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
            
            FinanceBarChartView().padding(.vertical,10).modifier(HomeAnimationStyle(isAnimating: $isAnimating, delay: 0.6))
            
            CountryListView().padding(.top, 20).modifier(HomeAnimationStyle(isAnimating: $isAnimating, delay: 0.8))
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

let decimalFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  return formatter
}()

struct FinanceBarView: View {
  private static let dateFormatte: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd"
    return formatter
  }()
  
  var height: Double
  var label: Date
  var best = false
  var havingSpacer = true
  
  @State private var isAnimating = false
  
  var body: some View {
    HStack(alignment: .bottom) {
      VStack {
        Spacer()
        Text("\(decimalFormatter.string(from: NSNumber(value: height))!)")
          .offset(x: 0, y: isAnimating ? 0 : 60)
          .opacity(isAnimating ? 1 : 0)
          .animation(Animation.interpolatingSpring(stiffness: 100, damping: 10)
            .delay(0.5))
        RoundedRectangle(cornerRadius: 6)
          .fill(Color(red: 80/255, green: 90/255, blue: 250/255))
          .opacity(best ? 1 : 0.4)
          .frame(width: 12, height: CGFloat(isAnimating ? height/10 : 0))
          .animation(Animation.interpolatingSpring(stiffness: 100, damping: 10)
            .delay(0.5))
        Text("\(label, formatter: Self.dateFormatte)")
      }.font(.system(size: 11))
      .foregroundColor(best ? .primary : .secondary)
      if havingSpacer {
        Spacer()
      }
    }.frame(height: CGFloat(height/10))
    .onAppear() {
      self.isAnimating = true
    }
  }
}

struct FinanceBarChartView: View {
  private static let dateFormatte: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
  }()
  
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Image(systemName: "chevron.left")
        Spacer()
        Text("\(Date(), formatter: Self.dateFormatte)")
        Spacer()
        Image(systemName: "chevron.right")
        Spacer()
      }.padding(.bottom, 10)
        .foregroundColor(Color(red: 80/255, green: 90/255, blue: 250/255))
      HStack(alignment: .bottom) {
        FinanceBarView(height: 700, label: Date())
        FinanceBarView(height: 1000, label: Date())
        FinanceBarView(height: 1200, label: Date())
        FinanceBarView(height: 1600, label: Date(), best: true)
        FinanceBarView(height: 600, label: Date())
        FinanceBarView(height: 1100, label: Date(), havingSpacer: false)
      }.padding(EdgeInsets(top: 30, leading: 30, bottom: 0, trailing: 30))
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
