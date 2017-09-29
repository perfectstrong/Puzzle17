-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

math.randomseed(os.time())

-- Initial setups
math.randomseed(os.time())
local composer = require("composer")
local globalData = require("globalData")

local background = display.newImageRect(display.getCurrentStage(), globalData.background, display.contentWidth, display.contentHeight)
background.x = display.contentCenterX
background.y = display.contentCenterY
--[[local background = display.newRect(display.getCurrentStage(), display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
background:setFillColor(unpack(globalData.backgroundColor))--]]
background:toBack()

audio.play(globalData.bgm, { channel = globalData.bgmChannel, loops = - 1, fadein = 1000})
audio.setVolume(0.5, {channel = globalData.bgmChannel})

composer.gotoScene("mainMenu", globalData.fade)
