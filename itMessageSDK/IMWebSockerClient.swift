//
//  IMWebSockerClient.swift
//  imclient
//
//  Created by Jem.Lee on 2022/5/3.
//

import Foundation
import Starscream

class IMWebSockerClient:WebSocketDelegate {
    
    
    var fromUid:String = ""
    var token:String = ""
    var deviceId:String = ""
    
    var imIpAndPort:String = ""
    
    var socket: WebSocket!

    var isLogin:Bool = false
    
    var secKey:String = ""

    var iMManagerSubject:IMManagerSubject<String>?

    //继承事件机制
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
            case .connected(_):
                loginIm()
                break
            case .disconnected(_, _):
                isLogin = false
                break
            case .text(let string):
                handleReceive(string: string)
                break
            case .binary(_):
                break
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isLogin = false
            case .error(let error):
                isLogin = false
                handleError(error: error!)
                break;

        }
        
    }
    
    //处理错误信息
    func handleError(error:Error!){
        iMManagerSubject!.publishError(err: error.debugDescription)
    }
    
    
    //处理接收到的消息
    func handleReceive(string:String!){
        
        if(string.range(of: "用户未登录") != nil){
            loginIm()
        }else{
            
            var index:Int = -1
            
            if(string.range(of: "{") != nil){
                let range:Range<String.Index> = string.range(of: "{")!
                index = string.distance(from: string.startIndex,to: range.lowerBound)
            }
        //
            if(index >= 0){
                if(string.range(of: "登录成功") != nil){
                    isLogin = true
                    iMManagerSubject!.publish(str: string)
                }else{
                    isLogin = false
                    iMManagerSubject!.publishError(err: string)
                }
            }else{
                
                let recMessage:String  = AESCode.Decode_AES_ECB(strToDecode: string, secKey: secKey)
                let jsonData:Data = recMessage.data(using: .utf8)!
                let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                if dict != nil {
                    let eventId:String = (dict as! NSDictionary).value(forKey: "eventId") as! String
                    //1000001,5000004,8000000
                    if(eventId=="1000001" || eventId=="5000004" || eventId=="8000000"){
                        let sTimest:String = (dict as! NSDictionary).value(forKey: "sTimest") as! String
                        sendAck(sTimest: sTimest)
                    }
                }
                iMManagerSubject!.publish(str: recMessage)
            }
        }

    }
    
    //登陆到IM服务器
    func loginIm(){
        
        let message = MessageBody.message.init(eventId: "1000000", fromUid: fromUid, token: token, toUid: "", mType: "0", cTimest: "", sTimest: "", dataBody: "", isGroup: "0", groupId: "", groupName: "", isAck: "",channelId: "",pkGroupId:"",spUid:"",oldChannelId:"",isRoot:"")
        let jsonEncoder = JSONEncoder()
        let jsonStr = try? jsonEncoder.encode(message)
        let loginStr:String = String(data: jsonStr!, encoding:String.Encoding.utf8)!
        socket.write(string: loginStr)
        
    }
    
    func sendAck(sTimest:String){
        let message = MessageBody.message.init(eventId: "1000002", fromUid: fromUid, token: token, toUid: "", mType: "1", cTimest: "\(sTimest)", sTimest: "\(sTimest)", dataBody: "\(sTimest)", isGroup: "0", groupId: "", groupName: "", isAck: "1",channelId: "",pkGroupId:"",spUid:"",oldChannelId:"",isRoot:"")
        let jsonEncoder = JSONEncoder()
        let jsonStr = try? jsonEncoder.encode(message)
        let loginStr:String = String(data: jsonStr!, encoding:String.Encoding.utf8)!
        socket.write(string: AESCode.Endcode_AES_ECB(strToEncode: loginStr, secKey: secKey))
        
    }
    
    //发起链接
    func connectServer(){
        var request = URLRequest(url: URL(string: "ws://\(imIpAndPort)/")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func closeConnect(){
        socket.disconnect(closeCode: 0)
        socket.delegate = nil
    }
    
    //销毁对象
    deinit {
       socket.disconnect(closeCode: 0)
       socket.delegate = nil
    }
    
}
