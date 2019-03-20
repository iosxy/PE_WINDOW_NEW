//
//  UIView+Nib.swift
//  Yuwan
//
//  Created by lqs on 2017/6/10.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {
    
    // note that this method returns an instance of type `Self`, rather than UIView
    static func loadFromNib() -> Self {
        let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
    
}

extension UIViewController {
    
    func setupBackButton(_ image: UIImage = #imageLiteral(resourceName: "nav_back"), _ toRoot: Bool = false) {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: toRoot ? #selector(backToRoot(_:)) : #selector(back(_:)))
        if toRoot {
        
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(backToRoot(_:)))
            
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self.navigationController as! UIGestureRecognizerDelegate
    }
    
    @objc func back(_ sender: Any) {
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationController!.popViewController(animated: true)
        } else {
            self.navigationController!.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func backToRoot(_ sender: Any) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    
}
