//
//  FindView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/5/9.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

struct FindView: View {

    var body: some View {
        VStack {
          TopBarView()
          SplitterView()
            
            FinanceBarChartView().padding(.vertical,10)
            
            CountryListView().padding(.top, 20)
        }
        
    }
    
    
}
