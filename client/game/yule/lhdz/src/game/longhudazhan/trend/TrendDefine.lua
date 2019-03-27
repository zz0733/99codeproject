local M = {}

M.LU_TYPE = {
    T1 = 1, -- 红
    T2 = 2, -- 蓝
    T3 = 3  -- 绿
}

local Lu = class('Lu')

function Lu:ctor(type, extra)
    self.type = type
    self.extra = extra
end

M.Lu = Lu

return M
