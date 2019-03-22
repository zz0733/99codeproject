--region *.lua
--Date
--
--endregion

local Effect = class("Effect")

Effect.g_instance = nil

SCORE_LABEL_NUM = 4

function Effect.getInstance()
    if not Effect.g_instance then
        Effect.g_instance = Effect:new()
    end
    return Effect.g_instance
end

function Effect.releaseInstance()
    Effect.g_instance = nil
end

function Effect:ctor()
    self.m_pLbResultScore = nil
    self.m_pSpGold = nil
    self._richText = nil
    self.m_lDesScore  = {}
    self.m_lSubScore  = {}
    self.m_lShowScore = {}
    self.m_iShowCount = {}
    self.m_pLbScore   = {}
    self.m_vecPaths = {}

    for i = 1, SCORE_LABEL_NUM do
        self.m_lDesScore[i] = 0
        self.m_lSubScore[i] = 0
        self.m_lShowScore[i] = 0
        self.m_iShowCount[i] = 0
        self.m_pLbScore[i] = 0
    end
    self.m_nChangeCount = 0
    self:Clear()

end

function Effect:Clear()
    self:cleanFileData()
    self.m_vecPaths = {}
    self.m_vecAllArmature = {}     
    self._richText = nil
    
    for i = 1, SCORE_LABEL_NUM do
        self.m_lDesScore[i] = 0
        self.m_lSubScore[i] = 0
        self.m_lShowScore[i] = 0
        self.m_iShowCount[i] = 0
        self.m_pLbScore[i] = 0
    end
end

function Effect:loadFileData(_path, _add)
    local manager = ccs.ArmatureDataManager:getInstance()
    for k,v in pairs(_path) do
        local path = v
        table.insert(self.m_vecPaths,path)
        if _add then
            manager:addArmatureFileInfo(path)
        end
    end
    return true
end

function Effect:cleanFileData()
    local manager = ccs.ArmatureDataManager:getInstance()
    for k,v in pairs(self.m_vecPaths) do
        manager:removeArmatureFileInfo(v)
    end
    self.m_vecPaths = {}
    self.m_vecAllArmature = {}
end

function Effect:getPathCount()
    return #self.m_vecPaths
end

function Effect:getPathAtIndex( index)
    local str = ""
    if index >= 1 and index <= #self.m_vecPaths then
        str = self.m_vecPaths[index]
    end
    return str
end

function Effect:creatEffectWithDelegate(node, _name, _playIndex, _control, _pos, _order)
    if not node or string.len(_name) < 0 then
        print("creat effect error.")
        return nil
    end
    local armData = ccs.ArmatureDataManager:getInstance():getAnimationData(_name)
    if (armData == nil) then 
        print("armData is nil.")
        return 
    end
    local layerIndex = _order or 1
    local armature = self:creatEffect(_name, _pos, _control)
    armature:getAnimation():playWithIndex(_playIndex,-1,-1)
    node:addChild(armature,layerIndex)
    return armature
end

function Effect:creatEffectWithDelegate2(node, _name , _playName, _control, _pos, _order)
    if not node or string.len(_name) <= 0 or string.len(_playName) <= 0 then
        print("creat effect error.")
        return 
    end
    local armData = ccs.ArmatureDataManager:getInstance():getAnimationData(_name)
    if (armData == nil) then 
        print("armData is nil.")
        return 
    end

    local layerIndex = _order or 1
    local pos = _pos or cc.p(667, 375)
    local armature = self:creatEffect(_name, pos, _control)
    armature:getAnimation():play(_playName)
    node:addChild(armature,layerIndex)
    
    return armature
end

function Effect:creatEffect(_name, _pos, _control)
    local armature = ccs.Armature:create(_name)
    armature:setPosition(_pos)
    if _control then
        table.insert( self.m_vecAllArmature,armature)
    end
    return armature
end

function Effect:showScoreChangeEffect(_label, _lastScore, _subScore, _dstScore, _index, _changeCount, callbf, callaf)
    local index = _index or 1
    local changeCount = _changeCount or 10
    if not _label or index < 1 or index >= SCORE_LABEL_NUM then
        return
    end
    self.m_nChangeCount = changeCount
    if _subScore == 0 or self.m_iShowCount[index] ~=0  then
        local strSocre = LuaUtils.getFormatGoldAndNumber(_dstScore)
        if index == 2 then
            local strSocre = LuaUtils.getFormatGoldAndNumber(_dstScore)
            _label:setString(strSocre)
            return
        end
    end
    self.m_lDesScore[index] = _dstScore
    self.m_lSubScore[index] = _subScore
    self.m_lShowScore[index] = _lastScore
    self.m_pLbScore[index] = _label
    self.m_iShowCount[index] = 0
    self.m_pLbScore[index]:setScale(1.3)

    if index == 1 then
        self:updateScoreChangeOne(callbf, callaf)
    elseif index == 2 then
        self:updateScoreChangeTwo()
    elseif index == 3 then
        self:updateScoreChangeThree()
    elseif index == 4 then
        self:updateScoreChangeFour()
    end
