//
//  UIView+Addition.swift
//  Yuwan
//
//  Created by PengFei on 11/7/17.
//  Copyright © 2017 lqs. All rights reserved.
//

import Foundation

import UIKit
import SnapKit
//MARK: UIView
public extension UIView {
  
  public var width: CGFloat {
    get { return self.frame.size.width }
    set { self.frame.size.width = newValue }
  }
  
  public var height: CGFloat {
    get { return self.frame.size.height }
    set { self.frame.size.height = newValue }
  }
  
  public var top: CGFloat {
    get { return self.frame.origin.y }
    set { self.frame.origin.y = newValue }
  }
  public var right: CGFloat {
    get { return self.frame.origin.x + self.width }
    set { self.frame.origin.x = newValue - self.width }
  }
  public var bottom: CGFloat {
    get { return self.frame.origin.y + self.height }
    set { self.frame.origin.y = newValue - self.height }
  }
  public var left: CGFloat {
    get { return self.frame.origin.x }
    set { self.frame.origin.x = newValue }
  }
  
  public var centerX: CGFloat{
    get { return self.center.x }
    set { self.center = CGPoint(x: newValue,y: self.centerY) }
  }
  public var centerY: CGFloat {
    get { return self.center.y }
    set { self.center = CGPoint(x: self.centerX,y: newValue) }
  }
  
  public var origin: CGPoint {
    set { self.frame.origin = newValue }
    get { return self.frame.origin }
  }
  public var size: CGSize {
    set { self.frame.size = newValue }
    get { return self.frame.size }
  }
}

extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self
    while let responder = parentResponder {
      parentResponder = responder.next
      if let viewController = parentResponder as? UIViewController {
        return viewController
      }
    }
    return nil
  }
    public func clipView(corner:CGFloat,lineColor:UIColor,lineWidth:CGFloat) -> Void{
        
        self.layer.cornerRadius = corner
        self.layer.borderColor = lineColor.cgColor
        self.clipsToBounds = true
        self.layer.borderWidth = lineWidth
        
    }
    public func clip(corner:CGFloat)
    {
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
    }

    public func clip(corner:CGFloat,lineWidth:CGFloat,lineColor:UIColor)
    {
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
        self.layer.borderWidth = lineWidth
        self.layer.borderColor = lineColor.cgColor
    }

    
    
    /// 根据方向切圆角
    ///
    /// - Parameters:
    ///   - corner: 方向
    ///   - size: 圆角大小
    public func clipViewCornerWithDirection(corner:UIRectCorner ,size:CGSize)
    {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.cgPath;
        self.layer.mask = maskLayer;
    }
    

}

//MARK: UITableView,UITableViewCell,UICollectionView,UICollectionViewCell
public extension UITableView{
  public func registerClass(cellType:UITableViewCell.Type){
    register(cellType, forCellReuseIdentifier: cellType.defaultReuseIdentifier)
  }
  
  public func dequeueReusableCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier , for: indexPath as IndexPath) as? T else {
      fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier). Ensure you have registered the cell." )
    }
    
    return cell
  }
}

public extension UITableViewCell {
  public static var defaultReuseIdentifier: String {
    return String(describing: self)
  }
}

public extension UICollectionView {
  public func registerClass(cellType:UICollectionViewCell.Type) {
    register(cellType, forCellWithReuseIdentifier: cellType.defaultReuseIdentifier)
  }
  
  public func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath) -> T {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
      fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier).  Ensure you have registered the cell" )
    }
    
    return cell
  }
}

public extension UICollectionViewCell {
  public static var defaultReuseIdentifier:String{
    return String(describing: self)
  }
}

public extension UIViewController {
  public func showTitleBar() {
    let maskView = UIImageView(image: UIImage(named: "nav_backgrd"))
    maskView.contentMode = UIView.ContentMode.scaleToFill
    self.view.addSubview(maskView)
    maskView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalTo(kTopHeight)
    }
    maskView.isUserInteractionEnabled = true
    self.view.bringSubviewToFront(maskView)
    maskView.tag = 999
  }

    
}

extension UILabel {
  func yw_textColor(value: Int) {
    self.textColor = HEXCOLOR(value)
  }
  
    func yw_eqOtherLabel(label : UILabel) {
        self.textColor = label.textColor
        self.font = label.font
    }
    func yw_text(text: String! , textColor : Int , textFont : CGFloat) {
        yw_font(size: textFont)
        yw_textColor(value: textColor)
        self.text = text
    }
  func yw_font(size: CGFloat) {
    self.font = UIFont.systemFont(ofSize: size)
  }
    
//    func getAttributeStringWithString(_ string: String, color : UIColor, range : NSRange) -> NSMutableAttributedString {
//        
//        if range.length > string.count {
//            return NSMutableAttributedString()
//        }
//        let attributeText = NSMutableAttributedString.init(string: string)
//        attributeText.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: color, range: range)
//        return attributeText
//    }
//    
     func getAttributeStringWithString(_ string: String,lineSpace:CGFloat
        ) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStye = NSMutableParagraphStyle()
        let str = string as NSString
        //调整行间距
        paragraphStye.lineSpacing = lineSpace
        let rang = NSMakeRange(0, str.length)
        attributedString .addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value: paragraphStye, range: rang)
       
        return attributedString
        
    }
}


extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in:UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: image!.cgImage!)
  }
    
    func scaledToSize(newSize:CGSize,withScale:Bool) -> UIImage {
        var scale:CGFloat = 1
        if withScale {
            scale = UIScreen.main.scale
        }
        let mynewSize = CGSize(width: newSize.width * scale, height: newSize.height * scale)
        UIGraphicsBeginImageContextWithOptions(mynewSize, false, 0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: mynewSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
}
extension UIButton {
    
    func setButtonInfo(_ title : String? = nil , _ font : CGFloat? = nil , _ titleColor : UIColor?  = nil , _ state : UIControl.State ) -> Void {
        
        if title != nil {
            self.setTitle(title, for: state)
        }
        if font != nil {
            self.titleLabel?.yw_font(size: font!)
        }
        if titleColor != nil {
            self.setTitleColor(titleColor, for: state)
        }
    }
}

//  import FTPopOverMenu_Swift
//  import MZFormSheetPresentationController
//  @objc func buttonTap(sender: UIButton) {
//    let navigationController = self.formSheetControllerWithNavigationController()
//    let formSheetController = MZFormSheetPresentationViewController(contentViewController: navigationController)
//    formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
//    // formSheetController.presentationController?.shouldApplyBackgroundBlurEffect = true
//    formSheetController.presentationController?.blurEffectStyle = .dark
//    formSheetController.presentationController?.shouldUseMotionEffect = true
//    formSheetController.presentationController?.contentViewSize = UILayoutFittingExpandedSize
//    formSheetController.contentViewControllerTransitionStyle = .slideFromBottom
//    
////    let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
//    
//    formSheetController.willPresentContentViewControllerHandler = { vc in
//      let navigationController = vc as! UINavigationController
//      let presentedViewController = navigationController.viewControllers.first as! PresentedTableViewController
//      presentedViewController.view?.layoutIfNeeded()
//    }
//    
//    self.present(formSheetController, animated: true, completion: nil)
//    
//    
//    
////    FTPopOverMenu.showForSender(
////      sender: sender,
////      with: ["Share", "Share", "Share", "Share"],
////      menuImageArray:["photo_verybig", "photo_verybig", "photo_verybig", "photo_verybig"],
////      done: { index in
////    }, cancel: {
////
////    })
//  }

