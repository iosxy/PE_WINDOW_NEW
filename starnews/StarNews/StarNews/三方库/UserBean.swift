//
//  UserBean.swift
//  Yuwan
//
//  Created by PengFei on 11/23/17.
//  Copyright © 2017 lqs. All rights reserved.
//

import Foundation


class UserBean: BaseBean {
  var id: NSNumber!
  var name: String!
  var address: AddressBean?
  var telephone: String!
  var avatar: String?
  var nick: String!
  var gender : NSNumber!
  var birthDate : NSNumber!
  var signature : String!
  var region : regionBean? = regionBean()

    
    func covertToJsonString() -> String{
        
        let userDic = ["id":id , "name" : name  , "telephone" : telephone , "avatar" : avatar , "nick" : nick, "gender" : gender , "birthDate" : birthDate , "signature" : signature , "region" : ["province" : region?.province , "county" : region?.county , "city" : region?.city]] as [String : Any]
        
        return self.dicValueString(userDic)!
        
    }
    func dicValueString(_ dic:[String : Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
}
