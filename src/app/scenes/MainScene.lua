
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- 创建背景
    display.newSprite("res/scene.jpg")
    :align(display.CENTER, display.cx, display.cy)
    :addTo(self)

    -- 开始按钮
    cc.ui.UIPushButton.new("res/star.png")
    :align(display.CENTER, display.cx, display.cy)
    :addTo(self)
    :addButtonClickedEventListener(function()
        -- body
        cc.Director:getInstance():pushScene(import("app.scenes.GameScene").new())
    end)

    -- 播放音乐
    local audio = cc.SimpleAudioEngine:getInstance()
    audio:playMusic("bird.mp3", true);
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
