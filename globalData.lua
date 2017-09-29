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

M.fade = {
	effect = "fade",
    time = 500
}

M.sound = {
	bravo = audio.loadSound("audio/applause.mp3"),
}
M.bgm = audio.loadStream("audio/bgm.mp3")
M.bgmChannel = 1
M.nobgm = false
M.soundiconsSheet = "img/volume.png"
M.soundiconsOptions = {
	width = 200,
	height = 200,
	numFrames = 2
}

M.reshuffle = "img/refresh.png"

M.background = "img/background.png"
M.backgroundColor =  {178/255, 45/255, 126/255, 1.0}
M.defaultColor = {
	normalText = {2/255, 195/255, 154/255},
	title = {5/255, 102/255, 141/255},
	h2 =   {2/255, 128/255, 144/255},
	indicativeText = {0, 168/255, 150/255},
	gray = {0, 0, 0, 0.5},
	black = {0, 0, 0, 1},
	stroke = {1, 0, 0}
}
M.labelColor = {
	default = {2/255, 195/255, 154/255, 1.0},
	over = {247/255, 142/255, 105/255, 1.0}
}
M.buttonColor = {
	default = {240/255, 243/255, 189/255, 1.0},
	over = {240/255, 243/255, 189/255, 0.7}
}

return M