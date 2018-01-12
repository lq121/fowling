
local OverScene = class("OverScene", function()
    return display.newScene("OverScene")
end)

function OverScene:ctor()
    -- 创建背景
    display.newSprite("res/scene.jpg")
    :align(display.CENTER, display.cx, display.cy)
    :addTo(self)

-- 分数
    self.score = cc.ui.UILabel.new({text="0",size = 80,color = cc.c3b(0, 0, 255)})
                :align(display.CENTER, display.cx, display.cy+30)
                :addTo(self)


-- 开始按钮
    cc.ui.UIPushButton.new("res/continue.png")
    :align(display.CENTER, display.cx, display.cy-100)
    :addTo(self)
    :addButtonClickedEventListener(function()
        -- body
        cc.Director:getInstance():pushScene(import("app.scenes.MainScene").new())
    end)
   
end

function OverScene:setScore(value)
    -- body
    self.score:setString(value)
end

function OverScene:onEnter()
end

function OverScene:onExit()
end

return OverScene
