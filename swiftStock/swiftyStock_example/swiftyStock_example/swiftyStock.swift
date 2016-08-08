//  swiftyStock.swift
//
//  Author : Nick Wu
//  Date : AUG, 7, 2016
//  Xcode 7.1, Swift 2.2

import Foundation

enum stockDataProvider {
    
    case Google
    case Yahoo
    
}

class swiftStock {
    
    var dataProvider: stockDataProvider
    
    init(dataProvider provider: stockDataProvider){
        dataProvider = provider
    }
    
    func getStockData(symbol: String) -> [String: String] {
        
        switch dataProvider {
            
        case .Google:
            return stockFromGoogle(symbol: symbol)
        case .Yahoo:
            return stockFromYahoo(symbol: symbol)
        }
    }
    
    func getStockHistoricalDataFromYahoo(symbol symbol: String, startDate: String, endDate : String) -> [[String: String]]{
        
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
        return historicalStockData
    }
    
    func stockFromGoogle(symbol name: String) ->[String: String]{
        
        var stock = [String: String]()
        let symbol = name.stringByReplacingOccurrencesOfString(".TW", withString: "")
        let stockUrlString = "https://finance.google.com/finance/info?q=" + symbol
        let stockUrl = NSURL(string: stockUrlString)
        
        var stockData = try! NSData(contentsOfURL: stockUrl!, options: [])
        var stockString = String(data: stockData, encoding: NSUTF8StringEncoding)
        stockString = stockString!.stringByReplacingOccurrencesOfString("\n", withString: "")
        stockString = stockString!.stringByReplacingOccurrencesOfString("// ", withString: "")
        stockData = stockString!.dataUsingEncoding(NSUTF8StringEncoding)!
        let json = JSON(data: stockData)
        
        for (index, data) in json.arrayValue[0]{
            stock[index] = data.stringValue
        }
        return stock
    }
    
    func stockFromYahoo(symbol symbol: String) -> [String: String]{
        
        var stock = [String: String]()
        let urlPrefix = "http://query.yahooapis.com/v1/public/yql?q="
        let urlData = "select * from yahoo.finance.quotes where symbol in (\"\(symbol)\")"
        let urlProfix = "&env=http://datatables.org/alltables.env&format=json"
        let stockUrlString = urlPrefix + urlData + urlProfix
        let stockUrl = NSURL(string: stockUrlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        if let stockData = try? NSData(contentsOfURL: stockUrl!, options: []){
            
            let json = JSON(data: stockData)//Get JSON

            for (key, data) in json["query"]["results"]["quote"]{
                
                stock[key] = data.stringValue
            }
        }
        return stock
    }
    
    func multipleStockFromYahoo(symbolSet symbols: [String]) -> [[String : String]]{
        
        var multipleStock = [[String: String]]()
        var symbol = "\"" + symbols[0]
        for value in 1..<symbols.endIndex{
            symbol = symbol + "\",\"" + symbols[value]
        }
        symbol = symbol + "\""
        
        let urlPrefix = "http://query.yahooapis.com/v1/public/yql?q="
        let urlData = "select * from yahoo.finance.quotes where symbol in (\(symbol))"
        let urlProfix = "&env=http://datatables.org/alltables.env&format=json"
        let stockUrlString = urlPrefix + urlData + urlProfix
        
        let stockUrl = NSURL(string: stockUrlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        let stockData = try! NSData(contentsOfURL: stockUrl!, options: [])
        let json = JSON(data: stockData)
        
        for (_ , data) in json["query"]["results"]["quote"]{
            
            var currentStock = [String: String]()
            
            for (key, value) in data{
                currentStock[key] = value.stringValue
            }
            multipleStock.append(currentStock)
            
        }
        return multipleStock
    }
}



