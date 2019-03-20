import UIKit
import Alamofire
extension UIImageView {
    func yw_setImage(with url: URL?) {
        if url == nil {return}
        var urlString = url?.absoluteString
        if !(urlString?.contains("http"))!{
            urlString = YW_URL_IMAGE + urlString!
        }
        
        self.sd_setImage(with: URL.init(string: self.urlEncoded(urlStr: urlString!)), placeholderImage: #imageLiteral(resourceName: "image_placeholder"))
    } 
    func yw_setImageWithUrlStr(with url: String?) {
        if url == nil {return}
        var urlString = url
        if !(urlString?.contains("http"))!{
            urlString = YW_URL_IMAGE + urlString!
        }
        
        self.sd_setImage(with: URL.init(string: self.urlEncoded(urlStr: urlString!)), placeholderImage: #imageLiteral(resourceName: "image_placeholder"))
    }
    //将原始的url编码为合法的url
    func urlEncoded(urlStr : String) -> String {
        let encodeUrlString = urlStr.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        
        return encodeUrlString ?? ""
    }
    func yw_downLoadImage(url : String ,done: @escaping (UIImage?) -> Void) {
        
        if url == nil {return}
        var urlString = url
        if !(urlString.contains("http")){
            urlString = YW_URL_IMAGE + urlString
        }
        let imageUrl = URL.init(string: self.urlEncoded(urlStr: urlString))
    
        
        SDWebImageDownloader.shared()?.downloadImage(with: imageUrl, options: SDWebImageDownloaderOptions(rawValue: 0), progress: { (rec, pro) in
            
        }, completed: { (image, data, error, status) in
            OperationQueue.main.addOperation {
                done(image)
            }
            
            
        })
    }
    
    func yw_setImageWithUrlStr(with url: String? , w : String , h : String) {
        if url == nil || url == "" {return}
     
        if Int(w) == nil || Int(h) == nil {
            return
        }
        var newW = ""
        var newH = ""
        if isIphonex || kScreenWidth == 414 {
            
            newW = String ( Int(w)! * 3 )
            newH = String ( Int(h)! * 3 )
            
        }else {
            newW = String ( Int(w)! * 2 )
            newH = String ( Int(h)! * 2 )
        }
        
        var urlString = url! + "?x-oss-process=image/resize,m_mfit,h_" + newH + ",w_" + newW
        if !(urlString.contains("http")){
            urlString = YW_URL_IMAGE + urlString
        }
        
        
        self.sd_setImage(with: URL.init(string: self.urlEncoded(urlStr: urlString)), placeholderImage: #imageLiteral(resourceName: "image_placeholder"))

    }
    
}

extension UIButton {
    func yw_setImage(with url: URL?, for state: UIControl.State) {
        self.sd_setImage(with: url, for: state, placeholderImage: #imageLiteral(resourceName: "image_placeholder"))
    }
}

extension UIViewController {
    func inNavigationController() -> UINavigationController {
        return RootNavigationController(rootViewController: self)
    }
}

