//
//  ZYSocketManager.swift
//  Serve
//
//  Created by 王志盼 on 17/05/2017.
//  Copyright © 2017 王志盼. All rights reserved.
//

import Cocoa

class ZYSocketManager: NSObject {
    
    fileprivate lazy var server: TCPServer = TCPServer(addr: "0.0.0.0", port: 9999)
    
    //判断是否不再接受消息
    fileprivate var isServeRunning: Bool = false
    fileprivate lazy var clientMgrArr = [ZYClientManager]()
    
}

extension ZYSocketManager {
    
    func startRunning() {
        //开始监听
        server.listen()
        
        isServeRunning = true
        
        //接受所有客户端
        DispatchQueue.global().async {
            //需要接受多个客户端的连接，并且是一直接受，不能卡主线
            while(self.isServeRunning) {
                if let client = self.server.accept() {
                    print("接收到一个客户端连接")
                    self.dealupClient(client: client)
                }
            }
            
        }
        
    }
    
    
    func stopRunning() {
        isServeRunning = false
    }
    
}

extension ZYSocketManager {
    fileprivate func dealupClient(client: TCPClient) {
        //用ZYClientManager来管理client的相关操作
        let clientMgr = ZYClientManager(client: client)
        
        //保存所以的clientMgr，以便操作
        clientMgrArr.append(clientMgr)
    }
}