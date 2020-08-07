//
//  Bemark.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/28.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct BemarkView: View {
    
    @State var title = "对标苏高新"
    
    @State var serias: [[String: String]] = [["color":"#90EE14", "title":"苏高新"], ["color":"#9014EE", "title":"常高新"]]
    
    @State var items: [[String: Any]] = [["label": "2018/09", "values": ["65", "65"]],["label": "2018/10", "values": ["75", "71"]],["label": "2018/11", "values": ["70", "67"]],["label": "2018/12", "values": ["75", "73"]],["label": "2019/01", "values": ["70", "69"]],["label": "2019/02", "values": ["65", "66"]],["label": "2019/03", "values": ["100", "90"]],["label": "2019/04", "values": ["85", "90"]],["label": "2019/05", "values": ["80", "85"]],["label": "2019/06", "values": ["90", "95"]],["label": "2019/07", "values": ["95", "90"]],["label": "2019/08", "values": ["90", "100"]]]

    var body: some View {
        VStack{
            DateBarView(date: "2020年07月").padding(.bottom, 10)
            HStack(alignment: .center) {
                PieChartView()
            }.padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
          
            BarChartView(serias: serias, items: items).padding(.top,15).padding(.bottom, 0)
            
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
                  
                  Rectangle()
                    .fill(inactiveColor)
                    .frame(width: screenWidth - 40, height: 1)
                }
              }
          }
        }
        
    }
    
    
}

let dateFormatte: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd/MM/yyyy"
  return formatter
}()

struct FinanceCardView: View {
  var cardNo: String
  var person: String
  var color: Color
  var expireDate: Date
  var cardType: CardType
  
  enum CardType: String {
    case VISA
    case MASTER
  }
  
  var body: some View {
    ZStack {
      Rectangle()
        .fill(color)
        .cornerRadius(6)
      VStack(alignment: .leading) {
        Text(cardType.rawValue)
          .bold()
          .italic()
          .font(.system(size: 24))
        Text(cardNo)
          .padding(.top, 10)
          .padding(.bottom, 26)
          .font(.system(size: 20))
        HStack {
          VStack(alignment: .leading, spacing: 5) {
            Text("姓名")
            Text(person)
          }
          Spacer()
          VStack(alignment: .leading, spacing: 5) {
            Text("失效日期")
            Text("\(expireDate, formatter: dateFormatte)")
          }
        }.font(.system(size: 12))
      }.padding(.horizontal, 28)
    }.foregroundColor(.white)
    .frame(width: screenWidth - 76, height: 160)
  }
}

struct BemarkView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BemarkView()
        }
    }
}
