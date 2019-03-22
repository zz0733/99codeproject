--
-- Author: zhong
-- Date: 2017-08-04 15:22:17
--
-- 多目录下载
local MultiUpdaterZip = class("MultiUpdaterZip")

-- url:下载list地址 
-- wirtepath:保存路径
-- curfile:当前list路径
function MultiUpdaterZip:ctor(fileurl,savename, savepath, unzippath)
    self._fileurl= fileurl
    self._savename = savename
    self._savepath = savepath
    self._unzippath = unzippath
    self._app = nil
    self._updateGame = nil
    self._listener = nil
    self._retryCount = 3
end

--开始更新 
--app MyApp
--listener回调目标
--listener:updateProgress(sub,msg)
--listener:updateResult(result,msg)
function MultiUpdaterZip:upDateClient( app, listener, gameinfo )
    --监听
    self._app = app
    self._listener = listener
    self._updateGame = gameinfo

    self:UpdateFile()
end

--下载
function MultiUpdaterZip:UpdateFile()
    --调用C++下载
    downFileAsync(self._fileurl,self._savename,self._savepath,function(main,sub)
        --下载回调
        if main == appdf.DOWN_PRO_INFO then --进度信息
            if nil ~= self._listener and nil ~= self._listener.updateProgress then
                self._listener:updateProgress(self._updateGame, sub, self._savename, sub)
            end
        elseif main == appdf.DOWN_COMPELETED then --下载完毕
            local zipfile = self._savepath  .. self._savename

            self._listener:ZipResult(self._updateGame, 1,"解压") 
            --解压
            unZipAsync(zipfile, self._unzippath, function(result)
                --删除压缩文件
                os.remove(zipfile)
                if result == 1 then
                    --self._listener:ZipResult(self._updateGame, 2,"解压成功") 
                    self._listener:updateResult(self._updateGame, true,"") --下载成功
                else
                    --self._listener:ZipResult(self._updateGame, 0,"解压失败") 
                end
			end)
        else
            if sub == 28 and self._retryCount > 0 then
                self._retryCount = self._retryCount - 1
                self:UpdateFile()
            else
                if nil ~= self._listener and nil ~= self._listener.updateResult then
                    if true == isDebug() then
                        self._listener:updateResult(self._updateGame, false,"文件 [" .. self._savename .. "] 下载失败,main:" .. main .. " ## sub:" .. sub) --失败信息
                    else
                        self._listener:updateResult(self._updateGame, false,"下载失败,main:" .. main .. " ## sub:" .. sub) --失败信息
                    end
                end
            end
        end
    end)
end

return MultiUpdaterZip