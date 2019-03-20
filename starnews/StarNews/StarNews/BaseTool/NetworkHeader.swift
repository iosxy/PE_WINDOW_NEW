//
//  NetworkHeader.swift
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/5/28.
//  Copyright © 2018年 lqs. All rights reserved.
//

import Foundation

let YWNET_onboardAds = "/group/onboardAds";
let YWNET_home_guides = "/config/getKey?key=home.guides"
let YWNETNEW_starsByContentId = "starsByContentId"
let YWNET_star = "/star/star"
let YWNETNEW_getStar = "getStar"
let YWNET_products = "/product/products/"
let YWNET_content = "/content/content"
let YWNET_tasks = "/task/tasks"
let YWNET_content_type = "/content/contents?type="
let YWNET_homeTimeline = "/subscribe/homeTimeline"
let YWNET_use_live = "/config/getKey?key=use.live"
let YWNET_BANNER = "/group/randomGroup?type=BANNER"
let YWNET_home_icons2 = "/config/getKey?key=home.icons2"
let YWNET_CALENDAR = "/group/randomGroup?type=CALENDAR"
let YWNET_RECOMMEND = "/group/entities?type=RECOMMEND"

let YWNET_MOVIE = "/content/contents?type=MOVIE"
let YWNET_TV = "/content/contents?type=TV"
let YWNET_PERIPHERY = "/content/contents?type=PERIPHERY"
let YWNET_MUSIC = "/content/contents?type=MUSIC"
let YWNET_BOOK = "/content/contents?type=BOOK"

let YWNET_NEWS = "/content/contents?type=NEWS"
let YWNET_mySubscribes = "/subscribe/mySubscribes"
let YWNET_GUESS = "/group/entities?type=GUESS"
let YWNET_feed = "/homepage/feed"
let YWNET_feedAnchor = "/homepage/feedAnchor"
let YWNET_TOPIC = "/content/contents?type=TOPIC"
let YWNET_CALENDAR_content = "/content/contents?type=CALENDAR"
let YWNET_TOWN = "/content/contents?type=TOWN"
let YWNET_stars = "/star/stars"
let YWNET_searchStarByName = "/star/searchStarByName"

let YWNET_VIDEO = "/content/contents?type=VIDEO"
let YWNET_IMAGE = "/content/contents?type=IMAGE"
let YWNET_CALENDAR_CONTENT = "/content/contents?type=CALENDAR"
let YWNET_shareToken = "/shareToken"
let YWNET_share = "/share"
let YWNET_profile = "/user/profile"

let YWNET_orders = "/order/orders"
let YWNET_comments = "/comment/comments"
let YWNET_getStarByName = "/star/getStarByName"


//post
let YWNETNEW_getConfig = "getConfig"
let YWNET_youzan_initToken = "/youzan/initToken"
let YWNETNEW_token = "token"
let YWNET_login = "/auth/login"
let YWNET_youzan_login = "/youzan/login"
let YWNET_updateAvatar = "/user/updateAvatar"
let YWNET_updateNick = "/user/updateNick"
let YWNET_user_login = "/user/login"
let YWNET_verifyCode = "/user/verifyCode"
let YWNETNEW_forgetPassword = "forgetPassword"
let YWNET_register = "/user/register"
let YWNET_subscribe = "/subscribe/subscribe"
let YWNET_exchange = "/product/exchange"
let YWNET_updateAddress = "/user/updateAddress"
let YWNET_addComment = "/comment/addComment"
let YWNETNEW_upload = "upload"
let YWNETNEW_isFavorite = "isFavorite"
let YWNETNEW_myFavorites = "myFavorites"
//post 新接口 要使用YWAPI_NEW 来调用  // let YWNETNEW_ = ""
let YWNETNEW_addContentLikeCount = "addContentLikeCount"
let YWNETNEW_addLikeCount = "addLikeCount"

let YWNETNEW_login = "login"
let YWNETNEW_thirdPartyLogin = "thirdPartyLogin"
let YWNETNEW_newLogin = "newLogin"
let YWNETNEW_queryComment = "queryComment"
let YWNETNEW_queryOneComment = "queryOneComment"
let YWNETNEW_queryTwoComment = "queryTwoComment" //查询二级评论

let YWNETNEW_inserComment = "insertComment"
let YWNETNEW_listCommenByParentId = "listCommenByParentId" //刷新单挑评论
let YWNETNEW_queryMsg = "queryMsg"
let YWNETNEW_countMsg = "countMsg"

