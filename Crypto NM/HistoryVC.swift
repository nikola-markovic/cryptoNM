//
//  HistoryVC.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/27/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollV : UIScrollView!
    @IBOutlet weak var contentV : UIView!
    @IBOutlet weak var dailyV : UIView!
    @IBOutlet weak var dailyImgV: UIImageView!
    @IBOutlet weak var hourlyV : UIView!
    @IBOutlet weak var hourlyImgV: UIImageView!
    @IBOutlet weak var minuteV : UIView!
    @IBOutlet weak var minuteImgV: UIImageView!
    
    @IBOutlet var highestLbls : [UILabel]!
    @IBOutlet var midsLbls : [UILabel]!
    @IBOutlet var lowestLbls : [UILabel]!
    
    @IBOutlet var graphTitles : [UILabel]!

    
    var oneDay: [History]?
    var threeDays: [History]?
    var oneWeek: [History]?
    var twoWeeks: [History]?
    var oneMonth: [History]?
    
    var oneWeekHourly: [History]?
    
    var oneHour: [History]?
    var threeHours: [History]?
    var oneDayMinutes: [History]?
    
    weak var detailNavBar : DetailNavBar!
    var selectedCurrencyInfo : CurrencyInfo!
    
    var currentDaily = 0
    var currentHourly = 0
    var currentMinute = 0
    
    var to = "BTC"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedCurrencyInfo.symbol == to || self.detailNavBar.detailVC.comparePrices[0].currency != "BTC" {
            to = "USD"
        }
        
        for l in graphTitles {
            l.text = l.text! + " compared to \(to)"
        }
        
        self.getHourlyHistory(for: 0, graph: dailyV)
        self.getHourlyHistory(for: 0, graph: hourlyV)
        self.getMinuteHistory(for: 0, graph: minuteV)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            let h: CGFloat = self.dailyV.frame.height + self.hourlyV.frame.height + self.minuteV.frame.height + 360
            
            self.scrollV.contentSize = CGSize(width: self.view.frame.width, height: h)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 70 {
            self.detailNavBar.topBar_H.constant = 140 - scrollView.contentOffset.y
        } else {
            self.detailNavBar.topBar_H.constant = 70
        }
    }
    
    // DAILY
    
    func getDailyHistory(for segment: Int, graph: UIView) {
        let agg = "1"
        var limit = "6"
        switch segment {
        case 1:
            if self.oneWeek != nil {
                loadHistory(history: self.oneWeek!, for: graph)
                return
            }
            break
        case 2:
            if twoWeeks != nil {
                loadHistory(history: self.twoWeeks!, for: graph)
                return
            }
            limit = "15"
            break
        case 3:
            if oneMonth != nil {
                loadHistory(history: self.oneMonth!, for: graph)
                return
            }
            limit = "30"
            break
        default:
            break
        }
        self.detailNavBar.loading.startAnimating()
        CryptoDB.main.getHistoryFor(currency: selectedCurrencyInfo.symbol,
                                    timeType: "histoday",
                                    historyCount: limit,
                                    aggregation: agg,
                                    comparedTo: to)
        { (gathered) in
            if gathered == nil {
                self.loadHistory(history: [History](), for: graph)
                showServerErrorAlert(in: self)
            } else {
                
                switch segment {
                case 1:
                    self.oneWeek = gathered
                    break
                case 2:
                    self.twoWeeks = gathered
                    break
                case 3:
                    self.oneMonth = gathered
                    break
                default:
                    break
                }
                self.loadHistory(history: gathered!, for: graph)
            }
        }
    }
    
    @IBAction func dailyValueTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.getHourlyHistory(for: 0, graph: dailyV)
        } else {
            self.getDailyHistory(for: sender.selectedSegmentIndex, graph: dailyV)
        }
    }
    
    // HOURLY
    
    func getHourlyHistory(for segment: Int, graph: UIView) {
        let agg = "1"
        var limit = "23"
        switch segment {
        case 0:
            if self.oneDay != nil {
                loadHistory(history: self.oneDay!, for: graph)
                return
            }
            break
        case 1:
            if self.threeDays != nil {
                loadHistory(history: self.threeDays!, for: graph)
                return
            }
            limit = "71"
            break
        case 2:
            if oneWeekHourly != nil {
                loadHistory(history: self.oneWeekHourly!, for: graph)
                return
            }
            limit = "167"
            break
        default:
            break
        }
        self.detailNavBar.loading.startAnimating()
        CryptoDB.main.getHistoryFor(currency: selectedCurrencyInfo.symbol,
                                    timeType: "histohour",
                                    historyCount: limit,
                                    aggregation: agg,
                                    comparedTo: to)
        { (gathered) in
            if gathered == nil {
                self.loadHistory(history: [History](), for: graph)
                showServerErrorAlert(in: self)
            } else {
                switch segment {
                case 0:
                    self.oneDay = gathered
                    break
                case 1:
                    self.threeDays = gathered
                    break
                case 2:
                    self.oneWeekHourly = gathered
                    break
                default:
                    break
                }
                self.loadHistory(history: gathered!, for: graph)
            }
        }
    }
    
    @IBAction func hourlyValueTapped(_ sender: UISegmentedControl) {
        self.getHourlyHistory(for: sender.selectedSegmentIndex, graph: hourlyV)
    }
    
    
    
    // MINUTE
    
    func getMinuteHistory(for segment: Int, graph: UIView) {
        let agg = "1"
        var limit = "59"
        switch segment {
        case 1:
            if self.threeHours != nil {
                loadHistory(history: self.threeHours!, for: graph)
                return
            }
            limit = "179"
            break
        case 2:
            if self.oneDayMinutes != nil {
                loadHistory(history: self.oneDayMinutes!, for: graph)
                return
            }
            limit = "1439"
        default:
            break
        }
        self.detailNavBar.loading.startAnimating()
        CryptoDB.main.getHistoryFor(currency: selectedCurrencyInfo.symbol,
                                    timeType: "histominute",
                                    historyCount: limit,
                                    aggregation: agg,
                                    comparedTo: to)
        { (gathered) in
            if gathered == nil {
                self.loadHistory(history: [History](), for: graph)
                showServerErrorAlert(in: self)
            } else {
                
                switch segment {
                case 0:
                    self.oneHour = gathered
                    break
                case 1:
                    self.threeHours = gathered
                    break
                case 2:
                    self.oneDayMinutes = gathered
                default:
                    break
                }
                self.loadHistory(history: gathered!, for: graph)
            }
        }
    }
    
    @IBAction func minuteValueTapped(_ sender: UISegmentedControl) {
        //        if sender.selectedSegmentIndex == 2 {
        //            self.getHourlyHistory(for: 0, graph: minuteV)
        //        } else {
        self.getMinuteHistory(for: sender.selectedSegmentIndex, graph: minuteV)
        //        }
    }
    
    
    // GRAPH CREATION
    
    func loadHistory(history: [History], for theView: UIView) {
        theView.layer.sublayers?.removeAll()
        let imgs = [7,9,10,12]
        var img = imgs[0]
        for i in imgs {
            if history.count % i == 0 {
                img = i
                break
            }
        }
        
        if theView.tag == 0 {
            dailyImgV.image = UIImage.init(named: "History\(img)")
        } else if theView.tag == 1 {
            hourlyImgV.image = UIImage.init(named: "History\(img)")
        } else {
            minuteImgV.image = UIImage.init(named: "History\(img)")
        }
        
        let sepDistance = theView.frame.width / CGFloat(history.count - 1)
        
        let shape = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: theView.frame.height))
        
        var highest:Float = 0.0
        var lowest:Float = Float.infinity
        
        for h in history {
            if Float(h.highValue)! > highest {
                highest = Float(h.highValue)!
            }
            if Float(h.highValue)! < lowest {
                lowest = Float(h.highValue)!
            }
        }
        
        let difference = (highest - lowest) / 100
        
        let mid = (highest + lowest) / 2
        
        self.lowestLbls[theView.tag].text = "\(lowest)"
        self.highestLbls[theView.tag].text = "\(highest)"
        self.midsLbls[theView.tag].text = "\(mid)"
        
        
        let lowestY = theView.frame.height / 6
        let highestY = theView.frame.height - lowestY * 2
        
        
        for i in 0..<history.count {
            if let high = NumberFormatter().number(from: history[i].highValue) {
                let currentY = (high.floatValue - lowest) / difference / 100
                
                path.addLine(to: CGPoint(x: CGFloat(i) * sepDistance, y: lowestY + CGFloat(currentY) * highestY))
            }
        }
        
        path.addLine(to: CGPoint(x: CGFloat(history.count - 1) * sepDistance, y: theView.frame.height))
        path.close()
        
        shape.fillColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
        shape.strokeColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        shape.lineWidth = 1
        shape.position = CGPoint(x: 0, y: 0)
        
        shape.path = path.cgPath
        theView.layer.addSublayer(shape)
        self.detailNavBar.loading.stopAnimating()
    }
    
}
