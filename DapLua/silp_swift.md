# REGISTRY_PROPERTY(type) #
```swift
public func add${type}(itemPath: String, propertyPath: String, value: ${type}) -> Bool {
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

public func get${type}(itemPath: String, propertyPath: String, defaultValue: ${type}) -> ${type} {
    if let item: Item = registry.get(itemPath) {
        if let value: ${type} = item.get${type}(propertyPath) {
            return value
        }
    }
    return defaultValue
}

public func set${type}(itemPath: String, propertyPath: String, value: ${type}) -> Bool {
    if let item: Item = registry.get(itemPath) {
        if let result = item.set${type}(propertyPath, value) {
            return result
        }
    }
    return false
}
```
# DATA_NUMBER(type, ns_type) #
```
public func get${type}(key: String) -> ${type}? {
    if let _value: AnyObject = valueForKey(key) {
        if let value = _value as? NSNumber {
            return value.${ns_type}Value
        }
    }
    return nil
}

public func set${type}(key: String, value: ${type}) -> Bool {
    if valueForKey(key) == nil {
        setValue(NSNumber(${ns_type}: value), forKey: key)
        return true
    }
    return false
}
``` 

# DYNAMIC_VARS(name) #
```
public var {name}: Vars? {
    var result: Vars? = get("._{name}_.");
    if result == nil {
        result = add("._{name}_.")
    }
    return result;
}
``` 