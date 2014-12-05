//
//  ItemLuaHelper.swift
//  DapLua
//
//  Created by YJ Park on 14/11/30.
//  Copyright (c) 2014年 angeldnd. All rights reserved.
//

import Foundation
import DapCore

public class LuaElement {
    public let luaState: DapLuaState
    public let itemPath: String
    
    public init(luaState: DapLuaState, itemPath: String) {
        self.luaState = luaState;
        self.itemPath = itemPath;
    }
}

public final class LuaEventListener : LuaElement, EventListener {
     public func onEvent(channelPath: String, evt: Data?) -> Void {
        if evt != nil {
            luaState.onEvent(itemPath, channelPath: channelPath, evt:evt!)
        } else {
            luaState.onEvent(itemPath, channelPath: channelPath, evt:Data())
        }
    }
}

public final class LuaRequestListener : LuaElement, RequestListener {
    public func onRequest(handlerPath: String, req: Data?) -> Void {
        if req != nil {
            luaState.onRequest(itemPath, handlerPath: handlerPath, req:req!)
        } else {
            luaState.onRequest(itemPath, handlerPath: handlerPath, req:Data())
        }
    }
}

public final class LuaResponseListener : LuaElement, ResponseListener {
    public func onResponse(handlerPath: String, req: Data?, res: Data?) -> Void {
        if req != nil && req != nil {
            luaState.onResponse(itemPath, handlerPath: handlerPath, req:req!, res: res!)
        } else if req != nil {
            luaState.onResponse(itemPath, handlerPath: handlerPath, req:req!, res: Data())
        } else if res != nil {
            luaState.onResponse(itemPath, handlerPath: handlerPath, req:Data(), res: res!)
        } else {
            luaState.onResponse(itemPath, handlerPath: handlerPath, req:Data(), res: Data())
        }
    }
}

public final class LuaHandler : LuaElement, RequestHandler {   
    public func doHandle(handlerPath: String, req: Data?) -> Data? {
        if req != nil {
            return luaState.doHandle(itemPath, handlerPath: handlerPath, req:req!)
        } else {
            return luaState.doHandle(itemPath, handlerPath: handlerPath, req:Data())
        }
    }
}

extension Item {
    //SILP: DYNAMIC_VARS(luaPropertyWatchers)
    public var luaPropertyWatchers: Vars? {                           //__SILP__
        var result: Vars? = get("._luaPropertyWatchers_.");           //__SILP__
        if result == nil {                                            //__SILP__
            result = add("._luaPropertyWatchers_.")                   //__SILP__
        }                                                             //__SILP__
        return result;                                                //__SILP__
    }                                                                 //__SILP__
                                                                      //__SILP__
    //SILP: DYNAMIC_VARS(luaEventListeners)
    public var luaEventListeners: Vars? {                             //__SILP__
        var result: Vars? = get("._luaEventListeners_.");             //__SILP__
        if result == nil {                                            //__SILP__
            result = add("._luaEventListeners_.")                     //__SILP__
        }                                                             //__SILP__
        return result;                                                //__SILP__
    }                                                                 //__SILP__
                                                                      //__SILP__
    //SILP: DYNAMIC_VARS(luaRequestListeners)
    public var luaRequestListeners: Vars? {                           //__SILP__
        var result: Vars? = get("._luaRequestListeners_.");           //__SILP__
        if result == nil {                                            //__SILP__
            result = add("._luaRequestListeners_.")                   //__SILP__
        }                                                             //__SILP__
        return result;                                                //__SILP__
    }                                                                 //__SILP__
                                                                      //__SILP__
    //SILP: DYNAMIC_VARS(luaResponseListeners)
    public var luaResponseListeners: Vars? {                          //__SILP__
        var result: Vars? = get("._luaResponseListeners_.");          //__SILP__
        if result == nil {                                            //__SILP__
            result = add("._luaResponseListeners_.")                  //__SILP__
        }                                                             //__SILP__
        return result;                                                //__SILP__
    }                                                                 //__SILP__
                                                                      //__SILP__
}