end

function Effect:showScoreChangeEffectWithNoSound(_label, _lastScore, _subScore, _dstScore, _changeCount, _hasFlag)
    local index = 1
    local changeCount = _changeCount or 10
    if not _label then
        return
    end
    self.m_nChangeCount = changeCount
    if _subScore == 0 or self.m_iShowCount[index] ~=0  then
        local strSocre = LuaUtils.getFormatGoldAndNumber(_dstScore)
    end
    self.m_lDesScore[index] = _dstScore
    self.m_lSubScore[index] = _subScore
    self.m_lShowScore[index] = _lastScore
    self.m_pLbScore[index] = _label
    self.m_iShowCount[index] = 0
    self.m_pLbScore[index]:setScale(1.3)
    local flag = _hasFlag==true and true or false
    self:updateScoreChangeFive(flag)
end

function Effect:updateScoreChangeOne(callbf, callaf)
    local index = 1
    if self:checkScoreChangeDone(index, true, true) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callbefore = cc.CallFunc:create(function()
        if callbf and type(callbf) == "function" then
            callbf()
        end
    end)
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeOne()
    end)
    local callafter = cc.CallFunc:create(function()
        if callaf and type(callaf) == "function" then
            callaf()
        end
    end)
    local seq = cc.Sequence:create(callbefore, cc.DelayTime:create(0.10), callback, callafter)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:updateScoreChangeTwo()
    local index = 2
    if self:checkScoreChangeDone(index, false, false) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeTwo()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.07), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:updateScoreChangeThree()
    local index = 3
    if self:checkScoreChangeDone(index, true, false) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeThree()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.1), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:updateScoreChangeFour()
    local index = 4
    if self:checkScoreChangeDone(index, true, true) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local scale = cc.EaseBackOut:create(cc.ScaleTo:create(0.05, 1.1))
    local back = cc.ScaleTo:create(0.05, 1.0)
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeFour()
    end)
    local seq = cc.Sequence:create(scale, back, callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:updateScoreChangeFive(flag)
    local index = 1
    if self:checkScoreChangeDone(index, true, false, flag) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    if flag then
        strScore = "+"..strScore
    end
    self.m_pLbScore[index]:setString(strScore)
    
--    local callbefore = cc.CallFunc:create(function()
--        if callbf and type(callbf) == "function" then
--            callbf()
--        end
--    end)
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeFive(flag)
    end)
--    local callafter = cc.CallFunc:create(function()
--        if callaf and type(callaf) == "function" then
--            callaf()
--        end
--    end)
--    local seq = cc.Sequence:create(callbefore, cc.DelayTime:create(0.10), callback, callafter)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.10), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:checkScoreChangeDone( index, format, sound, flag)
    if not self.m_pLbScore[index] then return true end
    local tmp = self.m_lShowScore[index]
    self.m_lShowScore[index] = tmp + (self.m_lSubScore[index]/self.m_nChangeCount)
    if self.m_lSubScore[index] < 0 and (self.m_lShowScore[index] <= self.m_lDesScore[index] or self.m_iShowCount[index] >= self.m_nChangeCount) then
        -- ¼õÉÙ
        self:socreChangeDone(index, format, sound, flag)
        return true
    end
    if self.m_lSubScore[index] >= 0  and (self.m_lShowScore[index] >= self.m_lDesScore[index] or self.m_iShowCount[index] >= self.m_nChangeCount) then
        -- Ôö¼Ó
        self:socreChangeDone(index, format, sound, flag)
        return true
    end
    return false
end

function Effect:socreChangeDone(index, format, sound, flag)
    local strScore = ""
    if (format) then
        strScore = LuaUtils.getFormatGoldAndNumber(self.m_lDesScore[index])
    else
        strScore = LuaUtils.getFormatGoldAndNumber(self.m_lDesScore[index])
    end
    if flag then
        strScore = "+"..strScore
    end
    self.m_pLbScore[index]:setString(strScore)
    self.m_iShowCount[index] = 0
    if (sound) then
         AudioManager.getInstance():playSound("public/sound/sound-gold.wav")
    end

    local scale = cc.EaseBackOut:create(cc.ScaleTo:create(1.0, 1))
    local callback = cc.CallFunc:create(function()
        self.m_pLbScore[index]:setScale(1.0)
    end)
    local seq = cc.Sequence:create(scale, callback)
    self.m_pLbScore[index]:runAction(seq)
