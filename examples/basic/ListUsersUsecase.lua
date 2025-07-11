local ListUsersUsecase = {}
ListUsersUsecase.__index = ListUsersUsecase

function ListUsersUsecase:new(userRepository)
    return setmetatable({ userRepository = userRepository }, self)
end

function ListUsersUsecase:execute()
    return self.userRepository:get_all_users()
end

return ListUsersUsecase
