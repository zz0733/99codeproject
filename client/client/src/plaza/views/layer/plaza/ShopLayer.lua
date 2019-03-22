--
-- Author: zhong
-- Date: 2017-05-25 17:08:11
--
-- 包含(商店界面-ShopLayer、 商店充值界面-ShopChargeLayer)

-- 商店界面(二级弹窗)
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local ShopLayer = class("ShopLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")

-- 商店充值(三级弹窗)
local ShopChargeLayer = class("ShopChargeLayer", TransitionLayer)
local LingQianPay = class("LingQianPay", TransitionLayer)

-- ui

local TAG_START             = 100
local enumTable = 
{
    "BTN_CLOSE",            -- 关闭按钮
    "TAG_MASK",             -- 遮罩
    "BTN_WX",               -- 微信充值
    "BTN_ALIPAY",           -- 支付宝充值
    "BTN_JFPAY",            -- 竣付通
    "BTN_LQ",               -- 零钱

    "CBT_SWITCH",           -- 切换
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)
-- 普通
local NORAML_PRODUCT = 0
-- 推荐
local RECOMMAND_PRODUCT = 1
-- 首充
local FIRSTPAY_PRODUCT = 2
local PAYTYPE = {}
PAYTYPE[TAG_ENUM.BTN_WX] =
{
    str = "wx",
    plat = yl.ThirdParty.WECHAT
}
PAYTYPE[TAG_ENUM.BTN_ALIPAY] =
{
    str = "zfb",
    plat = yl.ThirdParty.ALIPAY
}
PAYTYPE[TAG_ENUM.BTN_JFPAY] =
{
    str = "jft",
    plat = yl.ThirdParty.JFT
}
PAYTYPE[TAG_ENUM.BTN_LQ] =
{
    str = "lq",
    plat = yl.ThirdParty.LQ
}
-- 金币兑换
ShopLayer.ZFB = 1
-- 钻石充值
ShopLayer.WX = 2

local posConfig = 
{
    {{0.5},},       -- 1
    {{0.3},{0.7}},      -- 2
    {{0.20},{0.5},{0.8}},      -- 3
}

function ShopLayer:ctor( scene, param, level )
    local this = self
    ShopLayer.super.ctor( self, scene, param, level )
    -- 当前动作
    self.m_nAction = self._param or ShopLayer.ZFB

    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("hall/csb/ShopLayer.csb", self)
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            this:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

    -- 遮罩
    local mask = csbNode:getChildByName("panel_mask")
    mask:setTag(TAG_ENUM.TAG_MASK)
    mask:addTouchEventListener( touchFunC )

    -- 底板
    local spbg = csbNode:getChildByName("sp_bg")
    self.m_spBg = spbg


    -- 关闭
    local btn = spbg:getChildByName("btn_close")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
    btn:setPressedActionEnabled(true)

    -- 切换
    local checkboxlistener = function (sender,eventType)
        this:onSelectedEvent(sender:getTag(),sender)
    end

    --宝石购买
    local btnzfb = spbg:getChildByName("btn_zfb")
    btnzfb:addClickEventListener(checkboxlistener)
    btnzfb:setEnabled(self.m_nAction == ShopLayer.WX)
    btnzfb:setTag(ShopLayer.WX)
    self.m_btnzfb = btnzfb

    --金币购买
    local btnwx = spbg:getChildByName("btn_wx")
    btnwx:addClickEventListener(checkboxlistener)
    btnwx:setTag(ShopLayer.ZFB)
    btnwx:setEnabled(self.m_nAction == ShopLayer.ZFB)
    self.m_btnwx = btnwx

    self.m_tabDiamondList = {}
    self.m_tabGoldList = {}
    self.m_tabList = {}
    self.m_nListCount = 0
    -- 列表
    local tmp = spbg:getChildByName("content")
    local tmpsize = tmp:getContentSize()
    self.m_nCellSize = tmpsize.width / 3
    self._listView = cc.TableView:create(tmpsize)
    self._listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self._listView:setPosition(tmp:getPosition())
    self._listView:setDelegate()
    self._listView:addTo(spbg)
    --self._listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self._listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self._listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self._listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    --self._listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
    tmp:removeFromParent()
    self._listView:reloadData()

    -- 注册事件监听
    --self:registerEventListenr()
	
	    -- 事件监听
    self.m_listener = cc.EventListenerCustom:create(yl.RY_USERINFO_NOTIFY,handler(self, self.onUserInfoChange))
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_listener, self)

    self._scene.m_nSubtype = ""

    -- 加载动画
    self:scaleTransitionIn(spbg)
