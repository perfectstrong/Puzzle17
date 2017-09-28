--[[This contains all global parameters]]

local M = {}

-- Font overall
M.font = {
	default = "InknutAntiqua-Light.ttf",
	defaultBold = "InknutAntiqua-ExtraBold.ttf",
	size = {
		normal = display.contentHeight * 0.03,
		large = display.contentHeight * 0.05,
		xlarge = display.contentHeight * 0.075,
		small = display.contentHeight * 0.01,
	},
}

-- About the table of pieces of picture to play
M.gamePreconfig = {
	leftPadding = display.contentWidth * 0.1,
	rightPadding = display.contentWidth * 0.1,
	topPadding = display.contentHeight * 0.2,
	bottomPadding = display.contentHeight * 0.2,
	background = "img/background.png",

}

-- The level chosen by user
M.gameSetting = {
	imageRoot = "img/game/",
	imagePath = nil,
	rowNum = 3,
	colNum = 3,
	rowNumMin = 3,
	rowNumMax = 10,
	colNumMin = 3,
	colNumMax = 10,
}

M.labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }
M.buttonColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } }

M.fade = {
	effect = "fade",
    time = 500
}

M.sound = {
	bravo = audio.loadSound("audio/applause.wav"),
}
M.bgm = audio.loadStream("audio/bgm.wav")
M.bgmChannel = 1
M.nobgm = false
M.soundiconsSheet = "img/volume.png"
M.soundiconsOptions = {
	width = 200,
	height = 200,
	numFrames = 2
}

M.reshuffle = "img/refresh.png"

return M