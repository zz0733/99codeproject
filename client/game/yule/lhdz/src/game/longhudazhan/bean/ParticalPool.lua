--region *.lua
--Date
--
--endregion

local UI_Res       = require("game.yule.lhdz.src.game.longhudazhan.scene.Lhdz_Res")

local ParticalPool = class("ParticalPool")

ParticalPool.g_instance = nil

local defaultParticalFile = UI_Res.PLIST_OF_BAGUA

function ParticalPool.getInstance()
    if not ParticalPool.g_instance then
        ParticalPool.g_instance = ParticalPool:new()
    end
    return ParticalPool.g_instance
end

function ParticalPool.releaseInstance()
    ParticalPool.g_instance = nil
end

function ParticalPool:ctor()
    self.m_resName = nil
    self.m_pool = {}
    self.m_luckyWinEffect = nil
    self.m_richWinEffect = nil
    self.m_bgEffect = {}
    self.m_lanternEffect = {}
    self.m_animalEffect = {}
end

function ParticalPool:setResName(resName)
    ParticalPool.resName = resName
end

function ParticalPool:addNewPartical()
    if nil == ParticalPool.resName then
        print("createPartical need resName...")
        self.m_resName = defaultParticalFile
    end

    local partical = cc.ParticleSystemQuad:create(ParticalPool.resName)
    partical:setAnchorPoint(0.5,0.5)
    partical:setVisible(false)
    partical:retain()
    table.insert(self.m_pool, partical )
end

function ParticalPool:clearPool()
    for i,v in pairs(self.m_pool) do
        v:release()
    end
    self.m_pool = {}

    if self.m_luckyWinEffect then
        self.m_luckyWinEffect:release()
        self.m_luckyWinEffect = nil
    end

    if self.m_richWinEffect then
        self.m_richWinEffect:release()
        self.m_richWinEffect = nil
    end

    for i,v in pairs(self.m_bgEffect) do
        v:release()
    end
    self.m_bgEffect = {}

    for i,v in pairs(self.m_lanternEffect) do
        v:release()
    end
    self.m_lanternEffect = {}

    for i,v in pairs(self.m_animalEffect) do
        v:release()
    end
    self.m_animalEffect = {}
end

function ParticalPool:takePartical()
    local size = table.nums(self.m_pool)
    local partical = nil
    if size > 0 then 
        partical = self.m_pool[size]
        table.remove(self.m_pool)
    else
        if nil == self.m_resName then
            print("createPartical need resName...")
            self.m_resName = defaultParticalFile
        end
        partical = cc.ParticleSystemQuad:create(ParticalPool.resName)
        partical:setAnchorPoint(0.5,0.5)
        partical:retain()
    end

    return partical
end

function ParticalPool:putPartical(partical)
    if nil ~= partical:getParent() then
        partical:removeFromParent()
    end
    table.insert(self.m_pool, partical )
end

--[[
    部分spine动画加载在进入游戏主界面是会消耗大量性能，造成卡顿
    由于1.9底层不能使用缓存spine构造数据的方式进行预加载
    暂借粒子缓存池构造
]]--

--大富豪获胜特效
function ParticalPool:createRichWinEffect()
    --大富豪
    if self.m_richWinEffect then return end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(UI_Res.ANI_OF_TOPWINEFFECT.FILEPATH) 
    self.m_richWinEffect = ccs.Armature:create(UI_Res.ANI_OF_TOPWINEFFECT.FILENAME)
    self.m_richWinEffect:getAnimation():play(UI_Res.ANI_OF_TOPWINEFFECT.ANILIST.RICHNORMAL.NAME, -1, 0)
    self.m_richWinEffect:retain()
end

function ParticalPool:getRichWinEffect()
    return self.m_richWinEffect
end

--神算子获胜特效
function ParticalPool:createLuckyWinEffect()
    --神算子
    if self.m_luckyWinEffect then return end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(UI_Res.ANI_OF_TOPWINEFFECT.FILEPATH) 
    self.m_luckyWinEffect = ccs.Armature:create(UI_Res.ANI_OF_TOPWINEFFECT.FILENAME)
    self.m_luckyWinEffect:getAnimation():play(UI_Res.ANI_OF_TOPWINEFFECT.ANILIST.LUCKYNORMAL.NAME, -1, 0)
    self.m_luckyWinEffect:retain()
end

function ParticalPool:getLuckyWinEffect()
    return self.m_luckyWinEffect
end

--背景特效
function ParticalPool:createBGEffect(i)
    if self.m_bgEffect[i] then return end
    local strJson = string.format(UI_Res.ANI_OF_BACKGROUND, "json")
    local strAtlas = string.format(UI_Res.ANI_OF_BACKGROUND, "atlas")
    self.m_bgEffect[i] = sp.SkeletonAnimation:create(strJson, strAtlas)
    self.m_bgEffect[i]:retain()
end

function ParticalPool:getBGEffect(i)
    return self.m_bgEffect[i]
end

--灯笼特效
function ParticalPool:createLanternEffect(i)
    if self.m_lanternEffect[i] then return end
    local strJson = string.format(UI_Res.ANI_OF_LANTERN, "json")
    local strAtlas = string.format(UI_Res.ANI_OF_LANTERN, "atlas")
    self.m_lanternEffect[i] = sp.SkeletonAnimation:create(strJson, strAtlas)
    self.m_lanternEffect[i]:retain()
end

function ParticalPool:getLanternEffect(i)
    return self.m_lanternEffect[i]
end

--动物特效
function ParticalPool:createAnimalEffect(i)
    if self.m_animalEffect[i] then return end
    local strJson = string.format(UI_Res.ANI_OF_ANIMAL, "json")
    local strAtlas = string.format(UI_Res.ANI_OF_ANIMAL, "atlas")
    self.m_animalEffect[i] = sp.SkeletonAnimation:create(strJson, strAtlas)
    self.m_animalEffect[i]:retain()
end

function ParticalPool:getAnimalEffect(i)
    return self.m_animalEffect[i]
end

return ParticalPool