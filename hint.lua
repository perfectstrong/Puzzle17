local composer = require( "composer" )
local globalData = require("globalData")
 local widget = require("widget")
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local hint = globalData.hint
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local transparentFilm = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    transparentFilm:setFillColor(0,0,0,0.5)

    -- Show the hint
    local width, height = hint.width, hint.height
    local img = display.newImageRect(sceneGroup, globalData.gameSetting.imagePath, system.TemporaryDirectory, width, height)
    img.x = display.contentCenterX
    img.y = display.contentCenterY

    local resumeButton = widget.newButton({
        -- Button to resume game
        x = display.contentCenterX,
        y = display.contentHeight * 0.9,
        label = "Resume",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = display.contentWidth,
        height = display.contentHeight * 0.1,
    })
    sceneGroup:insert(resumeButton)
    resumeButton:addEventListener("tap",
        function (  )
            -- Function to resume to the current game
            composer.hideOverlay("fade", 400)
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