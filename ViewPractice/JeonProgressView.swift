//
//  JeonProgressView.swift
//  ViewPractice
//
//  Created by 전한경 on 2016. 11. 29..
//  Copyright © 2016년 jeon. All rights reserved.
//

import UIKit

open class JeonProgressView {
    
    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    open class var shared: JeonProgressView {
        struct Static {
            static let instance: JeonProgressView = JeonProgressView()
        }
        return Static.instance
    }
    
    open func showProgressView(_ view: UIView) {
        containerView.frame = view.frame
        containerView.center = view.center
        containerView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.9)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        progressView.center = view.center
        progressView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.9)
        
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        //        activityIndicator.color = UIColor(hex: 0x000000, alpha: 0.3)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        view.addSubview(containerView)
        
        activityIndicator.startAnimating()
    }
    
    open func hideProgressView() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }
}

extension UIColor {
    
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
