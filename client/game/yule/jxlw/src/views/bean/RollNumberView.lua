-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成	

local SLFacade       = cc.exports.SLFacade

local RollNumberView = class("RollNumberView", cc.Node)

local DefaultRollTime = 0.15 --数字跳动间隔时间

--[[
    构建一个滚动数字显示节点
    @param numWidth: 单张数字图片宽度
    @param numHeight: 单张数字图片高度
    @param posVec: 所有数字显示坐标位置，此坐标为相对将要被添加的节点位置，横向排列
    @param hspace: 滚动数字上下显示间隔
    @param numImgPathFormat: 数字图片格式化路径 eg: "game/tiger/gui/gui-tiger-joke-num-%d.png"
    @param nullImgPath: 空图片路径 eg: "game/tiger/gui/gui-tiger-texture-null.png"
    @param rollTime: 单个精灵滚动时间，指数字图片从一个不可见位置滚动到完整显示位置所用时间
    @return 返回节点
]]--
function RollNumberView.create(numWidth, numHeight, posVec, hspace, numImgPathFormat, nullImgPath, rollTime)
    local RollNumberView = RollNumberView.new()
    RollNumberView:init(numWidth, numHeight, posVec, hspace, numImgPathFormat, nullImgPath, rollTime)
    return RollNumberView
end

function RollNumberView:init(numwidth, numHeight, posVec, hspace, numImgPathFormat, nullImgPath, rollTime)
    self.m_resNum = 0 -- 原始值
    self.m_numHeight = numHeight
    self.m_maxLength = #posVec
    self.m_pNumSprites = {}
    self.m_frameVec = {}
    self.n_rollTime = rollTime and rollTime or DefaultRollTime
    self.m_hSpace = hspace and hspace or 0
    for i = 0, 9 do
        self.m_frameVec[i] = string.format(numImgPathFormat, i)
    end
    self.m_frameVec[-1] = nullImgPath
    self:createClipers(numwidth, numHeight, posVec)
end

--构建遮罩
function RollNumberView:createClipers(numwidth, numHeight, posVec)
    local maxWidth = posVec[#posVec].x + numwidth
    local shap = cc.DrawNode:create()
    local vecPoint = {cc.p(0, 0),
                      cc.p(maxWidth, 0),
                      cc.p(maxWidth, numHeight),
                      cc.p(0, numHeight)}
    shap:drawPolygon(vecPoint, 4, cc.c4f(255, 255, 255, 255), 2, cc.c4f(255, 255, 255, 255))
    local cliper = cc.ClippingNode:create(shap)
    cliper:setAnchorPoint(cc.p(0,0))
          :setPosition(cc.p(0, posVec[1].y))
          :addTo(self)

    for i = 1, self.m_maxLength do
        self.m_pNumSprites[i] = {}
        for j = 1, 2 do
            local sp = cc.Sprite:createWithSpriteFrameName(self.m_frameVec[-1])
            sp:setPosition(cc.p(posVec[i].x, 0))
              :setAnchorPoint(0, 0)
              :addTo(cliper)
              :setVisible(false)

            --附加业务属性
            sp.m_nowNum = -1        --现在显示的值(默认精灵显示空图片，这样在下一个精灵+1翻滚上来时，可以正好显示从0开始)
            sp.m_tagNum = 0         --目标值
            sp.m_isRoll = false     --标记是否正在动画过程中
            sp.m_rollUp = true      --默认向上翻滚 (向上翻滚为数值增加，向下翻滚为数值减少)

            table.insert(self.m_pNumSprites[i], sp)
        end
        --标记循环关联
        self.m_pNumSprites[i][1].m_nextSp = self.m_pNumSprites[i][2]
        self.m_pNumSprites[i][2].m_nextSp = self.m_pNumSprites[i][1]
    end
end

--初始数值
function RollNumberView:setInitNum(num)
    local val = num
    local idx = self.m_maxLength
    while val > 0 do
        local curval = val%10
        val = math.floor(val/10)
        self.m_pNumSprites[idx][1]:setVisible(true)
        self.m_pNumSprites[idx][1]:setSpriteFrame(self.m_frameVec[curval])
        self.m_pNumSprites[idx][1]:setPositionY(0)
        self.m_pNumSprites[idx][1].m_nextSp:setPositionY(-(self.m_numHeight + self.m_hSpace))
        self.m_pNumSprites[idx][1].m_nowNum = curval
        idx = idx - 1
    end
    self.m_resNum = num
end

--滚动到指定值
function RollNumberView:rollToNum(dstnum)
    local resnum = self.m_resNum
    self.m_resNum = dstnum
    if dstnum > resnum then
        --向上翻滚
        self:rollUp(dstnum)
    elseif dstnum < resnum then
        --向下翻滚
        self:rollDown(dstnum)
    end
end

--向上翻滚,数值从小到大
function RollNumberView:rollUp(num)
    local val = num
    local idx = self.m_maxLength
    while val > 0 do
        local curval = val%10
        val = math.floor(val/10)
        self:rollSingleNumUp(idx, curval)
        idx = idx - 1
    end
end

--向下翻滚,数值从大到小
function RollNumberView:rollDown(num)
    local val = num
    local idx = self.m_maxLength
    while val > 0 do
        local curval = val%1--0
        val = math.floor(val/1)--0)
        self:rollSingleNumDown(idx, curval)
        idx = idx - 1
    end

    --其他的值翻滚到空图片
    for i = 1, idx do
        self:rollSingleNumDown(i, -1)
    end