let YWNETNEW_readUserAllMsg = "readUserAllMsg" //一键已读
let YWNETNEW_listTag = "listTag"
let YWNETNEW_favorite = "favorite" //收藏商品
let YWNETNEW_unFavorite = "unFavorite" //取消收藏商品

let YWNETNEW_updateMsgStatues = "updateMsgStatues"
let YWNETNEW_findCardById = "findCardById" //根据礼物ID查礼物详情

let YWNETNEW_receivePrize = "receivePrize"
let YWNETNEW_getPrizeHistoryActivity = "getPrizeHistoryActivity" //查询抽奖活动
let YWNETNEW_getNewHistoryActivity = "getNewHistoryActivity" //查询文章活动
let YWNETNEW_listNewHistoryActivity = "listNewHistoryActivity" //分页查询往期活动
let YWNETNEW_listPrizeHistoryActivity = "listPrizeHistoryActivity" //分页查询往期抽奖

let YWNETNEW_getContent = "getContent"
let YWNETNEW_getContentShareStatus = "getContentShareStatus"
let YWNETNEW_share = "share"
let YWNETNEW_listProductType = "listProductType"
let YWNETNEW_listProduct = "listProduct"
let YWNETNEW_getProduct = "getProduct" //查询商品详情
let YWNETNEW_exchange = "exchange"
let YWNETNEW_getChargeOrder = "getChargeOrder" //查询商品订单状    态
let YWNETNEW_listProductOrder = "listProductOrder" //查询订单列表
let YWNETNEW_getProductOrder = "getProductOrder" //查询订单详情
let YWNETNEW_confirm = "confirm" //确认收货
let YWNETNEW_deleteProductOrder = "deleteProductOrder" //删除订单
let YWNETNEW_payOrder = "payOrder" //支付运费
let YWNETNEW_getContentStarVo = "getContentStarVo" //支付运费
let YWNETNEW_getSignStatus = "getSignStatus"       //查询签到状态
let YWNETNEW_getSign = "getSign"
let YWNETNEW_userSign = "userSign"
let YWNETNEW_userSignOrder = "userSignOrder"
let YWNETNEW_signExchange = "signExchange"   //签到物品领取
let YWNETNEW_getOrderById = "getOrderById"   //签到物品领取
let YWNETNEW_everybodyChange = "everybodyChange"   //大家都在换
let YWNETNEW_getImg = "getImg"
let YWNETNEW_generateVerifyCode = "generateVerifyCode"
let YWNETNEW_register = "register"
let YWNETNEW_subscribe = "subscribe"
let YWNETNEW_getShareInfo = "getShareInfo"
let YWNETNEW_isSubscribe = "isSubscribe" //批量取关
let YWNETNEW_getContentShareStatusNews = "getContentShareStatusNews"
let YWNETNEW_newShare = "newShare"
let YWNETNEW_getMyUserPocketDetails = "getMyUserPocketDetails"
let YWNETNEW_getInviteInfo = "getInviteInfo"
let YWNETNEW_querryStatus = "querryStatus"
let YWNETNEW_getRankingList = "getNewRankingList" // 查询排行榜
let YWNETNEW_indexRankingList = "indexNewRankingList" //首页榜单
let YWNETNEW_getCommentMsg = "getCommentMsg" 
let YWNETNEW_listContentByType = "listContentByType"
let YWNETNEW_addContentNumber = "addContentNumber" //新增点播量
let YWNETNEW_listUserSubscribe = "listUserSubscribe" //我的关注列表

let YWNETNEW_getUserPocket = "getUserPocket" //查询用户余额
let YWNETNEW_getTask = "getTask" //查询任务详情

let YWNETNEW_hotVideo = "hotVideo" //首页热点视频
let YWNETNEW_getStarLikeCount = "getStarLikeCount" //获取明星粉丝数
let YWNETNEW_updateAddress = "updateAddress" //兑换保存用户地址
let YWNETNEW_updateUserConfig = "updateUserConfig" //兑换保存用户地址

let YWNETNEW_getGoodsSendDay = "getGoodsSendDay"

let YWNETNEW_getContentByType = "getContentByType" //根据类型查询明星行程接口
let YWNETNEW_getContentByStarId = "getContentByStarId" //根据ID 查询明星作品集

let YWNETNEW_starLike = "starLike" //娱丸星球
let YWNETNEW_listStar = "listStar" //娱丸星球列表
let YWNETNEW_listStarLetter = "listStarLetter" //娱丸星球索引


