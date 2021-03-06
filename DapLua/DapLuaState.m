//
//  DapLuaState.m
//  DapLua
//
//  Created by YJ Park on 14/11/10.
//  Copyright (c) 2014年 AngelDnD. All rights reserved.
//


#import "DapLuaState.h"

#import "lua.h"
#import "lualib.h"
#import "lauxlib.h"

#include "lptree.h"
#include "lfs.h"

#import "DapLua/DapLua-Swift.h"

int luaopen_lpeg(lua_State *L);

@interface DapLuaState ()
{
    lua_State *luaState;
}
- (void) setup;

@end

@implementation DapLuaState

+ (DapLuaState *)sharedState {
    static DapLuaState *state;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        state = [[DapLuaState alloc] init];
        [state setup];
    });

    return state;
}

- (void)eval:(NSString *)script {
    int error = luaL_dostring(luaState, [script cStringUsingEncoding:NSUTF8StringEncoding]);
    if (error) {
        NSLog(@"Lua Error: %s", lua_tostring(luaState, -1));
    }
}

//SILP: LUA_PRORERTY_CHANGED(bool, bool, boolean, Bool)
- (void)onBoolChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath //__SILP__
                lastValue: (bool)lastValue value: (bool)value {                    //__SILP__
    lua_call_function_begin(luaState, @"_dap_on_bool_changed");                    //__SILP__
    lua_push_nsstring(luaState, itemPath);                                         //__SILP__
    lua_push_nsstring(luaState, propertyPath);                                     //__SILP__
    lua_pushboolean(luaState, lastValue);                                          //__SILP__
    lua_pushboolean(luaState, value);                                              //__SILP__
    lua_call_function_end(luaState, 4);                                            //__SILP__
}                                                                                  //__SILP__

//SILP: LUA_PRORERTY_CHANGED(int, int, number, Int)
- (void)onIntChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath //__SILP__
                lastValue: (int)lastValue value: (int)value {                     //__SILP__
    lua_call_function_begin(luaState, @"_dap_on_int_changed");                    //__SILP__
    lua_push_nsstring(luaState, itemPath);                                        //__SILP__
    lua_push_nsstring(luaState, propertyPath);                                    //__SILP__
    lua_pushnumber(luaState, lastValue);                                          //__SILP__
    lua_pushnumber(luaState, value);                                              //__SILP__
    lua_call_function_end(luaState, 4);                                           //__SILP__
}                                                                                 //__SILP__

//SILP: LUA_PRORERTY_CHANGED(long, long long, number, Long)
- (void)onLongChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath //__SILP__
                lastValue: (long long)lastValue value: (long long)value {          //__SILP__
    lua_call_function_begin(luaState, @"_dap_on_long_changed");                    //__SILP__
    lua_push_nsstring(luaState, itemPath);                                         //__SILP__
    lua_push_nsstring(luaState, propertyPath);                                     //__SILP__
    lua_pushnumber(luaState, lastValue);                                           //__SILP__
    lua_pushnumber(luaState, value);                                               //__SILP__
    lua_call_function_end(luaState, 4);                                            //__SILP__
}                                                                                  //__SILP__

//SILP: LUA_PRORERTY_CHANGED(float, float, number, Float)
- (void)onFloatChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath //__SILP__
                lastValue: (float)lastValue value: (float)value {                   //__SILP__
    lua_call_function_begin(luaState, @"_dap_on_float_changed");                    //__SILP__
    lua_push_nsstring(luaState, itemPath);                                          //__SILP__
    lua_push_nsstring(luaState, propertyPath);                                      //__SILP__
    lua_pushnumber(luaState, lastValue);                                            //__SILP__
    lua_pushnumber(luaState, value);                                                //__SILP__
    lua_call_function_end(luaState, 4);                                             //__SILP__
}                                                                                   //__SILP__

//SILP: LUA_PRORERTY_CHANGED(double, double, number, Double)
- (void)onDoubleChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath //__SILP__
                lastValue: (double)lastValue value: (double)value {                  //__SILP__
    lua_call_function_begin(luaState, @"_dap_on_double_changed");                    //__SILP__
    lua_push_nsstring(luaState, itemPath);                                           //__SILP__
    lua_push_nsstring(luaState, propertyPath);                                       //__SILP__
    lua_pushnumber(luaState, lastValue);                                             //__SILP__
    lua_pushnumber(luaState, value);                                                 //__SILP__
    lua_call_function_end(luaState, 4);                                              //__SILP__
}                                                                                    //__SILP__

//SILP: LUA_PRORERTY_CHANGED(string, NSString *, _nsstring, String)
- (void)onStringChanged: (NSString *)itemPath propertyPath: (NSString *)propertyPath //__SILP__
                lastValue: (NSString *)lastValue value: (NSString *)value {          //__SILP__
    lua_call_function_begin(luaState, @"_dap_on_string_changed");                    //__SILP__
    lua_push_nsstring(luaState, itemPath);                                           //__SILP__
    lua_push_nsstring(luaState, propertyPath);                                       //__SILP__
    lua_push_nsstring(luaState, lastValue);                                          //__SILP__
    lua_push_nsstring(luaState, value);                                              //__SILP__
    lua_call_function_end(luaState, 4);                                              //__SILP__
}                                                                                    //__SILP__

- (void)onEvent: (NSString *)itemPath channelPath: (NSString *)channelPath
            evt: (Data *) evt {
    lua_call_function_begin(luaState, @"_dap_on_event");
    lua_push_nsstring(luaState, itemPath);
    lua_push_nsstring(luaState, channelPath);
    lua_push_data(luaState, evt);
    lua_call_function_end(luaState, 3);
}

- (void)onRequest: (NSString *)itemPath handlerPath: (NSString *)handlerPath
              req: (Data *) req {
    lua_call_function_begin(luaState, @"_dap_on_request");
    lua_push_nsstring(luaState, itemPath);
    lua_push_nsstring(luaState, handlerPath);
    lua_push_data(luaState, req);
    lua_call_function_end(luaState, 3);
}

- (void)onResponse: (NSString *)itemPath handlerPath: (NSString *)handlerPath
               req: (Data *) req res: (Data *) res {
    lua_call_function_begin(luaState, @"_dap_on_response");
    lua_push_nsstring(luaState, itemPath);
    lua_push_nsstring(luaState, handlerPath);
    lua_push_data(luaState, req);
    lua_push_data(luaState, res);
    lua_call_function_end(luaState, 3);
}

- (Data *)doHandle: (NSString *)itemPath handlerPath: (NSString *)handlerPath
               req: (Data *) req {
    lua_call_function_begin(luaState, @"_dap_do_handle");
    lua_push_nsstring(luaState, itemPath);
    lua_push_nsstring(luaState, handlerPath);
    lua_push_data(luaState, req);
    lua_call_function_end(luaState, 3);
    
    luaL_argcheck(luaState, lua_istable(luaState, 1), 1, "doHandle should return a table!");
    Data *res = lua_to_data(luaState);
    return res;
}

/*
 * Note: Since setup is called when creating sharedState, it can NOT
 * accees RegistryAPI.Global (which reference to sharedState)
 */
- (void)setup {
    luaState = luaL_newstate();
    luaL_openlibs(luaState);

    luaopen_lpeg(luaState);
    luaopen_lfs(luaState);

    luaL_newlib(luaState, daplib);
    lua_setglobal(luaState, daplib_name);

    [self eval: @"package.loaded['lpeg'] = lpeg"];
    [self eval: @"package.loaded['lfs'] = lfs"];
    [self eval: @"package.loaded['dap'] = dap"];
}

- (void)bootstrap {
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *luaPath = [NSString stringWithFormat:@"%@/lua/?.lua;%@/lua.dap.bundle/?.lua;%@/lua.lib.bundle/?.lua",
                bundlePath, bundlePath, bundlePath];
    setLuaPath(luaState, [luaPath cStringUsingEncoding:NSUTF8StringEncoding]);
    [self eval: @"require 'bootstrap'"];
}

/*
Showing the stack when call lua code failed
http://blog.sina.com.cn/s/blog_600ce18b0100r5sd.html
*/

static int lua_error_handler(lua_State *L) {
    lua_getglobal(L, "debug");
    if (!lua_istable(L, -1)) {
        lua_pop(L, 1);
        return 1;
    }
    lua_getfield(L, -1, "traceback");
    if (!lua_isfunction(L, -1)) {
        lua_pop(L, 2);
        return 1;
    }
    lua_pushvalue(L, 1);
    lua_pushinteger(L, 2);
    lua_call(L, 2, 1);
    return 1;
}

static bool lua_call_function_begin(lua_State *L, NSString *func) {
    lua_getglobal(L, [func cStringUsingEncoding:NSUTF8StringEncoding]);
    if (!lua_isfunction(L, -1)) {
        lua_pop(L, 1);
        return false;
    }
    return true;
}
    
static bool lua_call_function_end(lua_State *L, int argc) {
    bool result = true;
    int size0 = lua_gettop(L);
    int error_index = lua_gettop(L) - argc;
    lua_pushcfunction(L, lua_error_handler);
    lua_insert(L, error_index);
    if(lua_pcall(L, argc, 1, error_index) != 0) {
        result = false;
    }
    lua_remove(L, error_index);
    if ((lua_gettop(L) + (int)argc  + 1) != size0) {
        //LuaScriptInterface::reportError(NULL, "Stack size changed!");
    }
    return result;
}

static void lua_push_nsstring(lua_State *L, NSString *str) {
    lua_pushstring(L, [str cStringUsingEncoding:NSUTF8StringEncoding]);
}

static void lua_push_data(lua_State *L, Data *data) {
    if (data == nil) {
        lua_pushnil(L);
        return;
    }
    
    lua_newtable(L);
    for (NSString *key in [data getKeys]) {
        lua_pushstring(L, [key cStringUsingEncoding:NSUTF8StringEncoding]);
        int type = [data getTypeAsInt:key];
        if (type == [Data BOOL]) {
            lua_pushboolean(L, [data getBool: key defaultValue:false]);
        } else if (type == [Data INT]) {
            lua_pushnumber(L, [data getInt: key defaultValue:0]);
        } else if (type == [Data LONG]) {
            lua_pushnumber(L, [data getLong: key defaultValue:0]);
        } else if (type == [Data FLOAT]) {
            lua_pushnumber(L, [data getFloat: key defaultValue:0]);
        } else if (type == [Data DOUBLE]) {
            lua_pushnumber(L, [data getDouble: key defaultValue:0]);
        } else if (type == [Data STRING]) {
            lua_push_nsstring(L, [data getString: key defaultValue:@""]);
        } else if (type == [Data DATA]) {
            lua_push_data(L, [data getData: key defaultValue:nil]);
        } else if (type == [Data NUMBER]) {
            lua_pushnumber(L, [data getDouble: key defaultValue:0]);
        } else {
            lua_pushnil(L);
            //TODO: Error message
        }
        lua_rawset(L, -3);
    }
}

static Data* lua_to_data(lua_State *L) {
    Data *data = [Data data];
    lua_pushnil(L);
    while (lua_next(L, -2)) {
        NSString *key = [NSString stringWithCString:lua_tostring(L, -2) encoding:NSUTF8StringEncoding];
        switch (lua_type(L, -1)) {
            case LUA_TNUMBER: {
                lua_Number number = lua_tonumber(L, -1);
                [data setNumber:key value:[NSNumber numberWithDouble:number]];
            }
            case LUA_TBOOLEAN: {
                [data setBool: key value: lua_toboolean(L, -1)];
            }
            case LUA_TSTRING: {
                NSString *value = [NSString stringWithCString:lua_tostring(L, -1) encoding:NSUTF8StringEncoding];
                [data setString: key value: value];
            }
            case LUA_TTABLE: {
                Data *value = lua_to_data(L);
                [data setData: key value: value];
            }
        }
        lua_pop(L, 1);
    }
    return data;
}

//SILP: LUA_CHANNEL_BEGIN(fire_event, channel)
static int dap_fire_event(lua_State *L) {                                                                  //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "channel_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *channelPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    
    luaL_argcheck(L, lua_istable(L, 3), 3, "data should be table!");
    Data *evt = lua_to_data(L);
    bool result = [RegistryAPI.Global fireEvent: itemPath channelPath: channelPath evt:evt];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_ITEM_BEGIN(add_item)
static int dap_add_item(lua_State *L) {                                                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                             //__SILP__
                                                                                                        //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding]; //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "item_type should be string!");
    NSString *itemType = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];
    bool result = [RegistryAPI.Global addItem: itemPath itemType: itemType];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_ITEM_BEGIN(remove_item)
static int dap_remove_item(lua_State *L) {                                                              //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                             //__SILP__
                                                                                                        //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global removeItem: itemPath];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_ITEM_BEGIN(is_item)
static int dap_is_item(lua_State *L) {                                                                  //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                             //__SILP__
                                                                                                        //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding]; //__SILP__
    NSString *itemType = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];
    bool result = [RegistryAPI.Global isItem: itemPath itemType: itemType];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_ITEM_BEGIN(dump_item)
static int dap_dump_item(lua_State *L) {                                                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                             //__SILP__
                                                                                                        //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding]; //__SILP__
    Data *result = [RegistryAPI.Global dumpItem: itemPath];
    lua_push_data(L, result);
    return 1;
}

//SILP: LUA_ITEM_BEGIN(load_item)
static int dap_load_item(lua_State *L) {                                                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                             //__SILP__
                                                                                                        //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding]; //__SILP__
    luaL_argcheck(L, lua_istable(L, 2), 2, "data should be table!");
    Data *data = lua_to_data(L);
    bool result = [RegistryAPI.Global loadItem: itemPath data: data];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_ITEM_BEGIN(clone_item)
static int dap_clone_item(lua_State *L) {                                                               //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                             //__SILP__
                                                                                                        //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding]; //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "to_path should be string!");
    NSString *toPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];
    bool result = [RegistryAPI.Global cloneItem: itemPath toPath: toPath];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_LISTEN(event, Event, channel)
static int dap_listen_event(lua_State *L) {                                                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "channel_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *channelPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global listenEvent: itemPath channelPath: channelPath];                     //__SILP__
    lua_pushboolean(L, result);                                                                            //__SILP__
    return 1;                                                                                              //__SILP__
}                                                                                                          //__SILP__
                                                                                                           //__SILP__
static int dap_unlisten_event(lua_State *L) {                                                              //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "channel_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *channelPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global unlistenEvent: itemPath channelPath: channelPath];                   //__SILP__
    lua_pushboolean(L, result);                                                                            //__SILP__
    return 1;                                                                                              //__SILP__
}                                                                                                          //__SILP__

//SILP: LUA_CHANNEL_BEGIN(add_channel, channel)
static int dap_add_channel(lua_State *L) {                                                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "channel_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *channelPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global addChannel: itemPath channelPath: channelPath];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_CHANNEL_BEGIN(remove_channel, channel)
static int dap_remove_channel(lua_State *L) {                                                              //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "channel_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *channelPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global removeChannel: itemPath channelPath: channelPath];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_CHANNEL_BEGIN(handle_request, handler)
static int dap_handle_request(lua_State *L) {                                                              //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "handler_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *handlerPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    
    luaL_argcheck(L, lua_istable(L, 3), 3, "data should be table!");
    Data *req = lua_to_data(L);
    Data *result = [RegistryAPI.Global handleRequest: itemPath handlerPath: handlerPath req:req];
    lua_push_data(L, result);
    return 1;
}

//SILP: LUA_LISTEN(request, Request, handler)
static int dap_listen_request(lua_State *L) {                                                              //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "handler_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *handlerPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global listenRequest: itemPath handlerPath: handlerPath];                   //__SILP__
    lua_pushboolean(L, result);                                                                            //__SILP__
    return 1;                                                                                              //__SILP__
}                                                                                                          //__SILP__
                                                                                                           //__SILP__
static int dap_unlisten_request(lua_State *L) {                                                            //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "handler_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *handlerPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global unlistenRequest: itemPath handlerPath: handlerPath];                 //__SILP__
    lua_pushboolean(L, result);                                                                            //__SILP__
    return 1;                                                                                              //__SILP__
}                                                                                                          //__SILP__

//SILP: LUA_LISTEN(response, Response, handler)
static int dap_listen_response(lua_State *L) {                                                             //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "handler_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *handlerPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global listenResponse: itemPath handlerPath: handlerPath];                  //__SILP__
    lua_pushboolean(L, result);                                                                            //__SILP__
    return 1;                                                                                              //__SILP__
}                                                                                                          //__SILP__
                                                                                                           //__SILP__
static int dap_unlisten_response(lua_State *L) {                                                           //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "handler_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *handlerPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global unlistenResponse: itemPath handlerPath: handlerPath];                //__SILP__
    lua_pushboolean(L, result);                                                                            //__SILP__
    return 1;                                                                                              //__SILP__
}                                                                                                          //__SILP__

//SILP: LUA_CHANNEL_BEGIN(add_handler, handler)
static int dap_add_handler(lua_State *L) {                                                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "handler_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *handlerPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global addHandler: itemPath handlerPath: handlerPath];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_CHANNEL_BEGIN(remove_handler, handler)
static int dap_remove_handler(lua_State *L) {                                                              //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "handler_path should be string!");                             //__SILP__
                                                                                                           //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];    //__SILP__
    NSString *handlerPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool result = [RegistryAPI.Global removeHandler: itemPath handlerPath: handlerPath];
    lua_pushboolean(L, result);
    return 1;
}

//SILP: LUA_PROPERTY_BEGIN(add, default_value, bool, boolean, Bool)
static int dap_add_bool(lua_State *L) {                                                                     //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isboolean(L, 3), 3, "default_value should be boolean!");                           //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool value = [[NSNumber numberWithBool:lua_toboolean(L, 3)] boolValue];
//SILP: LUA_PROPERTY_ADD_END(bool, boolean, Bool)
    bool result = [RegistryAPI.Global addBool: itemPath propertyPath: propertyPath value:value]; //__SILP__
    lua_pushboolean(L, result);                                                                  //__SILP__
    return 1;                                                                                    //__SILP__
}                                                                                                //__SILP__

//SILP: LUA_PROPERTY_REMOVE(bool, boolean, Bool)
static int dap_remove_bool(lua_State *L) {                                                                  //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global removeBool: itemPath propertyPath: propertyPath];                     //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__
//SILP: LUA_PROPERTY_IS(bool, boolean, Bool)
static int dap_is_bool(lua_State *L) {                                                                      //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global isBool: itemPath propertyPath: propertyPath];                         //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__

//SILP: LUA_PROPERTY_BEGIN(get, default_value, bool, boolean, Bool)
static int dap_get_bool(lua_State *L) {                                                                     //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isboolean(L, 3), 3, "default_value should be boolean!");                           //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool defaultValue = [[NSNumber numberWithBool:lua_toboolean(L, 3)] boolValue];
//SILP: LUA_PROPERTY_GET_END(bool, boolean, Bool)
    bool value = [RegistryAPI.Global getBool: itemPath propertyPath: propertyPath defaultValue: defaultValue]; //__SILP__
    lua_pushboolean(L, value);                                                                                 //__SILP__
    return 1;                                                                                                  //__SILP__
}                                                                                                              //__SILP__

//SILP: LUA_PROPERTY_BEGIN(set, new_value, bool, boolean, Bool)
static int dap_set_bool(lua_State *L) {                                                                     //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isboolean(L, 3), 3, "new_value should be boolean!");                               //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool newValue = [[NSNumber numberWithBool:lua_toboolean(L, 3)] boolValue];
//SILP: LUA_PROPERTY_SET_END(bool, boolean, Bool)
    bool result = [RegistryAPI.Global setBool: itemPath propertyPath: propertyPath value: newValue]; //__SILP__
    lua_pushboolean(L, result);                                                                      //__SILP__
    return 1;                                                                                        //__SILP__
}                                                                                                    //__SILP__

//SILP: LUA_PROPERTY_BEGIN(watch, default_value, bool, boolean, Bool)
static int dap_watch_bool(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isboolean(L, 3), 3, "default_value should be boolean!");                           //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool defaultValue = [[NSNumber numberWithBool:lua_toboolean(L, 3)] boolValue];
//SILP: LUA_PROPERTY_WATCH_END(bool, boolean, Bool)
    bool result = [RegistryAPI.Global watchBool: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                  //__SILP__
    return 1;                                                                                                    //__SILP__
}                                                                                                                //__SILP__

//SILP: LUA_PROPERTY_BEGIN(unwatch, default_value, bool, boolean, Bool)
static int dap_unwatch_bool(lua_State *L) {                                                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isboolean(L, 3), 3, "default_value should be boolean!");                           //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    bool defaultValue = [[NSNumber numberWithBool:lua_toboolean(L, 3)] boolValue];
//SILP: LUA_PROPERTY_UNWATCH_END(bool, boolean, Bool)
    bool result = [RegistryAPI.Global unwatchBool: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                    //__SILP__
    return 1;                                                                                                      //__SILP__
}                                                                                                                  //__SILP__

//SILP: LUA_PROPERTY_BEGIN(add, default_value, int, number, Int)
static int dap_add_int(lua_State *L) {                                                                      //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    int value = [[NSNumber numberWithInt:(int)lua_tonumber(L, 3)] intValue];
//SILP: LUA_PROPERTY_ADD_END(int, number, Int)
    bool result = [RegistryAPI.Global addInt: itemPath propertyPath: propertyPath value:value]; //__SILP__
    lua_pushboolean(L, result);                                                                 //__SILP__
    return 1;                                                                                   //__SILP__
}                                                                                               //__SILP__

//SILP: LUA_PROPERTY_REMOVE(int, number, Int)
static int dap_remove_int(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global removeInt: itemPath propertyPath: propertyPath];                      //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__
//SILP: LUA_PROPERTY_IS(int, number, Int)
static int dap_is_int(lua_State *L) {                                                                       //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global isInt: itemPath propertyPath: propertyPath];                          //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__

//SILP: LUA_PROPERTY_BEGIN(get, default_value, int, number, Int)
static int dap_get_int(lua_State *L) {                                                                      //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    int defaultValue = [[NSNumber numberWithInt:(int)lua_tonumber(L, 3)] intValue];
//SILP: LUA_PROPERTY_GET_END(long, number, Int)
    long value = [RegistryAPI.Global getInt: itemPath propertyPath: propertyPath defaultValue: defaultValue]; //__SILP__
    lua_pushnumber(L, value);                                                                                 //__SILP__
    return 1;                                                                                                 //__SILP__
}                                                                                                             //__SILP__

//SILP: LUA_PROPERTY_BEGIN(set, new_value, int, number, Int)
static int dap_set_int(lua_State *L) {                                                                      //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "new_value should be number!");                                 //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    int newValue = [[NSNumber numberWithInt:(int)lua_tonumber(L, 3)] intValue];
//SILP: LUA_PROPERTY_SET_END(int, number, Int)
    bool result = [RegistryAPI.Global setInt: itemPath propertyPath: propertyPath value: newValue]; //__SILP__
    lua_pushboolean(L, result);                                                                     //__SILP__
    return 1;                                                                                       //__SILP__
}                                                                                                   //__SILP__

//SILP: LUA_PROPERTY_BEGIN(watch, default_value, int, number, Int)
static int dap_watch_int(lua_State *L) {                                                                    //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    int defaultValue = [[NSNumber numberWithInt:(int)lua_tonumber(L, 3)] intValue];
//SILP: LUA_PROPERTY_WATCH_END(int, number, Int)
    bool result = [RegistryAPI.Global watchInt: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                 //__SILP__
    return 1;                                                                                                   //__SILP__
}                                                                                                               //__SILP__

//SILP: LUA_PROPERTY_BEGIN(unwatch, default_value, int, number, Int)
static int dap_unwatch_int(lua_State *L) {                                                                  //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    int defaultValue = [[NSNumber numberWithInt:(int)lua_tonumber(L, 3)] intValue];
//SILP: LUA_PROPERTY_UNWATCH_END(int, number, Int)
    bool result = [RegistryAPI.Global unwatchInt: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                   //__SILP__
    return 1;                                                                                                     //__SILP__
}                                                                                                                 //__SILP__

//SILP: LUA_PROPERTY_BEGIN(add, default_value, long, number, Long)
static int dap_add_long(lua_State *L) {                                                                     //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    long long value = [[NSNumber numberWithLongLong:(long)lua_tonumber(L, 3)] longLongValue];
//SILP: LUA_PROPERTY_ADD_END(long, number, Long)
    bool result = [RegistryAPI.Global addLong: itemPath propertyPath: propertyPath value:value]; //__SILP__
    lua_pushboolean(L, result);                                                                  //__SILP__
    return 1;                                                                                    //__SILP__
}                                                                                                //__SILP__

//SILP: LUA_PROPERTY_REMOVE(long, number, Long)
static int dap_remove_long(lua_State *L) {                                                                  //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global removeLong: itemPath propertyPath: propertyPath];                     //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__
//SILP: LUA_PROPERTY_IS(long, number, Long)
static int dap_is_long(lua_State *L) {                                                                      //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global isLong: itemPath propertyPath: propertyPath];                         //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__

//SILP: LUA_PROPERTY_BEGIN(get, default_value, long, number, Long)
static int dap_get_long(lua_State *L) {                                                                     //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    long long defaultValue = [[NSNumber numberWithLongLong:(long)lua_tonumber(L, 3)] longLongValue];
//SILP: LUA_PROPERTY_GET_END(long, number, Long)
    long value = [RegistryAPI.Global getLong: itemPath propertyPath: propertyPath defaultValue: defaultValue]; //__SILP__
    lua_pushnumber(L, value);                                                                                  //__SILP__
    return 1;                                                                                                  //__SILP__
}                                                                                                              //__SILP__

//SILP: LUA_PROPERTY_BEGIN(set, new_value, long, number, Long)
static int dap_set_long(lua_State *L) {                                                                     //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "new_value should be number!");                                 //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    long long newValue = [[NSNumber numberWithLongLong:(long)lua_tonumber(L, 3)] longLongValue];
//SILP: LUA_PROPERTY_SET_END(long, number, Long)
    bool result = [RegistryAPI.Global setLong: itemPath propertyPath: propertyPath value: newValue]; //__SILP__
    lua_pushboolean(L, result);                                                                      //__SILP__
    return 1;                                                                                        //__SILP__
}                                                                                                    //__SILP__

//SILP: LUA_PROPERTY_BEGIN(watch, default_value, long, number, Long)
static int dap_watch_long(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    long long defaultValue = [[NSNumber numberWithLongLong:(long)lua_tonumber(L, 3)] longLongValue];
//SILP: LUA_PROPERTY_WATCH_END(long, number, Long)
    bool result = [RegistryAPI.Global watchLong: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                  //__SILP__
    return 1;                                                                                                    //__SILP__
}                                                                                                                //__SILP__

//SILP: LUA_PROPERTY_BEGIN(unwatch, default_value, long, number, Long)
static int dap_unwatch_long(lua_State *L) {                                                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    long long defaultValue = [[NSNumber numberWithLongLong:(long)lua_tonumber(L, 3)] longLongValue];
//SILP: LUA_PROPERTY_UNWATCH_END(long, number, Long)
    bool result = [RegistryAPI.Global unwatchLong: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                    //__SILP__
    return 1;                                                                                                      //__SILP__
}                                                                                                                  //__SILP__

//SILP: LUA_PROPERTY_BEGIN(add, default_value, float, number, Float)
static int dap_add_float(lua_State *L) {                                                                    //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    float value = [[NSNumber numberWithFloat:(float)lua_tonumber(L, 3)] floatValue];
//SILP: LUA_PROPERTY_ADD_END(float, number, Float)
    bool result = [RegistryAPI.Global addFloat: itemPath propertyPath: propertyPath value:value]; //__SILP__
    lua_pushboolean(L, result);                                                                   //__SILP__
    return 1;                                                                                     //__SILP__
}                                                                                                 //__SILP__

//SILP: LUA_PROPERTY_REMOVE(float, number, Float)
static int dap_remove_float(lua_State *L) {                                                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global removeFloat: itemPath propertyPath: propertyPath];                    //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__
//SILP: LUA_PROPERTY_IS(float, number, Float)
static int dap_is_float(lua_State *L) {                                                                     //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global isFloat: itemPath propertyPath: propertyPath];                        //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__

//SILP: LUA_PROPERTY_BEGIN(get, default_value, float, number, Float)
static int dap_get_float(lua_State *L) {                                                                    //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    float defaultValue = [[NSNumber numberWithFloat:(float)lua_tonumber(L, 3)] floatValue];
//SILP: LUA_PROPERTY_GET_END(float, number, Float)
    float value = [RegistryAPI.Global getFloat: itemPath propertyPath: propertyPath defaultValue: defaultValue]; //__SILP__
    lua_pushnumber(L, value);                                                                                    //__SILP__
    return 1;                                                                                                    //__SILP__
}                                                                                                                //__SILP__

//SILP: LUA_PROPERTY_BEGIN(set, new_value, float, number, Float)
static int dap_set_float(lua_State *L) {                                                                    //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "new_value should be number!");                                 //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    float newValue = [[NSNumber numberWithFloat:(float)lua_tonumber(L, 3)] floatValue];
//SILP: LUA_PROPERTY_SET_END(float, number, Float)
    bool result = [RegistryAPI.Global setFloat: itemPath propertyPath: propertyPath value: newValue]; //__SILP__
    lua_pushboolean(L, result);                                                                       //__SILP__
    return 1;                                                                                         //__SILP__
}                                                                                                     //__SILP__

//SILP: LUA_PROPERTY_BEGIN(watch, default_value, float, number, Float)
static int dap_watch_float(lua_State *L) {                                                                  //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    float defaultValue = [[NSNumber numberWithFloat:(float)lua_tonumber(L, 3)] floatValue];
//SILP: LUA_PROPERTY_WATCH_END(float, number, Float)
    bool result = [RegistryAPI.Global watchFloat: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                   //__SILP__
    return 1;                                                                                                     //__SILP__
}                                                                                                                 //__SILP__

//SILP: LUA_PROPERTY_BEGIN(unwatch, default_value, float, number, Float)
static int dap_unwatch_float(lua_State *L) {                                                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    float defaultValue = [[NSNumber numberWithFloat:(float)lua_tonumber(L, 3)] floatValue];
//SILP: LUA_PROPERTY_UNWATCH_END(float, number, Float)
    bool result = [RegistryAPI.Global unwatchFloat: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                     //__SILP__
    return 1;                                                                                                       //__SILP__
}                                                                                                                   //__SILP__

//SILP: LUA_PROPERTY_BEGIN(add, default_value, double, number, Double)
static int dap_add_double(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    double value = [[NSNumber numberWithDouble:lua_tonumber(L, 3)] doubleValue];
//SILP: LUA_PROPERTY_ADD_END(double, number, Double)
    bool result = [RegistryAPI.Global addDouble: itemPath propertyPath: propertyPath value:value]; //__SILP__
    lua_pushboolean(L, result);                                                                    //__SILP__
    return 1;                                                                                      //__SILP__
}                                                                                                  //__SILP__

//SILP: LUA_PROPERTY_REMOVE(double, number, Double)
static int dap_remove_double(lua_State *L) {                                                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global removeDouble: itemPath propertyPath: propertyPath];                   //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__
//SILP: LUA_PROPERTY_IS(double, number, Double)
static int dap_is_double(lua_State *L) {                                                                    //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global isDouble: itemPath propertyPath: propertyPath];                       //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__

//SILP: LUA_PROPERTY_BEGIN(get, default_value, double, number, Double)
static int dap_get_double(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    double defaultValue = [[NSNumber numberWithDouble:lua_tonumber(L, 3)] doubleValue];
//SILP: LUA_PROPERTY_GET_END(double, number, Double)
    double value = [RegistryAPI.Global getDouble: itemPath propertyPath: propertyPath defaultValue: defaultValue]; //__SILP__
    lua_pushnumber(L, value);                                                                                      //__SILP__
    return 1;                                                                                                      //__SILP__
}                                                                                                                  //__SILP__

//SILP: LUA_PROPERTY_BEGIN(set, new_value, double, number, Double)
static int dap_set_double(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "new_value should be number!");                                 //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    double newValue = [[NSNumber numberWithDouble:lua_tonumber(L, 3)] doubleValue];
//SILP: LUA_PROPERTY_SET_END(double, number, Double)
    bool result = [RegistryAPI.Global setDouble: itemPath propertyPath: propertyPath value: newValue]; //__SILP__
    lua_pushboolean(L, result);                                                                        //__SILP__
    return 1;                                                                                          //__SILP__
}                                                                                                      //__SILP__

//SILP: LUA_PROPERTY_BEGIN(watch, default_value, double, number, Double)
static int dap_watch_double(lua_State *L) {                                                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    double defaultValue = [[NSNumber numberWithDouble:lua_tonumber(L, 3)] doubleValue];
//SILP: LUA_PROPERTY_WATCH_END(double, number, Double)
    bool result = [RegistryAPI.Global watchDouble: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                    //__SILP__
    return 1;                                                                                                      //__SILP__
}                                                                                                                  //__SILP__

//SILP: LUA_PROPERTY_BEGIN(unwatch, default_value, double, number, Double)
static int dap_unwatch_double(lua_State *L) {                                                               //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isnumber(L, 3), 3, "default_value should be number!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    double defaultValue = [[NSNumber numberWithDouble:lua_tonumber(L, 3)] doubleValue];
//SILP: LUA_PROPERTY_UNWATCH_END(double, number, Double)
    bool result = [RegistryAPI.Global unwatchDouble: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                      //__SILP__
    return 1;                                                                                                        //__SILP__
}                                                                                                                    //__SILP__

//SILP: LUA_PROPERTY_BEGIN(add, new_value, string, string, String)
static int dap_add_string(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isstring(L, 3), 3, "new_value should be string!");                                 //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    NSString *value = [NSString stringWithCString:lua_tostring(L, 3) encoding:NSUTF8StringEncoding];
//SILP: LUA_PROPERTY_ADD_END(string, string, String)
    bool result = [RegistryAPI.Global addString: itemPath propertyPath: propertyPath value:value]; //__SILP__
    lua_pushboolean(L, result);                                                                    //__SILP__
    return 1;                                                                                      //__SILP__
}                                                                                                  //__SILP__

//SILP: LUA_PROPERTY_REMOVE(string, string, String)
static int dap_remove_string(lua_State *L) {                                                                //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global removeString: itemPath propertyPath: propertyPath];                   //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__
//SILP: LUA_PROPERTY_IS(string, string, String)
static int dap_is_string(lua_State *L) {                                                                    //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
                                                                                                            //__SILP__
    bool result = [RegistryAPI.Global isString: itemPath propertyPath: propertyPath];                       //__SILP__
    lua_pushboolean(L, result);                                                                             //__SILP__
    return 1;                                                                                               //__SILP__
}                                                                                                           //__SILP__

//SILP: LUA_PROPERTY_BEGIN(get, default_value, string, string, String)
static int dap_get_string(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isstring(L, 3), 3, "default_value should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    NSString *defaultValue = [NSString stringWithCString:lua_tostring(L, 3) encoding:NSUTF8StringEncoding];
    NSString *value = [RegistryAPI.Global getString: itemPath propertyPath: propertyPath defaultValue: defaultValue];
    lua_pushstring(L, [value cStringUsingEncoding:NSUTF8StringEncoding]);
    return 1;
}

//SILP: LUA_PROPERTY_BEGIN(set, new_value, string, string, String)
static int dap_set_string(lua_State *L) {                                                                   //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isstring(L, 3), 3, "new_value should be string!");                                 //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    NSString *newValue = [NSString stringWithCString:lua_tostring(L, 3) encoding:NSUTF8StringEncoding];
//SILP: LUA_PROPERTY_SET_END(string, string, String)
    bool result = [RegistryAPI.Global setString: itemPath propertyPath: propertyPath value: newValue]; //__SILP__
    lua_pushboolean(L, result);                                                                        //__SILP__
    return 1;                                                                                          //__SILP__
}                                                                                                      //__SILP__

//SILP: LUA_PROPERTY_BEGIN(watch, default_value, string, string, String)
static int dap_watch_string(lua_State *L) {                                                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isstring(L, 3), 3, "default_value should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    NSString *defaultValue = [NSString stringWithCString:lua_tostring(L, 3) encoding:NSUTF8StringEncoding];
//SILP: LUA_PROPERTY_WATCH_END(string, string, String)
    bool result = [RegistryAPI.Global watchString: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                    //__SILP__
    return 1;                                                                                                      //__SILP__
}                                                                                                                  //__SILP__

//SILP: LUA_PROPERTY_BEGIN(unwatch, default_value, string, string, String)
static int dap_unwatch_string(lua_State *L) {                                                               //__SILP__
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");                                 //__SILP__
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");                             //__SILP__
    luaL_argcheck(L, lua_isstring(L, 3), 3, "default_value should be string!");                             //__SILP__
                                                                                                            //__SILP__
    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];     //__SILP__
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding]; //__SILP__
    NSString *defaultValue = [NSString stringWithCString:lua_tostring(L, 3) encoding:NSUTF8StringEncoding];
//SILP: LUA_PROPERTY_UNWATCH_END(string, string, String)
    bool result = [RegistryAPI.Global unwatchString: itemPath propertyPath: propertyPath defaultValue:defaultValue]; //__SILP__
    lua_pushboolean(L, result);                                                                                      //__SILP__
    return 1;                                                                                                        //__SILP__
}                                                                                                                    //__SILP__

/* get from http://stackoverflow.com/questions/4125971/setting-the-global-lua-path-variable-from-c-c */
static int setLuaPath(lua_State* L, const char* path) {
    lua_getglobal( L, "package" );
    lua_getfield( L, -1, "path" ); // get field "path" from table at top of stack (-1)
    lua_pop( L, 1 ); // get rid of the string on the stack we just pushed on line 5
    lua_pushstring( L, path); // push the new one
    lua_setfield( L, -2, "path" ); // set the field "path" in table at -2 with value at top of stack
    lua_pop( L, 1 ); // get rid of package table from top of stack
    return 0; // all done!
}

static const char *daplib_name = "_dap";
static const luaL_Reg daplib[] =
{
    //Item functions
    { "add_item", dap_add_item},
    { "remove_item", dap_remove_item},
    { "is_item", dap_is_item},
    { "dump_item", dap_dump_item},
    { "load_item", dap_load_item},
    { "clone_item", dap_clone_item},
    //Channel functions
    { "fire_event", dap_fire_event },
    { "listen_event", dap_listen_event },
    { "unlisten_event", dap_unlisten_event },
    { "add_channel", dap_add_channel },
    { "remove_channel", dap_remove_channel },
    //Handler functions
    { "handle_request", dap_handle_request },
    { "listen_request", dap_listen_request },
    { "unlisten_request", dap_unlisten_request },
    { "listen_response", dap_listen_response },
    { "unlisten_response", dap_unlisten_response },
    { "add_handler", dap_add_handler },
    { "remove_handler", dap_remove_handler },
    //SILP: LUA_PROPERTY_FUNCTIONS(bool)
    { "add_bool", dap_add_bool },                                     //__SILP__
    { "remove_bool", dap_remove_bool },                               //__SILP__
    { "is_bool", dap_is_bool },                                       //__SILP__
    { "get_bool", dap_get_bool },                                     //__SILP__
    { "set_bool", dap_set_bool },                                     //__SILP__
    { "watch_bool", dap_watch_bool },                                 //__SILP__
    { "unwatch_bool", dap_unwatch_bool },                             //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(int)
    { "add_int", dap_add_int },                                       //__SILP__
    { "remove_int", dap_remove_int },                                 //__SILP__
    { "is_int", dap_is_int },                                         //__SILP__
    { "get_int", dap_get_int },                                       //__SILP__
    { "set_int", dap_set_int },                                       //__SILP__
    { "watch_int", dap_watch_int },                                   //__SILP__
    { "unwatch_int", dap_unwatch_int },                               //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(long)
    { "add_long", dap_add_long },                                     //__SILP__
    { "remove_long", dap_remove_long },                               //__SILP__
    { "is_long", dap_is_long },                                       //__SILP__
    { "get_long", dap_get_long },                                     //__SILP__
    { "set_long", dap_set_long },                                     //__SILP__
    { "watch_long", dap_watch_long },                                 //__SILP__
    { "unwatch_long", dap_unwatch_long },                             //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(float)
    { "add_float", dap_add_float },                                   //__SILP__
    { "remove_float", dap_remove_float },                             //__SILP__
    { "is_float", dap_is_float },                                     //__SILP__
    { "get_float", dap_get_float },                                   //__SILP__
    { "set_float", dap_set_float },                                   //__SILP__
    { "watch_float", dap_watch_float },                               //__SILP__
    { "unwatch_float", dap_unwatch_float },                           //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(double)
    { "add_double", dap_add_double },                                 //__SILP__
    { "remove_double", dap_remove_double },                           //__SILP__
    { "is_double", dap_is_double },                                   //__SILP__
    { "get_double", dap_get_double },                                 //__SILP__
    { "set_double", dap_set_double },                                 //__SILP__
    { "watch_double", dap_watch_double },                             //__SILP__
    { "unwatch_double", dap_unwatch_double },                         //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(string)
    { "add_string", dap_add_string },                                 //__SILP__
    { "remove_string", dap_remove_string },                           //__SILP__
    { "is_string", dap_is_string },                                   //__SILP__
    { "get_string", dap_get_string },                                 //__SILP__
    { "set_string", dap_set_string },                                 //__SILP__
    { "watch_string", dap_watch_string },                             //__SILP__
    { "unwatch_string", dap_unwatch_string },                         //__SILP__
    { NULL, NULL }
};

@end
