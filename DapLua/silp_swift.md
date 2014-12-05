# REGISTRY_PROPERTY(type, swift_type) #
```swift
public func add${type}(itemPath: String, propertyPath: String, value: ${swift_type}) -> Bool {
    if let item: Item = registry.get(itemPath) {
        if let result = item.add${type}(propertyPath, value) {
            return true
        }
    }
    return false               
}

public func remove${type}(itemPath: String, propertyPath: String) -> Bool {
    if let item: Item = registry.get(itemPath) {
        if let result = item.remove${type}(propertyPath) {
            return true
        }
    }
    return false               
}

public func is${type}(itemPath: String, propertyPath: String) -> Bool {
    if let item: Item = registry.get(itemPath) {
        return item.is${type}(propertyPath)
    }
    return false               
}

public func get${type}(itemPath: String, propertyPath: String, defaultValue: ${swift_type}) -> ${swift_type} {
    if let item: Item = registry.get(itemPath) {
        if let value: ${swift_type} = item.get${type}(propertyPath) {
            return value
        }
    }
    return defaultValue
}

public func set${type}(itemPath: String, propertyPath: String, value: ${swift_type}) -> Bool {
    if let item: Item = registry.get(itemPath) {
        if let result = item.set${type}(propertyPath, value) {
            return result
        }
    }
    return false
}

public func watch${type}(itemPath: String, propertyPath: String, defaultValue: ${swift_type}) -> Bool {
    if let item: Item = registry.get(itemPath) {
        if let watchers = item.luaPropertyWatchers {
            if !watchers.has(propertyPath) {
                let watcher = Lua${type}ValueWatcher(luaState: luaState, itemPath: itemPath, defaultValue: defaultValue)
                watchers.addAnyVar(propertyPath, value: watcher)
                return item.properties.add${type}ValueWatcher(propertyPath, watcher: watcher)
            }
        }
    }
    return false
}
```

# LUA_VALUE_WATCHER(type, swift_type) #
```
public final class Lua${type}ValueWatcher : LuaElement, ${type}Property.ValueWatcher {   
    private let _defaultValue: ${swift_type}?

    public init(luaState: DapLuaState, itemPath: String, defaultValue: ${swift_type}) {
        super.init(luaState: luaState, itemPath: itemPath)
        _defaultValue = defaultValue
    }

    public func onChanged(propertyPath: String, lastValue: ${swift_type}?, value: ${swift_type}?) -> Void {
        if lastValue != nil && value != nil {
            self.luaState.on${type}Changed(itemPath, propertyPath: propertyPath,
                                           lastValue: lastValue!, value: value!)
        } else if lastValue != nil {
            self.luaState.on${type}Changed(itemPath, propertyPath: propertyPath,
                                           lastValue: lastValue!, value: _defaultValue!)
        } else if value != nil {
            self.luaState.on${type}Changed(itemPath, propertyPath: propertyPath,
                                           lastValue: _defaultValue!, value: value!)
        }
    }
}

```

# DYNAMIC_VARS(name) #
```
public var ${name}: Vars? {
    var result: Vars? = get("._${name}_.");
    if result == nil {
        result = add("._${name}_.")
    }
    return result;
}

``` 

# REGISTRY_LISTEN(name, var_name, aspect) #
```
public func listen${name}(itemPath: String, ${var_name}: String) -> Bool {
    if let item: Item = registry.get(itemPath) {
        if let listeners = item.lua${name}Listeners{
            if !listeners.has(${var_name}) {
                let listener = Lua${name}Listener(luaState: luaState, itemPath: itemPath)
                listeners.addAnyVar(${var_name}, value: listener)
                return item.${aspect}.add${name}Listener(${var_name}, listener: listener);
            }
        }
    }
    return false
}
```