local unpack = table.unpack or unpack -- luacheck: ignore 143 113
-- 5.1 (W143) accessing undefined field unpack of global table
-- 5.2 (W113) accessing undefined variable unpack

--- A lightweight dependency injection container for Lua.
-- Supports singleton instances, constructor injection, and circular dependency detection.
-- @module DIContainer
-- @classmod DIContainer
local DIContainer = {}
DIContainer.__index = DIContainer

--- Creates a new DI container instance.
-- @treturn DIContainer A new container instance
function DIContainer:new()
    local instance = setmetatable({
        dependencies = {},
        instances = {}
    }, self)
    return instance
end

--- Registers a dependency with the container.
-- @string name Unique identifier for the dependency
-- @tparam table dependency Dependency configuration table
-- @tparam function dependency.constructor Factory function that creates the instance
-- @tparam[opt] table dependency.dependencies Array of dependency names required by the constructor
-- @raise Error if `dependency` is not a table or missing a constructor function
function DIContainer:register(name, dependency)
    if type(dependency) ~= "table" then
        error("Dependency must be a table")
    end
    if type(dependency.constructor) ~= "function" then
        error("Dependency must have a constructor function")
    end
    self.dependencies[name] = dependency
end

--- Resolves a dependency by name.
-- @string name Name of the dependency to resolve
-- @tparam[opt] table stack Internal tracking for circular dependency detection
-- @treturn any The resolved dependency instance
-- @raise Error if dependency is not registered or if a circular dependency is detected
function DIContainer:resolve(name, stack)
    stack = stack or {}

    if stack[name] then
        error("Circular dependency detected: " .. name)
    end

    if self.instances[name] then
        return self.instances[name]
    end

    local dependency = self.dependencies[name]
    if not dependency then
        error("Dependency not registered: " .. name)
    end

    stack[name] = true

    local deps = {}
    for _, depName in ipairs(dependency.dependencies or {}) do
        table.insert(deps, self:resolve(depName, stack))
    end

    stack[name] = nil

    local constructor = dependency.constructor
    local instance

    instance = constructor(unpack(deps))

    self.instances[name] = instance
    return instance
end

return DIContainer
