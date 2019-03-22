--region LhdzUserInfoLayer.lua
--Date
--Auther Ace
--Desc [[龙虎斗玩家信息界面]]
--此文件由[BabeLua]插件自动生成

local LhdzUserInfoLayer = class("LhdzUserInfoLayer", cc.Layer)

local Lhdz_Res = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Res")

--_nStyle 为0，界面没有胜率和逃跑率
--_nStyle 为1，界面有胜率和逃跑率
function LhdzUserInfoLayer.create()
    return LhdzUserInfoLayer:new():init()
end

function LhdzUserInfoLayer:ctor()
    self:enableNodeEvents()
    self.handler = nil
end

function LhdzUserInfoLayer:init()

    self.m_rootUI = display.newNode()
    self.m_rootUI:addTo(self)
                   
    self.m_pathUI = cc.CSLoader:createNode(Lhdz_Res.CSB_OF_USERINFO)
    self.m_pathUI:addTo(self.m_rootUI)

    self.m_pNodeRoot = self.m_pathUI:getChildByName("Node_root")
    self.m_pSpHead = self.m_pNodeRoot:getChildByName("Sprite_head")
    self.m_pLbName = self.m_pNodeRoot:getChildByName("Text_name")
    self.m_pLbGold = self.m_pNodeRoot:getChildByName("Text_gold")

   return self
end 

function LhdzUserInfoLayer:onEnter()

end

function LhdzUserInfoLayer:onExit()
    self.handler = nil
end

function LhdzUserInfoLayer:updateUserInfo(userID)
    local user = CUserManager.getInstance():getUserInfoByUserID(userID)
    ------------------------------
    -- add by JackyXu on 2017.06.15.
    if not user then
        print("CommonUserInfo:updateUserInfo user is nil !!!")
        self:removeDialog()
    end
    ------------------------------
    
    local strNick = LuaUtils.getDisplayNickName2(user.szNickName, 200, "Helvetica", 24, "...")
    self.m_pLbName:setString( string.format(LuaUtils.getLocalString("STRING_154"),strNick or ""))
    self.m_pLbGold:setString( string.format(LuaUtils.getLocalString("STRING_157"), LuaUtils.getFormatGoldAndNumber(user.lScore or 0)))
    self.m_pSpHead:setTexture(string.format(Lhdz_Res.PNG_OF_HEAD, user.wFaceID % G_CONSTANTS.FACE_NUM + 1))

    local callback = cc.CallFunc:create(function()
        self:removeDialog()
    end)
    self.m_pNodeRoot:setOpacity(1)
    local fadeIn = cc.FadeTo:create(0.4, 220)
    local delay = cc.DelayTime:create(3)
    local fadeOut = cc.FadeTo:create(0.5, 0)
    self.m_pNodeRoot:runAction(cc.Sequence:create(fadeIn, delay, fadeOut, callback))
end

function LhdzUserInfoLayer:updateUserInfoByInfo(info)
    if not info then
        self:removeDialog()
    end
    local strNick = LuaUtils.getDisplayNickName(info[2], 8, true)
    self.m_pLbName:setString( string.format( "昵称:%s",strNick))
    self.m_pLbGold:setString( string.format("金币:%d",LuaUtils.getFormatGoldAndNumber(info[3] or 0)))

    self.m_pSpHead:setSpriteFrame( string.format(Lhdz_Res.PNG_OF_HEAD, info[1] % G_CONSTANTS.FACE_NUM + 1))
    
    local delayTime = 3 --3.5-info.fShowTimes > 0 and 3.5-info.fShowTimes or 0.1
    local callback = cc.CallFunc:create(function()
        self:removeDialog()
    end)

    self.m_pNodeRoot:setOpacity(1)
    local fadeIn = cc.FadeTo:create(0.4, 220)
    local delay = cc.DelayTime:create(3)
    local fadeOut = cc.FadeTo:create(0.5, 0)
    self.m_pNodeRoot:runAction(cc.Sequence:create(fadeIn, delay, fadeOut, callback))
end

function LhdzUserInfoLayer:setHandler(handler)
    self.handler = handler
end

function LhdzUserInfoLayer:removeDialog()
--    CUserManager:getInstance():deleteUserDialogByTag(self:getTag())
    if self.handler and self.handler.clearDialog then
        self.handler:clearDialog()
    else
        self:removeFromParent()
    end
end

return LhdzUserInfoLayer

--endregion
