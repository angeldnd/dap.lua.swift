//
//  RegistryAPI.swift
//  DapLua
//
//  Created by YJ Park on 14/11/10.
//  Copyright (c) 2014年 AngelDnD. All rights reserved.
//

import Foundation
import DapCore

@objc public final class RegistryAPI {
    public class var Global: RegistryAPI {
        struct Static {
            static let Instance: RegistryAPI = RegistryAPI()
        }
        return Static.Instance
    }
    public let registry: Registry

    public required init(registry: Registry) {
        self.registry = registry;
    }

    public convenience init() {
        self.init(registry: Registry.Global)
    }

    public func send(itemPath: String, channelPath: String, data: NSMutableDictionary) -> Bool {
        if let item: Item = registry.get(itemPath) {
            if let result = item.send(channelPath, data) {
                return result
            }
        }
        return false
    }

    public func handle(itemPath: String, handlerPath: String, data: NSMutableDictionary) -> NSMutableDictionary {
        if let item: Item = registry.get(itemPath) {
            if let result = item.handle(handlerPath, data) as? NSMutableDictionary {
                return result
            }
        }
        return data.newData() as NSMutableDictionary
    }

    //SILP: REGISTRY_PROPERTY(Bool)
    public func watch(itemPath: String, propertyPath: String) -> Bool {
        if let item: Item = registry.get(itemPath) {
            return item.isBool(propertyPath)
        }
        return false
    }
    