end

--翻滚单个数字
-- idx:数值位置索引
-- to:结束数值
function RollNumberView:rollSingleNumUp(idx, to)
    local sp = self:getViewSp(idx)
    sp.m_tagNum = to
    sp.m_nextSp.m_tagNum = to
    sp.m_rollUp = true
    if not sp.m_isRoll then
        self:loopRollUp(sp)
    end
end

--循环滚动数字直到目标值
function RollNumberView:loopRollUp(sp)
    sp:setVisible(true)
    --print(sp.m_nowNum .. "====>" .. sp.m_tagNum)
    if sp.m_nowNum == sp.m_tagNum then
        sp.m_isRoll = false
        sp.m_nextSp.m_isRoll = false
        return
    end
    local callback = cc.CallFunc:create(
        function()
            sp.m_isRoll = false
            self:loopRollUp(sp.m_nextSp)
        end
    )

    --如果有需要处理边界显示数字的特殊动画逻辑可以在此处
    --[[
        if sp.m_tagNum - sp.m_nowNum <2  then
            --递加减速？
        end
    ]]--

    local seq = cc.Sequence:create(cc.MoveTo:create(self.n_rollTime, cc.p(sp:getPositionX(), self.m_numHeight + self.m_hSpace)), callback)
    sp:runAction(seq)
    sp.m_isRoll = true

    if -1 == sp.m_nowNum and 1 == sp.m_tagNum then
        --当前显示的为空图片，并且目标数值为显示1，则下个图片不显示0
        sp.m_nextSp.m_nowNum = 1
    else
        sp.m_nextSp.m_nowNum = sp.m_nowNum + 1
    end

    sp.m_nextSp.m_nowNum = sp.m_nextSp.m_nowNum > 9 and 0 or sp.m_nextSp.m_nowNum
    sp.m_nextSp:setSpriteFrame(self.m_frameVec[sp.m_nextSp.m_nowNum])
    sp.m_nextSp:setVisible(true)
    sp.m_nextSp:setPositionY(-(self.m_numHeight + self.m_hSpace))
    sp.m_nextSp:runAction(cc.MoveTo:create(self.n_rollTime, cc.p(sp:getPositionX(), 0)))
    sp.m_nextSp.m_isRoll = true
end

function RollNumberView:rollSingleNumDown(idx, to)
    local sp = self:getViewSp(idx)
    sp.m_tagNum = to
    sp.m_nextSp.m_tagNum = to
    sp.m_rollUp = false
    if not sp.m_isRoll then
        self:loopRollDown(sp)
    end
end

--循环滚动数字直到目标值
function RollNumberView:loopRollDown(sp)
    sp:setVisible(true)
    if sp.m_nowNum == sp.m_tagNum then
        sp.m_isRoll = false
        sp.m_nextSp.m_isRoll = false
        return
    end
    local callback = cc.CallFunc:create(
        function()
            sp.m_isRoll = false
            self:loopRollDown(sp.m_nextSp)
        end
    )

    local seq = cc.Sequence:create(cc.MoveTo:create(self.n_rollTime, cc.p(sp:getPositionX(), -(self.m_numHeight + self.m_hSpace))), callback)
    sp:runAction(seq)
    sp.m_isRoll = true

    if 1 == sp.m_nowNum and -1 == sp.m_tagNum then
        --当前显示的为1，并且目标数值为显示空图片，则下个图片不显示0
        sp.m_nextSp.m_nowNum = - 1
    else
        --当前显示为0，并且目标值不为-1，则下一个滚动从9继续开始
        if 0 == sp.m_nowNum and -1 ~= sp.m_tagNum then
            sp.m_nextSp.m_nowNum = 9
        else
            sp.m_nextSp.m_nowNum = sp.m_nowNum - 1
        end
    end
    sp.m_nextSp.m_nowNum = sp.m_nextSp.m_nowNum < -1 and -1 or sp.m_nextSp.m_nowNum
    sp.m_nextSp:setSpriteFrame(self.m_frameVec[sp.m_nextSp.m_nowNum])
    sp.m_nextSp:setVisible(true)
    sp.m_nextSp:setPositionY(self.m_numHeight + self.m_hSpace)
    sp.m_nextSp:runAction(cc.MoveTo:create(self.n_rollTime, cc.p(sp:getPositionX(), 0)))
    sp.m_nextSp.m_isRoll = true
end

--获取当前显示的数字精灵
function RollNumberView:getViewSp(idx)
    local posy = self.m_pNumSprites[idx][1]:getPositionY()
    --动画过程中的精灵在动画结束后，才会自动处理目标值滚动
    if 0 == posy then
        return self.m_pNumSprites[idx][1]
    else
        return self.m_pNumSprites[idx][2]
    end
end

return RollNumberView
