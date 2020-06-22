//
//  MapView.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/17.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import MapKit
import MAMapKit

struct MapView :UIViewRepresentable {
   typealias UIViewType = MAMapView
    
    class Coordinator: NSObject,MAMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        //Mark MAMapViewDelegate
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MAMapView {
    
        AMapServices.shared().enableHTTPS = true //默认开启https
        
        let mapView = MAMapView(frame: .zero)
        
        mapView.showsUserLocation = true //显示用户当前位置，地图上显示蓝色小点，并且有个精度范围
        mapView.userTrackingMode = .follow //开启用户的追踪模式
        
       // mapView.logoCenter = .init(x: 200, y: 200)
        //显示指南针，和指南针位置
        mapView.showsCompass = false
        //mapView.compassOrigin = CGPoint(x: mapView.bounds.origin.x + 300, y: 10)
        //显示比例尺，和比例尺位置
        mapView.showsScale = false
        mapView.scaleOrigin = CGPoint(x: 10, y: 10)
        //mapView.metersPerPointForCurrentZoomLevel 只读
        
        mapView.isShowTraffic = false//显示交通
        mapView.mapType = .standard//地图类型，卫星地图
        mapView.setZoomLevel(17, animated: true)//初始化放大10倍，显示在合适的位置
       //mapView.setCompassImage(T##image: UIImage!##UIImage!)//设置罗盘的图片
        
        mapView.setCenter(CLLocationCoordinate2D(latitude: 31.86376485854748, longitude: 120.03423292849348), animated: true)
        
        let pointAnnotation = MAPointAnnotation()
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: 31.86376485854748, longitude: 120.03423292849348)
                    pointAnnotation.title = "璜土公园"
                    pointAnnotation.subtitle = "璜土生态公园"
        mapView.addAnnotation(pointAnnotation)
        
        return mapView
    }
    func updateUIView(_ uiView: MAMapView, context: Context) {
        
    }
}

#if DEBUG
struct GDMap_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            //.frame(width: 200, height: 200, alignment: .center)
    }
}
#endif
