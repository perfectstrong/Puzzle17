local composer = require( "composer" )
local globalData = require("globalData")
local widget = require("widget")
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 

-- Initial setups

local background
local counterGroup, navigationGroup
local tilesDisplay, tilesCenter
local sheetOptions, objectSheet, originalImage

-- Prepare tiles
local tiles, nilTile
local colNum, rowNum, hLength, vLength, w, h, scale -- w and h are scaled width and height of a tile
local moveCount, moveText, congratsText
local solved
local sound, nosound, soundSheet

-----------------------------------------------------------------------------------------
-- Useful functions

-- Loading the image in mode letterbox,  scaling in order to be "divisible" then caching
-- Also return the scaled width and height
function fitImage( )
    -- Loading the original image
    image = display.newImage(globalData.gameSetting.imageRoot .. globalData.gameSetting.imagePath)
    local w, h = image.width, image.height
    image:removeSelf()
    image = nil
    print("h0=" .. h)
    print("w0=" .. w)
    -- Scale to fit window
    local recWidth = display.contentWidth - globalData.gamePreconfig.leftPadding - globalData.gamePreconfig.rightPadding
    local recHeight = display.contentHeight - globalData.gamePreconfig.topPadding - globalData.gamePreconfig.bottomPadding
    local scaleFactor = recWidth / w
    local newHeight = h * scaleFactor
    if (newHeight > recHeight) then
        scaleFactor = recHeight / h
    end
    w, h = w * scaleFactor, h * scaleFactor
    print("h1=" .. h)
    print("w1=" .. w)
    -- Scale to be divisible
    w = math.floor(w / colNum) * colNum
    h = math.floor(h / rowNum) * rowNum
    print("h2=" .. h)
    print("w2=" .. w)
    -- Caching
    image = display.newImageRect(globalData.gameSetting.imageRoot .. globalData.gameSetting.imagePath, w, h)
    display.save(image,{
        filename = globalData.gameSetting.imagePath,
        baseDir = system.TemporaryDirectory,
        captureOffscreenArea = true,
        jpegQuality = 1 -- ! Important !
    })
    image:removeSelf()
    image = nil
    return w, h
end

-- Swap a chosen tile with the nil tile which is adjacent
function swap( tile )
    local dj = tile.j - nilTile.j
    local di = tile.i - nilTile.i

    nilTile:translate(dj * w, di * h)
    tile:translate(- dj * w, - di * h)

    nilTile.i, nilTile.j, tile.i, tile.j = tile.i, tile.j, nilTile.i, nilTile.j
    moveCount = moveCount + 1
    moveText.text = moveCount
end

-- Check if there is a nil tile around
function checkNilTile( event )
    local thisTile = event.target
    -- Swap directly with nil tile if adjacent
    if (math.abs(nilTile.i - thisTile.i) + math.abs(nilTile.j - thisTile.j) == 1) then
        swap(thisTile)
        return
    end
end

-- Calculate temporary order
function temporaryOrder( tile )
    if (tile.i == 0) then
        return 0
    else 
        return (tile.i - 1) * colNum + tile.j
    end
end

-- Calculate inversion
function inversion( tile )
    return tile.trueOrder - temporaryOrder(tile)
end

-- Verify if we succeed
function verifyTiles()
    -- Check if the nil tile returns its orignial position
    if (nilTile.i ~= 0) then
        return
    end
    -- Check if other pieces are in right order
    for i = 0, #tiles do
        if (inversion(tiles[i]) ~= 0) then
            return
        end
    end
    -- If true, then we show congrats text
    solved = true
    composer.setVariable("numMoves", moveCount)
    composer.showOverlay("bravo", {
        effect = "fade",
        time = 500,
        isModal = true
    })
end

-- Generate a solvable shuffle of numbers from numTiles first positive integers
function shuffleOrder(numTiles)
    -- Idea from https://gist.github.com/Uradamus/10323382
    local x = {}
    for i = 1, numTiles do
        x[i] = i
    end
    for i = numTiles, 2, -1 do
        local rand = math.random(2, numTiles)
        x[i], x[rand] = x[rand], x[i]
    end
    -- Ensure the shuffle is solvable
    -- Using equations from mathworld.wolfram.com/15Puzzle.html
    local inverCounter, totalInver = {}, 0
    for i = 1, numTiles do
        inverCounter[i] = 0
        for j = i + 1, numTiles do
            if (x[j] < x[i]) then
                inverCounter[i] = inverCounter[i] + 1
            end
        end
        totalInver = totalInver + inverCounter[i]
    end
    -- Check the parity of number of total inversion
    if (totalInver % 2 ~= 0) then
        -- We have to swap a little before handing out
        -- We swap the 2nd and 3rd tile
        -- or any adjacent couple
        -- The move will increase (or decrease) the number of total inversions
        -- by 1, which changes the parity of totalInver
        if (x[2] < x[3]) then
            inverCounter[3] = inverCounter[3] + 1
            totalInver = totalInver + 1
        else
            inverCounter[2] = inverCounter[2] - 1
            totalInver = totalInver - 1
        end
        x[2], x[3] = x[3], x[2]
    end
    return x
end

-- Rearrange randomly all initialized tiles
function shuffleTiles()
    local x = shuffleOrder(rowNum * colNum)
    -- Apply shuffling for tiles
    local newTiles = {}
    for i = 1, #x do
        local thisTile = tiles[x[i]]
        newTiles[i] = thisTile
        if (i % colNum == 0) then
            thisTile.i = i / colNum
            thisTile.j = colNum
        else
            thisTile.j = i % colNum
            thisTile.i = (i - thisTile.j) / colNum + 1
        end
    end

    tiles = newTiles
end

