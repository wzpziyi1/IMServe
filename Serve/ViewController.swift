//
//  ViewController.swift
//  Serve
//
//  Created by 王志盼 on 16/05/2017.
//  Copyright © 2017 王志盼. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    fileprivate lazy var socketManager = ZYSocketManager()
    @IBOutlet weak var statusLab: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    
    @IBAction func startRun(_ sender: Any) {
        statusLab.stringValue = "服务器正在运行"
        socketManager.startRunning()
    }
    @IBAction func stopRun(_ sender: Any) {
        statusLab.stringValue = "服务器停止运行"
        socketManager.stopRunning()
    }
}

