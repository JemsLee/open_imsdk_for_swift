//
//  MessageBody.swift
//  imclient
//
//  Created by Jem.Lee on 2022/5/3.
//

import Foundation

@objcMembers class MessageBody:NSObject{
    public struct message:Codable{
        
        var eventId:String //事件ID，参考事件ID文件
        var fromUid:String //发送者ID
        var token:String //发送者token
        var toUid:String //接收者ID，多个以逗号隔开  重点：对于客户端发送过来的消息，不能和groupId并存，两者只能同时出现一个
        var mType:String //消息类型
        var cTimest:String //客户端发送时间搓
        var sTimest:String //服务端接收时间搓
        var dataBody:String //消息体，可以自由定义，以字符串格式传入
        var isGroup:String //是否群组 1-群组，0-个人
        var groupId:String //群组ID
        var groupName:String //群组名称
        var isAck:String //客户端接收到服务端发送的消息后，返回的状态= 1；dataBody结构 sTimest,sTimest,sTimest,sTimest......
        var isCache:String = "0" //是否需要存离线 1-需要，0-不需要
        var channelId:String //用户的channel
        var pkGroupId:String //pk时使用
        var spUid:String //特殊用户ID
        var oldChannelId:String //准备离线的channel
        var isRoot:String = "0" //是否机器人 1-机器人
        var fbFlag:String = "";//分包的标记
        
    }
}