    public func addBool(itemPath: String, propertyPath: String, value: Bool) -> Bool {        //__SILP__
        if let item: Item = registry.get(itemPath) {                                          //__SILP__
            if let result = item.addBool(propertyPath, value) {                               //__SILP__
                return true                                                                   //__SILP__
            }                                                                                 //__SILP__
        }                                                                                     //__SILP__
        return false                                                                          //__SILP__
    }                                                                                         //__SILP__
                                                                                              //__SILP__
    public func removeBool(itemPath: String, propertyPath: String) -> Bool {                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                          //__SILP__
            if let result = item.removeBool(propertyPath) {                                   //__SILP__
                return true                                                                   //__SILP__
            }                                                                                 //__SILP__
        }                                                                                     //__SILP__
        return false                                                                          //__SILP__
    }                                                                                         //__SILP__
                                                                                              //__SILP__
    public func isBool(itemPath: String, propertyPath: String) -> Bool {                      //__SILP__
        if let item: Item = registry.get(itemPath) {                                          //__SILP__
            return item.isBool(propertyPath)                                                  //__SILP__
        }                                                                                     //__SILP__
        return false                                                                          //__SILP__
    }                                                                                         //__SILP__
                                                                                              //__SILP__
    public func getBool(itemPath: String, propertyPath: String, defaultValue: Bool) -> Bool { //__SILP__
        if let item: Item = registry.get(itemPath) {                                          //__SILP__
            if let value: Bool = item.getBool(propertyPath) {                                 //__SILP__
                return value                                                                  //__SILP__
            }                                                                                 //__SILP__
        }                                                                                     //__SILP__
        return defaultValue                                                                   //__SILP__
    }                                                                                         //__SILP__
                                                                                              //__SILP__
    public func setBool(itemPath: String, propertyPath: String, value: Bool) -> Bool {        //__SILP__
        if let item: Item = registry.get(itemPath) {                                          //__SILP__
            if let result = item.setBool(propertyPath, value) {                               //__SILP__
                return result                                                                 //__SILP__
            }                                                                                 //__SILP__
        }                                                                                     //__SILP__
        return false                                                                          //__SILP__
    }                                                                                         //__SILP__
    //SILP: REGISTRY_PROPERTY(Int)
    public func addInt(itemPath: String, propertyPath: String, value: Int) -> Bool {       //__SILP__
        if let item: Item = registry.get(itemPath) {                                       //__SILP__
            if let result = item.addInt(propertyPath, value) {                             //__SILP__
                return true                                                                //__SILP__
            }                                                                              //__SILP__
        }                                                                                  //__SILP__
        return false                                                                       //__SILP__
    }                                                                                      //__SILP__
                                                                                           //__SILP__
    public func removeInt(itemPath: String, propertyPath: String) -> Bool {                //__SILP__
        if let item: Item = registry.get(itemPath) {                                       //__SILP__
            if let result = item.removeInt(propertyPath) {                                 //__SILP__
                return true                                                                //__SILP__
            }                                                                              //__SILP__
        }                                                                                  //__SILP__
        return false                                                                       //__SILP__
    }                                                                                      //__SILP__
                                                                                           //__SILP__
    public func isInt(itemPath: String, propertyPath: String) -> Bool {                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                       //__SILP__
            return item.isInt(propertyPath)                                                //__SILP__
        }                                                                                  //__SILP__
        return false                                                                       //__SILP__
    }                                                                                      //__SILP__
                                                                                           //__SILP__
    public func getInt(itemPath: String, propertyPath: String, defaultValue: Int) -> Int { //__SILP__
        if let item: Item = registry.get(itemPath) {                                       //__SILP__
            if let value: Int = item.getInt(propertyPath) {                                //__SILP__
                return value                                                               //__SILP__
            }                                                                              //__SILP__
        }                                                                                  //__SILP__
        return defaultValue                                                                //__SILP__
    }                                                                                      //__SILP__
                                                                                           //__SILP__
    public func setInt(itemPath: String, propertyPath: String, value: Int) -> Bool {       //__SILP__
        if let item: Item = registry.get(itemPath) {                                       //__SILP__
            if let result = item.setInt(propertyPath, value) {                             //__SILP__
                return result                                                              //__SILP__
            }                                                                              //__SILP__
        }                                                                                  //__SILP__
        return false                                                                       //__SILP__
    }                                                                                      //__SILP__
    //SILP: REGISTRY_PROPERTY(Float)
    public func addFloat(itemPath: String, propertyPath: String, value: Float) -> Bool {         //__SILP__
        if let item: Item = registry.get(itemPath) {                                             //__SILP__
            if let result = item.addFloat(propertyPath, value) {                                 //__SILP__
                return true                                                                      //__SILP__
            }                                                                                    //__SILP__
        }                                                                                        //__SILP__
        return false                                                                             //__SILP__
    }                                                                                            //__SILP__
                                                                                                 //__SILP__
    public func removeFloat(itemPath: String, propertyPath: String) -> Bool {                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                             //__SILP__
            if let result = item.removeFloat(propertyPath) {                                     //__SILP__
                return true                                                                      //__SILP__
            }                                                                                    //__SILP__
        }                                                                                        //__SILP__
        return false                                                                             //__SILP__
    }                                                                                            //__SILP__
                                                                                                 //__SILP__
    public func isFloat(itemPath: String, propertyPath: String) -> Bool {                        //__SILP__
        if let item: Item = registry.get(itemPath) {                                             //__SILP__
            return item.isFloat(propertyPath)                                                    //__SILP__
        }                                                                                        //__SILP__
        return false                                                                             //__SILP__
    }                                                                                            //__SILP__
                                                                                                 //__SILP__
    public func getFloat(itemPath: String, propertyPath: String, defaultValue: Float) -> Float { //__SILP__
        if let item: Item = registry.get(itemPath) {                                             //__SILP__
            if let value: Float = item.getFloat(propertyPath) {                                  //__SILP__
                return value                                                                     //__SILP__
            }                                                                                    //__SILP__
        }                                                                                        //__SILP__
        return defaultValue                                                                      //__SILP__
    }                                                                                            //__SILP__
                                                                                                 //__SILP__
    public func setFloat(itemPath: String, propertyPath: String, value: Float) -> Bool {         //__SILP__
        if let item: Item = registry.get(itemPath) {                                             //__SILP__
            if let result = item.setFloat(propertyPath, value) {                                 //__SILP__
                return result                                                                    //__SILP__
            }                                                                                    //__SILP__
        }                                                                                        //__SILP__
        return false                                                                             //__SILP__
    }                                                                                            //__SILP__
    //SILP: REGISTRY_PROPERTY(Double)
    public func addDouble(itemPath: String, propertyPath: String, value: Double) -> Bool {          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let result = item.addDouble(propertyPath, value) {                                   //__SILP__
                return true                                                                         //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func removeDouble(itemPath: String, propertyPath: String) -> Bool {                      //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let result = item.removeDouble(propertyPath) {                                       //__SILP__
                return true                                                                         //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func isDouble(itemPath: String, propertyPath: String) -> Bool {                          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            return item.isDouble(propertyPath)                                                      //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func getDouble(itemPath: String, propertyPath: String, defaultValue: Double) -> Double { //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let value: Double = item.getDouble(propertyPath) {                                   //__SILP__
                return value                                                                        //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return defaultValue                                                                         //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func setDouble(itemPath: String, propertyPath: String, value: Double) -> Bool {          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let result = item.setDouble(propertyPath, value) {                                   //__SILP__
                return result                                                                       //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
    //SILP: REGISTRY_PROPERTY(String)
    public func addString(itemPath: String, propertyPath: String, value: String) -> Bool {          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let result = item.addString(propertyPath, value) {                                   //__SILP__
                return true                                                                         //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func removeString(itemPath: String, propertyPath: String) -> Bool {                      //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let result = item.removeString(propertyPath) {                                       //__SILP__
                return true                                                                         //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func isString(itemPath: String, propertyPath: String) -> Bool {                          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            return item.isString(propertyPath)                                                      //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func getString(itemPath: String, propertyPath: String, defaultValue: String) -> String { //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let value: String = item.getString(propertyPath) {                                   //__SILP__
                return value                                                                        //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return defaultValue                                                                         //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func setString(itemPath: String, propertyPath: String, value: String) -> Bool {          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let result = item.setString(propertyPath, value) {                                   //__SILP__
                return result                                                                       //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
}