//SILP: LUA_VALUE_WATCHER(Bool, Bool)
public final class LuaBoolValueWatcher : LuaElement, BoolProperty.ValueWatcher {          //__SILP__
    private let _defaultValue: Bool?                                                      //__SILP__
                                                                                          //__SILP__
    public init(luaState: DapLuaState, itemPath: String, defaultValue: Bool) {            //__SILP__
        super.init(luaState: luaState, itemPath: itemPath)                                //__SILP__
        _defaultValue = defaultValue                                                      //__SILP__
    }                                                                                     //__SILP__
                                                                                          //__SILP__
    public func onChanged(propertyPath: String, lastValue: Bool?, value: Bool?) -> Void { //__SILP__
        if lastValue != nil && value != nil {                                             //__SILP__
            self.luaState.onBoolChanged(itemPath, propertyPath: propertyPath,             //__SILP__
                                           lastValue: lastValue!, value: value!)          //__SILP__
        } else if lastValue != nil {                                                      //__SILP__
            self.luaState.onBoolChanged(itemPath, propertyPath: propertyPath,             //__SILP__
                                           lastValue: lastValue!, value: _defaultValue!)  //__SILP__
        } else if value != nil {                                                          //__SILP__
            self.luaState.onBoolChanged(itemPath, propertyPath: propertyPath,             //__SILP__
                                           lastValue: _defaultValue!, value: value!)      //__SILP__
        }                                                                                 //__SILP__
    }                                                                                     //__SILP__
}                                                                                         //__SILP__
                                                                                          //__SILP__
//SILP: LUA_VALUE_WATCHER(Int, Int32)
public final class LuaIntValueWatcher : LuaElement, IntProperty.ValueWatcher {              //__SILP__
    private let _defaultValue: Int32?                                                       //__SILP__
                                                                                            //__SILP__
    public init(luaState: DapLuaState, itemPath: String, defaultValue: Int32) {             //__SILP__
        super.init(luaState: luaState, itemPath: itemPath)                                  //__SILP__
        _defaultValue = defaultValue                                                        //__SILP__
    }                                                                                       //__SILP__
                                                                                            //__SILP__
    public func onChanged(propertyPath: String, lastValue: Int32?, value: Int32?) -> Void { //__SILP__
        if lastValue != nil && value != nil {                                               //__SILP__
            self.luaState.onIntChanged(itemPath, propertyPath: propertyPath,                //__SILP__
                                           lastValue: lastValue!, value: value!)            //__SILP__
        } else if lastValue != nil {                                                        //__SILP__
            self.luaState.onIntChanged(itemPath, propertyPath: propertyPath,                //__SILP__
                                           lastValue: lastValue!, value: _defaultValue!)    //__SILP__
        } else if value != nil {                                                            //__SILP__
            self.luaState.onIntChanged(itemPath, propertyPath: propertyPath,                //__SILP__
                                           lastValue: _defaultValue!, value: value!)        //__SILP__
        }                                                                                   //__SILP__
    }                                                                                       //__SILP__
}                                                                                           //__SILP__
                                                                                            //__SILP__
//SILP: LUA_VALUE_WATCHER(Long, Int64)
public final class LuaLongValueWatcher : LuaElement, LongProperty.ValueWatcher {            //__SILP__
    private let _defaultValue: Int64?                                                       //__SILP__
                                                                                            //__SILP__
    public init(luaState: DapLuaState, itemPath: String, defaultValue: Int64) {             //__SILP__
        super.init(luaState: luaState, itemPath: itemPath)                                  //__SILP__
        _defaultValue = defaultValue                                                        //__SILP__
    }                                                                                       //__SILP__
                                                                                            //__SILP__
    public func onChanged(propertyPath: String, lastValue: Int64?, value: Int64?) -> Void { //__SILP__
        if lastValue != nil && value != nil {                                               //__SILP__
            self.luaState.onLongChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: lastValue!, value: value!)            //__SILP__
        } else if lastValue != nil {                                                        //__SILP__
            self.luaState.onLongChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: lastValue!, value: _defaultValue!)    //__SILP__
        } else if value != nil {                                                            //__SILP__
            self.luaState.onLongChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: _defaultValue!, value: value!)        //__SILP__
        }                                                                                   //__SILP__
    }                                                                                       //__SILP__
}                                                                                           //__SILP__
                                                                                            //__SILP__
