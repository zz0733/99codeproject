--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local playerMondel =  {}

function playerMondel:ctor(bufferData)
	self:setProperties(bufferData)
end

function playerMondel:setProperties(bufferData)
    self.uid = bufferData.uid                            --
    self.stream = bufferData.stream                     --
    self.bag_money = bufferData.bag_money               --    
    self.into_money = bufferData.into_money             --
    self.is_staff = bufferData.is_staff                 --
    self.ready = bufferData.ready                       --  会否开始游戏
    self.client_address = bufferData.client_address     --
    self.wzcardnum = bufferData.wzcardnum               --
    self.winning = bufferData.winning                   --
    self.waiting = bufferData.waiting                   -- 是否是在等待游戏
    self.vip_level = bufferData.vip_level               --
    self.avatar_img = bufferData.avatar_img             --
    self.lose_times = bufferData.lose_times             --
    self.win_times = bufferData.win_times               --  
    self.mobile_type = bufferData.mobile_type           --
    self.avatar_no = bufferData.avatar_no               --头像
    self.keynum = bufferData.keynum                     --
    self.nickname = bufferData.nickname                 --昵称
    self.active_point = bufferData.active_point         --
    self.level = bufferData.level                       --
    self.exp = bufferData.exp                           --
    self.position = bufferData.position                 --座位
end

function playerMondel:getuid()
	return self.uid 
end

function playerMondel:getstream()
	return self.stream 
end

function playerMondel:getbag_money()
	return self.bag_money 
end

function playerMondel:getinto_money()
	return self.into_money 
end

function playerMondel:getis_staff()
	return self.is_staff 
end

function playerMondel:getready()
	return self.ready 
end

function playerMondel:getclient_address()
	return self.client_address 
end

function playerMondel:getwzcardnum()
	return self.wzcardnum 
end

function playerMondel:getwinning()
	return self.winning 
end

function playerMondel:getwaiting()
	return self.waiting 
end

function playerMondel:getvip_level()
	return self.vip_level 
end

function playerMondel:getavatar_img()
	return self.avatar_img 
end

function playerMondel:getlose_times()
	return self.lose_times 
end

function playerMondel:getwin_times()
	return self.win_times 
end

function playerMondel:getmobile_type()
	return self.mobile_type 
end

function playerMondel:getavatar_no()
	return self.avatar_no 
end

function playerMondel:getkeynum()
	return self.keynum 
end

function playerMondel:getnickname()
	return self.nickname 
end

function playerMondel:getactive_point()
	return self.active_point 
end

function playerMondel:getlevel()
	return self.level 
end

function playerMondel:getexp()
	return self.exp 
end

function playerMondel:getposition()
	return self.position 
end

return playerMondel


--endregion
