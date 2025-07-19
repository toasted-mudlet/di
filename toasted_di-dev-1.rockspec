package = "toasted_di"
version = "dev-1"

source = {
    url = "git+https://github.com/toasted-mudlet/di-container.git",
    tag = "dev-1"
}

description = {
    summary = "A lightweight dependency injection container",
    detailed = [[
        A lightweight dependency injection container for constructor-based injection and singleton management.
    ]],
    homepage = "https://github.com/toasted-mudlet/di",
    license = "MIT"
}

dependencies = {
    "lua >= 5.1"
}

build = {
    type = "builtin",

    modules = {
        toasted_di = "src/toasted_di.lua"
    }
}
