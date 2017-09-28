--[[This contains all global parameters]]

local M = {}

-- Font overall
M.font = {
	default = native.systemFont,
	defaultBold = native.systemFontBold,
	size = {
		normal = display.contentHeight * 0.05,
		large = display.contentHeight * 0.075,
		small = display.contentHeight * 0.025,
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
return M