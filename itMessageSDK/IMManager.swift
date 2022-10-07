//
//  IMManager.swift
//  imclient
//
//  Created by Jem.Lee on 2022/5/3.
//

import Foundation
import Starscream
import CommonCrypto

@objcMembers class IMManager: NSObject{
    
    var imIpAndPort:String = ""
    var fromUid:String = ""
    var token:String = ""
    var deviceId:String = ""
    var secKey:String = ""
    
    var iMWebSockerClient:IMWebSockerClient!
    var iMManagerSubject:IMManagerSubject<String>?
    
    var messageQueue:MessageQueue = MessageQueue()
    
    static var shared: IMManager = {
        let instance = IMManager()
        return instance
    }()
    
    private override init(){
        
    }
    
    //开始启动服务
    @objc public func startSocket(){
        invalidateTimer();
        secKey = AESCode.MD5(codeString: fromUid)
        iMWebSockerClient = IMWebSockerClient()
        iMWebSockerClient.iMManagerSubject = iMManagerSubject
        iMWebSockerClient.fromUid = fromUid
        iMWebSockerClient.token = token
        iMWebSockerClient.deviceId = deviceId
        iMWebSockerClient.imIpAndPort = imIpAndPort
        iMWebSockerClient.secKey = secKey
        iMWebSockerClient.connectServer()
        startTimer()
    }
    
    //停止socket
    @objc public func stopSocket(){
        invalidateTimer()
        if (iMWebSockerClient != nil) {
            iMWebSockerClient.closeConnect()
        }
        
    }

    // @objc public 同时修饰，才能在OC项目中被调用；并且也能被swift项目调用
    //发送消息
    @objc public func sendMessage(messageStr:String) -> Void{
        let secStr =  AESCode.Endcode_AES_ECB(strToEncode: messageStr, secKey: secKey)
        if iMWebSockerClient != nil {
            iMWebSockerClient.socket.write(string: secStr)
        }else{
            messageQueue.enqueue(messageStr)
        }
    }
    
    //ping check
    func pingCheck(){
        
        if(iMWebSockerClient.isLogin){
            let message = MessageBody.message.init(eventId: "9000000", fromUid: fromUid, token: token, toUid: "", mType: "0", cTimest: "", sTimest: "", dataBody: "", isGroup: "0", groupId: "", groupName: "", isAck: "",channelId: "",pkGroupId:"",spUid:"",oldChannelId:"",isRoot:"")
            let jsonEncoder = JSONEncoder()
            let jsonStr = try? jsonEncoder.encode(message)
            let pingStr:String = String(data: jsonStr!, encoding:String.Encoding.utf8)!
            let secStr = AESCode.Endcode_AES_ECB(strToEncode: pingStr, secKey: secKey)
            iMWebSockerClient.socket.write(string: secStr)
        }else{
            startSocket()
        }
    }
    
    //本地发送为发送成功消息
    func sendLostMessage(){
        if(iMWebSockerClient.isLogin){
            while(!messageQueue.isEmpty){
                let messageStr:String = messageQueue.dequeue()!
                iMWebSockerClient.socket.write(string: messageStr)
            }
        }
    }
    
    //处理定时器
    var pingTimer:Timer?
    var lostMessageTimer:Timer?
    func startTimer() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (_) in
            self.pingCheck()
        })
        RunLoop.current.add(pingTimer!, forMode: .common)
        
        lostMessageTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true, block: { (_) in
            self.sendLostMessage()
        })
        RunLoop.current.add(lostMessageTimer!, forMode: .common)
    }
    
    //停止计时，清除对象
    func invalidateTimer() {
        
        if pingTimer != nil {
            pingTimer!.invalidate()
            pingTimer = nil
        }
        if lostMessageTimer != nil {
            lostMessageTimer!.invalidate()
            lostMessageTimer = nil
        }
        if iMWebSockerClient != nil {
            iMWebSockerClient.socket.disconnect(closeCode: 0)
            iMWebSockerClient = nil
        }
    }
    
}


