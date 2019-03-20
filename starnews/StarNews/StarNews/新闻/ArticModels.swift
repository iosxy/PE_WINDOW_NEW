//
//  ArticModels.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/6/13.
//  Copyright © 2018年 lqs. All rights reserved.
//

import Foundation
import UIKit
import HandyJSON

class commentModel: HandyJSON {
    var twoCommentCount : Int! = 0
    var id:Int? 
    var time:String?
    var comment : String?
    var userId : Int?
    var userName :String! = ""
    var contentId :Int?
    var status : String?
    var parentId : Int?
    var replyId :Int?
    var replyName : String?
    var likeCount = 0
    var commentVo:[commentModel]! = Array()
    var  userAvatar :String?
    var commentLike:Bool? = false
    required init(){}
}
