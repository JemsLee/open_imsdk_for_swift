//
//  IMQueue.swift
//  imclient
//
//  Created by Jem.Lee on 2022/5/3.
//

import Foundation
//定义队列的通用协议
protocol IMQueue {
    //持有元素的类型
    associatedtype Element
    
    //是否为空
    var isEmpty : Bool {get}
    
    //队列的大小
    var size : Int {get}
    
    //队首元素
    var peek : Element? {get}
    
    //入队
    mutating func enqueue (_ newElement : Element)
    
    //出队
    mutating func dequeue()->Element?
    
}

//定义一个整数类型的栈
struct MessageQueue:IMQueue {
    
    typealias Element = String
    
    //定义两个数组是因为队列是左边进右边出 即 先进先出
    private var left = [Element]()
    private var right = [Element]()
    
    var isEmpty: Bool {
        return left.isEmpty && right.isEmpty
    }
    
    var peek: String? {
        return left.isEmpty ? right.last : left.last
    }
    
    var size: Int {
        return left.count + right.count
    }
    
    mutating func enqueue(_ newElement: String) {
        right.append(newElement)
    }
    
    mutating func dequeue() -> String? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
    
}
