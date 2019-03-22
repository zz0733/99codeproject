--
-- Author: zhong
-- Date: 2017-05-31 18:10:25
--
-- 排行榜(非弹窗)
local TransitionLayer = appdf.req(appdf.EXTERNAL_SRC .. "TransitionLayer")
local RankListLayer = class("RankListLayer", TransitionLayer)
local ExternalFun = appdf.req(appdf.EXTERNAL_SRC .. "ExternalFun")
local HeadSprite = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
local ClipText = appdf.req(appdf.EXTERNAL_SRC .. "ClipText")
local AnimationMgr = appdf.req(appdf.EXTERNAL_SRC .. "AnimationMgr")
local PopupInfoHead = appdf.req("client.src.external.PopupInfoHead")
local MultiPlatform = appdf.req(appdf.EXTERNAL_SRC .. "MultiPlatform")


local LogonFrame = appdf.req(appdf.CLIENT_SRC.."plaza.models.LogonFrame")

local TAG_START             = 100
local enumTable = 
{
    "BT_SHOWRANK",          -- 显示排行
    "BT_HIDERANK",          -- 隐藏排行
    "BT_SCORERANK",         -- 财富榜
    "BT_BATTLERANK",        -- 战绩榜
    "BT_CONSUMERANK",       -- 消耗榜
    "RANK_NONE",            -- 无
    "RANK_SCORE",           -- 财富榜
    "RANK_BATTLE",          -- 战绩榜
    "RANK_CONSUME",         -- 消费榜
    "BTN_CLOSE",
    "TAG_MASK",
}
local TAG_ENUM = ExternalFun.declarEnumWithTable(TAG_START, enumTable)
--RankListLayer.RANK_SCORE = TAG_ENUM.RANK_SCORE
--RankListLayer.RANK_BATTLE = TAG_ENUM.RANK_BATTLE
--RankListLayer.RANK_CONSUME = TAG_ENUM.RANK_CONSUME

function RankListLayer:ctor( scene,param,level )
    RankListLayer.super.ctor(self, scene, param, level)

   
    --网络回调
    local  rankCallBack = function(result,message)
       self:onRankCallBack(result,message)
    end
    --网络处理
    self._logonFrame = LogonFrame:getInstance()
    self._logonFrame:setCallBackDelegate(self, rankCallBack)

    -- 加载csb资源
    local rootLayer, csbNode = ExternalFun.loadRootCSB("plaza/RankListLayer.csb", self)
    local touchFunC = function(ref, tType)
        if tType == ccui.TouchEventType.ended then
            self:onButtonClickedEvent(ref:getTag(), ref)            
        end
    end

     -- 遮罩
    local mask = csbNode:getChildByName("panel_mask")
    mask:setTag(TAG_ENUM.TAG_MASK)
    mask:addTouchEventListener( touchFunC )

    -- 排行榜
    local sprank = csbNode:getChildByName("plaza_sp_rankbg")
    self.m_spBg = sprank

    -- 关闭
    btn = sprank:getChildByName("btn_close")
    btn:setTag(TAG_ENUM.BTN_CLOSE)
    btn:addTouchEventListener( touchFunC )
  
    -- 
    local ScrollView = sprank:getChildByName("ScrollView_1")
    self._scrollview = ScrollView

     -- 加载动画
    self:scaleTransitionIn(self.m_spBg)
    self:scaleShakeTransitionIn(self.m_spBg)
    
    self:showPopWait()
    local msgta = {}
    msgta["type"] = "AccountService"
    msgta["tag"] = "get_userranks"
    msgta["body"] = {}
    self._logonFrame:sendGameData(msgta)
end

function RankListLayer:onRankCallBack(result,message)
    self:dismissPopWait()
    if not yl.isObject(self) then return end --防止返回消息时对象已经销毁导致崩溃
    if message ~= nill and message ~= "" then
        if message.result == "ok" and type(message.body) == "table" then
        
           local x = 430
           local y = 1150

            for i = 1 , #message.body do

                local jinbi = self._scrollview:getChildByName("hall_jinbi_6")

                if i > 3 then
                    local num = self._scrollview:getChildByName("txtnum_4")
                    local txtnum = cc.Label:createWithTTF("", "fonts/round_body.ttf", 25)
                    txtnum:setPosition(num:getPositionX(),num:getPositionY()-100*(i-4))
                    txtnum:setString(i)
                    txtnum:setColor(cc.c3b(255,255,0))
                    num:setVisible(false)
                    self._scrollview:addChild(txtnum)
                end

                local rankList = message.body[i]
                local txtid = cc.Label:createWithTTF("", "fonts/round_body.ttf", 25)
                txtid:setPosition(cc.p(x-50,y-100*(i-1)))
                txtid:setString("ID:"..rankList.user_id)
                txtid:setColor(cc.c3b(0,0,0))
                self._scrollview:addChild(txtid)

                local txtname =cc.Label:createWithTTF("", "fonts/round_body.ttf", 25)
                txtname:setPosition(cc.p(x+200,y-100*(i-1)))
                txtname:setString(rankList.nickname)
                txtname:setColor(cc.c3b(0,0,0))
                self._scrollview:addChild(txtname)

                local txtbag = cc.Label:createWithTTF("", "fonts/round_body.ttf", 25)
                txtbag:setPosition(cc.p(x+550,y-100*(i-1)))
                txtbag:setString(rankList.bag_money)
                txtbag:setColor(cc.c3b(255,255,0))
                self._scrollview:addChild(txtbag)
            end


     else
        -- todo 
    end

    end
end
function RankListLayer:onTransitionOutFinish()
    self:removeFromParent()
end

function RankListLayer:onButtonClickedEvent(tag, ref)

      if TAG_ENUM.BTN_CLOSE == tag or TAG_ENUM.TAG_MASK then
          self:scaleTransitionOut(self.m_spBg)
    end
end

return RankListLayer