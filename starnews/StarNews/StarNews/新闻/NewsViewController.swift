//
//  NewsViewController.swift
//  StarNews
//
//  Created by 欢瑞世纪 on 2019/3/19.
//

import UIKit
import PromiseKit
import SnapKit
import SVProgressHUD
import SwiftyJSON
import JLRoutes
class NewsViewController: BaseViewController , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout , BaseCollectionViewDelegate {
 
    

    var collectionView : YWBaseCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showTitleBar()
        title = "每日新闻"
        self.tabBarItem.title = "新闻"
        let layout = UICollectionViewFlowLayout()
        collectionView = YWBaseCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(FeedItemNormalCell.self,
                                forCellWithReuseIdentifier: String("FeedItemNormalCell"))
        collectionView.register(FeedItemBigCell.self,
                                forCellWithReuseIdentifier: String("FeedItemBigCell"))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showLoadingView()
        collectionView.loadDataDelegate = self
        collectionView.triggerRefresh()
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.right.left.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kTopHeight)
        }
    }
    
    func loadCollectionViewData(isLoadMore: Bool, pageNo: Int) -> Promise<Void> {
        return Promise {[weak self] fulfill , reject in
            
            YWAPI_NEW.post(YWNETNEW_listEveryDayStarNews, ["pageNo":1,"pageSize":20 , "userId" : ""]).then{[weak self]respone -> Void in
                
                if pageNo == 1 {
                    self?.collectionView.dataSourceArr.removeAll()
                }
                for item in respone["starNewsList"]["list"].arrayValue {
                   self?.collectionView.dataSourceArr.append(item)
                }
                self?.collectionView.judgeLoadMoreStatus(respone["rankingList"]["list"].count)
                fulfill(Void())
                }.catch(execute: { (error) in
                    reject(error)
                })
            
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.dataSourceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = self.collectionView.dataSourceArr[indexPath.row] as! JSON
        
        if item["cardType"].stringValue == "BIG" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String("FeedItemBigCell"), for: indexPath) as! FeedItemBigCell
            cell.setModel(model: self.collectionView.dataSourceArr[indexPath.row] as! JSON)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String("FeedItemNormalCell"), for: indexPath) as! FeedItemNormalCell
            cell.setModel(model: self.collectionView.dataSourceArr[indexPath.row] as! JSON)
            return cell
        }
        
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = self.collectionView.dataSourceArr[indexPath.row] as! JSON
        if item["cardType"].stringValue == "BIG" {
            return CGSize(width: collectionView.width - 24, height: 250)
        } else {
            return CGSize(width: collectionView.width - 24, height: 115)
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let item = self.collectionView.dataSourceArr[indexPath.row] as! JSON
        let urlStr = item["url"].stringValue
        let array = urlStr.components(separatedBy: "/")
     //   UIApplication.shared.openURL(item["url"].url!)
      
        let vc = YWArticleDetailViewController()
        vc.shareContentID = array.last
        Utils.getNavigationController().pushViewController(vc, animated: true)
    }
}
