--region RedVsBlackOtherInfoLayer.lua
--Date 2018/03/16
--百人牛牛其他玩家信息界面
--endregion

local RedVsBlackRes             = appdf.req("game.yule.hhdz.src.game.redvsblack.scene.RedVsBlackRes")
local RedVsBlackDataManager     = appdf.req("game.yule.hhdz.src.game.redvsblack.manager.RedVsBlackDataManager")
local RedVsBlackOtherInfoLayer  = class("RedVsBlackOtherInfoLayer", cc.Layer)
local HeadSprite               = appdf.req(appdf.EXTERNAL_SRC .. "HeadSprite")
function RedVsBlackOtherInfoLayer.create()
    RedVsBlackOtherInfoLayer.instance_ = RedVsBlackOtherInfoLayer.new()
    return RedVsBlackOtherInfoLayer.instance_
end

function RedVsBlackOtherInfoLayer:ctor()
    self:enableNodeEvents()
    self:init()
end

function RedVsBlackOtherInfoLayer:init()
    self:initVar()
    self:initCSB()
    self:initView()
end 

function RedVsBlackOtherInfoLayer:onEnter()
end

function RedVsBlackOtherInfoLayer:onExit()
end

function RedVsBlackOtherInfoLayer:initVar()
    self.m_vecOtherInfo = {}
    --按金币大小排序
    local tab = RedVsBlackDataManager.getInstance():getRankUser() --CUserManager.getInstance():getUserInfoInTable(PlayerInfo.getInstance():getTableID())
    table.sort(tab, function(a,b)
        local ascore = a[6]
        local bscore = b[6]
        return ascore > bscore
    end)
    self.m_vecOtherInfo = tab
end

function RedVsBlackOtherInfoLayer:initCSB()
    self.m_rootUI       = display.newNode()
    self.m_rootUI:addTo(self)
    self.m_pathUI       = cc.CSLoader:createNode(RedVsBlackRes.CSB_GAME_USERINFO)
    self.m_pathUI:addTo(self.m_rootUI)
    self.m_rootNode     = self.m_pathUI:getChildByName("Panel_1")
    self.m_pBg          = self.m_pathUI:getChildByName("image_bg")
    self.m_pBtnClose    = self.m_pBg:getChildByName("button_close")
    self.m_pBtnClose:addClickEventListener(handler(self, self.onReturnClicked))
    self.m_pTxtNum      = self.m_pBg:getChildByName("text_left__"):getChildByName("text_num")
    self.m_pTxtNum:setString(table.nums(self.m_vecOtherInfo))
    self.m_plistView    = self.m_pBg:getChildByName("listView_list")
    self.m_plistView:setScrollBarEnabled(false)
    self.m_NodeItem     = self.m_pathUI:getChildByName("panel_itemModelLine")

end

function RedVsBlackOtherInfoLayer:initView()
    
    local numplayer = table.nums(self.m_vecOtherInfo)
    local num = self:getIntValue( table.nums(self.m_vecOtherInfo)/3 )
    local lastnum = 0
    if (table.nums(self.m_vecOtherInfo)%3) ~= 0 then
        num = num + 1
        lastnum = (table.nums(self.m_vecOtherInfo)%3)
    end
    for i = 1, num do
        local item = self.m_NodeItem:clone();
        for j = 1, 3 do
            local player = item:getChildByName(string.format("panel_player_%d",j))
            local icon = player:getChildByName("image_avatar")
            local name = player:getChildByName("text_name")
            local money = player:getChildByName("image_coinIcon"):getChildByName("text_coin")
            if numplayer >= (3*(i -1) + j) then
                local head = HeadSprite:createClipHead({userid = self.m_vecOtherInfo[3*(i -1) + j][1], nickname = self.m_vecOtherInfo[3*(i -1) + j][2], avatar_no = self.m_vecOtherInfo[3*(i -1) + j][3]},129)
                head:setAnchorPoint(cc.p(0,0))
                icon:addChild(head)

                name:setString(self.m_vecOtherInfo[3*(i -1) + j][2])
                money:setString(self.m_vecOtherInfo[3*(i -1) + j][6])
            end
            if i == num then
                if lastnum == 1 then
                    if j == 3 or j == 2 then
                        player:setVisible(false)
                    end
                elseif lastnum == 2 then
                    if j == 3 then
                        player:setVisible(false)
                    end
                end
            end
        end   

        self.m_plistView:addChild(item)
    end

end

function RedVsBlackOtherInfoLayer:onReturnClicked()
    self:removeFromParent()
end

--得到整数部分
function RedVsBlackOtherInfoLayer:getIntValue(num)
    local tt = 0
    num,tt = math.modf(num/1);
    return num
end
return RedVsBlackOtherInfoLayer
