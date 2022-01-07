//
//  Server.swift
//  OCRAggregator
//
//  Created by xulihang on 2022/1/7.
//

import Foundation
import GCDWebServer
import SwiftyJSON

class Server:ObservableObject{
    private var webServer:GCDWebServer
    private var reader:Aggregator! = nil
    @Published var currentImage:UIImage = UIImage(named: "DMX1a")!
    @Published var resultsString:String = ""
    init(){
        webServer = GCDWebServer()
        webServer.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self) { request in
            return GCDWebServerDataResponse(html:"<html><body><p>Hello World</p></body></html>")
        }
        webServer.addDefaultHandler(forMethod: "POST", request: GCDWebServerDataRequest.self, asyncProcessBlock: {request,completion  in
            DispatchQueue.main.async() {
                let get = request as! GCDWebServerDataRequest
                do{
                    let json = try JSON(data: get.data)
                    let sdk = json["sdk"].rawString() ?? "MLKit"
                    if sdk != self.reader.name{
                        self.reader.switchSDK(name: sdk)
                    }
                    let imageBase64 = json["base64"]
                    print(self.reader.name)
                    let imageData = Data(base64Encoded: imageBase64.rawString() ?? "", options: .ignoreUnknownCharacters)
                    let image = UIImage(data: imageData!)!
                    self.currentImage = image.copy() as! UIImage
                    Task() {
                        do {
                            let startTime = Date.now.timeIntervalSince1970
                            let results = await self.reader.OCR(image: image)
                            let endTime = Date.now.timeIntervalSince1970
                            
                            let elapsedTime = Int((endTime - startTime)*1000)
                            let dictionary = NSMutableDictionary()
                            dictionary["results"] = results
                            dictionary["elapsedTime"] = elapsedTime
                            let json2 = JSON(dictionary)
                            self.resultsString = json2.rawString(options: []) ?? ""
                            completion(GCDWebServerDataResponse(text: self.resultsString))
                        }
                    }
                } catch{
                    print(error)
                    completion(GCDWebServerErrorResponse(text: error.localizedDescription))
                }
            }
        })
        webServer.start(withPort: 8888, bonjourName: "GCD Web Server")
    }
    
    func passReader(reader:Aggregator){
        self.reader = reader
    }
    
    func getServerURL() -> String{
        return webServer.serverURL?.absoluteString ?? ""
    }
    
}
