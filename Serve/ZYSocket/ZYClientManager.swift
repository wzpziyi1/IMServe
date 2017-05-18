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
            if let headMsg = client.read(4) {    //读取4字节长度。UInt8 表示是char类型，一个char，8位
                                            // 读取出来的实际是head的长度，head里面记录了真实的消息的长度
                
                //将字符型数组headMsg转化为data
                let lenData = Data(bytes: headMsg, count: 4)
                var actualLen = 0
                //将data转化为具体的Int，head里面就是一个实际消息的长度
                (lenData as NSData).getBytes(&actualLen, length: 4)
                
                
                
                //读取消息type
                guard let typeMsg = client.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type = 0
                (typeData as NSData).getBytes(&type, length: 2)
                print(type)
                
                //根据长度读取真实信息
                guard let actualMsg = client.read(actualLen) else {
                    return
                }
                let actualData = Data(bytes: actualMsg, count: actualLen)
                let actualMsgStr = String(data: actualData, encoding: .utf8)
                
                print(actualMsgStr ?? "解析消息出错")
            }
            else {
                isClientConnecting = false
                print("客户端断开连接")
            }
        }
        
    }
}
