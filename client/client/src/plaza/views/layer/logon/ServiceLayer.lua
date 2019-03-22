--[[
	服务条款页面
	2016_06_03 Ravioyla
	功能：显示服务条款
]]
-- 登陆(二级弹窗)
-- 设置(三级弹窗)

local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local ServiceLayer = class("ServiceLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")

local TAG_START             = 100
local enumTable = 
{
    "BTN_CLOSE",            -- 关闭
    "BTN_FANKUI",           -- 反馈
    "BTN_FANKUILIST",       -- 反馈列表
    "BTN_WENTI",            -- 常见问题
    "BTN_JIANYI",           -- 提建议
    "BTN_CHONGZHI",         -- 充值问题
    "BTN_DAILI",            -- 代理问题
    "BTN_OTHER",            -- 其他问题
    "BTN_POST",             -- 提交反馈

}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)

function ServiceLayer:ctor( scene, param, level )
    ServiceLayer.super.ctor( self, scene, param, level )
	-- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("service/ServiceLayer.csb", self)

    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 底板
    local spbg = csbNode:getChildByName("sp_bg")
    self.m_spBg = spbg

    -- 关闭
    local btn = spbg:getChildByName("btn_close")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)

    --反馈按钮
    self.btnfankui = spbg:getChildByName("btn_fankui") 
    self.btnfankui:setTag(TAG_ENUM.BTN_FANKUI)
    self.btnfankui:addTouchEventListener( touchFunC )
    self.btnfankui:setPressedActionEnabled(true)
    self.btnfankui:setTouchEnabled(false)
    self.btnfankui:setBright(false)

    --反馈列表按钮
    self.btnlist = spbg:getChildByName("btn_fankuilist")
    self.btnlist:setTag(TAG_ENUM.BTN_FANKUILIST)
    self.btnlist:addTouchEventListener( touchFunC )
    self.btnlist:setPressedActionEnabled(true)

    --常见问题按钮
    self.wenti = spbg:getChildByName("btn_changjianwenti")
    self.wenti:setTag(TAG_ENUM.BTN_WENTI)
    self.wenti:addTouchEventListener( touchFunC )
    self.wenti:setPressedActionEnabled(true)   

    --反馈消息列表
    self.Panel_layout2 = spbg:getChildByName("Panel_layout_0")
    self.Panel_layout2:setVisible(false)

    --提交反馈列表
    self.Panel_layout1 = spbg:getChildByName("Panel_layout")

    --提交反馈
    self.btnpost = self.Panel_layout1:getChildByName("btn_post")
    self.btnpost:setTag(TAG_ENUM.BTN_POST)
    self.btnpost:addTouchEventListener( touchFunC )
    self.btnpost:setPressedActionEnabled(true)

    --提建议
    self.btnjianyi = self.Panel_layout1:getChildByName("btn_jianyi")
    self.btnjianyi:setTag(TAG_ENUM.BTN_JIANYI)
    self.btnjianyi:addTouchEventListener( touchFunC )
    self.btnjianyi:setPressedActionEnabled(true)
    self.btnjianyi:setTouchEnabled(false)
    self.btnjianyi:setBright(false)

   --充值问题
    self.btnchongzhi = self.Panel_layout1:getChildByName("btn_chongzhi")
    self.btnchongzhi:setTag(TAG_ENUM.BTN_CHONGZHI)
    self.btnchongzhi:addTouchEventListener( touchFunC )
    self.btnchongzhi:setPressedActionEnabled(true)

    --代理问题
    self.btndaili = self.Panel_layout1:getChildByName("btn_daili")
    self.btndaili:setTag(TAG_ENUM.BTN_DAILI)
    self.btndaili:addTouchEventListener( touchFunC )
    self.btndaili:setPressedActionEnabled(true)

    --其他问题
    self.btnother = self.Panel_layout1:getChildByName("btn_other")
    self.btnother :setTag(TAG_ENUM.BTN_OTHER)
    self.btnother :addTouchEventListener( touchFunC )
    self.btnother :setPressedActionEnabled(true)

    --（玩家）输入反馈
    local localTxtprintf = self.Panel_layout1:getChildByName("TextField") 

    --回复反馈
    local Txtfankui = self.Panel_layout2:getChildByName("Text_fankui")


     --加载动画
    self:scaleTransitionIn(spbg)
    self:scaleShakeTransitionIn(spbg)
end

