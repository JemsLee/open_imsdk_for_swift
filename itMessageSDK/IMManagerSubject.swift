//
//  IMManagerSubject.swift
//  imclient
//
//  Created by Jem.Lee on 2022/5/3.
//

import Foundation
class IMManagerSubject<T>:IMSubject {
    
    func notifyObservers<T>(with newValue: T) {
        for observer in observers {
            observer.onIMMessage(with: newValue)
        }
    }
    
    func notifyErrorObservers<T>(with newValue: T) {
        for observer in observers {
            observer.onIMError(with: newValue)
        }
    }
    
    func publish(str:String){
        notifyObservers(with: str)
    }
    
    func publishError(err:String){
        notifyErrorObservers(with: err)
    }
    
    
    var _value: T! = nil
    
    var _observers: [IMObserver] = []
    
    var value: T {
        get {
            return self._value
        }
        set {
            self._value = newValue
        }
    }
    
    var observers: [IMObserver] {
        set {
            self._observers = newValue
        }
        get {
            return self._observers
        }
    }
    
    func addObserver(observer: IMObserver) {
        observers.append(observer)
    }
    
    func removeObserver(observer: IMObserver) {
        observers = observers.filter{$0.id != observer.id }
    }
    
}