let YWNETNEW_profile = "profile" //查询用户信息
let YWNETNEW_findShopBannerList = "findShopBannerList" //主页Banner
let YWNETNEW_findBannerList = "findBannerList" //主页Banner
let YWNETNEW_onboardAds = "onboardAds" //主页Banner
let YWNETNEW_listCalendar = "listCalendar" //捕娱星程
let YWNETNEW_addRankingNumber = "addRankingNumber" //榜单投票
let YWNETNEW_updateUserInfo = "updateUserInfo" //榜单投票
let YWNETNEW_randomGroup = "randomGroup"
let YWNETNEW_getCommentAndLikeNumber = "getCommentAndLikeNumber"
let YWNETNEW_listChoiceNews = "listChoiceNews" //星闻精选


let YWNETNEW_listEveryDayStarNews = "listEveryDayStarNews" //每日星讯
let YWNETNEW_saveUserReadRecord = "saveUserReadRecord" //保存用户阅读记录
let YWNETNEW_getUserVoteNumber = "getUserVoteNumber" //查询投票次数


//签名照相关
let YWNETNEW_signaturePhotoList = "signaturePhotoList"
let YWNETNEW_listFragmentProduct = "listFragmentProduct" //官方商城碎片
let YWNETNEW_userFragmentProductList = "userFragmentProductList" //个人碎片
let YWNETNEW_buyCard = "buyCard" //购买卡片
let YWNETNEW_userSignaturePhotoInfo = "userSignaturePhotoInfo"
let YWNETNEW_recommendSignaturePhotoList = "recommendSignaturePhotoList"

let YWNETNEW_getSignaturePhotoById = "getSignaturePhotoById"
let YWNETNEW_synthesisSignaturePhoto = "synthesisSignaturePhoto"
let YWNETNEW_searchListFragmentProduct = "searchListFragmentProduct"

let YWNETNEW_userSignaturePhotoList = "userSignaturePhotoList" //我的签名照
let YWNETNEW_exchangeSignaturePhoto = "exchangeSignaturePhoto" //我的签名照
let YWNETNEW_getOrdersState = "getOrdersState" //签名照的支付状态
let YWNETNEW_getSignaturePhotoSendDays = "getSignaturePhotoSendDays" //签名照的发货日期



//MARK: 通知名定义

let YWNEW_NOTIFATION_applicationWillEnterForeground = "applicationWillEnterForeground"
let YWNEW_NOTIFATION_OfficalMailDidUpdate = "OfficalMailDidUpdate"

let YWNEW_NOTIFATION_applicationWillEnterBackForeground = "applicationWillEnterBackForeground"

let YWNEW_NOTIFATION_signSuccess = "YWNEW_NOTIFATION_signSuccess"

let YWNEW_NOTIFATION_YUWAN_JUMP = "YWNEW_NOTIFATION_YUWAN_JUMP"
//tyoe
let YW_TYPE_CONTENT = "CONTENT"
let YW_TYPE_VIDEO = "VIDEO"
let YW_TYPE_MOVIE = "MOVIE"
let YW_TYPE_TV = "TV"
let YW_TYPE_CALENDAR = "CALENDAR"
let YW_TYPE_ARTICLE = "ARTICLE"
let YW_TYPE_NEWS = "NEWS"
let YW_TYPE_STARNEWS = "STARNEWS"

let YW_TYPE_TOWN = "TOWN"
let YW_TYPE_STAR = "STAR"
let YW_TYPE_OUT = "OUT"
let YW_TYPE_IN = "IN"

let YW_TYPE_IMAGE = "IMAGE"
let YW_TYPE_BOOK = "BOOK"
let YW_TYPE_PERIPHERY = "PERIPHERY"
let YW_TYPE_LIVE = "LIVE"
let YW_TYPE_UNKNOWN = "UNKNOWN"
let YW_TYPE_ARTICLE_BOOK = "ARTICLE,BOOK"
let YW_TYPE_MUSIC = "MUSIC"
let YW_ERROR_ALERT = "异常,请重试一下吧"


//域名定义
let YW_URL_IMAGE = "http://ywimage.hryouxi.com/"
//图片地址域名
let YW_API_PRODUCTION = "http://ywapp.hryouxi.com/"
//.生产环境域名
let YW_URL_SHARE = "http://ywshare.hryouxi.com/YvWanH5"
//let YW_URL_SHARE = "http://ywshare.hryouxi.com"
//http://www.yuwantop.com/detail/product.html?id=



let IS_IPHONE4 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false)

let IS_IPHONE5 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)

let IS_IPHONE6 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)

let IS_IPHONE6_PLUS =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)


let IS_IPHONE6_PLUS_SCALE =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2001).equalTo((UIScreen.main.currentMode?.size)!) : false)

let IS_IPHONE_X =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)




