//
//  Constants.swift
//  Stase
//
//  Created by 宋志勇 on 2020/6/3.
//  Copyright © 2020 宋志勇. All rights reserved.
//

import SwiftUI

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let regularColor = Color.primary
let inactiveColor = Color.primary.opacity(0.1)
let activeColor = Color.accentColor

let regularFontSize: CGFloat = 15

let chartWidth = UIScreen.main.bounds.width * 0.6
let menuWidth = UIScreen.main.bounds.width / 4

struct Country: Identifiable {
  var id: Int
  var title: String
  var color: Color
  var visit: Int
}

let country = [
  Country(id: 1, title: "地区生产总值", color: .red, visit: 563),
  Country(id: 2, title: "工业总产值", color: .orange, visit: 234),
  Country(id: 3, title: "工业产品销售收入", color: .yellow, visit: 522),
  Country(id: 4, title: "工业实现利税", color: .green, visit: 1023),
  Country(id: 5, title: "财政总收入", color: .blue, visit: 421),
  Country(id: 6, title: "固定资产投资完成额", color: .purple, visit: 98),
  Country(id: 7, title: "协议注册外资", color: .gray, visit: 321),
]

let enter = [
  EnterItem(//基本信息
  id: "1",
  name: "小米科技有限责任公司",
  leprent: "雷军",
  capital: "185000万元人民币",
  esdate: "2010-03-03",
  address: "北京市海淀区西二旗中路33号院6号楼6层006号",
  scope: "技术开发；货物进出口、技术进出口、代理进出口；销售通讯设备、厨房用品、卫生用品（含个人护理用品）、日用杂货、化妆品、医疗器械Ⅰ类、Ⅱ类、避孕器具、玩具、体育用品、文化用品、服装鞋帽、钟表眼镜、针纺织品、家用电器、家具（不从事实体店铺经营）、花、草及观赏植物、不再分装的包装种子、照相器材、工艺品、礼品、计算机、软件及辅助设备、珠宝首饰、食用农产品、宠物食品、电子产品、摩托车、电动车、自行车及零部件、智能卡、五金交电（不从事实体店铺经营）、建筑材料（不从事实体店铺经营）；维修仪器仪表；维修办公设备；承办展览展示活动；会议服务；筹备、策划、组织大型庆典；设计、制作、代理、发布广告；摄影扩印服务；文艺演出票务代理、体育赛事票务代理、展览会票务代理、博览会票务代理；手机技术开发；手机生产、手机服务（限海淀区永捷北路2号二层经营）；从事互联网文化活动；出版物零售；出版物批发；销售第三类医疗器械；销售食品；零售药品；广播电视节目制作；经营电信业务。（市场主体依法自主选择经营项目，开展经营活动；从事互联网文化活动、出版物批发、出版物零售、销售食品、经营电信业务、广播电视节目制作、零售药品、销售第三类医疗器械以及依法须经批准的项目，经相关部门批准后依批准的内容开展经营活动；不得从事国家和本市产业政策禁止和限制类项目的经营活动。）",
  //经营信息
  state: "在业",
  scale: "大型",
  hinech: "是",
  listed: "是",
  pripo: "否",
  threbole: "否",
  threbore: "否",
  topive: "是",
  saoumle: "是"
),
  EnterItem(//基本信息
    id: "2",
    name: "有米科技股份有限公司",
    leprent: "陈第",
    capital: "10000万元人民币",
    esdate: "2010-04-21",
    address: "广州市番禺区小谷围街青蓝街26号1701",
    scope: "技术进出口;广告业;计算机技术开发、技术服务;货物进出口（专营专控商品除外）;软件开发;信息技术咨询服务;企业管理咨询服务;增值电信服务（业务种类以《增值电信业务经营许可证》载明内容为准）",
    //经营信息
    state: "",
    scale: "中型",
    hinech: "否",
    listed: "是",
    pripo: "是",
    threbole: "是",
    threbore: "是",
    topive: "是",
    saoumle: "是"
  )
]
