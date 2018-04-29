//
//  History.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/27/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import Foundation

struct History {
    var time = ""
    var closeValue = ""
    var highValue = ""
    var lowValue = ""
    var openValue = ""
    var volumefrom = ""
    var volumeto = ""
    
    mutating func initFrom(historyD: [String : Any]) {
        time = historyD["time"] != nil ? "\(String(describing: historyD["time"]!))" : ""
        closeValue = historyD["close"] != nil ? "\(String(describing: historyD["close"]!))" : ""
        highValue = historyD["high"] != nil ? "\(String(describing: historyD["high"]!))" : ""
        lowValue = historyD["low"] != nil ? "\(String(describing: historyD["low"]!))" : ""
        openValue = historyD["open"] != nil ? "\(String(describing: historyD["open"]!))" : ""
        volumefrom = historyD["volumefrom"] != nil ? "\(String(describing: historyD["volumefrom"]!))" : ""
        volumeto = historyD["volumeto"] != nil ? "\(String(describing: historyD["volumeto"]!))" : ""
    }
}

