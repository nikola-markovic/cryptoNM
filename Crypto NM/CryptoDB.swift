//
//  CryptoStream.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/24/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import UIKit
import Alamofire

class CryptoDB {
    
    static let main = CryptoDB()
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    
    let cryproApiURL = "https://min-api.cryptocompare.com/data/"
    let cryptoWebURL = "https://www.cryptocompare.com"
    
    enum completeMessage {
        case success
        case fail
    }
    
    func getAllCurrecies(completion: @escaping ([CurrencyInfo]?) -> Void) {
        
        if !isInternetAvailable() {
            completion(getCachedList())
        } else {
            
            Alamofire.request(cryproApiURL + "all/coinlist",
                              method: .get,
                              parameters: [:],
                              encoding: URLEncoding.default,
                              headers: [:])
                .responseJSON { (response) in
                    
                    if response.error == nil {
                        print(response)
                        
                        do {
                            let jsonD = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String : Any]
                            if let allD = jsonD["Data"] as? [String : Any] {
                                var all = [CurrencyInfo]()
                                for d in allD {
                                    var cInfo = CurrencyInfo()
                                    cInfo.initFrom(currencyD: d.value as! [String : Any])
                                    all.append(cInfo)
                                }
                                all.sort(by: { (a, b) -> Bool in
                                    return a.sortOrder < b.sortOrder
                                })
                                
                                let toCache = NSMutableDictionary.init(dictionary: allD)
                                toCache.write(toFile: self.documentsPath + "/currencyInfos.plist", atomically: false)
                                let currentDate = Date.init(timeIntervalSinceNow: 0)
                                let dateF = DateFormatter()
                                dateF.dateStyle = .short
                                dateF.locale = Locale(identifier: "en-US")
                                dateF.string(from: currentDate)
                                UserDefaults.standard.set(dateF.string(from: currentDate), forKey: "all")
                                
                                completion(all)
                            } else {
                                completion(nil)
                            }
                        } catch {
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                        print(response.error!.localizedDescription)
                    }
            }
        }
    }
    
    func getPriceFor(currency: String, converted to: String, completion: @escaping ([Price]?) -> Void) {
        
        if !isInternetAvailable() {
            completion( getCachedPriceFor(currency: currency) )
        } else {
            
            let params: [String: String] = [ "tryConversion" : "true",
                                             "fsym" : currency,
                                             "tsyms" : to ]
            
            Alamofire.request(cryproApiURL + "price",
                              method: .get,
                              parameters: params,
                              encoding: URLEncoding.default,
                              headers: [:])
                .responseJSON { (response) in
                    
                    if response.error == nil {
                        print(response)
                        do {
                            let jsonD = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String : Any]
                            var all = [Price]()
                            for d in jsonD {
                                var price = Price()
                                price.currency = d.key
                                price.value = "\(d.value)".folding(locale: nil)
                                if !price.value.contains("e") && !price.value.contains("-") {
                                    all.append(price)
                                }
                            }
                            let toCache = NSMutableDictionary.init(dictionary: jsonD)
                            toCache.write(toFile: self.documentsPath + "/\(currency)_prices.plist", atomically: false)
                            
                            all.sort(by: { (a, b) -> Bool in
                                return a.currency < b.currency
                            })
                            completion(all)
                        } catch {
                            completion(nil)
                        }
                    } else {
                        print(response.error!.localizedDescription)
                    }
            }
        }
        
    }
    
    func getHistoryFor(currency: String, timeType: String, historyCount: String, aggregation: String, comparedTo: String, completion: @escaping ([History]?) -> Void) {
        
        if !isInternetAvailable() {
            completion(getCachedHistoryFor(currency: currency + timeType + historyCount + aggregation + comparedTo))
        } else {
            
            let params: [String: String] = [ "fsym" : currency,
                                             "tsym" : comparedTo,
                                             "limit" : historyCount,
                                             "aggregate" : aggregation
            ]
            
            Alamofire.request(cryproApiURL + timeType,
                              method: .get,
                              parameters: params,
                              encoding: URLEncoding.default,
                              headers: [:])
                .responseJSON { (response) in
                    
                    if response.error == nil {
                        print(response)
                        
                        do {
                            let jsonD = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String : Any]
                            if let allD = jsonD["Data"] as? [[String : Any]] {
                                var all = [History]()
                                for d in allD {
                                    var history = History()
                                    history.initFrom(historyD: d)
                                    all.append(history)
                                }
                                                                
                                let toCache = NSMutableArray.init(array: allD)
                                toCache.write(toFile: self.documentsPath + "/\(currency + timeType + historyCount + aggregation + comparedTo)_history.plist", atomically: false)
                                
                                completion(all.reversed())
                            } else {
                                completion(nil)
                            }
                        } catch {
                            completion(nil)
                        }
                    } else {
                        completion(nil)
                        print(response.error!.localizedDescription)
                    }
            }
        }
    }
    
    
    // cached
    func getCachedList() -> [CurrencyInfo]? {
        if FileManager.default.fileExists(atPath: documentsPath.appending("/currencyInfos.plist")) {
            let cachedD = NSMutableDictionary.init(contentsOfFile: documentsPath.appending("/currencyInfos.plist"))!
            var all = [CurrencyInfo]()
            
            for infoD in cachedD {
                var cInfo = CurrencyInfo()
                cInfo.initFrom(currencyD: (infoD.value as! [String : Any]))
                all.append(cInfo)
            }
            
            all.sort { (a, b) -> Bool in
                return a.sortOrder < b.sortOrder
            }
            
            return all
        } else {
            return nil
        }
    }
    
    func getCachedPriceFor(currency: String) -> [Price]? {
        if FileManager.default.fileExists(atPath: documentsPath.appending("/\(currency)_prices.plist")) {
            let cachedD = (NSMutableDictionary.init(contentsOfFile: documentsPath.appending("/\(currency)_prices.plist"))! as! [String : Any])
            var all = [Price]()
            
            for priceD in cachedD {
                var price = Price()
                price.currency = priceD.key
                price.value = "\(priceD.value)"
                all.append(price)
            }
            
            all.sort { (a, b) -> Bool in
                return a.currency < b.currency
            }
            
            return all
        } else {
            return nil
        }
    }
    
    func getCachedHistoryFor(currency: String) -> [History]? {
        if FileManager.default.fileExists(atPath: documentsPath.appending("/\(currency)_history.plist")) {
            let cachedD = NSMutableArray.init(contentsOfFile: documentsPath.appending("/\(currency)_history.plist"))!
            var all = [History]()
            
            for historyD in cachedD {
                var history = History()
                history.initFrom(historyD: (historyD as! [String : Any]))
                all.append(history)
            }
            
            return all.reversed()
        } else {
            return nil
        }
    }
}