end

-- 按键监听
function ShopLayer:onButtonClickedEvent(tag,sender)
    if tag == TAG_ENUM.TAG_MASK or tag == TAG_ENUM.BTN_CLOSE then
        self:scaleTransitionOut(self.m_spBg)
    end
end

function ShopLayer:onSelectedEvent(tag, sender)
    self.m_btnwx:setEnabled(tag == ShopLayer.WX)
    self.m_btnzfb:setEnabled(tag == ShopLayer.ZFB)
    self._listView:reloadData()
end

function ShopLayer:animationRemove()
    self:scaleTransitionOut(self.m_spBg)
end

function ShopLayer:onTransitionInBegin()
    self:sendShowEvent()
end

function ShopLayer:onTransitionInFinish()
    for i = 1, 6 do
        local item = {}
        item["ImageType"] = math.random(1,4)
        item["ExchGold"] = i
        item["PayPrice"] = i
        table.insert(self.m_tabList, item)
    end
    self.m_nListCount = #self.m_tabList
    self._listView:reloadData()
end

function ShopLayer:onTransitionOutBegin()
    self:sendHideEvent()
end

function ShopLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function ShopLayer:onOtherShowEvent()
    if self:isVisible() then
        self:setVisible(false)
    end
end

function ShopLayer:onOtherHideEvent()
    if not self:isVisible() then
        self:setVisible(true) 
    end
end

function ShopLayer:tableCellTouched(view, cell)

end

-- 子视图大小
function ShopLayer:cellSizeForTable(view, idx)
    return self.m_nCellSize, view:getViewSize().height/2
end

