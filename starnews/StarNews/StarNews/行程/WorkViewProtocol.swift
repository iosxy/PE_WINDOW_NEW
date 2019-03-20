//
//  WorkViewProtocol.swift
//  Yuwan
//
//  Created by lqs on 2017/7/5.
//  Copyright © 2017年 lqs. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol WorkViewProtocol {

  func loadContent(_ item: JSON, workType: WorkType, _ starId: Int64)
}
