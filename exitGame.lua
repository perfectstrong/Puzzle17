local composer = require( "composer" )
local globalData = require("globalData")
local color = globalData.defaultColor
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
    transparentFilm:setFillColor(unpack(color.gray))

    local box = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.9, display.contentHeight * 0.2)
    box:setFillColor(unpack(color.black))
    box.strokeWidth = 3
    box:setStrokeColor(unpack(color.stroke))

    local text = display.newText({
        parent = sceneGroup,
        text = "Are you sure about this?",
        x = box.x,
        y = box.y - box.height / 6,
        width = box.width * 0.8,
        height = box.height * 0.5,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        align = "center",
    })
    text:setFillColor(unpack(color.normalText))

    local resumeButton = widget.newButton({
        -- Button to resume game
        x = box.x - box.width * 0.25,
        y = box.y + box.height * 0.2,
        label = "Resume",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = box.width * 0.4,
        height = box.height * 0.4,
    })
    sceneGroup:insert(resumeButton)
    resumeButton:addEventListener("tap",
        function (  )
            -- Function to resume to the current game
            composer.hideOverlay("fade", 400)
        end
    )

    local quitButton = widget.newButton({
        -- Button to resume game
        x = box.x + box.width * 0.25,
        y = box.y + box.height * 0.2,
        label = "Quit",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = box.width * 0.4,
        height = box.height * 0.4,
    })
    sceneGroup:insert(quitButton)
    quitButton:addEventListener("tap",
        function ( event )
            -- Function to quit game
            composer.hideOverlay("fade", 400)
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