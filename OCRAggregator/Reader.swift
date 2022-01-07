//
//  Reader.swift
//  OCRAggregator
//
//  Created by xulihang on 2022/1/7.
//

import Foundation
import UIKit

protocol Reader {
   func OCR (image:UIImage) async ->NSArray
}