-- 按键监听
function ServiceLayer:onButtonClickedEvent(tag,sender)
	if tag == TAG_ENUM.TAG_MASK or tag == TAG_ENUM.BTN_CLOSE then
        self:scaleTransitionOut(self.m_spBg)
    elseif tag == TAG_ENUM.BTN_FANKUI then
        self:popfankui()
    elseif tag == TAG_ENUM.BTN_FANKUILIST then
        self:popfankuilist()
    elseif tag == TAG_ENUM.BTN_WENTI then
        self:popwenti()    
    elseif tag == TAG_ENUM.BTN_JIANYI then
        self:popjianyi()
    elseif tag == TAG_ENUM.BTN_CHONGZHI then
        self:popchongzhi()
    elseif tag == TAG_ENUM.BTN_DAILI then
        self:popdaili()
    elseif tag == TAG_ENUM.BTN_OTHER then
        self:popother()
    elseif tag == TAG_ENUM.BTN_POST then
        self:poppost()
    --[[elseif tag == TAG_ENUM.TAG_TEL then
        local szText = GlobalUserItem.tabServiceCache["Phone"]
        if type(szText) == "string" and szText ~= "" then
            MultiPlatform:getInstance():systemCall(szText)
        end
    elseif tag == TAG_ENUM.TAG_QQ then
        local szText = GlobalUserItem.tabServiceCache["QQ"]
        if type(szText) == "string" and szText ~= "" then
            MultiPlatform:getInstance():copyToClipboard(szText)
        end
    elseif tag == TAG_ENUM.TAG_WX then
        local szText = GlobalUserItem.tabServiceCache["WeiXin"]
        if type(szText) == "string" and szText ~= "" then
            MultiPlatform:getInstance():copyToClipboard(szText)
        end]]
	end
end

function ServiceLayer:poppost()
    print("提交反馈")

end
function ServiceLayer:popjianyi()
    self:setopen(self.btnother )
    self:setopen(self.btnchongzhi)
    self:setopen(self.btndaili)
    self:setclose(self.btnjianyi)
end

function ServiceLayer:popchongzhi()
    self:setopen(self.btnjianyi)
    self:setopen(self.btnother )
    self:setopen(self.btndaili)
    self:setclose(self.btnchongzhi)
end

function ServiceLayer:popdaili()
    self:setopen(self.btnjianyi)
    self:setopen(self.btnchongzhi)
    self:setopen(self.btnother )
    self:setclose(self.btndaili)
end

function ServiceLayer:popother()
    self:setopen(self.btnjianyi)
    self:setopen(self.btnchongzhi)
    self:setopen(self.btndaili)
    self:setclose(self.btnother )
end

function ServiceLayer:popwenti()
    self:setopen(self.btnfankui)
    self:setopen(self.btnlist)
    self:setclose(self.wenti)
     
    self.Panel_layout2:setVisible(true)
    self.Panel_layout1:setVisible(false)   
end

function ServiceLayer:popfankuilist()
    self:setopen(self.wenti)
    self:setopen(self.btnfankui)
    self:setclose(self.btnlist)
     
    self.Panel_layout2:setVisible(true)
    self.Panel_layout1:setVisible(false)
end

function ServiceLayer:popfankui()
    self:setopen(self.wenti)
    self:setopen(self.btnlist)
    self:setclose(self.btnfankui)

    self.Panel_layout2:setVisible(false)
    self.Panel_layout1:setVisible(true)
end

function ServiceLayer:setopen(sender)
    sender:setBright(true)
    sender:setTouchEnabled(true)
end

function ServiceLayer:setclose(sender)
    sender:setBright(false)
    sender:setTouchEnabled(false)
end

function ServiceLayer:onTransitionInBegin()
    self:sendShowEvent()
end

function ServiceLayer:onTransitionOutBegin()
    self:sendHideEvent()
end

function ServiceLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function ServiceLayer:refreshInfo()
   --[[ local qrcontent = yl.HTTP_URL
    local sztel = ""
    local szqq = ""
    local szwx = ""
    if nil ~= GlobalUserItem.tabServiceCache then
        qrcontent = tostring(GlobalUserItem.tabServiceCache["Link"]) or ""
        local tmp = tostring(GlobalUserItem.tabServiceCache["Phone"]) or ""
        sztel = string.format("%s", tmp)
        tmp = tostring(GlobalUserItem.tabServiceCache["QQ"]) or ""
        szqq = string.format("%s", tmp)
        tmp = tostring(GlobalUserItem.tabServiceCache["WeiXin"]) or ""
        szwx = string.format("%s", tmp)
    end
    -- 电话
    self.m_txtTel:setString(sztel)
    -- qq
    self.m_txtQQ:setString(szqq)
    -- wx
    self.m_txtWX:setString(szwx)
    
    local tmpqr = self.m_spBg:getChildByName("tmp_qr")
    -- 二维码
    local qr = QrNode:createQrNode(qrcontent, tmpqr:getContentSize().width, 5, 1)
    self.m_spBg:addChild(qr)
    qr:setPosition(tmpqr:getPosition())
    tmpqr:removeFromParent()]]
end

return ServiceLayer