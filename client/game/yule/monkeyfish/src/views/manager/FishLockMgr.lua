-- region *.lua
-- Date     2017.04.11
-- zhiyuan
-- 此文件由[BabeLua]插件自动生成

-- 定时器

local FishLockMgr = class("FishLockMgr")

FishLockMgr.instance_ = nil
function FishLockMgr.getInstance()
    if FishLockMgr.instance_ == nil then
        FishLockMgr.instance_ = FishLockMgr:new()
    end
    return FishLockMgr.instance_
end 

function FishLockMgr:ctor()

    self.rotate_angle_ = 0
    for i = 1, GAME_PLAYER_FISH do
        self.lock_fish_id_[i] = 0
        self.lock_fish_kind_[i] = FishKind.FISH_KIND_COUNT
    end
end 

function FishLockMgr:LoadGameResource()

    return true
end 

function FishLockMgr:OnFrame(delta_time)

    return false
end 

function FishLockMgr:OnRender(offset_x, offset_y, hscale, vscale)

    return false
end 

function FishLockMgr:UpdateLockTrace(chair_id, fish_pos_x, fish_pos_y)

end 

function FishLockMgr:ClearLockTrace(chair_id)

    self.lock_line_trace_[chair_id] = { }
    self.lock_fish_id_[chair_id] = 0
    self.lock_fish_kind_[chair_id] = FishKind.FISH_KIND_COUNT
end 

function FishLockMgr:LockPos(chair_id)

    if #self.lock_line_trace_[chair_id] == 0 then

        local pos = cc.p(0, 0)
        return pos
    else

        return self.lock_line_trace_[chair_id][#self.lock_line_trace_[chair_id]]
    end
end 

return FishLockMgr

-- endregion
