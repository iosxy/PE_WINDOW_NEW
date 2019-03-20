//
//  BaseBean.swift
//  Yuwan
//
//  Created by PengFei on 11/22/17.
//  Copyright © 2017 lqs. All rights reserved.
//

import Foundation
import EVReflection

public class BaseBean: EVObject {
  override public func propertyMapping() -> [(keyInObject: String?, keyInResource: String?)] {
    return [(keyInObject: "ywDesc", keyInResource: "description"),
            (keyInObject: "ywOperator", keyInResource: "operator")]
  }
  
  override public func setValue(_ value: Any!, forUndefinedKey key: String) {
    if let kvc = self as? EVGenericsKVC {
      kvc.setGenericValue(value as AnyObject!, forUndefinedKey: key)
    }
  }
}
