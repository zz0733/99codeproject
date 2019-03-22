--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local RollMsg = class("RollMsg", cc.Node)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local PNG_MSG = "common/ui/zjm_paomadeng1.png"

function RollMsg:ctor()
    self:enableNodeEvents()
    
    self.m_root = nil

    -- 播放索引
    self._sysIndex = 1
    -- 消息是否运行
    self.m_bNotifyRunning = false
    -- 跑马灯内容
    self.m_tabMarquee = {}
    -- 消息id
    self.m_nNotifyId = 0
end

function RollMsg:onEnter()
    self:init()
end

function RollMsg:onExit()
end

function RollMsg:init()

    --节点
    self.m_root = display.newNode()
    self.m_root:addTo(self)

    local diffX = -25
    -- 系统消息
    local bg = cc.Scale9Sprite:create(PNG_MSG)
    bg:setPosition(cc.p(yl.WIDTH/2+diffX, yl.HEIGHT - 115))
    bg:setContentSize(cc.size(905,51))
    bg:addTo(self.m_root)

    local lb = cc.Sprite:create("common/ui/zjm_paomadeng3.png")
    lb:setAnchorPoint(cc.p(0.5, 0.5))
    lb:setPosition(cc.p(75+diffX,25))
    bg:addChild(lb)

    ExternalFun.playUnLoadCSBani("common/Marquee/pmd_light.csb", "pmd_light",bg, true,cc.p(500+diffX,15))

    local noticeSize = bg:getContentSize()
    self.m_noticeArea = noticeSize

    -- 消息区域
    local stencil = display.newSprite()
        :setAnchorPoint(cc.p(0,0.5))
    stencil:setTextureRect(cc.rect(0, 0, noticeSize.width - 100, noticeSize.height))
    self._notifyClip = cc.ClippingNode:create(stencil)
        :setAnchorPoint(cc.p(0,0.5))
    self._notifyClip:setInverted(false)
    self._notifyClip:move(100+diffX,noticeSize.height * 0.5 + 2)
    self._notifyClip:addTo(bg)
    self._notifyText = cc.LabelTTF:create("", "Arial", 26)
                                :addTo(self._notifyClip)
                                --:setTextColor(cc.c4b(255,191,123,255))
                                :setAnchorPoint(cc.p(0,0.5))
                                --:enableOutline(cc.c4b(79,48,35,255), 1)
end

-- 添加公告
function RollMsg:onAddNotice( msg )
    if type(msg) ~= "table" then
        dump(msg, "PlazaLayer:onAddNotice 参数非法", 6)
        return
    end
    table.insert( self.m_tabMarquee, msg )
    if not self.m_bNotifyRunning then
        self:onChangeNotify(self.m_tabMarquee[self._sysIndex])
    end
end

-- 循环公告
function RollMsg:onChangeNotify( msg )
    self._notifyText:stopAllActions()
    if not msg or not msg.title or #msg.title == 0 then
        self._notifyText:setString("")
        self.m_bNotifyRunning = false
        self._tipIndex = 1
        return
    end
    local showMessage = msg.title
    if not showMessage or #showMessage == 0 then
        self._notifyText:setString("")
        self.m_bNotifyRunning = false
        self._tipIndex = 1
        return
    end
    self.m_bNotifyRunning = true
    local msgcolor = cc.c4b(255,255,255,255)
    self._notifyText:setVisible(false)
    self._notifyText:setString(showMessage)
    --self._notifyText:setTextColor(msgcolor)

    if true == msg.autoremove then
        msg.showcount = msg.showcount or 0
        msg.showcount = msg.showcount - 1
        if msg.showcount <= 0 then
            self:removeNoticeById(msg.id)
        end
    end
    
    local tmpWidth = self._notifyText:getContentSize().width
    self._notifyText:runAction(
        cc.Sequence:create(
            cc.CallFunc:create( function()
                self._notifyText:move(self.m_noticeArea.width, 0)
                self._notifyText:setVisible(true)
            end),
            cc.MoveTo:create(6 + (tmpWidth / self.m_noticeArea.width) * 8,cc.p(0 - tmpWidth,0)),
            cc.CallFunc:create( function()
                local tipsSize = 0
                local tips = {}
                local index = 1
                -- 系统公告
               
                local tmp = self._sysIndex + 1
                if tmp > #self.m_tabMarquee then
                    tmp = 1
                end
                self._sysIndex = tmp
                self:onChangeNotify(self.m_tabMarquee[self._sysIndex])  
            end)
        )
    )
end

-- 移除公告
function RollMsg:removeNoticeById(id)
    if nil == id then
        return
    end
    local idx = nil
    for k,v in pairs(self.m_tabMarquee) do
        if nil ~= v.id and v.id == id then
            idx = k
            break
        end
    end
    if nil ~= idx then
        table.remove(self.m_tabMarquee, idx)
    end

end

cc.exports.RollMsg = RollMsg
return RollMsg
    
--endregion
    
