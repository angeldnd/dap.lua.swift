//
//  ItemLuaHelper.swift
//  DapLua
//
//  Created by YJ Park on 14/11/30.
//  Copyright (c) 2014年 angeldnd. All rights reserved.
//

import Foundation
import DapCore

public class LuaChannelListener : ChannelListener {
    public let luaState: DapLuaState
    public let itemPath: String
    
    public init(luaState: DapLuaState, itemPath: String) {
        self.luaState = luaState;
        self.itemPath = itemPath;
    }

    public func onReceive(path: String, data: Data?) -> Void {
        if data != nil {
            luaState.onReceive(itemPath, channelPath: path, data:data!)
        } else {
            luaState.onReceive(itemPath, channelPath: path, data:Data())
        }
    }
}

public final class LuaHandlerListener : LuaChannelListener {
    public override func onReceive(path: String, data: Data?) -> Void {
        if data != nil {
            luaState.onHandle(itemPath, handlerPath: path, data:data!)
        } else {
            luaState.onHandle(itemPath, handlerPath: path, data:Data())
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
    
    //SILP: DYNAMIC_VARS(luaChannelListeners)
    public var luaChannelListeners: Vars? {                           //__SILP__
        var result: Vars? = get("._luaChannelListeners_.");           //__SILP__
        if result == nil {                                            //__SILP__
            result = add("._luaChannelListeners_.")                   //__SILP__
        }                                                             //__SILP__
        return result;                                                //__SILP__
    }                                                                 //__SILP__
    
    //SILP: DYNAMIC_VARS(luaHandlerListeners)
    public var luaHandlerListeners: Vars? {                           //__SILP__
        var result: Vars? = get("._luaHandlerListeners_.");           //__SILP__
        if result == nil {                                            //__SILP__
            result = add("._luaHandlerListeners_.")                   //__SILP__
        }                                                             //__SILP__
        return result;                                                //__SILP__
    }                                                                 //__SILP__
    
    //SILP: DYNAMIC_VARS(luaChannels)
    public var luaChannels: Vars? {                                   //__SILP__
        var result: Vars? = get("._luaChannels_.");                   //__SILP__
        if result == nil {                                            //__SILP__
            result = add("._luaChannels_.")                           //__SILP__
        }                                                             //__SILP__
        return result;                                                //__SILP__
    }                                                                 //__SILP__
        
    //SILP: DYNAMIC_VARS(luaHandlers)
    public var luaHandlers: Vars? {                                   //__SILP__
        var result: Vars? = get("._luaHandlers_.");                   //__SILP__
        if result == nil {                                            //__SILP__
            result = add("._luaHandlers_.")                           //__SILP__
        }                                                             //__SILP__
        return result;                                                //__SILP__
    }                                                                 //__SILP__
}