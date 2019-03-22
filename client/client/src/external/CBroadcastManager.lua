--CBroadcastManager *.lua
--Date:2017.08.02
--author: Goblin
--大厅滚动消息manger

local CBroadcastManager = class("CBroadcastManager")

CBroadcastManager.g_instance = nil
function CBroadcastManager.getInstance()
    if not CBroadcastManager.g_instance then
        CBroadcastManager.g_instance = CBroadcastManager:new()
    end
    return CBroadcastManager.g_instance
end

function CBroadcastManager.releaseInstance()
    CBroadcastManager.g_instance = nil
end

function CBroadcastManager:ctor()
    self.m_vecBroadcastDetails = {}
    self.m_vecPopBroadcast = {}
end

function CBroadcastManager:Clear()
    self.m_vecBroadcastDetails = {}
    self.m_vecPopBroadcast = {}
end

function CBroadcastManager:getBroadcastDetailsCount()
    return #self.m_vecBroadcastDetails
end 

function CBroadcastManager:addBroadcastDetailsInfo(info)
    table.insert(self.m_vecBroadcastDetails, info)
end

function CBroadcastManager:getBroadcastDetailsInfoAtIndex(index)
    return self.m_vecBroadcastDetails[index]
end

function CBroadcastManager:updateBroadcastDetailsInfo(msg)

    for k, v in pairs(self.m_vecBroadcastDetails) do
        if v.dwAnnounceID == msg.dwAnnounceID then
            v.wStatus = msg.wStatus
            break
        end
    end
end

function CBroadcastManager:delBroadcastDetailsInfoByID(msgID)

    for k, v in pairs(self.m_vecBroadcastDetails) do
        if v.dwAnnounceID == msgID then
            table.remove(self.m_vecBroadcastDetails, k)
        end
    end
end

--大厅弹出的公告
function CBroadcastManager:getPopBroadcastCount()
    return #self.m_vecPopBroadcast
end 

function CBroadcastManager:addPopBroadcastInfo(info)
    table.insert(self.m_vecPopBroadcast, info)
end

function CBroadcastManager:getPopBroadcastInfoAtIndex(index)
    return self.m_vecPopBroadcast[index]
end

function CBroadcastManager:delPopBroadcastInfoByID(msgID)

    for k, v in pairs(self.m_vecPopBroadcast) do
        if v.dwAnnounceID == msgID then
            table.remove(self.m_vecPopBroadcast, k)
        end
    end
end

return CBroadcastManager