package.path = "./examples/basic/?.lua;./src/?.lua;" .. package.path

local DIContainer = require("toasted_di_container")

local UserRepository = require("examples.basic.UserRepository")
local ListUsersUsecase = require("examples.basic.ListUsersUsecase")

local container = DIContainer:new()

container:register("userRepository", {
    constructor = function()
        return UserRepository:new()
    end
})

container:register("listUsersUsecase", {
    dependencies = {"userRepository"},
    constructor = function(userRepository)
        return ListUsersUsecase:new(userRepository)
    end
})

local userRepository = container:resolve("userRepository")
userRepository:add_user({ name = "Alice" })
userRepository:add_user({ name = "Bob" })

local listUsersUsecase = container:resolve("listUsersUsecase")
local users = listUsersUsecase:execute()

for _, user in ipairs(users) do
    print(user.name)
end
