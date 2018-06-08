//
//  Source.swift
//  MyWeb
//
//  Created by 一磊 on 2018/6/1.
//  Copyright © 2018年 一磊. All rights reserved.
//

import Foundation
class Source {
    
}

//MARK: webs
extension Source {
    //web获取路径
    class private func getWebsPath() -> String? {
        //模拟器可以读写
//        if let pathWebs = Bundle.main.path(forResource: "webs", ofType: "plist") {
//            return pathWebs
//        }
        
        //真机可以读写
        let fileManager = FileManager.default
        let documentDirectory: Array = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = documentDirectory[0].appending("/webs.plist")
        let isExit = fileManager.fileExists(atPath: path)
        if !isExit {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return path
    }
    
    //web读取数据
    class func getDictionaryOfWebs() -> Dictionary<String, Any>? {
        if let path = getWebsPath() {
            let dataDict = NSDictionary(contentsOfFile:path)//swift 中参杂objective-c
            return dataDict as? Dictionary<String,Any>
        }
        
        return nil
    }
    
    //web写入数据
    class func writeDictionaryToWebs(dict : Dictionary<String, Any>) {
        if let path = getWebsPath() {
            //swift 中参杂objective-c
            NSDictionary(dictionary: dict).write(toFile: path, atomically: true)
        }
    }
    
    //将web写入plist
    class func writeWebToPlist(web:Web) {
        var sourceDict:Dictionary<String, Any> = Source.getDictionaryOfWebs()!
        if  sourceDict.isEmpty {
            sourceDict[web.group] = web.toWebDict()
        } else {
            let groups = sourceDict.keys
            if groups.contains(web.group) {
                var webDict = sourceDict[web.group]! as! Dictionary<String,String>
                webDict[web.name] = web.web
                sourceDict[web.group] = webDict
            } else {
                sourceDict[web.group] = web.toWebDict()
            }
        }
        Source.writeDictionaryToWebs(dict: sourceDict)
    }
    
    //名字是否存在
    class func hasName(web:Web) -> Bool {
        let sourceDict:Dictionary<String, Any> = Source.getDictionaryOfWebs()!
        if  sourceDict.isEmpty {
            return false
        } else {
            for (_, webs) in sourceDict {
                let names = webs as! [String : String]
                for (name, _) in names {
                    if name == web.name {
                        return true
                    }
                }
            }
        }
        return false
    }
}

