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

    public func fireEvent(itemPath: String, channelPath: String, evt: Data) -> Bool {
        if let item: Item = registry.get(itemPath) {
            if let result = item.fireEvent(channelPath, evt) {
                return result
            }
        }
        return false
    }
    
    public func addChannel(itemPath: String, channelPath: String) -> Bool {
        if let item: Item = registry.get(itemPath) {
            return item.channels.addChannel(channelPath) != nil
        }
        return false
    }

    public func handleRequest(itemPath: String, handlerPath: String, req: Data) -> Data {
        if let item: Item = registry.get(itemPath) {
            if let result = item.handleRequest(handlerPath, req) {
                return result
            }
        }
        return Data()
    }
    
    public func addHandler(itemPath: String, handlerPath: String) -> Bool {
        if let item: Item = registry.get(itemPath) {
            if let handler: Handler = item.handlers.addHandler(handlerPath) {
                return handler.setup(LuaHandler(luaState: luaState, itemPath: itemPath))
            }
        }
        return false
    }
    
    //SILP: REGISTRY_LISTEN(Event, channelPath, channels)
    public func listenEvent(itemPath: String, channelPath: String) -> Bool {                      //__SILP__
        if let item: Item = registry.get(itemPath) {                                              //__SILP__
            if let listeners = item.luaEventListeners{                                            //__SILP__
                if !listeners.has(channelPath) {                                                  //__SILP__
                    let listener = LuaEventListener(luaState: luaState, itemPath: itemPath)       //__SILP__
                    listeners.addAnyVar(channelPath, value: listener)                             //__SILP__
                    return item.channels.addEventListener(channelPath, listener: listener);       //__SILP__
                }                                                                                 //__SILP__
            }                                                                                     //__SILP__
        }                                                                                         //__SILP__
        return false                                                                              //__SILP__
    }                                                                                             //__SILP__
                                                                                                  //__SILP__
    public func unlistenEvent(itemPath: String, channelPath: String) -> Bool {                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                              //__SILP__
            if let listeners = item.luaEventListeners{                                            //__SILP__
                if let listenerVar: AnyVar<LuaEventListener> = listeners.remove(channelPath) {    //__SILP__
                    if let listener = listenerVar.value {                                         //__SILP__
                        return item.channels.removeEventListener(channelPath, listener: listener) //__SILP__
                    }                                                                             //__SILP__
                }                                                                                 //__SILP__
            }                                                                                     //__SILP__
        }                                                                                         //__SILP__
        return false                                                                              //__SILP__
    }                                                                                             //__SILP__
    
    //SILP: REGISTRY_LISTEN(Request, handlerPath, handlers)
    public func listenRequest(itemPath: String, handlerPath: String) -> Bool {                      //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let listeners = item.luaRequestListeners{                                            //__SILP__
                if !listeners.has(handlerPath) {                                                    //__SILP__
                    let listener = LuaRequestListener(luaState: luaState, itemPath: itemPath)       //__SILP__
                    listeners.addAnyVar(handlerPath, value: listener)                               //__SILP__
                    return item.handlers.addRequestListener(handlerPath, listener: listener);       //__SILP__
                }                                                                                   //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
                                                                                                    //__SILP__
    public func unlistenRequest(itemPath: String, handlerPath: String) -> Bool {                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                                //__SILP__
            if let listeners = item.luaRequestListeners{                                            //__SILP__
                if let listenerVar: AnyVar<LuaRequestListener> = listeners.remove(handlerPath) {    //__SILP__
                    if let listener = listenerVar.value {                                           //__SILP__
                        return item.handlers.removeRequestListener(handlerPath, listener: listener) //__SILP__
                    }                                                                               //__SILP__
                }                                                                                   //__SILP__
            }                                                                                       //__SILP__
        }                                                                                           //__SILP__
        return false                                                                                //__SILP__
    }                                                                                               //__SILP__
    
    //SILP: REGISTRY_LISTEN(Response, handlerPath, handlers)
    public func listenResponse(itemPath: String, handlerPath: String) -> Bool {                      //__SILP__
        if let item: Item = registry.get(itemPath) {                                                 //__SILP__
            if let listeners = item.luaResponseListeners{                                            //__SILP__
                if !listeners.has(handlerPath) {                                                     //__SILP__
                    let listener = LuaResponseListener(luaState: luaState, itemPath: itemPath)       //__SILP__
                    listeners.addAnyVar(handlerPath, value: listener)                                //__SILP__
                    return item.handlers.addResponseListener(handlerPath, listener: listener);       //__SILP__
                }                                                                                    //__SILP__
            }                                                                                        //__SILP__
        }                                                                                            //__SILP__
        return false                                                                                 //__SILP__
    }                                                                                                //__SILP__
                                                                                                     //__SILP__
    public func unlistenResponse(itemPath: String, handlerPath: String) -> Bool {                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                                 //__SILP__
            if let listeners = item.luaResponseListeners{                                            //__SILP__
                if let listenerVar: AnyVar<LuaResponseListener> = listeners.remove(handlerPath) {    //__SILP__
                    if let listener = listenerVar.value {                                            //__SILP__
                        return item.handlers.removeResponseListener(handlerPath, listener: listener) //__SILP__
                    }                                                                                //__SILP__
                }                                                                                    //__SILP__
            }                                                                                        //__SILP__
        }                                                                                            //__SILP__
        return false                                                                                 //__SILP__
    }                                                                                                //__SILP__

    //SILP: REGISTRY_PROPERTY(Bool, Bool)
    public func addBool(itemPath: String, propertyPath: String, value: Bool) -> Bool {                                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let result = item.addBool(propertyPath, value) {                                                           //__SILP__
                return true                                                                                               //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func removeBool(itemPath: String, propertyPath: String) -> Bool {                                              //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let result = item.removeBool(propertyPath) {                                                               //__SILP__
                return true                                                                                               //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func isBool(itemPath: String, propertyPath: String) -> Bool {                                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            return item.isBool(propertyPath)                                                                              //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func getBool(itemPath: String, propertyPath: String, defaultValue: Bool) -> Bool {                             //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let value: Bool = item.getBool(propertyPath) {                                                             //__SILP__
                return value                                                                                              //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return defaultValue                                                                                               //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func setBool(itemPath: String, propertyPath: String, value: Bool) -> Bool {                                    //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let result = item.setBool(propertyPath, value) {                                                           //__SILP__
                return result                                                                                             //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func watchBool(itemPath: String, propertyPath: String, defaultValue: Bool) -> Bool {                           //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                  //__SILP__
                if !watchers.has(propertyPath) {                                                                          //__SILP__
                    let watcher = LuaBoolValueWatcher(luaState: luaState, itemPath: itemPath, defaultValue: defaultValue) //__SILP__
                    watchers.addAnyVar(propertyPath, value: watcher)                                                      //__SILP__
                    return item.properties.addBoolValueWatcher(propertyPath, watcher: watcher)                            //__SILP__
                }                                                                                                         //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func unwatchBool(itemPath: String, propertyPath: String, defaultValue: Bool) -> Bool {                         //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                  //__SILP__
                if let watcherVar: AnyVar<LuaBoolValueWatcher> = watchers.remove(propertyPath) {                          //__SILP__
                    if let watcher = watcherVar.value {                                                                   //__SILP__
                        return item.properties.removeBoolValueWatcher(propertyPath, watcher: watcher)                     //__SILP__
                    }                                                                                                     //__SILP__
                }                                                                                                         //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
    //SILP: REGISTRY_PROPERTY(Int, Int32)
    public func addInt(itemPath: String, propertyPath: String, value: Int32) -> Bool {                                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                     //__SILP__
            if let result = item.addInt(propertyPath, value) {                                                           //__SILP__
                return true                                                                                              //__SILP__
            }                                                                                                            //__SILP__
        }                                                                                                                //__SILP__
        return false                                                                                                     //__SILP__
    }                                                                                                                    //__SILP__
                                                                                                                         //__SILP__
    public func removeInt(itemPath: String, propertyPath: String) -> Bool {                                              //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                     //__SILP__
            if let result = item.removeInt(propertyPath) {                                                               //__SILP__
                return true                                                                                              //__SILP__
            }                                                                                                            //__SILP__
        }                                                                                                                //__SILP__
        return false                                                                                                     //__SILP__
    }                                                                                                                    //__SILP__
                                                                                                                         //__SILP__
    public func isInt(itemPath: String, propertyPath: String) -> Bool {                                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                     //__SILP__
            return item.isInt(propertyPath)                                                                              //__SILP__
        }                                                                                                                //__SILP__
        return false                                                                                                     //__SILP__
    }                                                                                                                    //__SILP__
                                                                                                                         //__SILP__
    public func getInt(itemPath: String, propertyPath: String, defaultValue: Int32) -> Int32 {                           //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                     //__SILP__
            if let value: Int32 = item.getInt(propertyPath) {                                                            //__SILP__
                return value                                                                                             //__SILP__
            }                                                                                                            //__SILP__
        }                                                                                                                //__SILP__
        return defaultValue                                                                                              //__SILP__
    }                                                                                                                    //__SILP__
                                                                                                                         //__SILP__
    public func setInt(itemPath: String, propertyPath: String, value: Int32) -> Bool {                                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                     //__SILP__
            if let result = item.setInt(propertyPath, value) {                                                           //__SILP__
                return result                                                                                            //__SILP__
            }                                                                                                            //__SILP__
        }                                                                                                                //__SILP__
        return false                                                                                                     //__SILP__
    }                                                                                                                    //__SILP__
                                                                                                                         //__SILP__
    public func watchInt(itemPath: String, propertyPath: String, defaultValue: Int32) -> Bool {                          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                     //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                 //__SILP__
                if !watchers.has(propertyPath) {                                                                         //__SILP__
                    let watcher = LuaIntValueWatcher(luaState: luaState, itemPath: itemPath, defaultValue: defaultValue) //__SILP__
                    watchers.addAnyVar(propertyPath, value: watcher)                                                     //__SILP__
                    return item.properties.addIntValueWatcher(propertyPath, watcher: watcher)                            //__SILP__
                }                                                                                                        //__SILP__
            }                                                                                                            //__SILP__
        }                                                                                                                //__SILP__
        return false                                                                                                     //__SILP__
    }                                                                                                                    //__SILP__
                                                                                                                         //__SILP__
    public func unwatchInt(itemPath: String, propertyPath: String, defaultValue: Int32) -> Bool {                        //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                     //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                 //__SILP__
                if let watcherVar: AnyVar<LuaIntValueWatcher> = watchers.remove(propertyPath) {                          //__SILP__
                    if let watcher = watcherVar.value {                                                                  //__SILP__
                        return item.properties.removeIntValueWatcher(propertyPath, watcher: watcher)                     //__SILP__
                    }                                                                                                    //__SILP__
                }                                                                                                        //__SILP__
            }                                                                                                            //__SILP__
        }                                                                                                                //__SILP__
        return false                                                                                                     //__SILP__
    }                                                                                                                    //__SILP__
    //SILP: REGISTRY_PROPERTY(Long, Int64)
    public func addLong(itemPath: String, propertyPath: String, value: Int64) -> Bool {                                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let result = item.addLong(propertyPath, value) {                                                           //__SILP__
                return true                                                                                               //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func removeLong(itemPath: String, propertyPath: String) -> Bool {                                              //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let result = item.removeLong(propertyPath) {                                                               //__SILP__
                return true                                                                                               //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func isLong(itemPath: String, propertyPath: String) -> Bool {                                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            return item.isLong(propertyPath)                                                                              //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func getLong(itemPath: String, propertyPath: String, defaultValue: Int64) -> Int64 {                           //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let value: Int64 = item.getLong(propertyPath) {                                                            //__SILP__
                return value                                                                                              //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return defaultValue                                                                                               //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func setLong(itemPath: String, propertyPath: String, value: Int64) -> Bool {                                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let result = item.setLong(propertyPath, value) {                                                           //__SILP__
                return result                                                                                             //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func watchLong(itemPath: String, propertyPath: String, defaultValue: Int64) -> Bool {                          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                  //__SILP__
                if !watchers.has(propertyPath) {                                                                          //__SILP__
                    let watcher = LuaLongValueWatcher(luaState: luaState, itemPath: itemPath, defaultValue: defaultValue) //__SILP__
                    watchers.addAnyVar(propertyPath, value: watcher)                                                      //__SILP__
                    return item.properties.addLongValueWatcher(propertyPath, watcher: watcher)                            //__SILP__
                }                                                                                                         //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
                                                                                                                          //__SILP__
    public func unwatchLong(itemPath: String, propertyPath: String, defaultValue: Int64) -> Bool {                        //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                      //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                  //__SILP__
                if let watcherVar: AnyVar<LuaLongValueWatcher> = watchers.remove(propertyPath) {                          //__SILP__
                    if let watcher = watcherVar.value {                                                                   //__SILP__
                        return item.properties.removeLongValueWatcher(propertyPath, watcher: watcher)                     //__SILP__
                    }                                                                                                     //__SILP__
                }                                                                                                         //__SILP__
            }                                                                                                             //__SILP__
        }                                                                                                                 //__SILP__
        return false                                                                                                      //__SILP__
    }                                                                                                                     //__SILP__
    //SILP: REGISTRY_PROPERTY(Float, Float)
    public func addFloat(itemPath: String, propertyPath: String, value: Float) -> Bool {                                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                       //__SILP__
            if let result = item.addFloat(propertyPath, value) {                                                           //__SILP__
                return true                                                                                                //__SILP__
            }                                                                                                              //__SILP__
        }                                                                                                                  //__SILP__
        return false                                                                                                       //__SILP__
    }                                                                                                                      //__SILP__
                                                                                                                           //__SILP__
    public func removeFloat(itemPath: String, propertyPath: String) -> Bool {                                              //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                       //__SILP__
            if let result = item.removeFloat(propertyPath) {                                                               //__SILP__
                return true                                                                                                //__SILP__
            }                                                                                                              //__SILP__
        }                                                                                                                  //__SILP__
        return false                                                                                                       //__SILP__
    }                                                                                                                      //__SILP__
                                                                                                                           //__SILP__
    public func isFloat(itemPath: String, propertyPath: String) -> Bool {                                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                       //__SILP__
            return item.isFloat(propertyPath)                                                                              //__SILP__
        }                                                                                                                  //__SILP__
        return false                                                                                                       //__SILP__
    }                                                                                                                      //__SILP__
                                                                                                                           //__SILP__
    public func getFloat(itemPath: String, propertyPath: String, defaultValue: Float) -> Float {                           //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                       //__SILP__
            if let value: Float = item.getFloat(propertyPath) {                                                            //__SILP__
                return value                                                                                               //__SILP__
            }                                                                                                              //__SILP__
        }                                                                                                                  //__SILP__
        return defaultValue                                                                                                //__SILP__
    }                                                                                                                      //__SILP__
                                                                                                                           //__SILP__
    public func setFloat(itemPath: String, propertyPath: String, value: Float) -> Bool {                                   //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                       //__SILP__
            if let result = item.setFloat(propertyPath, value) {                                                           //__SILP__
                return result                                                                                              //__SILP__
            }                                                                                                              //__SILP__
        }                                                                                                                  //__SILP__
        return false                                                                                                       //__SILP__
    }                                                                                                                      //__SILP__
                                                                                                                           //__SILP__
    public func watchFloat(itemPath: String, propertyPath: String, defaultValue: Float) -> Bool {                          //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                       //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                   //__SILP__
                if !watchers.has(propertyPath) {                                                                           //__SILP__
                    let watcher = LuaFloatValueWatcher(luaState: luaState, itemPath: itemPath, defaultValue: defaultValue) //__SILP__
                    watchers.addAnyVar(propertyPath, value: watcher)                                                       //__SILP__
                    return item.properties.addFloatValueWatcher(propertyPath, watcher: watcher)                            //__SILP__
                }                                                                                                          //__SILP__
            }                                                                                                              //__SILP__
        }                                                                                                                  //__SILP__
        return false                                                                                                       //__SILP__
    }                                                                                                                      //__SILP__
                                                                                                                           //__SILP__
    public func unwatchFloat(itemPath: String, propertyPath: String, defaultValue: Float) -> Bool {                        //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                       //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                   //__SILP__
                if let watcherVar: AnyVar<LuaFloatValueWatcher> = watchers.remove(propertyPath) {                          //__SILP__
                    if let watcher = watcherVar.value {                                                                    //__SILP__
                        return item.properties.removeFloatValueWatcher(propertyPath, watcher: watcher)                     //__SILP__
                    }                                                                                                      //__SILP__
                }                                                                                                          //__SILP__
            }                                                                                                              //__SILP__
        }                                                                                                                  //__SILP__
        return false                                                                                                       //__SILP__
    }                                                                                                                      //__SILP__
    //SILP: REGISTRY_PROPERTY(Double, Double)
    public func addDouble(itemPath: String, propertyPath: String, value: Double) -> Bool {                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let result = item.addDouble(propertyPath, value) {                                                           //__SILP__
                return true                                                                                                 //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func removeDouble(itemPath: String, propertyPath: String) -> Bool {                                              //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let result = item.removeDouble(propertyPath) {                                                               //__SILP__
                return true                                                                                                 //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func isDouble(itemPath: String, propertyPath: String) -> Bool {                                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            return item.isDouble(propertyPath)                                                                              //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func getDouble(itemPath: String, propertyPath: String, defaultValue: Double) -> Double {                         //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let value: Double = item.getDouble(propertyPath) {                                                           //__SILP__
                return value                                                                                                //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return defaultValue                                                                                                 //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func setDouble(itemPath: String, propertyPath: String, value: Double) -> Bool {                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let result = item.setDouble(propertyPath, value) {                                                           //__SILP__
                return result                                                                                               //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func watchDouble(itemPath: String, propertyPath: String, defaultValue: Double) -> Bool {                         //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                    //__SILP__
                if !watchers.has(propertyPath) {                                                                            //__SILP__
                    let watcher = LuaDoubleValueWatcher(luaState: luaState, itemPath: itemPath, defaultValue: defaultValue) //__SILP__
                    watchers.addAnyVar(propertyPath, value: watcher)                                                        //__SILP__
                    return item.properties.addDoubleValueWatcher(propertyPath, watcher: watcher)                            //__SILP__
                }                                                                                                           //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func unwatchDouble(itemPath: String, propertyPath: String, defaultValue: Double) -> Bool {                       //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                    //__SILP__
                if let watcherVar: AnyVar<LuaDoubleValueWatcher> = watchers.remove(propertyPath) {                          //__SILP__
                    if let watcher = watcherVar.value {                                                                     //__SILP__
                        return item.properties.removeDoubleValueWatcher(propertyPath, watcher: watcher)                     //__SILP__
                    }                                                                                                       //__SILP__
                }                                                                                                           //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
    //SILP: REGISTRY_PROPERTY(String, String)
    public func addString(itemPath: String, propertyPath: String, value: String) -> Bool {                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let result = item.addString(propertyPath, value) {                                                           //__SILP__
                return true                                                                                                 //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func removeString(itemPath: String, propertyPath: String) -> Bool {                                              //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let result = item.removeString(propertyPath) {                                                               //__SILP__
                return true                                                                                                 //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func isString(itemPath: String, propertyPath: String) -> Bool {                                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            return item.isString(propertyPath)                                                                              //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func getString(itemPath: String, propertyPath: String, defaultValue: String) -> String {                         //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let value: String = item.getString(propertyPath) {                                                           //__SILP__
                return value                                                                                                //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return defaultValue                                                                                                 //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func setString(itemPath: String, propertyPath: String, value: String) -> Bool {                                  //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let result = item.setString(propertyPath, value) {                                                           //__SILP__
                return result                                                                                               //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func watchString(itemPath: String, propertyPath: String, defaultValue: String) -> Bool {                         //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                    //__SILP__
                if !watchers.has(propertyPath) {                                                                            //__SILP__
                    let watcher = LuaStringValueWatcher(luaState: luaState, itemPath: itemPath, defaultValue: defaultValue) //__SILP__
                    watchers.addAnyVar(propertyPath, value: watcher)                                                        //__SILP__
                    return item.properties.addStringValueWatcher(propertyPath, watcher: watcher)                            //__SILP__
                }                                                                                                           //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
                                                                                                                            //__SILP__
    public func unwatchString(itemPath: String, propertyPath: String, defaultValue: String) -> Bool {                       //__SILP__
        if let item: Item = registry.get(itemPath) {                                                                        //__SILP__
            if let watchers = item.luaPropertyWatchers {                                                                    //__SILP__
                if let watcherVar: AnyVar<LuaStringValueWatcher> = watchers.remove(propertyPath) {                          //__SILP__
                    if let watcher = watcherVar.value {                                                                     //__SILP__
                        return item.properties.removeStringValueWatcher(propertyPath, watcher: watcher)                     //__SILP__
                    }                                                                                                       //__SILP__
                }                                                                                                           //__SILP__
            }                                                                                                               //__SILP__
        }                                                                                                                   //__SILP__
        return false                                                                                                        //__SILP__
    }                                                                                                                       //__SILP__
}