//SILP: LUA_VALUE_WATCHER(Float, Float)
public final class LuaFloatValueWatcher : LuaElement, FloatProperty.ValueWatcher {          //__SILP__
    private let _defaultValue: Float?                                                       //__SILP__
                                                                                            //__SILP__
    public init(luaState: DapLuaState, itemPath: String, defaultValue: Float) {             //__SILP__
        super.init(luaState: luaState, itemPath: itemPath)                                  //__SILP__
        _defaultValue = defaultValue                                                        //__SILP__
    }                                                                                       //__SILP__
                                                                                            //__SILP__
    public func onChanged(propertyPath: String, lastValue: Float?, value: Float?) -> Void { //__SILP__
        if lastValue != nil && value != nil {                                               //__SILP__
            self.luaState.onFloatChanged(itemPath, propertyPath: propertyPath,              //__SILP__
                                           lastValue: lastValue!, value: value!)            //__SILP__
        } else if lastValue != nil {                                                        //__SILP__
            self.luaState.onFloatChanged(itemPath, propertyPath: propertyPath,              //__SILP__
                                           lastValue: lastValue!, value: _defaultValue!)    //__SILP__
        } else if value != nil {                                                            //__SILP__
            self.luaState.onFloatChanged(itemPath, propertyPath: propertyPath,              //__SILP__
                                           lastValue: _defaultValue!, value: value!)        //__SILP__
        }                                                                                   //__SILP__
    }                                                                                       //__SILP__
}                                                                                           //__SILP__
                                                                                            //__SILP__
//SILP: LUA_VALUE_WATCHER(Double, Double)
public final class LuaDoubleValueWatcher : LuaElement, DoubleProperty.ValueWatcher {          //__SILP__
    private let _defaultValue: Double?                                                        //__SILP__
                                                                                              //__SILP__
    public init(luaState: DapLuaState, itemPath: String, defaultValue: Double) {              //__SILP__
        super.init(luaState: luaState, itemPath: itemPath)                                    //__SILP__
        _defaultValue = defaultValue                                                          //__SILP__
    }                                                                                         //__SILP__
                                                                                              //__SILP__
    public func onChanged(propertyPath: String, lastValue: Double?, value: Double?) -> Void { //__SILP__
        if lastValue != nil && value != nil {                                                 //__SILP__
            self.luaState.onDoubleChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: lastValue!, value: value!)              //__SILP__
        } else if lastValue != nil {                                                          //__SILP__
            self.luaState.onDoubleChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: lastValue!, value: _defaultValue!)      //__SILP__
        } else if value != nil {                                                              //__SILP__
            self.luaState.onDoubleChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: _defaultValue!, value: value!)          //__SILP__
        }                                                                                     //__SILP__
    }                                                                                         //__SILP__
}                                                                                             //__SILP__
                                                                                              //__SILP__
//SILP: LUA_VALUE_WATCHER(String, String)
public final class LuaStringValueWatcher : LuaElement, StringProperty.ValueWatcher {          //__SILP__
    private let _defaultValue: String?                                                        //__SILP__
                                                                                              //__SILP__
    public init(luaState: DapLuaState, itemPath: String, defaultValue: String) {              //__SILP__
        super.init(luaState: luaState, itemPath: itemPath)                                    //__SILP__
        _defaultValue = defaultValue                                                          //__SILP__
    }                                                                                         //__SILP__
                                                                                              //__SILP__
    public func onChanged(propertyPath: String, lastValue: String?, value: String?) -> Void { //__SILP__
        if lastValue != nil && value != nil {                                                 //__SILP__
            self.luaState.onStringChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: lastValue!, value: value!)              //__SILP__
        } else if lastValue != nil {                                                          //__SILP__
            self.luaState.onStringChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: lastValue!, value: _defaultValue!)      //__SILP__
        } else if value != nil {                                                              //__SILP__
            self.luaState.onStringChanged(itemPath, propertyPath: propertyPath,               //__SILP__
                                           lastValue: _defaultValue!, value: value!)          //__SILP__
        }                                                                                     //__SILP__
    }                                                                                         //__SILP__
}                                                                                             //__SILP__
                                                                                              //__SILP__
