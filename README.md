# Toasted DI

A lightweight dependency injection container.

## Features

- Constructor-based dependency injection
- Singleton management (one instance per dependency)
- Circular dependency detection

## Requirements

- **[Lua 5.1](https://www.lua.org/versions.html#5.1)** or higher (including LuaJIT)

> **Note:**
> This library uses unpack for argument unpacking. For compatibility, this
> library automatically uses table.unpack if available (Lua 5.2+), otherwise
> falls back to the global unpack (Lua 5.1).

## Installation

```
luarocks install toasted_di
```

Or, if using a custom tree:

```
luarocks install --tree=lua_modules toasted_di
```

## Usage

After installing, require the DI container in your Lua project:

```
local DIContainer = require("toasted_di")
local container = DIContainer:new()
```

> **To run the provided example:**  
> From the project root, execute:
> ```
> lua examples/basic/main.lua
> ```
> This will demonstrate registering and resolving dependencies as described below.

### Example: Registering and resolving dependencies

Suppose you have a simple in-memory repository and a usecase that depends on it:

```
-- UserRepository.lua
local UserRepository = {}
UserRepository.__index = UserRepository

function UserRepository:new()
    return setmetatable({ users = {} }, self)
end

function UserRepository:add_user(user)
    table.insert(self.users, user)
end

function UserRepository:get_all_users()
    return self.users
end

return UserRepository
```

```
-- ListUsersUsecase.lua
local ListUsersUsecase = {}
ListUsersUsecase.__index = ListUsersUsecase

function ListUsersUsecase:new(userRepository)
    return setmetatable({ userRepository = userRepository }, self)
end

function ListUsersUsecase:execute()
    return self.userRepository:get_all_users()
end

return ListUsersUsecase
```

### Registering dependencies

Register both the repository and the usecase with the DI container:

```
local UserRepository = require("UserRepository")
local ListUsersUsecase = require("ListUsersUsecase")

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
```

### Resolving and using the usecase

Now you can resolve the usecase and use it in your application:

```
local userRepository = container:resolve("userRepository")
userRepository:add_user({ name = "Alice" })
userRepository:add_user({ name = "Bob" })

local listUsersUsecase = container:resolve("listUsersUsecase")
local users = listUsersUsecase:execute()

for _, user in ipairs(users) do
    print(user.name)
end
-- Output:
-- Alice
-- Bob
```

## Attribution

If you create a new project based substantially on this dependency injection
container, please consider adding the following attribution or similar for all
derived code:

> This project is based on [Toasted DI](https://github.com/toasted-mudlet/di), originally
> licensed under the MIT License (see [LICENSE](LICENSE) for details). All
> original code and documentation remain under the MIT License.

## License

Copyright © 2025 github.com/toasted323

This project is licensed under the MIT License.
See [LICENSE](LICENSE) in the root of this repository for full details.
```
