-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Initial setups
math.randomseed(os.time())
local composer = require("composer")
local globalData = require("globalData")

local background = display.newImageRect(display.getCurrentStage(), globalData.gamePreconfig.background, display.contentWidth, display.contentHeight)
background.x = display.contentCenterX
background.y = display.contentCenterY
background:toBack()

audio.play(globalData.bgm, { channel = globalData.bgmChannel, loops = - 1, fadein = 1000})
audio.setVolume(0.5, {channel = globalData.bgmChannel})

composer.gotoScene("mainMenu", globalData.fade)
