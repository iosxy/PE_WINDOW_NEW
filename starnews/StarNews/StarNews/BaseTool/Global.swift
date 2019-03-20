//
//  Global.swift
//  Yuwan
//
//  Created by PengFei on 11/7/17.
//  Copyright © 2017 lqs. All rights reserved.
//

import Foundation

public func RGBCOLOR(_ r: Float, _ g: Float, _ b: Float) -> UIColor {
  return RGBACOLOR(r, g, b, 1)
}

public func RGBCOLOR(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
  return RGBACOLOR(Float(r), Float(g), Float(b), 1)
}

public func RGBACOLOR(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> UIColor {
  return UIColor(red: CGFloat(r / 255.0),
                 green: CGFloat(g / 255.0),
                 blue: CGFloat(b / 255.0),
                 alpha: CGFloat(a))
}

public func RGBACOLOR(_ r: Int, _ g: Int, _ b: Int, _ a: Float) -> UIColor {
  return RGBACOLOR(Float(r), Float(g), Float(b), a)
}

public func HEXCOLOR(_ value: Int)  -> UIColor {
  return RGBCOLOR(((value >> 16) & 0xFF), ((value >> 8) & 0xFF), (value & 0xFF))
}

extension UIDevice {
  static var isIphoneX: Bool {
    var modelIdentifier = ""
    if isSimulator {
      modelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
    } else {
      var size = 0
      sysctlbyname("hw.machine", nil, &size, nil, 0)
      var machine = [CChar](repeating: 0, count: size)
      sysctlbyname("hw.machine", &machine, &size, nil, 0)
      modelIdentifier = String(cString: machine)
    }
    
    return modelIdentifier == "iPhone10,3" || modelIdentifier == "iPhone10,6"
  }
  
  static var isSimulator: Bool {
    return TARGET_OS_SIMULATOR != 0
  }
}

let yw_scale = UIScreen.main.bounds.width / 375.0
let yw_scale_height = UIScreen.main.bounds.height / 667.0
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height
let kNavigationBarHeight = CGFloat(44)
let kTopHeight = kStatusBarHeight + kNavigationBarHeight

//let kYouzanUrl = "https://h5.youzan.com/v2/showcase/homepage?alias=E8FV5ovV14"
let kYouzanUrl = "https://h5.youzan.com/wscshop/home/E8FV5ovV14?alias=E8FV5ovV14"

//let kIsIphoneX = UIScreen.instancesRespond(to: #selector(getter: RunLoop.currentMode)) ? __CGSizeEqualToSize(CGSizeFromString("{1125,2436}"), (UIScreen.main.currentMode?.size)!) : false;
func kIsIphonexSeries() -> Bool{
    var iPhoneXSeries : Bool = false
    if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
        return iPhoneXSeries
    }
    if #available(iOS 11.0, *){
        if UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > CGFloat.init(0.0) {
            iPhoneXSeries = true
        }
    }
    return iPhoneXSeries
}
let kPlaceHoderImage = UIImage.init(named: "image_placeholder")
let kScreenWidth = UIScreen.main.bounds.size.width;
let kScreenHeight = UIScreen.main.bounds.size.height;
let isIphonex:Bool! =  (UIScreen.main.bounds.size.width >= 375) &&  (UIScreen.main.bounds.size.height >= 812) ? true : false
let bottomSafetyHeight = kIsIphonexSeries() ? CGFloat(34) : CGFloat(0)

