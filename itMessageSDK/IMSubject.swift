//
//  IMSubject.swift
//  imclient
//
//  Created by Jem.Lee on 2022/5/3.
//

import Foundation
protocol IMSubject {
    func addObserver(observer: IMObserver)
    func removeObserver(observer: IMObserver)
    func notifyObservers<T>(with newValue: T)
    func notifyErrorObservers<T>(with newValue: T)
}
