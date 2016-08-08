//: Playground - noun: a place where people can play

import Foundation

var historicalStockData = [[String:String]]()
let urlPrefix = "http://query.yahooapis.com/v1/public/yql?q="
let urlData = "select * from yahoo.finance.historicaldata where symbol = \"\(symbol)\" and startDate = \"" + startDate + "\" and endDate = \"" + endDate + "\""
let urlProfix = "&format=json&diagnostics=true&env=store://datatables.org/alltableswithkeys&callback="
let stockUrlString = urlPrefix + urlData + urlProfix
let stockUrl = NSURL(string: stockUrlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
let stockData = try! NSData(contentsOfURL: stockUrl!, options: [])
let json = JSON(data: stockData)

for (_ , data) in json["query"]["results"]["quote"]{
    var currentDateData = [String: String]()
    for (key, value) in data {
        currentDateData[key] = value.stringValue
    }
    historicalStockData.append(currentDateData)
}

print(historicalStockData)