end




function Effect:showScoreChangeEffect2(_label, _lastScore, _subScore, _dstScore, _index, _changeCount)
    local index = _index or 1
    local changeCount = _changeCount or 10
    if not _label or index < 1 or index >= SCORE_LABEL_NUM then
        return
    end
    self.m_nChangeCount = changeCount
    if _subScore == 0 or self.m_iShowCount[index] ~=0  then
        local strSocre = LuaUtils.getFormatGoldAndNumber(_dstScore)
        if index == 2 then
            local strSocre = LuaUtils.getFormatGoldAndNumber(_dstScore)
            _label:setString(strSocre)
            return
        end
    end
    self.m_lDesScore[index] = _dstScore
    self.m_lSubScore[index] = _subScore
    self.m_lShowScore[index] = _lastScore
    self.m_pLbScore[index] = _label
    self.m_iShowCount[index] = 0
    --self.m_pLbScore[index]:setScale(1.3 / 2)
    --self.m_pLbScore[index]:runAction(cc.ScaleTo:create(0.3, 1.3 /2))
    

    if index == 1 then
        self:updateScoreChangeOne2()
    elseif index == 2 then
        self:updateScoreChangeTwo2()
    elseif index == 3 then
        self:updateScoreChangeThree2()
    elseif index == 4 then
        self:updateScoreChangeFour2()
    end
end

function Effect:updateScoreChangeOne2()
    local index = 1
    if self:checkScoreChangeDone2(index, true, true) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeOne2()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.10), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:updateScoreChangeTwo2()
    local index = 2
    if self:checkScoreChangeDone2(index, false, false) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeTwo2()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.07), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:updateScoreChangeThree2()
    local index = 3
    if self:checkScoreChangeDone2(index, true, false) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeThree2()
    end)
    local seq = cc.Sequence:create(cc.DelayTime:create(0.1), callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:updateScoreChangeFour2()
    local index = 4
    if self:checkScoreChangeDone2(index, true, true) then
        return
    end
    local strScore = LuaUtils.getFormatGoldAndNumber(self.m_lShowScore[index])
    self.m_pLbScore[index]:setString(strScore)
    
    local scale = cc.EaseBackOut:create(cc.ScaleTo:create(0.05, 1.1/2))
    local back = cc.ScaleTo:create(0.05, 1.0/2)
    local callback = cc.CallFunc:create(function()
        self:updateScoreChangeFour2()
    end)
    local seq = cc.Sequence:create(scale, back, callback)
    self.m_pLbScore[index]:runAction(seq)
    local tmp = self.m_iShowCount[index]
    self.m_iShowCount[index] = tmp + 1
end

function Effect:checkScoreChangeDone2( index, format, sound)
    if not self.m_pLbScore[index] then return true end
    local tmp = self.m_lShowScore[index]
    self.m_lShowScore[index] = tmp + (self.m_lSubScore[index]/self.m_nChangeCount)
    if self.m_lSubScore[index] < 0 and (self.m_lShowScore[index] <= self.m_lDesScore[index] or self.m_iShowCount[index] >= self.m_nChangeCount) then
        -- ¼õÉÙ
        self:socreChangeDone2(index, format, sound)
        return true
    end
    if self.m_lSubScore[index] >= 0  and (self.m_lShowScore[index] >= self.m_lDesScore[index] or self.m_iShowCount[index] >= self.m_nChangeCount) then
        -- Ôö¼Ó
        self:socreChangeDone2(index, format, sound)
        return true
    end
    return false
end

function Effect:socreChangeDone2(index, format, sound)
    local strScore = ""
    if (format) then
        strScore = LuaUtils.getFormatGoldAndNumber(self.m_lDesScore[index])
    else
        strScore = LuaUtils.getFormatGoldAndNumber(self.m_lDesScore[index])
    end
    self.m_pLbScore[index]:setString(strScore)
    self.m_iShowCount[index] = 0
    if (sound) then
         AudioManager.getInstance():playSound("public/sound/sound-gold.wav")
    end

    -- local scale = cc.EaseBackOut:create(cc.ScaleTo:create(1.0, 1/2))
    -- local callback = cc.CallFunc:create(function()
    --     self.m_pLbScore[index]:setScale(1.0 / 2)
    -- end)
    -- local seq = cc.Sequence:create(scale, callback)
    -- self.m_pLbScore[index]:runAction(seq)
end

cc.exports.Effect = Effect
return Effect