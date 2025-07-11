local DIContainer = require "toasted_di_container"

describe("DIContainer", function()
    local container

    before_each(function()
        container = DIContainer:new()
    end)

    it("should create a new instance", function()
        assert.is_not_nil(container)
        assert.are.equal(type(container), "table")
    end)

    it("should register a dependency", function()
        container:register("test", {
            constructor = function()

                return "test value"
            end
        })
        assert.is_not_nil(container.dependencies["test"])
    end)

    it("should resolve a simple dependency", function()
        container:register("test", {
            constructor = function()
                return "test value"
            end
        })
        local result = container:resolve("test")
        assert.are.equal(result, "test value")
    end)

    it("should resolve nested dependencies", function()
        container:register("dep1", {
            constructor = function()
                return "dep1 value"
            end
        })
        container:register("dep2", {
            dependencies = {"dep1"},
            constructor = function(dep1)
                return dep1 .. " and dep2"
            end
        })
        local result = container:resolve("dep2")
        assert.are.equal(result, "dep1 value and dep2")
    end)

    it("should cache resolved instances", function()
        local constructorCalls = 0
        container:register("test", {
            constructor = function()
                constructorCalls = constructorCalls + 1
                return "test value"
            end
        })
        container:resolve("test")
        container:resolve("test")
        assert.are.equal(constructorCalls, 1)
    end)

    it("should throw an error for unregistered dependencies", function()
        assert.has_error(function()
            container:resolve("unregistered")
        end, "Dependency not registered: unregistered")
    end)

    it("should handle circular dependencies", function()
        container:register("circular1", {
            dependencies = {"circular2"},
            constructor = function(circular2)
                return "circular1"
            end
        })
        container:register("circular2", {
            dependencies = {"circular1"},
            constructor = function(circular1)
                return "circular2"
            end
        })
        assert.has_error(function()
            container:resolve("circular1")
        end, "Circular dependency detected: circular1")
    end)

    it("should allow dependency overriding", function()
        container:register("test", {
            constructor = function()
                return "original"
            end
        })
        container:register("test", {
            constructor = function()
                return "overridden"
            end
        })
        local result = container:resolve("test")
        assert.are.equal(result, "overridden")
    end)
end)
