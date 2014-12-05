# LUA_CHANNEL_BEGIN(op, kind) #
```objectivec
static int dap_${op}(lua_State *L) {
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");
    luaL_argcheck(L, lua_isstring(L, 2), 2, "${kind}_path should be string!");

    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];
    NSString *${kind}Path = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];
```

# LUA_PRORERTY_CHANGED(c_type, lua_type, type) #
```
- (void)on${type}Changed: (NSString *)itemPath propertyPath: (NSString *)propertyPath
                lastValue: (${c_type})lastValue value: (${c_type})value {
    lua_call_function_begin(luaState, @"_on${type}Changed");
    lua_push_nsstring(luaState, itemPath);
    lua_push_nsstring(luaState, propertyPath);
    lua_push${lua_type}(luaState, lastValue);
    lua_push${lua_type}(luaState, value);
    lua_call_function_end(luaState, 4);
}
```

# LUA_PROPERTY_BEGIN(op, value_name, type, lua_type, swift_type) #
```objectivec
static int dap_${op}_${type}(lua_State *L) {
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");
    luaL_argcheck(L, lua_is${lua_type}(L, 3), 3, "${value_name} should be ${lua_type}!");

    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];
```

# LUA_PROPERTY_ADD_END(type, lua_type, swift_type) #
```objectivec
    bool result = [RegistryAPI.Global add${swift_type}: itemPath propertyPath: propertyPath value:value];
    lua_pushboolean(L, result);
    return 1;
}
```

# LUA_PROPERTY_WATCH_END(type, lua_type, swift_type) #
```objectivec
    bool result = [RegistryAPI.Global watch${swift_type}: itemPath propertyPath: propertyPath defaultValue:defaultValue];
    lua_pushboolean(L, result);
    return 1;
}
```

# LUA_PROPERTY_REMOVE(type, lua_type, swift_type) #
```objectivec
static int dap_remove_${type}(lua_State *L) {
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");

    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];

    bool result = [RegistryAPI.Global remove${swift_type}: itemPath propertyPath: propertyPath];
    lua_pushboolean(L, result);
    return 1;
}
```

# LUA_PROPERTY_IS(type, lua_type, swift_type) #
```objectivec
static int dap_is_${type}(lua_State *L) {
    luaL_argcheck(L, lua_isstring(L, 1), 1, "item_path should be string!");
    luaL_argcheck(L, lua_isstring(L, 2), 2, "property_path should be string!");

    NSString *itemPath = [NSString stringWithCString:lua_tostring(L, 1) encoding:NSUTF8StringEncoding];
    NSString *propertyPath = [NSString stringWithCString:lua_tostring(L, 2) encoding:NSUTF8StringEncoding];

    bool result = [RegistryAPI.Global is${swift_type}: itemPath propertyPath: propertyPath];
    lua_pushboolean(L, result);
    return 1;
}
```

# LUA_PROPERTY_GET_END(type, lua_type, swift_type) #
```objectivec
    ${type} value = [RegistryAPI.Global get${swift_type}: itemPath propertyPath: propertyPath defaultValue: defaultValue];
    lua_push${lua_type}(L, value);
    return 1;
}
```

# LUA_PROPERTY_SET_END(type, lua_type, swift_type) #
```objectivec
    bool result = [RegistryAPI.Global set${swift_type}: itemPath propertyPath: propertyPath value: newValue];
    lua_pushboolean(L, result);
    return 1;
}
```

# LUA_PROPERTY_FUNCTIONS(type) #
```
{ "add_${type}", dap_add_${type} },
{ "remove_${type}", dap_remove_${type} },
{ "is_${type}", dap_is_${type} },
{ "get_${type}", dap_get_${type} },
{ "set_${type}", dap_set_${type} },
{ "watch_${type}", dap_watch_${type} },
```
