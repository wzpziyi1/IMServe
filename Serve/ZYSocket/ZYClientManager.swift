//
//  ZYClientManager.swift
//  Serve
//
//  Created by 王志盼 on 18/05/2017.
//  Copyright © 2017 王志盼. All rights reserved.
//

import Cocoa

protocol ZYClientManagerDelegate : class {
    func sendMsgToClient(_ data : Data)
    func removeClient(client: ZYClientManager)
}

class ZYClientManager: NSObject {
    
    weak var delegate: ZYClientManagerDelegate?
    
    var client: TCPClient
    
    fileprivate var isClientConnecting: Bool = false
    
    //在定时器里面，每隔十秒接受一次心跳包
    fileprivate var heartTimeCount: Int = 0
    
    
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
                
                //接受心跳包，当十秒内没有接受到，说明客户端断开连接
                let timer = Timer(fireAt: Date(), interval: 1, target: self, selector: #selector(checkHeartBeat), userInfo: nil, repeats: true)
                //在子线程开启一个runloop，添加定时器（这里本来就都处于子线程中）
                RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
                timer.fire()
                
                //将字符型数组headMsg转化为data
                let headData = Data(bytes: headMsg, count: 4)
                var actualLen = 0
                //将data转化为具体的Int，head里面就是一个实际消息的长度
                (headData as NSData).getBytes(&actualLen, length: 4)
                
                
                
                //读取消息type
                guard let typeMsg = client.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type = 0
                (typeData as NSData).getBytes(&type, length: 2)
                
                //根据长度读取真实信息
                guard let actualMsg = client.read(actualLen) else {
                    return
                }
                let actualData = Data(bytes: actualMsg, count: actualLen)
                let actualMsgStr = String(data: actualData, encoding: .utf8)
                
                if type == 1 {
                    removeClient()
                } else if type == 100 {    //处理心跳包的情况
                    heartTimeCount += 1
                    continue
                }
                
                print(actualMsgStr ?? "解析消息出错")
                
                let totalData = headData + typeData + actualData
                delegate?.sendMsgToClient(totalData)
            }
            else {
                removeClient()
            }
        }
        
    }
    
    @objc fileprivate func checkHeartBeat() {
        heartTimeCount += 1
        //如果十秒内没有接受到一次心跳包
        if heartTimeCount >= 10 {
            self.removeClient()
        }
    }
    
    private func removeClient() {
        delegate?.removeClient(client: self)
        isClientConnecting = false
        print("客户端断开了连接")
        client.close()
    }
}
