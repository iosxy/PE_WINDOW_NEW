//
//  AddressBean.swift
//  Yuwan
//
//  Created by PengFei on 11/23/17.
//  Copyright © 2017 lqs. All rights reserved.
//

import Foundation
import HandyJSON
class AddressBean: BaseBean ,HandyJSON{
  var name: String!
  var telephone: String!
  var province: String!
  var city: String!
  var county: String!
  var detail: String!
  /*
   private String name;
   private String telephone;
   private String province;
   private String city;
   private String county;
   private String detail;
 */
}
class IDInfoModel: BaseBean ,HandyJSON{
    var userName: String!
    var idCard: String!
    var telephone: String!
}
class regionBean: BaseBean ,HandyJSON{
    var province: String?
    var city: String?
    var county: String?

}

