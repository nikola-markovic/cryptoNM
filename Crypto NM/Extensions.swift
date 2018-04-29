//
//  Extensions.swift
//  Kvizic
//
//  Created by Nikola Markovic on 3/8/18.
//  Copyright © 2018 Nikola Markovic. All rights reserved.
//

import UIKit
import SystemConfiguration

extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue  }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor  }
        get { return UIColor.init(cgColor: layer.borderColor!) }
    }
    
    @IBInspectable public var shadowOffset: CGSize {
        set { layer.shadowOffset = newValue  }
        get { return layer.shadowOffset }
    }
    
    @IBInspectable public var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.shadowOpacity }
    }
    
    @IBInspectable public var shadowRadius: CGFloat {
        set {  layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get { return UIColor.init(cgColor: layer.shadowColor!) }
    }
    
}

func isInternetAvailable() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        print("hm")
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        print("hm")
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}

func showServerErrorAlert(in vc: UIViewController) {
    let serverAlert = UIAlertController.init(title: "Server error", message: "Server is currently unreachable. Please try again.", preferredStyle: .alert)
    serverAlert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
        
    }))
    vc.present(serverAlert, animated: true, completion: nil)
}
