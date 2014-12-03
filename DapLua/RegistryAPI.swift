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
    public let luaState: DapLuaState

    private init() {
        self.registry = Registry.Global
        self.luaState = DapLuaState.sharedState()
    }

    public func send(itemPath: String, channelPath: String, data: Data) -> Bool {
        if let item: Item = registry.get(itemPath) {
            if let result = item.send(channelPath, data) {
                return result
            }
        }
        return false
    }
    
    public func listen_channel(itemPath: String, channelPath: String) -> Bool {
        if let item: Item = registry.get(itemPath) {
            if let listeners = item.luaChannelListeners {
                if !listeners.has(channelPath) {
                    listeners.addBool(channelPath, true)
                    return item.channels.addChannelListener(channelPath, listener: LuaChannelListener(luaState: luaState, itemPath: itemPath));
                }
            }
        }
        return false
    }

    public func handle(itemPath: String, handlerPath: String, data: Data) -> Data {
        if let item: Item = registry.get(itemPath) {
            if let result = item.handle(handlerPath, data) {
                return result
            }
        }
        return Data()
    }
    
    public func listen_handler(itemPath: String, handlerPath: String) -> Bool {
        if let item: Item = registry.get(itemPath) {
            if let listeners = item.luaHandlerListeners {
                if !listeners.has(handlerPath) {
                    listeners.addBool(handlerPath, true)
                    return item.handlers.addHandlerListener(handlerPath, listener: LuaHandlerListener(luaState: luaState, itemPath: itemPath));
                }
            }
        }
        return false
    }

    //SILP: REGISTRY_PROPERTY(Bool, Bool)
    public func addBool(itemPath: String, propertyPath: String, value: Bool) -> Bool {                     //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.addBool(propertyPath, value) {                                            //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func removeBool(itemPath: String, propertyPath: String) -> Bool {                               //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.removeBool(propertyPath) {                                                //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func isBool(itemPath: String, propertyPath: String) -> Bool {                                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            return item.isBool(propertyPath)                                                               //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func getBool(itemPath: String, propertyPath: String, defaultValue: Bool) -> Bool {              //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let value: Bool = item.getBool(propertyPath) {                                              //__SILP__
                return value                                                                               //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return defaultValue                                                                                //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func setBool(itemPath: String, propertyPath: String, value: Bool) -> Bool {                     //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.setBool(propertyPath, value) {                                            //__SILP__
                return result                                                                              //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func watchBool(itemPath: String, propertyPath: String, defaultValue: Bool) -> Bool {            //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                   //__SILP__
                if !watchers.has(propertyPath) {                                                           //__SILP__
                    watchers.addBool(propertyPath, true)                                                   //__SILP__
                    return item.properties.addWatcher(propertyPath,                                        //__SILP__
                        {(lastValue: Bool?, value: Bool?) -> Void in                                       //__SILP__
                            if lastValue != nil && value != nil {                                          //__SILP__
                                self.luaState.onBoolChanged(itemPath, propertyPath: propertyPath,          //__SILP__
                                                               lastValue: lastValue!, value: value!)       //__SILP__
                            } else if lastValue != nil {                                                   //__SILP__
                                self.luaState.onBoolChanged(itemPath, propertyPath: propertyPath,          //__SILP__
                                                               lastValue: lastValue!, value: defaultValue) //__SILP__
                            } else if value != nil {                                                       //__SILP__
                                self.luaState.onBoolChanged(itemPath, propertyPath: propertyPath,          //__SILP__
                                                               lastValue: defaultValue, value: value!)     //__SILP__
                            }                                                                              //__SILP__
                    }) != nil                                                                              //__SILP__
                }                                                                                          //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
    //SILP: REGISTRY_PROPERTY(Int, Int32)
    public func addInt(itemPath: String, propertyPath: String, value: Int32) -> Bool {                     //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.addInt(propertyPath, value) {                                             //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func removeInt(itemPath: String, propertyPath: String) -> Bool {                                //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.removeInt(propertyPath) {                                                 //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func isInt(itemPath: String, propertyPath: String) -> Bool {                                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            return item.isInt(propertyPath)                                                                //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func getInt(itemPath: String, propertyPath: String, defaultValue: Int32) -> Int32 {             //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let value: Int32 = item.getInt(propertyPath) {                                              //__SILP__
                return value                                                                               //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return defaultValue                                                                                //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func setInt(itemPath: String, propertyPath: String, value: Int32) -> Bool {                     //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.setInt(propertyPath, value) {                                             //__SILP__
                return result                                                                              //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func watchInt(itemPath: String, propertyPath: String, defaultValue: Int32) -> Bool {            //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                   //__SILP__
                if !watchers.has(propertyPath) {                                                           //__SILP__
                    watchers.addBool(propertyPath, true)                                                   //__SILP__
                    return item.properties.addWatcher(propertyPath,                                        //__SILP__
                        {(lastValue: Int32?, value: Int32?) -> Void in                                     //__SILP__
                            if lastValue != nil && value != nil {                                          //__SILP__
                                self.luaState.onIntChanged(itemPath, propertyPath: propertyPath,           //__SILP__
                                                               lastValue: lastValue!, value: value!)       //__SILP__
                            } else if lastValue != nil {                                                   //__SILP__
                                self.luaState.onIntChanged(itemPath, propertyPath: propertyPath,           //__SILP__
                                                               lastValue: lastValue!, value: defaultValue) //__SILP__
                            } else if value != nil {                                                       //__SILP__
                                self.luaState.onIntChanged(itemPath, propertyPath: propertyPath,           //__SILP__
                                                               lastValue: defaultValue, value: value!)     //__SILP__
                            }                                                                              //__SILP__
                    }) != nil                                                                              //__SILP__
                }                                                                                          //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
    //SILP: REGISTRY_PROPERTY(Long, Int64)
    public func addLong(itemPath: String, propertyPath: String, value: Int64) -> Bool {                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.addLong(propertyPath, value) {                                            //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func removeLong(itemPath: String, propertyPath: String) -> Bool {                               //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.removeLong(propertyPath) {                                                //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func isLong(itemPath: String, propertyPath: String) -> Bool {                                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            return item.isLong(propertyPath)                                                               //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func getLong(itemPath: String, propertyPath: String, defaultValue: Int64) -> Int64 {            //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let value: Int64 = item.getLong(propertyPath) {                                             //__SILP__
                return value                                                                               //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return defaultValue                                                                                //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func setLong(itemPath: String, propertyPath: String, value: Int64) -> Bool {                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.setLong(propertyPath, value) {                                            //__SILP__
                return result                                                                              //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func watchLong(itemPath: String, propertyPath: String, defaultValue: Int64) -> Bool {           //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                   //__SILP__
                if !watchers.has(propertyPath) {                                                           //__SILP__
                    watchers.addBool(propertyPath, true)                                                   //__SILP__
                    return item.properties.addWatcher(propertyPath,                                        //__SILP__
                        {(lastValue: Int64?, value: Int64?) -> Void in                                     //__SILP__
                            if lastValue != nil && value != nil {                                          //__SILP__
                                self.luaState.onLongChanged(itemPath, propertyPath: propertyPath,          //__SILP__
                                                               lastValue: lastValue!, value: value!)       //__SILP__
                            } else if lastValue != nil {                                                   //__SILP__
                                self.luaState.onLongChanged(itemPath, propertyPath: propertyPath,          //__SILP__
                                                               lastValue: lastValue!, value: defaultValue) //__SILP__
                            } else if value != nil {                                                       //__SILP__
                                self.luaState.onLongChanged(itemPath, propertyPath: propertyPath,          //__SILP__
                                                               lastValue: defaultValue, value: value!)     //__SILP__
                            }                                                                              //__SILP__
                    }) != nil                                                                              //__SILP__
                }                                                                                          //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
    //SILP: REGISTRY_PROPERTY(Float, Float)
    public func addFloat(itemPath: String, propertyPath: String, value: Float) -> Bool {                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.addFloat(propertyPath, value) {                                           //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func removeFloat(itemPath: String, propertyPath: String) -> Bool {                              //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.removeFloat(propertyPath) {                                               //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func isFloat(itemPath: String, propertyPath: String) -> Bool {                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            return item.isFloat(propertyPath)                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func getFloat(itemPath: String, propertyPath: String, defaultValue: Float) -> Float {           //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let value: Float = item.getFloat(propertyPath) {                                            //__SILP__
                return value                                                                               //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return defaultValue                                                                                //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func setFloat(itemPath: String, propertyPath: String, value: Float) -> Bool {                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.setFloat(propertyPath, value) {                                           //__SILP__
                return result                                                                              //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func watchFloat(itemPath: String, propertyPath: String, defaultValue: Float) -> Bool {          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                   //__SILP__
                if !watchers.has(propertyPath) {                                                           //__SILP__
                    watchers.addBool(propertyPath, true)                                                   //__SILP__
                    return item.properties.addWatcher(propertyPath,                                        //__SILP__
                        {(lastValue: Float?, value: Float?) -> Void in                                     //__SILP__
                            if lastValue != nil && value != nil {                                          //__SILP__
                                self.luaState.onFloatChanged(itemPath, propertyPath: propertyPath,         //__SILP__
                                                               lastValue: lastValue!, value: value!)       //__SILP__
                            } else if lastValue != nil {                                                   //__SILP__
                                self.luaState.onFloatChanged(itemPath, propertyPath: propertyPath,         //__SILP__
                                                               lastValue: lastValue!, value: defaultValue) //__SILP__
                            } else if value != nil {                                                       //__SILP__
                                self.luaState.onFloatChanged(itemPath, propertyPath: propertyPath,         //__SILP__
                                                               lastValue: defaultValue, value: value!)     //__SILP__
                            }                                                                              //__SILP__
                    }) != nil                                                                              //__SILP__
                }                                                                                          //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
    //SILP: REGISTRY_PROPERTY(Double, Double)
    public func addDouble(itemPath: String, propertyPath: String, value: Double) -> Bool {                 //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.addDouble(propertyPath, value) {                                          //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func removeDouble(itemPath: String, propertyPath: String) -> Bool {                             //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.removeDouble(propertyPath) {                                              //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func isDouble(itemPath: String, propertyPath: String) -> Bool {                                 //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            return item.isDouble(propertyPath)                                                             //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func getDouble(itemPath: String, propertyPath: String, defaultValue: Double) -> Double {        //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let value: Double = item.getDouble(propertyPath) {                                          //__SILP__
                return value                                                                               //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return defaultValue                                                                                //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func setDouble(itemPath: String, propertyPath: String, value: Double) -> Bool {                 //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.setDouble(propertyPath, value) {                                          //__SILP__
                return result                                                                              //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func watchDouble(itemPath: String, propertyPath: String, defaultValue: Double) -> Bool {        //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                   //__SILP__
                if !watchers.has(propertyPath) {                                                           //__SILP__
                    watchers.addBool(propertyPath, true)                                                   //__SILP__
                    return item.properties.addWatcher(propertyPath,                                        //__SILP__
                        {(lastValue: Double?, value: Double?) -> Void in                                   //__SILP__
                            if lastValue != nil && value != nil {                                          //__SILP__
                                self.luaState.onDoubleChanged(itemPath, propertyPath: propertyPath,        //__SILP__
                                                               lastValue: lastValue!, value: value!)       //__SILP__
                            } else if lastValue != nil {                                                   //__SILP__
                                self.luaState.onDoubleChanged(itemPath, propertyPath: propertyPath,        //__SILP__
                                                               lastValue: lastValue!, value: defaultValue) //__SILP__
                            } else if value != nil {                                                       //__SILP__
                                self.luaState.onDoubleChanged(itemPath, propertyPath: propertyPath,        //__SILP__
                                                               lastValue: defaultValue, value: value!)     //__SILP__
                            }                                                                              //__SILP__
                    }) != nil                                                                              //__SILP__
                }                                                                                          //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
    //SILP: REGISTRY_PROPERTY(String, String)
    public func addString(itemPath: String, propertyPath: String, value: String) -> Bool {                 //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.addString(propertyPath, value) {                                          //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func removeString(itemPath: String, propertyPath: String) -> Bool {                             //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.removeString(propertyPath) {                                              //__SILP__
                return true                                                                                //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func isString(itemPath: String, propertyPath: String) -> Bool {                                 //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            return item.isString(propertyPath)                                                             //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func getString(itemPath: String, propertyPath: String, defaultValue: String) -> String {        //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let value: String = item.getString(propertyPath) {                                          //__SILP__
                return value                                                                               //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return defaultValue                                                                                //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func setString(itemPath: String, propertyPath: String, value: String) -> Bool {                 //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let result = item.setString(propertyPath, value) {                                          //__SILP__
                return result                                                                              //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
                                                                                                           //__SILP__
    public func watchString(itemPath: String, propertyPath: String, defaultValue: String) -> Bool {        //__SILP__
        if let item: Item = registry.get(itemPath) {                                                       //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                   //__SILP__
                if !watchers.has(propertyPath) {                                                           //__SILP__
                    watchers.addBool(propertyPath, true)                                                   //__SILP__
                    return item.properties.addWatcher(propertyPath,                                        //__SILP__
                        {(lastValue: String?, value: String?) -> Void in                                   //__SILP__
                            if lastValue != nil && value != nil {                                          //__SILP__
                                self.luaState.onStringChanged(itemPath, propertyPath: propertyPath,        //__SILP__
                                                               lastValue: lastValue!, value: value!)       //__SILP__
                            } else if lastValue != nil {                                                   //__SILP__
                                self.luaState.onStringChanged(itemPath, propertyPath: propertyPath,        //__SILP__
                                                               lastValue: lastValue!, value: defaultValue) //__SILP__
                            } else if value != nil {                                                       //__SILP__
                                self.luaState.onStringChanged(itemPath, propertyPath: propertyPath,        //__SILP__
                                                               lastValue: defaultValue, value: value!)     //__SILP__
                            }                                                                              //__SILP__
                    }) != nil                                                                              //__SILP__
                }                                                                                          //__SILP__
            }                                                                                              //__SILP__
        }                                                                                                  //__SILP__
        return false                                                                                       //__SILP__
    }                                                                                                      //__SILP__
}
