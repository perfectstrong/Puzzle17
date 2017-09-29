local composer = require( "composer" )
local globalData = require("globalData")
local color = globalData.defaultColor
local widget = require("widget")

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local backGroup, levelsGroup, giftsGroup
local x = 1

-- For sliders
function getPercentage( value, min, max )
    if (value <= min) then
        return 0
    elseif (value >= max) then
        return 100
    else
        return math.floor((value - min) / (max - min) * 100)
    end
end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Background
    backGroup = display.newGroup()
    sceneGroup:insert(backGroup)

    -- ImageGifts
    giftsGroup = display.newGroup()
    sceneGroup:insert(giftsGroup)

    local titlePicture = display.newText(giftsGroup, "Choose a gift", display.contentCenterX, display.contentHeight * 0.1, globalData.font.default, globalData.font.size.large)
    titlePicture:setFillColor(unpack(color.h2))
    giftsGroup:insert(titlePicture)

    local indication = display.newText(giftsGroup, "Swipe left or right to view all", display.contentCenterX, display.contentHeight * 0.15, globalData.font.default, globalData.font.size.normal)
    indication:setFillColor(unpack(color.indicativeText))
    giftsGroup:insert(indication)

    local choice = display.newText({
        parent = giftsGroup,
        text = "You have not chosen a gift.",
        x = display.contentCenterX, 
        y = display.contentHeight * 0.4, 
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        width = display.contentWidth * 0.8,
        align = "center"
    })
    choice:setFillColor(unpack(color.indicativeText))
    giftsGroup:insert(choice)

    local gifts = {} -- Caching all gifts

    local scrollView = widget.newScrollView({
        x = display.contentCenterX,
        y = display.contentHeight * 0.275,
        width = display.contentWidth * 0.8,
        height = display.contentHeight * 0.2,
        scrollWidth = display.contentWidth * 0.8,
        scrollHeight = display.contentHeight * 0.1,
        hideBackground = true,
        hideScrollBar = false,
        verticalScrollDisabled = true,
    })
    giftsGroup:insert(scrollView)

    function setImageToPlay(name)
        -- Set the path to image to make the play
        globalData.gameSetting.imagePath = name
    end

    function deselectAll()
        -- Deselect all other choices in scrollView
        for _,child in pairs(gifts) do
            child:setFillColor(unpack(color.title))
            child.font = globalData.font.default
            choice.text = "You have not chosen a gift."
        end
    end

    function setGift( g )
        -- Set highlight the choice
        g:setFillColor(unpack(color.normalText))
        g.font = globalData.font.defaultBold
        choice.text = "You have chosen the gift no. " .. g.text .. "."
        setImageToPlay(g.target)
    end

    function newGift(name, target)
        local g = display.newText({
            text = name,
            font = globalData.font.default,
            fontSize = globalData.font.size.large,
            align = "center",
        })
        g.target = target
        scrollView:insert(g)
        table.insert(gifts, g)
        g.y = scrollView.height / 2
        for i = 1, #gifts do
            local child = gifts[i]
            child.x = scrollView.width / 2 - ((scrollView.numChildren + 1) / 2  - i) * scrollView.height
        end
        g:setFillColor(unpack(color.title))
        g:addEventListener("tap", function ()
                deselectAll()
                setGift(g)
            end
        )
    end

    newGift("1", "apple.jpg")
    newGift("2", "cake.jpg")
    newGift("3", "leopard.jpg")
    newGift("4", "mushroom.jpg")


    -- Level's sliders
    levelsGroup = display.newGroup()
    sceneGroup:insert(levelsGroup)

    local titleLevel = display.newText(levelsGroup, "Choose a level", display.contentCenterX, display.contentHeight * 0.5, globalData.font.default, globalData.font.size.large)
    titleLevel:setFillColor(unpack(color.h2))
    levelsGroup:insert(titleLevel)

    local rowNumControler = display.newGroup()
    levelsGroup:insert(rowNumControler)

    local rowNumTitle = display.newText(rowNumControler, "The number of rows: " .. globalData.gameSetting.rowNum, display.contentCenterX, display.contentHeight * 0.55, globalData.font.default, globalData.font.size.normal)
    rowNumTitle:setFillColor(unpack(color.h2))

    local options = {
        frames = {
            { x=0, y=0, width=40, height=64 },
            { x=40, y=0, width=40, height=64 },
            { x=80, y=0, width=40, height=64 },
            { x=120, y=0, width=36, height=64 },
            { x=156, y=0, width=64, height=64 }
        },
        sheetContentWidth = 220,
        sheetContentHeight = 64
    }
    local sliderSheet = graphics.newImageSheet( "img/widget-slider.png", options )

    local frameSize = math.min(display.contentWidth, display.contentHeight) * 0.05

    local rowNumSlider = widget.newSlider({
        sheet = sliderSheet,
        leftFrame = 1,
        middleFrame = 2,
        rightFrame = 3,
        fillFrame = 4,
        frameWidth = frameSize,
        frameHeight = frameSize,
        handleFrame = 5,
        handleWidth = frameSize * 1.5,
        handleHeight = frameSize * 1.5,
        x = display.contentCenterX,
        y = display.contentHeight * 0.6,
        width = display.contentWidth * 0.6,
        orientation = "horizontal",
        value = getPercentage(globalData.gameSetting.rowNum, globalData.gameSetting.rowNumMin, globalData.gameSetting.rowNumMax),
        listener = function (event)
            globalData.gameSetting.rowNum = math.floor(event.value / 100 * (globalData.gameSetting.rowNumMax - globalData.gameSetting.rowNumMin)) + globalData.gameSetting.rowNumMin
            rowNumTitle.text = "The number of rows: " .. globalData.gameSetting.rowNum
        end
    })
    rowNumControler:insert(rowNumSlider)

    local x = display.newText(rowNumControler, globalData.gameSetting.rowNumMin, display.contentWidth * 0.10, rowNumSlider.y, globalData.font.default, globalData.font.size.normal)
    x:setFillColor(unpack(color.title))
    local x = display.newText(rowNumControler, globalData.gameSetting.rowNumMax, display.contentWidth * 0.90, rowNumSlider.y, globalData.font.default, globalData.font.size.normal)
    x:setFillColor(unpack(color.title))


    local colNumControler = display.newGroup()
    levelsGroup:insert(colNumControler)

    local colNumTitle = display.newText(colNumControler, "The number of columns: " .. globalData.gameSetting.colNum, display.contentCenterX, display.contentHeight * 0.70, globalData.font.default, globalData.font.size.normal)
    colNumTitle:setFillColor(unpack(color.h2))

    local colNumSlider = widget.newSlider({
        sheet = sliderSheet,
        leftFrame = 1,
        middleFrame = 2,
        rightFrame = 3,
        fillFrame = 4,
        frameWidth = frameSize,
        frameHeight = frameSize,
        handleFrame = 5,
        handleWidth = frameSize * 1.5,
        handleHeight = frameSize * 1.5,
        x = display.contentCenterX,
        y = display.contentHeight * 0.75,
        width = display.contentWidth * 0.6,
        orientation = "horizontal",
        value = getPercentage(globalData.gameSetting.colNum, globalData.gameSetting.colNumMin, globalData.gameSetting.colNumMax),
        listener = function (event)
            globalData.gameSetting.colNum = math.floor(event.value / 100 * (globalData.gameSetting.colNumMax - globalData.gameSetting.colNumMin)) + globalData.gameSetting.colNumMin
            colNumTitle.text = "The number of columns: " .. globalData.gameSetting.colNum
        end
    })
    colNumControler:insert(colNumSlider)

    local x = display.newText(colNumControler, globalData.gameSetting.colNumMin, display.contentWidth * 0.10, colNumSlider.y, globalData.font.default, globalData.font.size.normal)
    x:setFillColor(unpack(color.title))
    local x = display.newText(colNumControler, globalData.gameSetting.colNumMax, display.contentWidth * 0.90, colNumSlider.y, globalData.font.default, globalData.font.size.normal)
    x:setFillColor(unpack(color.title))



    -- Button "Start"
    local startButton = widget.newButton({
        -- Button to resume game
        x = display.contentWidth * 0.25,
        y = display.contentHeight * 0.9,
        label = "Start",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = display.contentWidth * 0.4,
        height = display.contentHeight * 0.1,
    })
    sceneGroup:insert(startButton)
    startButton:addEventListener("tap",
        function (  )
            if (globalData.gameSetting.imagePath == nil) then
                choice.text = "No gift no fun."
                return
            end
            composer.gotoScene("mainGame", globalData.fade)
        end
    )

    -- Button "Home"
    local homeButton = widget.newButton({
        -- Button to resume game
        x = display.contentWidth * 0.75,
        y = display.contentHeight * 0.9,
        label = "Home",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = display.contentWidth * 0.4,
        height = display.contentHeight * 0.1,
    })
    sceneGroup:insert(homeButton)
    homeButton:addEventListener("tap",
        function (  )
            composer.gotoScene("mainMenu", globalData.fade)
        end
    )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene("chooseLevel")
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene