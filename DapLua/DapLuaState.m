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
- (void) initialize;

@end

@implementation DapLuaState

+ (DapLuaState *)sharedState {
    static DapLuaState *bridge;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bridge = [[DapLuaState alloc] init];
        [bridge initialize];
    });

    return bridge;
}

- (void)eval:(NSString *)script {
    int error = luaL_dostring(luaState, [script cStringUsingEncoding:NSUTF8StringEncoding]);
    if (error) {
        NSLog(@"Lua Error: %s", lua_tostring(luaState, -1));
    }
}

- (void)initialize {
    luaState = luaL_newstate();
    luaL_openlibs(luaState);

    luaopen_lpeg(luaState);
    luaopen_lfs(luaState);

    luaL_newlib(luaState, daplib);
    lua_setglobal(luaState, daplib_name);

    [self eval: @"package.loaded['lpeg'] = lpeg"];
    [self eval: @"package.loaded['lfs'] = lfs"];
    [self eval: @"package.loaded['dap'] = dap"];
    
    setLuaPath(luaState, "lua/?.lua;lua.dap/?.lua;lua.lib/?.lua");
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
//SILP: LUA_PROPERTY_GET_END(int, number, Int)
    int value = [RegistryAPI.Global getInt: itemPath propertyPath: propertyPath defaultValue: defaultValue]; //__SILP__
    lua_pushnumber(L, value);                                                                                //__SILP__
    return 1;                                                                                                //__SILP__
}                                                                                                            //__SILP__

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

static const char *daplib_name = "dap";
static const luaL_Reg daplib[] =
{
    //SILP: LUA_PROPERTY_FUNCTIONS(bool)
    { "add_bool",    dap_add_bool },                                  //__SILP__
    { "remove_bool", dap_remove_bool },                               //__SILP__
    { "is_bool",     dap_is_bool },                                   //__SILP__
    { "get_bool",    dap_get_bool },                                  //__SILP__
    { "set_bool",    dap_set_bool },                                  //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(int)
    { "add_int",    dap_add_int },                                    //__SILP__
    { "remove_int", dap_remove_int },                                 //__SILP__
    { "is_int",     dap_is_int },                                     //__SILP__
    { "get_int",    dap_get_int },                                    //__SILP__
    { "set_int",    dap_set_int },                                    //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(float)
    { "add_float",    dap_add_float },                                //__SILP__
    { "remove_float", dap_remove_float },                             //__SILP__
    { "is_float",     dap_is_float },                                 //__SILP__
    { "get_float",    dap_get_float },                                //__SILP__
    { "set_float",    dap_set_float },                                //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(double)
    { "add_double",    dap_add_double },                              //__SILP__
    { "remove_double", dap_remove_double },                           //__SILP__
    { "is_double",     dap_is_double },                               //__SILP__
    { "get_double",    dap_get_double },                              //__SILP__
    { "set_double",    dap_set_double },                              //__SILP__
    //SILP: LUA_PROPERTY_FUNCTIONS(string)
    { "add_string",    dap_add_string },                              //__SILP__
    { "remove_string", dap_remove_string },                           //__SILP__
    { "is_string",     dap_is_string },                               //__SILP__
    { "get_string",    dap_get_string },                              //__SILP__
    { "set_string",    dap_set_string },                              //__SILP__
    { NULL, NULL }
};

@end