local tabGoldImageType = 
{
    "shop/shop_sp_goldlarge_1.png", 
    "shop/shop_sp_goldlarge_2.png", 
    "shop/shop_sp_goldlarge_3.png", 
    "shop/shop_sp_goldlarge_4.png"
}
function ShopLayer:tableCellAtIndex(view, idx)
    print("重新绘制cell")
    local cell = view:dequeueCell()
    if not cell then        
        cell = cc.TableViewCell:new()
    else
        cell:removeAllChildren()
    end

    local this = self
    print("获取商城商品数目", #self.m_tabList)
    dump(self.m_tabList,"商城商品", 10)
    --一排摆3个
    for i=1, 3 do
        local iteminfo = self.m_tabList[idx *3 + i]
        if nil == iteminfo then
            return cell
        end
        local csb = ExternalFun.loadCSB("hall/csb/ShopItemNode.csb", cell)
        local imagecell = csb:getChildByName("image_bg")
        local imagesize = imagecell:getContentSize()
        csb:setPosition(self.m_nCellSize * (i -0.5), view:getViewSize().height * 0.25)
        csb:setScale(0.9)
        imagecell:setSwallowTouches(false)
        imagecell.info = iteminfo
        imagecell:addTouchEventListener(function(ref, tType)
            if tType == ccui.TouchEventType.ended then
           end
        end)
        -- 商品名
        local name = ""
        -- 价格
        local szprice = ""
        -- 标识
        local flag = csb:getChildByName("sp_flag")
        -- 图片
        local imagetype = iteminfo["ImageType"] or 0
        local imagefile = ""
        -- 背景图
        local bgimage = "shop/shop_sp_cellbg.png"
        -- 价格图
        local priceimage = "shop/shop_sp_rmbicon.png"
        local price = iteminfo["PayPrice"] or 0
        szprice = string.format("%d", price) 
        -- 兑换
        name = iteminfo["ExchGold"] or 0 
        flag:setVisible(false)
        imagefile = tabGoldImageType[imagetype]
        -- 名称
        local txtitemname = csb:getChildByName("txt_itemname")
        --txtitemname:setString("" .. name)
        -- 价格
        local altasprice = csb:getChildByName("txt_itemprice")
        --altasprice:setString(szprice)
        -- 按鈕
        csb:getChildByName("btn_price"):setSwallowTouches(false)
        -- 图片
        if nil ~= imagefile and cc.FileUtils:getInstance():isFileExist(imagefile) then
            csb:getChildByName("sp_image"):setSpriteFrame(cc.Sprite:create(imagefile):getSpriteFrame())
        end
        -- 背景
        if nil ~= bgimage and cc.FileUtils:getInstance():isFileExist(bgimage) then
            imagecell:loadTexture(bgimage)
        end
        -- 
        local spprice = csb:getChildByName("sp_itemprice")
        -- 位置调整
        altasprice:setPositionX(30)
        spprice:setPositionX( - altasprice:getContentSize().width * 0.5)
        if nil ~= priceimage and cc.FileUtils:getInstance():isFileExist(priceimage) then
            spprice:setSpriteFrame(cc.Sprite:create(priceimage):getSpriteFrame())
        end
    end

    return cell
end

-- 子视图数目
function ShopLayer:numberOfCellsInTableView(view)
    if 0 < self.m_nListCount and self.m_nListCount < 3 then
        return 1
    end
    return self.m_nListCount/3
end

function ShopLayer:scrollViewDidScroll(view)
end

function ShopLayer:doThirdpay( part,szType, info )
    local this = self
    if nil == info or nil == szType or nil == info.ConfigID then
        print("ShopLayer:doThirdpay 充值产品为空 begin")
        dump(info, "info", 6)
        print("szType ==> ", szType)
        print("ShopLayer:doThirdpay 充值产品为空 end")
        return
    end
    self:showPopWait()
    self:runAction(cc.Sequence:create(cc.DelayTime:create(20), cc.CallFunc:create(function()
        this:dismissPopWait()
    end)))
    local configid = info.ConfigID
     local action = nil
    if part == yl.ThirdParty.LQ then
        action = string.format("action=createpayorder&paytype=%s&configid=%d&subtype=%s&%s", szType, configid, self._scene.m_nSubtype, GlobalUserItem:urlUserIdSignParam())
        print("url =====", yl.HTTP_URL .. "/WS/NewMoblieInterface.ashx?"..action)
    else
        action = string.format("action=createpayorder&paytype=%s&configid=%d&%s", szType, configid, GlobalUserItem:urlUserIdSignParam())
    end
    --logFunc(action, true)
    appdf.onHttpJsionTable(yl.HTTP_URL .. "/WS/NewMoblieInterface.ashx","GET",action,function(jstable,jsdata)
        dump(jstable, "jstable", 6)
        local msg = nil
        if type(jstable) == "table" then
            msg = jstable["msg"]
            local data = jstable["data"]
            if type(data) == "table" then
                if nil ~= data["valid"] and true == data["valid"] then
                    local payparam = {}
                    if part == yl.ThirdParty.WECHAT then --微信支付
                        --获取微信支付订单id
                        local paypackage = data["PayPackage"]
                        if type(paypackage) == "string" then
                            local ok, paypackagetable = pcall(function()
                                return cjson.decode(paypackage)
                            end)
                            if ok then
                                local payid = paypackagetable["prepayid"]
                                if nil == payid then
                                    showToast(this, "微信支付订单获取异常", 2)
                                    this:dismissPopWait()
                                    return 
                                end
                                payparam["info"] = paypackagetable
                            else
                                showToast(this, "微信支付订单获取异常", 2)
                                this:dismissPopWait()
                                return
                            end
                        end
                    elseif part == yl.ThirdParty.LQ then
                        --获取微信支付订单id
                        local paypackage = data["PayUrl"]
                        if type(paypackage) == "string" then
                            payparam["info"] = data["PayUrl"]
                            local jsonStr = cjson.encode(payparam)
                            LogAsset:getInstance():logData(jsonStr, true)
                            print("@@@@@@@@@@@@@@@@@@@@@@@@@", payparam["info"])

                            -- local webview = appdf.req(appdf.CLIENT_SRC.."plaza.views.layer.plaza.WebViewLayer"):create(self, payparam["info"])
                            -- local runScene = cc.Director:getInstance():getRunningScene()
                            -- if nil ~= runScene then
                            --     runScene:addChild(webview, yl.ZORDER.Z_AD_WEBVIEW)
                            -- end
                            MultiPlatform:getInstance():openBrowser(payparam["info"])
                            this:dismissPopWait()
                            return
                        end
                    end
                    --订单id
                    payparam["orderid"] = data["OrderID"]                       
                    --价格
                    payparam["price"] = info.PayPrice
                    --商品名
                    payparam["name"] = info.PayName or ""
                    local function payCallBack(param)
                        local runScene = cc.Director:getInstance():getRunningScene()
                        if type(param) == "string" and "true" == param then
                            GlobalUserItem.setTodayPay()
                            
                            showToast(runScene, "支付成功", 2)
                            -- 充值
                            local dia = info.Diamond or 0
                            -- 赠送
                            local sendScale = info.PresentScale or 0
                            GlobalUserItem.tabAccountInfo.lDiamond = GlobalUserItem.tabAccountInfo.lDiamond + dia + dia * sendScale

                            this.m_clipDiamond:setString(GlobalUserItem.tabAccountInfo.lDiamond .. "")
                            -- 通知更新        
                            local eventListener = cc.EventCustom:new(yl.RY_USERINFO_NOTIFY)
                            eventListener.obj = yl.RY_MSG_USERWEALTH
                            cc.Director:getInstance():getEventDispatcher():dispatchEvent(eventListener)
                        else
                            showToast(runScene, "支付异常", 2)
                        end
                    end
                    this:showPopWait()
                    GlobalUserItem.bShopPay = true
                    MultiPlatform:getInstance():thirdPartyPay(part, payparam, payCallBack)
                    return
                end
            end
        end
        if type(msg) == "string" and msg ~= "" then
            showToast(this, msg, 2)
        end
        this:dismissPopWait()
    end)
end

function ShopLayer:onUserInfoChange( event  )
    print("----------userinfo change notify------------")
	local this = self
    local msgWhat = event.obj
    
    if nil ~= msgWhat then
        if  msgWhat == yl.RY_MSG_USERRECHARGE then
			--请求
			local url = yl.HTTP_URL .. "/WS/NewMoblieInterface.ashx"
			this:showPopWait()
			local param = "action=getuserwealth&" .. GlobalUserItem:urlUserIdSignParam()
			appdf.onHttpJsionTable(url ,"GET",param,function(jstable,jsdata)
				this:dismissPopWait()
				if type(jstable) == "table" then
					msg = jstable["msg"]
					local data = jstable["data"]
					if type(data) == "table" then
						local valid = data["valid"]
						if valid then
							-- + 钻石
							local diamond = tonumber(data["diamond"])
							if nil ~= diamond then
								GlobalUserItem.tabAccountInfo.lDiamond = diamond
							end
							--更新界面金钱
							this.m_clipDiamond:setString(GlobalUserItem.tabAccountInfo.lDiamond .. "")
							-- 通知更新        
							local eventListener = cc.EventCustom:new(yl.RY_USERINFO_NOTIFY)
							eventListener.obj = yl.RY_MSG_USERWEALTH
							cc.Director:getInstance():getEventDispatcher():dispatchEvent(eventListener)
						end
					end
				end
			end)
		end
    end
end


return ShopLayer