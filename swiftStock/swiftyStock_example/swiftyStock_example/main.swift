//
//  main.swift
//  swiftyStock_example
//
//  Created by Ting Wu on 8/8/16.
//  Copyright © 2016 TingWu. All rights reserved.
//

import Foundation

let s = swiftStock(dataProvider: .Google)
let stockData = s.getStockData("2330.TW")
let historicalData = s.getStockHistoricalDataFromYahoo(symbol: "2330.TW",startDate: "2016-8-01", endDate: "2016-08-05")
let multipleStock = s.multipleStockFromYahoo(symbolSet: ["2330.TW","AAPL"])



for  key in stockData.keys{
    
    print("\(key) : \(stockData[key]!)")
}

//for data in multipleStock {
//
//    print("\(data["symbol"]!) :")
//
//    for key in data.keys{
//        if data[key] != "" {
//            print("\(key): \(data[key]!)")
//        }
//    }
//    print ("\n\n")
//
//}
//
//for (day, data) in historicalData.enumerate(){
//
//    print("day \(day) :")
//
//    for key in data.keys{
//        print("\(key): \(data[key]!)")
//    }
//    print ("\n")
//}