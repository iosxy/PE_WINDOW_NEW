//
//  RootNavigationController.swift
//  Yuwan
//
//  Created by 亚鑫柳 on 2017/9/18.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController,UIGestureRecognizerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationBar.shadowImage = UIImage()
    self.navigationBar.backgroundColor = .clear
    self.navigationBar.tintColor = .white
    self.interactivePopGestureRecognizer?.delegate = self
  }
  override var shouldAutorotate: Bool {
    guard let topViewController = topViewController else {
      return true
    }
    return topViewController.shouldAutorotate
  }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    guard let topViewController = topViewController else {
      return .all
    }
    return topViewController.supportedInterfaceOrientations
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    guard let topViewController = topViewController else {
      return .default
    }
    return topViewController.preferredStatusBarStyle
  }
}

