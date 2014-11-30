//
//  NSDictionary+Data.swift
//  DapLua
//
//  Created by YJ Park on 2014-11-16.
//  Copyright (c) 2014 AngelDnD. All rights reserved.
//

import Foundation
import DapCore

extension NSMutableDictionary : Data {
    //SILP: DATA_NUMBER(Bool, bool)
    public func getBool(key: String) -> Bool? {                       //__SILP__
        if let _value: AnyObject = valueForKey(key) {                 //__SILP__
            if let value = _value as? NSNumber {                      //__SILP__
                return value.boolValue                                //__SILP__
            }                                                         //__SILP__
        }                                                             //__SILP__
        return nil                                                    //__SILP__
    }                                                                 //__SILP__
                                                                      //__SILP__
    public func setBool(key: String, value: Bool) -> Bool {           //__SILP__
        if valueForKey(key) == nil {                                  //__SILP__
            setValue(NSNumber(bool: value), forKey: key)              //__SILP__
            return true                                               //__SILP__
        }                                                             //__SILP__
        return false                                                  //__SILP__
    }                                                                 //__SILP__

    //SILP: DATA_NUMBER(Int, integer)
    public func getInt(key: String) -> Int? {                         //__SILP__
        if let _value: AnyObject = valueForKey(key) {                 //__SILP__
            if let value = _value as? NSNumber {                      //__SILP__
                return value.integerValue                             //__SILP__
            }                                                         //__SILP__
        }                                                             //__SILP__
        return nil                                                    //__SILP__
    }                                                                 //__SILP__
                                                                      //__SILP__
    public func setInt(key: String, value: Int) -> Bool {             //__SILP__
        if valueForKey(key) == nil {                                  //__SILP__
            setValue(NSNumber(integer: value), forKey: key)           //__SILP__
            return true                                               //__SILP__
        }                                                             //__SILP__
        return false                                                  //__SILP__
    }                                                                 //__SILP__
    
    //SILP: DATA_NUMBER(Float, float)
    public func getFloat(key: String) -> Float? {                     //__SILP__
        if let _value: AnyObject = valueForKey(key) {                 //__SILP__
            if let value = _value as? NSNumber {                      //__SILP__
                return value.floatValue                               //__SILP__
            }                                                         //__SILP__
        }                                                             //__SILP__
        return nil                                                    //__SILP__
    }                                                                 //__SILP__
                                                                      //__SILP__
    public func setFloat(key: String, value: Float) -> Bool {         //__SILP__
        if valueForKey(key) == nil {                                  //__SILP__
            setValue(NSNumber(float: value), forKey: key)             //__SILP__
            return true                                               //__SILP__
        }                                                             //__SILP__
        return false                                                  //__SILP__
    }                                                                 //__SILP__
    
    //SILP: DATA_NUMBER(Double, double)
    public func getDouble(key: String) -> Double? {                   //__SILP__
        if let _value: AnyObject = valueForKey(key) {                 //__SILP__
            if let value = _value as? NSNumber {                      //__SILP__
                return value.doubleValue                              //__SILP__
            }                                                         //__SILP__
        }                                                             //__SILP__
        return nil                                                    //__SILP__
    }                                                                 //__SILP__
                                                                      //__SILP__
    public func setDouble(key: String, value: Double) -> Bool {       //__SILP__
        if valueForKey(key) == nil {                                  //__SILP__
            setValue(NSNumber(double: value), forKey: key)            //__SILP__
            return true                                               //__SILP__
        }                                                             //__SILP__
        return false                                                  //__SILP__
    }                                                                 //__SILP__
    
    public func getString(key: String) -> String? {
        if let _value: AnyObject = valueForKey(key) {
            if let value = _value as? String {
                return value
            } else if let value = _value as? NSString {
                return value
            }
        }
        return nil
    }
    
    public func setString(key: String, value: String) -> Bool {
        if valueForKey(key) == nil {
            setValue(value, forKey: key)
            return true
        }
        return false
    }
    
    public func getData(key: String) -> Data? {
        if let _value: AnyObject = valueForKey(key) {
            if let value = _value as? NSMutableDictionary {
                return value
            }
        }
        return nil
    }
    
    public func setData(key: String, value: Data) -> Bool {
        if valueForKey(key) == nil && value is NSMutableDictionary {
            setValue(value as NSMutableDictionary, forKey: key)
            return true
        }
        return false
    }
    
    public func setData(key: String, value: NSMutableDictionary) -> Bool {
        if valueForKey(key) == nil {
            setValue(value, forKey: key)
            return true
        }
        return false
    }
    
    public func getKeys() -> [String] {
        var result = [String]()
        for key in allKeys {
            if let str = key as? String {
                result.append(str)
            }
        }
        return result
    }
    
    public func newData() -> Data {
        return NSMutableDictionary()
    }
}