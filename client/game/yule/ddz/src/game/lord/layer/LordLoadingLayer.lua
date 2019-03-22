--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local LordSceneRes = require("game.lord.scene.LordSceneRes")

local LordLoadingLayer = class("LordLoadingLayer", require("common.layer.LoadingLayer"))

function LordLoadingLayer.loading()
    return LordLoadingLayer.new(true)
end

function LordLoadingLayer.reload()
    return LordLoadingLayer.new(false)
end

function LordLoadingLayer:ctor(bBool)
    self:enableNodeEvents()
    self.bLoad = bBool
    self:initLoading()
    self:initLoadingWord(self)
end

function LordLoadingLayer:initLoading()

    -- root
    local pRoot = cc.CSLoader:createNode("game/lord/LordLoadUI.csb")
    pRoot:addTo(self)
    -- layer
    local pLayer = pRoot:getChildByName("Panel_root")
    pLayer:setPositionX(145 - (1624 - display.size.width) / 2)

    --修复bug:在上一次退出时,未断开socket,收到玩家出牌,重置了LoadDataMgr,
    --再次进游戏,未收到场景时,在没有牌数据的情况下初始化界面,造成显示全A
    require("game.lord.bean.LordDataMgr").getInstance():Clean()
end

function LordLoadingLayer:startLoading()

    --碎图/大图/动画/音效/音乐
    self:initPlistArray({ 
        {"game/lord/gui/gui-lord.plist", "game/lord/gui/gui-lord.png"}, 
        {"game/lord/gui/gui-poker.plist", "game/lord/gui/gui-poker.png"}, 
    })
    self:initImageArray({
        "game/lord/gui/gui-bg-table.png",
        "game/lord/gui/gui-bg-over-win.png",
        "game/lord/gui/gui-bg-over-lose.png",

        "game/lord/effect/doudizhu_nandizhu/doudizhu_nandizhu.png",
        "game/lord/effect/doudizhu_nvdizhu/doudizhu_nvdizhu.png",  
        "game/lord/effect/doudizhu_nongmin/doudizhu_nongmin.png",  
        "game/lord/effect/doudizhu_cungu/doudizhu4_cungu.png",     
    })
    self:initEffectArray({
        "game/lord/effect/doudizhu4_beijing/doudizhu4_beijing.ExportJson",
        "game/lord/effect/doudizhu4_chuntian/doudizhu4_chuntian.ExportJson",
        "game/lord/effect/doudizhu4_dengdai/doudizhu4_dengdai.ExportJson",
        "game/lord/effect/doudizhu4_dizhumao/doudizhu4_dizhumao.ExportJson",
        "game/lord/effect/doudizhu4_feiji/doudizhu4_feiji.ExportJson",
        "game/lord/effect/doudizhu4_huojian/doudizhu4_huojian.ExportJson",
        "game/lord/effect/doudizhu4_jiesuan/doudizhu4_jiesuan.ExportJson",
        "game/lord/effect/doudizhu4_jingdeng/doudizhu4_jingdeng.ExportJson",
        "game/lord/effect/doudizhu4_liandui/doudizhu4_liandui.ExportJson",
        "game/lord/effect/doudizhu4_shunzi/doudizhu4_shunzi.ExportJson",
        "game/lord/effect/doudizhu4_tishi/doudizhu4_tishi.ExportJson",
        "game/lord/effect/doudizhu4_zhadan/doudizhu4_zhadan.ExportJson",
        "game/lord/effect/jueseqiehuan_1/jueseqiehuan_1.ExportJson",
    })
    self:initSoundArray({
        "game/lord/sound/Special_alert.mp3",
        "game/lord/sound/Special_Baojingjiacheng.mp3",
        "game/lord/sound/Special_Bomb_New.mp3",
        "game/lord/sound/Special_Chuntian.mp3",
        "game/lord/sound/Special_Dispatch.mp3",
        "game/lord/sound/Special_give.mp3",
        "game/lord/sound/Special_Long_Bomb.mp3",
        "game/lord/sound/Special_plane.mp3",
        "game/lord/sound/Special_querendizhu.mp3",
        "game/lord/sound/Special_star.mp3",
        "game/lord/sound/SpecSelectCard.mp3",
    })
    self:initMusicArray({
        "game/lord/sound/MusicEx_Exciting.mp3",
        "game/lord/sound/MusicEx_Normal.mp3",
        "game/lord/sound/MusicEx_Normal2.mp3",
        "game/lord/sound/MusicEx_Welcome.mp3",
    })
    self:initOtherArray({})

    --进入加载
    self:executeLoading()
end

function LordLoadingLayer:stopLoading()
    
    --进入游戏
    SLFacade:dispatchCustomEvent(Public_Events.MSG_GAME_LOAD_SUCCESS)
end

return LordLoadingLayer
--endregion
