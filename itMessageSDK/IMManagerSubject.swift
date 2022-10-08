//
//  IMManagerSubject.swift
//  imclient
//
//  Created by Jem.Lee on 2022/5/3.
//

import Foundation
open class IMManagerSubject<T>:NSObject, IMSubject {
    
  
    public func notifyObservers<T>(with newValue: T) {
        for observer in observers {
            observer.onIMMessage(with: newValue)
        }
    }
    
    public func notifyErrorObservers<T>(with newValue: T) {
        for observer in observers {
            observer.onIMError(with: newValue)
        }
    }
    
    public func publish(str:String){
        notifyObservers(with: str)
    }
    
    public func publishError(err:String){
        notifyErrorObservers(with: err)
    }
    
    
    public var _value: T! = nil
    
    public var _observers: [IMObserver] = []
    
    public var value: T {
        get {
            return self._value
        }
        set {
            self._value = newValue
        }
    }
    
    public var observers: [IMObserver] {
        set {
            self._observers = newValue
        }
        get {
            return self._observers
        }
    }
    
    public func addObserver(observer: IMObserver) {
        observers.append(observer)
    }
    
    public func removeObserver(observer: IMObserver) {
        observers = observers.filter{$0.id != observer.id }
    }
    
}
