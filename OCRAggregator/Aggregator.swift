//
//  Aggregator.swift
//  OCRAggregator
//
//  Created by xulihang on 2022/1/7.
//

import Foundation
import UIKit

class Aggregator:ObservableObject {
    private var reader:Reader? = nil
    public var name:String = ""
    public static let mlKit:String = "MLKit"
    init(name:String) {
        switchSDK(name: name)
    }
    
    func switchSDK(name:String){
        if name == Aggregator.mlKit {
            reader = MLKit()
        }
        self.name = name
    }
    
    
    func OCR(image:UIImage) async ->NSArray{
        return await reader!.OCR(image:image)
    }
}
