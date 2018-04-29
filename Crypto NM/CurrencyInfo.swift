//
//  CurrencyInfo.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/24/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import Foundation

struct CurrencyInfo {
    var id : Int = 0
    var url : String = ""
    var imageUrl : String = ""
    var name : String = ""
    var symbol : String = ""
    var coinName : String = ""
    var fullName : String = ""
    var algorithm : String = ""
    var proofType : String = ""
    var fullyPremined : Bool = false
    var totalCoinSupply : String = ""
    var preMinedValue : String = ""
    var totalCoinsFreeFloat : String = ""
    var sortOrder : Int = 0
    var sponsored : Bool = false
    var isTrading : Bool = false
    
    mutating func initFrom(currencyD: [String : Any]) {
        id = currencyD["Id"] != nil ? Int(currencyD["Id"] as! String)! : 0
        url = currencyD["Url"] != nil ? currencyD["Url"] as! String : ""
        imageUrl = currencyD["ImageUrl"] != nil ? currencyD["ImageUrl"] as! String : ""
        name = currencyD["Name"] != nil ? currencyD["Name"] as! String : ""
        symbol = currencyD["Symbol"] != nil ? currencyD["Symbol"] as! String : ""
        coinName = currencyD["CoinName"] != nil ? currencyD["CoinName"] as! String : ""
        fullName = currencyD["FullName"] != nil ? currencyD["FullName"] as! String : ""
        algorithm = currencyD["Algorithm"] != nil ? currencyD["Algorithm"] as! String : ""
        proofType = currencyD["ProofType"] != nil ? currencyD["ProofType"] as! String : ""
        fullyPremined = currencyD["FullyPremined"] != nil ? currencyD["Sponsored"] as! Bool : false
        
        
        
        totalCoinSupply = currencyD["TotalCoinSupply"] != nil ? (currencyD["TotalCoinSupply"] as! String) : "N/A"
        preMinedValue = currencyD["PreMinedValue"] != nil ? currencyD["PreMinedValue"] as! String : ""
        totalCoinsFreeFloat = currencyD["TotalCoinsFreeFloat"] != nil ? currencyD["TotalCoinsFreeFloat"] as! String : ""
        sortOrder = currencyD["SortOrder"] != nil ? Int(currencyD["SortOrder"] as! String)! : 0
        sponsored = currencyD["Sponsored"] != nil ? (currencyD["Sponsored"] as! Bool) : false
        isTrading = currencyD["IsTrading"] != nil ? (currencyD["IsTrading"] as! Bool) : false
    }
}

