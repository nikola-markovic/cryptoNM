//
//  ViewController.swift
//  Crypto NM
//
//  Created by Nikola Markovic on 4/24/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var allCurrencies = [CurrencyInfo]()
    
    @IBOutlet weak var tableV : UITableView!
    @IBOutlet weak var darkenV : UIView!
    @IBOutlet weak var loading : UIActivityIndicatorView!
    @IBOutlet weak var errorLbl : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLbl.text = "Error occurred.\nPlease, try again."
        getAll()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getAll() {
        self.showLoading(yes: true)
        CryptoDB.main.getAllCurrecies { (gatheredInfo) in
            if gatheredInfo != nil {
                self.tableV.alpha = 1
                self.allCurrencies = gatheredInfo!
                self.tableV.reloadData()
            } else {
                // TO DO: Show error
                showServerErrorAlert(in: self)
                self.tableV.alpha = 0
            }
            self.showLoading(yes: false)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableV.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyCell
        cell.configureFor(currency: allCurrencies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsNavBar = self.storyboard?.instantiateViewController(withIdentifier: "detailNavBar") as! DetailNavBar
        
        
        detailsNavBar.selectedCurrencyInfo = self.allCurrencies[indexPath.row]
        
        self.navigationController?.pushViewController(detailsNavBar, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        
        self.tableV.deselectRow(at: indexPath, animated: true)
    }
    
    func showLoading(yes: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            if yes {
                self.darkenV.alpha = 1
                self.loading.startAnimating()
            } else {
                self.darkenV.alpha = 0
                self.loading.stopAnimating()
            }
        }) { (complete) in
            
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        self.getAll()
    }
    
    @IBAction func aboutTapped(_ sender: Any) {
        let alert = UIAlertController.init(title: "About", message: "Created by:\nNikola Marković", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
