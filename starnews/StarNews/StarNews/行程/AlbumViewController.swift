//
//  AlbumViewController.swift
//  Yuwan
//
//  Created by lqs on 2017/7/18.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON

class AlbumViewController: BaseViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    
    var viewArray = Array<UIImageView>()
    var items: Array<JSON>? = nil
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupBackButton()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.scrollView {
            return
        }
        page = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        title = String(page + 1) + "/" + String(items!.count)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewArray[page]
    }
    
    
    func createScollView() -> Void {
        self.view.backgroundColor = .black
        if self.scrollView == nil {
            self.scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 60, width: kScreenWidth, height: kScreenHeight-60));
            self.view.addSubview(self.scrollView);
            
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.clipsToBounds = true
            scrollView.contentSize = CGSize(width: kScreenWidth  * CGFloat((items?.count)!), height: 0);
        }
    }
    
    func loadItems(_ items: Array<JSON>, page: Int) {
        //self.loadViewIfNeeded()
        self.items = items
        self.loadView();
        self.createScollView();
        
        self.page = page
        var lastView: UIImageView? = nil
        var lastScrollView: UIScrollView? = nil
        for item in items {
            let innerScrollView = UIScrollView()
            innerScrollView.showsVerticalScrollIndicator = false
            innerScrollView.showsHorizontalScrollIndicator = false
            innerScrollView.minimumZoomScale = 1
            innerScrollView.maximumZoomScale = 2
            innerScrollView.clipsToBounds = true
            innerScrollView.delegate = self
            innerScrollView.contentSize = CGSize(width: kScreenWidth, height: 0)
            scrollView.addSubview(innerScrollView)
            innerScrollView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
            if (lastScrollView != nil) {
                innerScrollView.frame.origin.x = (lastScrollView?.right)!;
            }
            
            //            innerScrollView.snp.makeConstraints({ (make) in
            //                make.top.equalToSuperview()
            //                make.bottom.equalToSuperview()
            //                make.height.equalToSuperview()
            //                make.width.equalToSuperview()
            //                if lastScrollView == nil {
            //                    make.left.equalToSuperview()
            //                } else {
            //                    make.left.equalTo(lastScrollView!.snp.right)
            //                }
            //                make.right.lessThanOrEqualToSuperview()
            //            })
            lastScrollView = innerScrollView
            
            let imageView = UIImageView()
            
            viewArray.append(imageView)
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFit
            innerScrollView.addSubview(imageView)
            imageView.yw_setImage(with: item["url"].url)
            imageView.snp.makeConstraints({ (make) in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
                make.edges.equalToSuperview()
            })
            
            imageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:))))
            lastView = imageView
        }
        scrollView.contentOffset = CGPoint(x: scrollView.bounds.width * CGFloat(page), y: 0)
        scrollViewDidScroll(scrollView)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "保存到手机", style: .default, handler: { (alertAction) in
            UIImageWriteToSavedPhotosAlbum((sender.view as! UIImageView).image!, self, #selector(self.imageResult(image:didFinishSavingWithError:contextInfo:)), nil)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (alertAction) in
            
        }))
        self.navigationController?.present(alert, animated: true)
        
    }
    
    @objc func imageResult(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        var msg : String? = nil;
        if error != nil {
            msg = "保存图片失败"
        } else {
            msg = "保存图片成功"
        }
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好的", style: .default){ (action) -> Void in
        })
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
