//
//  WebModel.swift
//  MyWeb
//
//  Created by 一磊 on 2018/6/5.
//  Copyright © 2018年 一磊. All rights reserved.
//

import Foundation

class Web  {
    var group: String
    var name: String
    var web: String
    init(group: String, name:String, web:String) {
        self.group = group
        self.name = name
        self.web = web
    }
    
    func toWebDict() -> Dictionary<String, String> {
        return [self.name:self.web]
    }
}
