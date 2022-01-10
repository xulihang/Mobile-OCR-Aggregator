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
            var index:Int = 0
            for block:TextBlock in result.blocks{
                for line:TextLine in block.lines {
                    let subDic = NSMutableDictionary()
                    subDic.setObject(line.text, forKey: "text" as NSCopying)
                    subDic.setObject(index, forKey: "block" as NSCopying)
                    subDic.setObject(line.cornerPoints[0].cgPointValue.x, forKey: "x1" as NSCopying)
                    subDic.setObject(line.cornerPoints[0].cgPointValue.y, forKey: "y1" as NSCopying)
                    subDic.setObject(line.cornerPoints[1].cgPointValue.x, forKey: "x2" as NSCopying)
                    subDic.setObject(line.cornerPoints[1].cgPointValue.y, forKey: "y2" as NSCopying)
                    subDic.setObject(line.cornerPoints[2].cgPointValue.x, forKey: "x3" as NSCopying)
                    subDic.setObject(line.cornerPoints[2].cgPointValue.y, forKey: "y3" as NSCopying)
                    subDic.setObject(line.cornerPoints[3].cgPointValue.x, forKey: "x4" as NSCopying)
                    subDic.setObject(line.cornerPoints[3].cgPointValue.y, forKey: "y4" as NSCopying)
                    outResults.add(subDic)
                }
                index = index + 1
            }
        }catch{
            print(error)
        }
        return outResults
    }
    
    
}
