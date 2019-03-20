//
//  MainFrame.swift
//  Yuwan
//
//  Created by PengFei on 11/8/17.
//  Copyright © 2017 lqs. All rights reserved.
//

import Foundation
import UIKit
import ESTabBarController_swift
import SnapKit
class YuwanTabViewController: ESTabBarController {
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}

class YuwanRootViewController : RootNavigationController, UITabBarControllerDelegate {
  enum Tab: String {
    case news = "news"
    case ranking = "ranking"
    case clander = "clander"
    case me = "me"
  }

  let tabVC = YuwanTabViewController()
  private let newsVC = NewsViewController()
  private let rankingVC = RankingViewController()
    // private let laoVC = ActivityTabViewController()
  private let clanderVC = ClanderViewController()
  private let meVC = MineViewController()

  override func viewDidLoad() {
    super.viewDidLoad()

    let controllers:[UIViewController] = [newsVC,
                                          rankingVC,
                                          clanderVC,
                                          meVC,
                                          ]
    let icons = ["news",
                 "rangking",
                 "clander",
                 "me"]
    
    let titles = ["新闻", "排行", "行程", "我的"]

    for i in 0..<controllers.count {
//      if (i == 2) {
//        let contentView = ESTabBarItemContentView()
//        contentView.insets = UIEdgeInsets(top: -27, left: 0, bottom: 0, right: 0)
//        contentView.renderingMode = .alwaysOriginal
//
//        controllers[i].tabBarItem =
//          ESTabBarItem(contentView,
//                       title: nil,
//                       image: UIImage(named: icons[i]),
//                       selectedImage: UIImage(named: icons[i]))
//        contentView.textColor = .clear
//        contentView.highlightTextColor = .clear
//        contentView.imageView.snp.makeConstraints { (make) in
//            make.width.equalTo(55);
//            make.height.equalTo(55);
//            make.centerWithinMargins.equalToSuperview()
//        }
//        continue
//      }
      let contentView = ESTabBarItemContentView()
      contentView.renderingMode = .alwaysOriginal
      contentView.textColor = HEXCOLOR(0x9D9D9D)
      contentView.highlightTextColor = HEXCOLOR(0xFF9800)
      controllers[i].tabBarItem =
        ESTabBarItem(contentView,
                     title: titles[i],
                     image: UIImage(named: icons[i]),
                     selectedImage: UIImage(named: icons[i] + "_pre"))
    }
    tabVC.delegate = self
    tabVC.tabBar.isTranslucent = false
    tabVC.viewControllers = controllers
    self.showTab(tab: .news)
    self.pushViewController(tabVC, animated: false)
    
//    NotificationCenter.default.addObserver(self,
//                                           selector: #selector(onLogin(notification:)),
//                                           name: YWAPI.yuwanUserLoginNotificationName,
//                                           object: nil)
  }
//
//  deinit {
//    NotificationCenter.default.removeObserver(self)
//  }
//
//  @objc func onLogin(notification: Notification) {
//    self.showTab(tab: .home)
//  }

  func showTab(tab: Tab) {
    self.popToRootViewController(animated: true)
    var index = self.tabVC.selectedIndex
    switch tab {
    case .news:
      index = self.tabVC.viewControllers!.index(of: self.newsVC)!
      break
    case .ranking:
      index = self.tabVC.viewControllers!.index(of: self.rankingVC)!
      break
    case .clander:
      index = self.tabVC.viewControllers!.index(of: self.clanderVC)!
      break
 
    case .me:
      index = self.tabVC.viewControllers!.index(of: self.meVC)!
      break
    }
    
    self.tabVC.selectedIndex = index
  }
  
  func tabBarController(_ tabBarController: UITabBarController,
                        didSelect viewController: UIViewController) -> Void {
    tabBarController.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem
    tabBarController.navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems
    tabBarController.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem
    tabBarController.navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems
    tabBarController.navigationItem.title = viewController.navigationItem.title
    tabBarController.navigationItem.titleView = viewController.navigationItem.titleView
  }
  
  
}

