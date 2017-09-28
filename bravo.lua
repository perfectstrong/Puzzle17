local composer = require( "composer" )
local globalData = require("globalData")
local widget = require("widget")
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local transparentFilm = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    transparentFilm:setFillColor(0,0,0,0.5)

    local box = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.9, display.contentHeight * 0.8)
    box:setFillColor(0,0,0,0.5)
    box.strokeWidth = 3
    box:setStrokeColor(1, 0, 0)

    local text = display.newText({
        parent = sceneGroup,
        text = "You have solved the puzzle in:\n"
            ..composer.getVariable("numMoves")
            .."\nmoves.\n"
            .."!! INCREDIBLE !!",
        x = box.x,
        y = box.y - box.height / 5,
        width = box.width * 0.8,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        align = "center",
    })

    local reviewButton = widget.newButton({
        -- Button to resume game
        x = box.x,
        y = box.y + box.height * 0.2,
        label = "Review",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = box.width * 0.4,
        height = display.contentHeight * 0.1,
    })
    sceneGroup:insert(reviewButton)
    reviewButton:addEventListener("tap",
        function (  )
            -- Function to resume to the current game
            composer.hideOverlay("fade", 400)
        end
    )

    local homeButton = widget.newButton({
        -- Button to resume game
        x = box.x,
        y = box.y + box.height * 0.4,
        label = "Home",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = box.width * 0.4,
        height = display.contentHeight * 0.1,
    })
    sceneGroup:insert(homeButton)
    homeButton:addEventListener("tap",
        function (  )
            -- Function to resume to the current game
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
        audio.play(globalData.sound.bravo)
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