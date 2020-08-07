//
//  PieChartView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/7/13.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct StatCircleView: View {
  var diameter: CGFloat
    
  var startPoint: CGFloat
  var endPoint: CGFloat
  
  var angle: Double
  
  @State var isAnimating = false
  
  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 25)
        .fill(Color(.systemGroupedBackground))
        .frame(width: diameter, height: diameter)
      Circle()
        .trim(from: isAnimating ? startPoint : 0, to: isAnimating ? endPoint : 0)
        .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round))
        .fill(LinearGradient(gradient: Gradient(
                                colors: [Color.init(hex: 0x3905CD), Color.init(hex: 0x9014EE)]),
                             startPoint: .trailing,
                             endPoint: .leading))
        .frame(width: diameter, height: diameter)
        .rotationEffect(.degrees(angle))
        .transformEffect(CGAffineTransform(a: -1,b: 0,c: 0,d: 1,tx: diameter,ty: 0))
        .animation(.spring())
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
        startPoint: 0,
        endPoint: 0.8,
        angle: -90
      )
      
      VStack {
        Text("80")
          .font(.system(size: 40))
            .foregroundColor(.primary).padding(.top, 40)
        Text("超越率（%）")
          .font(.system(size: 14))
            .foregroundColor(Color.orange)
        Text("上月75%")
          .font(.system(size: 12))
            .foregroundColor(Color.primary.opacity(0.5)).padding(.top, 5)
        Text("提升5%")
          .font(.system(size: 12))
          .foregroundColor(Color.primary.opacity(0.5)).padding(.top, 5)
      }
    }
  }
}

