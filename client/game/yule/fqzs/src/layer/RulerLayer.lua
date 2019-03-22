local CBetManager = require("game.yule.fqzs.src.manager.CBetManager")

local RulerLayer = class("RulerLayer", cc.Layer)

function RulerLayer:ctor()
    self:enableNodeEvents()

    self.m_pathUI = cc.CSLoader:createNode("game/animals/RulerLayer.csb")
    self:addChild(self.m_pathUI)
    local diffY = (display.size.height - 750) / 2
    self.m_pathUI:setPosition(cc.p(0,diffY))

    self.m_pNodeRoot    = self.m_pathUI:getChildByName("Panel_RuleAndContent")

    local diffX = 145 - (1624-display.size.width)/2
    self.m_pNodeRoot:setPositionX(diffX)

    local Image_BG = self.m_pNodeRoot:getChildByName("Image_BG")
    -- 动态设置税率
    local tip = Image_BG:getChildByName("Image_tips"):getChildByName("Text_15")
    local str = LuaUtils.getLocalString("STRING_236")
    tip:setString( string.format(str, CBetManager.getInstance():getGameTax() * 100) )
    
    -- 设置弹窗动画节点
    --self:setTargetActNode(Image_BG)
end

function RulerLayer:onEnter()
    self:initBtnEvent()
end

function RulerLayer:initBtnEvent( )

    local BTN_youxijieshao_select = ccui.Helper:seekWidgetByName(self.m_pNodeRoot, "BTN_youxijieshao_select")
    local BTN_youxiguize_select = ccui.Helper:seekWidgetByName(self.m_pNodeRoot, "BTN_youxiguize_select")
    local BTN_youxijieshao_normal = ccui.Helper:seekWidgetByName(self.m_pNodeRoot, "BTN_youxijieshao_normal")
    local BTN_youxiguize_normal = ccui.Helper:seekWidgetByName(self.m_pNodeRoot, "BTN_youxiguize_normal")
    local IMG_youxijieshao = ccui.Helper:seekWidgetByName(self.m_pNodeRoot, "IMG_youxijieshao")
    local IMG_youxiguize = ccui.Helper:seekWidgetByName(self.m_pNodeRoot, "IMG_youxiguize")

    IMG_youxijieshao:setVisible(true)
    IMG_youxiguize:setVisible(false)


    BTN_youxijieshao_normal:setVisible(false)
    BTN_youxiguize_normal:setVisible(true)
    BTN_youxijieshao_select:setVisible(true)
    BTN_youxiguize_select:setVisible(false)


    local Image_tips = ccui.Helper:seekWidgetByName(self.m_pNodeRoot, "Image_tips")
    Image_tips:setVisible(true)


    --游戏介绍
    BTN_youxijieshao_normal:addTouchEventListener(function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end

        IMG_youxijieshao:setVisible(true)
        IMG_youxiguize:setVisible(false)

        BTN_youxijieshao_normal:setVisible(false)
        BTN_youxiguize_normal:setVisible(true)
        BTN_youxijieshao_select:setVisible(true)
        BTN_youxiguize_select:setVisible(false)
--        AudioManager.getInstance():playSound("game/animals/soundpublic/sound-button.mp3")

    end)

    --游戏规则
    BTN_youxiguize_normal:addTouchEventListener(function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
        IMG_youxijieshao:setVisible(false)
        IMG_youxiguize:setVisible(true)

        BTN_youxijieshao_normal:setVisible(true)
        BTN_youxiguize_normal:setVisible(false)
        BTN_youxijieshao_select:setVisible(false)
        BTN_youxiguize_select:setVisible(true)
--        AudioManager.getInstance():playSound("game/animals/soundpublic/sound-button.mp3")
    end)

    --关闭按钮
    local BtnClose = ccui.Helper:seekWidgetByName(self.m_pNodeRoot, "BTN_guanbiGuiZe")
    BtnClose:addTouchEventListener(function (sender,eventType)
        if eventType ~= ccui.TouchEventType.ended then
            return
        end
--        AudioManager.getInstance():playSound("game/animals/soundpublic/sound-close.mp3")
        self:removeFromParent()
    end)
end

function RulerLayer:onExit()
end

return RulerLayer