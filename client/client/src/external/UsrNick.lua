--region *.lua
--Date
--
--endregion

UsrNick = class("UsrNick")

UsrNick.g_instance = nil

function UsrNick.getInstance()
    if not UsrNick.g_instance then
        UsrNick.g_instance = UsrNick:new()
    end
    return UsrNick.g_instance
end

function UsrNick:ctor()
    self._vecFirstName = {}
    self._vecLastName = {}
end

function UsrNick:initWithFile()

    local dict_of_usr_name_ = require(appdf.EXTERNAL_SRC .."UserName")

    for _, v in pairs(dict_of_usr_name_) do
        if v[1] then
            table.insert(self._vecFirstName, v[1])
        end
        if v[2] then
            table.insert(self._vecLastName, v[2])
        end
    end
    return true
end

function UsrNick:getFirstNameByIdx( nIdx) --1-n
    local strFirst = ""
    if (nIdx >=0 and nIdx < #self._vecFirstName) then
        strFirst = self._vecFirstName[nIdx]
    end
    return strFirst
end

function UsrNick:getLastNameByIdx( nIdx)
    local strLast = ""
    if (nIdx >=0 and nIdx < #self._vecLastName) then
        strLast = self._vecLastName[nIdx]
    end
    return strLast
end

function UsrNick:getNickNameByIdx( nFidx,  nLidx)
    local strNick = ""
    if #self._vecLastName == 0 and #self._vecLastName == 0 then
        self:initWithFile()
    end
    strNick = self:getLastNameByIdx(nLidx) .. self:getFirstNameByIdx(nFidx)
    return strNick
end

function UsrNick:getNumFirstName()
    if #self._vecFirstName == 0 then
        self:initWithFile()
    end
    return #self._vecFirstName
end

function UsrNick:getNumLastName()
    if (#self._vecLastName == 0) then
        self:initWithFile()
    end
    return #self._vecLastName
end

function UsrNick:getRandomNickName()
    
    local strNickName = ""
    local nFirstCount = self:getNumFirstName()
    local nLastCount = self:getNumLastName()
    while true do
        local nFidx = math.random(1, nFirstCount)
        local nLidx = math.random(1, nLastCount)
        strNickName = self:getNickNameByIdx(nFidx, nLidx)
        if LuaUtils.getCharLength(strNickName)>=6 and LuaUtils.getCharLength(strNickName)<=16 then
            break
        end
    end
    return strNickName
end

cc.exports.UsrNick = UsrNick
return UsrNick