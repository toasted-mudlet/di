package = "toasted_di_container"
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
    homepage = "https://github.com/toasted-mudlet/di_container",
    license = "MIT"
}

dependencies = {
    "lua >= 5.1"
}

build = {
    type = "builtin",

    modules = {
        toasted_di_container = "src/di_container.lua"
    }
}
