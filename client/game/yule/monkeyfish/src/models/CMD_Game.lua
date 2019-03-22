--[[--
游戏命令
]]

local cmd = cmd or {}

--游戏标识
cmd.KIND_ID                 = 200

--我的炮台可用发射冷却时间
cmd.firingIntervalEnum  = { normal =  0.2, accelerate  =  0.15 }
--我锁的鱼类型
cmd.lockInEnum = { normal = 0, big = 1, especial = 2}


return cmd