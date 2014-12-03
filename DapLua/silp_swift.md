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
                watchers.addBool(propertyPath, true)
                return item.properties.addWatcher(propertyPath,
                    {(lastValue: ${swift_type}?, value: ${swift_type}?) -> Void in
                        if lastValue != nil && value != nil {
                            self.luaState.on${type}Changed(itemPath, propertyPath: propertyPath,
                                                           lastValue: lastValue!, value: value!)
                        } else if lastValue != nil {
                            self.luaState.on${type}Changed(itemPath, propertyPath: propertyPath,
                                                           lastValue: lastValue!, value: defaultValue)
                        } else if value != nil {
                            self.luaState.on${type}Changed(itemPath, propertyPath: propertyPath,
                                                           lastValue: defaultValue, value: value!)
                        }
                }) != nil
            }
        }
    }
    return false
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