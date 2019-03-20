//
//  YWRefreshGifHeader.swift
//  Yuwan
//
//  Created by PengFei on 1/28/18.
//  Copyright © 2018 lqs. All rights reserved.
//

import Foundation
import MJRefresh

class YWRefreshHeader: MJRefreshGifHeader {
  private static let images = YWRefreshHeader.gifImages(name: "pull_loading")

  init() {
    super.init(frame: CGRect.zero)

    self.setImages(YWRefreshHeader.images, for: .idle)
    self.setImages(YWRefreshHeader.images, for: .pulling)
    self.setImages(YWRefreshHeader.images, for: .refreshing)
    self.lastUpdatedTimeLabel.isHidden = true
    self.stateLabel.isHidden = true
  }
  
  convenience init(refreshingBlock: @escaping () -> Void) {
    self.init()
    self.refreshingBlock = refreshingBlock
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private static func gifImages(name: String) -> [UIImage] {
    let subfix = UIScreen.main.scale > 2 ? "@3x" : "@2x"
    let url = Bundle.main.url(forResource: name + subfix, withExtension: "gif")
    do {
      let data = try Data(contentsOf: url!)
      return YWRefreshHeader.gifImages(data: data)
    } catch {
      return []
    }
  }

  private static func gifImages(data: Data) -> [UIImage] {
    guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
      return []
    }
    var images: [UIImage] = []
    let count = CGImageSourceGetCount(source)
    for i in 0..<count {
      let image = CGImageSourceCreateImageAtIndex(source, i, nil)
      images.append(UIImage(cgImage: image!, scale: UIScreen.main.scale, orientation: .up))
    }
    return images
  }
}
