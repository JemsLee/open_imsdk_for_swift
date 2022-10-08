//
//  IMObserver.swift
//  imclient
//
//  Created by Jem.Lee on 2022/5/3.
//

import Foundation

public protocol IMObserver : NSObjectProtocol {
    
    var id: Int { get }
    func onIMMessage<T>(with newValue: T)
    func onIMError<T>(with newValue: T)
    
}
