//
//  ZYClientManager.swift
//  Serve
//
//  Created by 王志盼 on 18/05/2017.
//  Copyright © 2017 王志盼. All rights reserved.
//

import Cocoa

class ZYClientManager: NSObject {
    fileprivate var client: TCPClient
    
    fileprivate var isClientConnecting: Bool = false
    
    
    init(client: TCPClient) {
        self.client = client
        super.init()
    }
    
}

extension ZYClientManager {
    
    func readMessage() {
        
        isClientConnecting = true
        while isClientConnecting {
            if let msg = client.read(4) {    //读取多少字节长度。UInt8 表示是char类型，一个char，8位
                let dataMsg = Data(bytes: msg, count: 4)
                let msgStr = String(data: dataMsg, encoding: .utf8)
                print(msgStr ?? 0)
            }
            else {
                isClientConnecting = false
                print("客户端断开连接")
            }
        }
        
    }
}
