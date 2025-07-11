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
