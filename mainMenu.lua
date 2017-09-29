local composer = require( "composer" )
local globalData = require("globalData")
local color = globalData.defaultColor
local widget = require("widget") 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
math.randomseed(os.time())
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local title = display.newText(sceneGroup, "17-Puzzle", display.contentCenterX, display.contentHeight * 0.3, globalData.font.defaultBold, globalData.font.size.xlarge)
    title:setFillColor(unpack(color.title))

    local playButton = widget.newButton({
        -- Button to return to main menu
        -- Check if want to leave while the puzzle is still not solved
        x = display.contentCenterX,
        y = display.contentHeight * 0.7,
        label = "Play",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        emboss = true,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = display.contentWidth * 0.4,
        height = display.contentHeight * 0.1,
    })
    sceneGroup:insert(playButton)

    local aboutButton = widget.newButton({
        -- Button to return to main menu
        -- Check if want to leave while the puzzle is still not solved
        x = display.contentCenterX,
        y = display.contentHeight * 0.85,
        label = "About",
        labelAlign = "center",
        labelColor = globalData.labelColor,
        font = globalData.font.default,
        fontSize = globalData.font.size.normal,
        emboss = true,
        shape = "rect",
        fillColor = globalData.buttonColor,
        width = display.contentWidth * 0.4,
        height = display.contentHeight * 0.1,
    })
    sceneGroup:insert(aboutButton)

    playButton:addEventListener("tap", 
        function ()
            composer.gotoScene("chooseLevel", globalData.fade)
        end
    )

    aboutButton:addEventListener("tap",
        function ()
            composer.gotoScene("about", globalData.fade)
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