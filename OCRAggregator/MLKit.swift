//
//  MLKit.swift
//  OCRAggregator
//
//  Created by xulihang on 2022/1/7.
//

import Foundation
import MLKitVision
import MLKit
import MLKitTextRecognition
import MLKitTextRecognitionCommon


class MLKit:Reader{
    var textRecognizer:TextRecognizer
    init(){
        let options = TextRecognizerOptions()
        textRecognizer = TextRecognizer.textRecognizer(options:options)
    }
    
    func OCR(image:UIImage) async -> NSArray{
        let outResults = NSMutableArray()
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        do{
            let result = try await textRecognizer.process(visionImage)
            for block:TextBlock in result.blocks{
                for line:TextLine in block.lines{
                    let subDic = NSMutableDictionary()
                    subDic.setObject(line.text, forKey: "text" as NSCopying)
                    outResults.add(subDic)
                }
            }
        }catch{
            print(error)
        }
        return outResults
    }
    
    
}