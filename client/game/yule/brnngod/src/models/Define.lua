--
-- Author: zhong
-- Date: 2016-11-02 17:46:07
--
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")

local Define = {}
local TAG_START             = 100
local enumTable = 
{
    "BT_EXIT",
    "BT_CHAT",
    "BT_TRU",
    "BT_SET",
    "BT_READY",
    "BT_CALLSCORE0",
    "BT_CALLSCORE1",
    "BT_CALLSCORE2",
    "BT_CALLSCORE3",
    "BT_PASS",
    "BT_SUGGEST",
    "BT_OUTCARD",
    "BT_INVITE",
    "BT_SWITCH_1",
    "BT_SWITCH_2"
}
Define.TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)

local zorders = 
{
    "RESULT_ZORDER",
    "PRIROOM_ZORDER",
    "CHAT_ZORDER",
    "EFFECT_ZORDER",
    "SET_ZORDER"
}
Define.TAG_ZORDER = ExternalFun.declarEnumWithTable(1, zorders)
Define.W_Bg_Effect    = 0                 -- 是否播放背景动画  0 不播放, 非0 播放
-- 叫分动画(基本)
Define.CALLSCORE_ANIMATION_KEY = "callscore_key"
-- 叫分1
Define.CALLONE_ANIMATION_KEY = "1_score_key"
-- 叫分2
Define.CALLTWO_ANIMATION_KEY = "2_score_key"
-- 叫分3
Define.CALLTHREE_ANIMATION_KEY = "3_score_key"
-- 飞机动画
Define.AIRSHIP_ANIMATION_KEY = "airship_key"
-- 火箭动画
Define.ROCKET_ANIMATION_KEY = "rocket_key"
-- 报警动画
Define.ALARM_ANIMATION_KEY = "alarm_key"
-- 炸弹动画
Define.BOMB_ANIMATION_KEY = "bomb_key"
-- 语音动画
Define.VOICE_ANIMATION_KEY = "voice_ani_key"

-- 托管延迟
Define.TRU_DELAY = 0.5

-- 获取所有节点
function Define:getNodeList(container,node)

    local node_list1 = (container==nil) and {} or container
    if node == nil then
        return node_list1
    end

    local children = node:getChildren()
    for k , v in ipairs(children) do

        local function seach_child(parente)
            local childCount = parente:getChildrenCount()
            if childCount < 1 then
                local name = parente:getName()
                local index = string.find(name,'_')
                if index ~= nil then
                    strIndex = string.sub(name,index+1,-1)
                    node_list1[strIndex] = parente
                end

            else
                for i = 1, childCount do
                    dump(parente)
                    local name = parente:getName()
                    local index = string.find(name,'_')
                    if index ~= nil then
                        strIndex = string.sub(name,index+1,-1)
                        node_list1[strIndex] = parente
                        seach_child(parente:getChildren()[i])
                    end

                end
            end
        end

        if #v:getChildren() < 1 then
            local name = v:getName()
            local index = string.find(name,'_')
            if index ~= nil then
                strIndex = string.sub(name,index+1,-1)
                node_list1[strIndex] = v
            end

        else
            seach_child(v)
        end
    end
    return node_list1
end

-- 创建头像
function Define:createStencilAvatar(Avatar, mark1, mark2)
    if Avatar == nil then
        return Avatar
    end

    if mark1 ~= nil then
        local sprMark1 = cc.Sprite:create(mark1)
        sprMark1:addTo(Avatar,-1)
    end

    if mark2 ~= nil then
        local sprMark2 = cc.Sprite:create(mark2)
        sprMark2:addTo(Avatar,-2)
    end

    return Avatar
end


--
function Define:loadName(txtName, strName, num)

    if string.len(strName) > num then
        strName = string.sub(0, num)..'...'
    end

    txtName:setString(strName)
end

function Define:performWithDelay(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    node:runAction(sequence)
    return sequence
end

function Define:createLayer(path)
    local layer = appdf.req(path)
    return layer:create()
end


return Define