//
//  ZYClientManager.swift
//  Serve
//
//  Created by 王志盼 on 18/05/2017.
//  Copyright © 2017 王志盼. All rights reserved.
//

import Cocoa

class ZYClientManager: NSObject {
    var client: TCPClient
    
    init(client: TCPClient) {
        self.client = client
        super.init()
    }
    
}
