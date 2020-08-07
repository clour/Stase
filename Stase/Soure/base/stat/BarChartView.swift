//
//  BarChartView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/8/3.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct BarChartItemView: View {
    
    @State var label: String = ""
    
    @State var colors = ["#90EE14", "#9014EE"]
    
    @State var values:[String] = ["50", "60"]
    
    @State var rate: Float = 1
    
    @Binding var selected: String?
    
    @State private var isAnimating = false
    
    @State private var delay = 0.5
    
    func height() -> Float {
        var result: Float = 0
        for value in values
        {
            let itemHeight = rate * (value as NSString).floatValue
            result = itemHeight > result ? itemHeight : result
        }
        return result
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack {
                HStack(alignment: .bottom) {
                    
                    ForEach(values.indices, id: \.self)
                    { index in
                        let itemHeight = rate * (values[index] as NSString).floatValue
                        VStack {
                            Spacer()
                            Text(values[index])
                                .offset(x: 0, y: isAnimating ? 0 : 60)
                                .opacity(isAnimating ? 1 : 0)
                                .animation(Animation.interpolatingSpring(stiffness: 100, damping: 10)
                                            .delay(0.5))
                                .fixedSize()
                            
                            RoundedRectangle(cornerRadius: selected == label ? 10 : 6)
                                .fill(Color.init(hex: colors[index]) ?? .blue)
                                .frame(width: selected == label ? 20 : 12, height: CGFloat(isAnimating ? itemHeight : 0))
                                .animation(Animation.interpolatingSpring(stiffness: selected == label ? 200 : 100, damping: selected == label ? 100 : 10)
                                            .delay(delay))
                        }
                    }
                }.padding(.top, 0)
                Text(label).fixedSize()
            }.font(.system(size: 11))
            .foregroundColor(selected == label ? .accentColor : .secondary)
            .padding(.top, 0)
        }.frame(height: CGFloat(height()) + 25).padding(.top, 0).padding(.bottom, 0)
        .onAppear() {
            self.isAnimating = true
        }.onTapGesture {
            delay = 0
            if selected == label {
                selected = nil
            }
            else{
                selected = label
            }
        }
    }
}

struct BarChartTitleView: View {
    @State var serias = [["color":"#90EE14", "title":"苏高新"], ["color":"#9014EE", "title":"常高新"]]
    
    var body: some View {
        HStack(alignment: .bottom) {
            Spacer()
            
            ForEach(serias, id: \.self){
                item in
                
                Image(systemName: "square.fill")
                    .font(.system(size: 11))
                    .foregroundColor(Color.init(hex: item["color"] ?? "#9014EE"))
                    .padding(.bottom, 0)
                Text(item["title"] ?? "#9014EE")
                    .font(.system(size: 11)).foregroundColor(Color.init(hex: item["color"] ?? "#9014EE"))
                    .padding(.bottom, 0)
                
            }
            Spacer()
        }
        
    }
}

struct BarChartView: View {
    
    @State var serias: [[String: String]]// = [["color":"#90EE14", "title":"苏高新"], ["color":"#9014EE", "title":"常高新"]]
    
    @State var items: [[String: Any]]// = [["label": "2018/09", "values": ["65", "65"]],["label": "2018/10", "values": ["75", "71"]],["label": "2018/11", "values": ["70", "67"]],["label": "2018/12", "values": ["75", "73"]],["label": "2019/01", "values": ["70", "69"]],["label": "2019/02", "values": ["65", "66"]],["label": "2019/03", "values": ["100", "90"]],["label": "2019/04", "values": ["85", "90"]],["label": "2019/05", "values": ["80", "85"]],["label": "2019/06", "values": ["90", "95"]]]
    
    @State var contentHeight = 100
    
    @State private var scrollPosition: CGPoint = CGPoint(x: 0, y: 0)
    
    @State private var selectedLabel: String?
    
    @State private var toInit = true
    
    func colors() -> [String] {
        var result: [String] = []
        for seria in serias {
            result.append(seria["color"]!)
        }
        return result
    }
    
    func rate() -> Float {
        var result: Float = 0
        var max: Float = 0
        var min: Float = 0
        for item in items {
            for value in item["values"] as! [String] {
                let itemValue = (value as NSString).floatValue
                
                if max < itemValue {
                    max = itemValue
                }
                
                if min > itemValue {
                    min = itemValue
                }
            }
        }
        
        if max - min > 0 {
            result = Float(contentHeight) / (max - min)
        }
        else {
            result = 0
        }
        
        return result
    }
    
    var body: some View {
        VStack(spacing: 0) {
            BarChartTitleView(serias: serias).padding(.bottom, 0)
            ScrollableView($scrollPosition, animationDuration: 0.5, axis: .horizontal){
                
                HStack(alignment: .bottom, spacing: 25) {
                    ForEach(items.indices){
                        index in
                        BarChartItemView(label: items[index]["label"] as! String, colors: colors(), values: items[index]["values"] as! [String], rate: rate(), selected: $selectedLabel)
                    }
                }.background(
                    GeometryReader {
                        proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }).onPreferenceChange(SizePreferenceKey.self) { preferences in
                        if(toInit) {
                            let contentWidth = preferences.width
                            let scrollWidth = CGFloat(contentWidth - screenWidth + 50.0)
                            scrollPosition = CGPoint(x: scrollWidth, y:0)
                            toInit = false
                        }
                    }
                
            }.frame(height: 170).padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25))
            
        }
    }
    
    struct SizePreferenceKey: PreferenceKey {
        typealias Value = CGSize
        static var defaultValue: Value = .zero
        
        static func reduce(value _: inout Value, nextValue: () -> Value) {
            _ = nextValue()
        }
    }
}