-- Setup the nil tile
function setupNilTile( ... )
    if (nilTile ~= nil) then 
        nilTile:removeSelf()
    end
    nilTile = display.newRect(tilesDisplay, tilesCenter.x - ((colNum - 1)/2) * w, tilesCenter.y - ((rowNum + 1) / 2) * h, w, h)
    nilTile.i = 0
    nilTile.j = 1
    nilTile.trueOrder = 0
    nilTile:setFillColor(0.5)
    tiles[0] = nilTile
end

-- Setup the tiles
function initializeTiles()
    for i = 1, rowNum do
        for j = 1, colNum do
            local order = (i - 1) * colNum + j
            local newTile = display.newImageRect(tilesDisplay, objectSheet, order, w, h)
            newTile.i = i
            newTile.j = j
            newTile.trueOrder = (i - 1) * colNum + j
            tiles[newTile.trueOrder] = newTile
            newTile:addEventListener("tap", checkNilTile)
            newTile:addEventListener("tap", verifyTiles)
        end
    end
end

-- Setup shuffled image
function updateImage()

    for i = 1, #tiles do
        local tile = tiles[i]
        tile.x = tilesCenter.x - ((colNum + 1) / 2 - tile.j) * w
        tile.y = tilesCenter.y - ((rowNum + 1) / 2 - tile.i) * h
    end
end

-- Verify if user want to quit the unsolved current game
function checkQuit( )
    if (solved) then
        composer.gotoScene("mainMenu")
    else
        composer.showOverlay("exitGame", {
            effect = "fade",
            time = 500,
            isModal = true
        })
    end
end

-- Turn sound on or off
function toggleSound( )
    if (globalData.nobgm) then
        globalData.nobgm = false
    else
        globalData.nobgm = true
    end
    -- Toggle sound and icon
    if (globalData.nobgm) then
        sound.isVisible = false
        noSound.isVisible = true
        audio.stop(globalData.bgmChannel)
    else
        sound.isVisible = true
        noSound.isVisible = false
        audio.play(globalData.bgm, { channel = globalData.bgmChannel, loops = - 1, fadein = 1000})        
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    background = display.newImageRect(sceneGroup, globalData.gamePreconfig.background, display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    tilesDisplay = display.newGroup()
    sceneGroup:insert(tilesDisplay)

    tilesCenter = {
        x = display.contentCenterX,
        y = display.contentCenterY
    }
    colNum, rowNum = globalData.gameSetting.colNum, globalData.gameSetting.rowNum
    hLength, vLength = fitImage()
    w, h = hLength / colNum, vLength / rowNum
    print("wp=" .. w)
    print("hp=".. h)

    counterGroup = display.newGroup()
    sceneGroup:insert(counterGroup)
    moveCount = 0
    moveText = display.newText(counterGroup, moveCount, display.contentCenterX, display.contentHeight * 0.1, globalData.font.default, globalData.font.size.large)
    moveText:setFillColor(0, 0, 1)

    -- Load the image in pieces
    sheetOptions = {
        width = w,
        height = h,
        numFrames = colNum * rowNum
    }

    -- Load the cached scaled image
    objectSheet = graphics.newImageSheet(globalData.gameSetting.imagePath, system.TemporaryDirectory, sheetOptions)

    tiles = {}

    -- Prepare buttons
    navigationGroup = display.newGroup()
    sceneGroup:insert(navigationGroup)

    local homeButton = widget.newButton({
        -- Button to return to main menu
        -- Check if want to leave while the puzzle is still not solved
        x = display.contentWidth * 0.25,
        y = display.contentHeight * 0.9,
        label = "Home",
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
    navigationGroup:insert(homeButton)
    homeButton:addEventListener("tap", checkQuit )

    local hintButton = widget.newButton({
        -- Button to show the full original image
        x = display.contentWidth * 0.75,
        y = display.contentHeight * 0.9,
        label = "Hint",
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
    navigationGroup:insert(hintButton)
    hintButton:addEventListener("tap",
        function (  )
            composer.showOverlay("hint", {
                    effect = "fade",
                    time = 500,
                    isModal = true,
                })
        end
    )

    -- Load the icons for sound/no sound
    soundSheet = graphics.newImageSheet(globalData.soundiconsSheet, globalData.soundiconsOptions)
    local wIcon = math.min(display.contentHeight * 0.2, display.contentWidth * 0.2)
    sound = display.newImageRect(navigationGroup, soundSheet, 1, wIcon, wIcon)
    sound.x = display.contentWidth * 0.7
    sound.y = display.contentHeight * 0.1
    sound.isVisible = true
    noSound = display.newImageRect(navigationGroup, soundSheet, 2, wIcon, wIcon)
    noSound.x = display.contentWidth * 0.7
    noSound.y = display.contentHeight * 0.1
    noSound.isVisible = false
    if (globalData.nobgm) then
        toggleSound()
    end
    sound:addEventListener("tap", toggleSound)
    noSound:addEventListener("tap", toggleSound)

    -- Save the original image into global data
    globalData.hint = {
        width = hLength,
        height = vLength,
    }

    -- icon for reshuffling
    local reshuffle = display.newImageRect(navigationGroup, globalData.reshuffle, wIcon, wIcon)
    reshuffle.x = display.contentWidth * 0.9
    reshuffle.y = display.contentHeight * 0.1
    reshuffle.isVisible = true
    reshuffle:addEventListener("tap",
        function (  )
            shuffleTiles()
            solved = false
            moveCount = 0
            moveText.text = moveCount
            setupNilTile()
            updateImage()
        end
    )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        initializeTiles()
        shuffleTiles()
        setupNilTile()
        solved = false
        updateImage()
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
        composer.removeScene("mainGame")
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