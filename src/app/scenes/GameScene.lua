
local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
    end)

local birdRect = {
cc.rect(0,0,500,500),
cc.rect(500,0,500,500),
cc.rect(1000,0,500,500),
cc.rect(0,500,500,500),
cc.rect(500,500,500,500),
cc.rect(1000,500,500,500),
cc.rect(0,1000,500,500),
cc.rect(500,1000,500,500),
cc.rect(1000,1000,500,500),
}

function GameScene:ctor()

    self.countDown = 2000;
    self.scoreValue = 0;

    -- 小鸟数组
    self.birdArr = {}

    -- 创建背景
    display.newSprite("res/gameBG.jpg")
    :align(display.CENTER, display.cx, display.cy)
    :addTo(self)

    -- 分数
    self.score = cc.ui.UILabel.new({text="0",size = 50})
    :align(display.LEFT_TOP, 10, display.height-10)
    :addTo(self)

    -- 倒计时
    self.time = cc.ui.UILabel.new({text = tostring(math.floor(self.countDown / 100)).."'",
        size = 60
        })
    :align(display.RIGHT_TOP, display.width - 10 , display.height-10)
    :addTo(self)

    -- 小鸟层
    self.birdLayer = display.newNode():addTo(self)

end

function GameScene:onEnter()
    local scheduler = require(cc.PACKAGE_NAME..".scheduler");
    self.step = 0;
    local me = self;
    self.updateid = scheduler.scheduleUpdateGlobal(function (t)
        -- body
        me.countDown = me.countDown - t * 100;
        me.time:setString(math.floor(me.countDown / 100).."'");
        if me.countDown <= 0 then
            --todo
            -- 游戏结束
            local gameOver = import("app.scenes.OverScene").new()
            gameOver:setScore(me.scoreValue)
            cc.Director:getInstance():replaceScene(gameOver)
        end

        me.step = me.step + 1;
        if me.step % 20 == 0 then
            -- 创建小鸟
            -- 方向
            local  way = math.random()>0.5 and 1 or -1
            -- 开始位置
            local starPos = cc.p(way == 1 and display.width or 0,math.random(0,display.height))
            -- 结束位置
            local endPos = cc.p(way == 1 and 0 or display.width,math.random(0,display.height))
            -- 飞行时间
            local time = math.random(1,3)

            -- 创建小鸟
            local bird = cc.Sprite:create("res/birds.png",birdRect[math.random(1,9)])
            :setScale(0.3*way,0.3)
            :setAnchorPoint(cc.p(0,0.5))
            :setPosition(starPos)
            :addTo(self.birdLayer)
            bird:retain()

            table.insert(me.birdArr,bird);

            bird:runAction(cc.Sequence:create(
                cc.MoveTo:create(time,endPos),
                cc.CallFunc:create(function ()
                     -- body
                     bird:removeFromParent();
                     for i,v in ipairs(me.birdArr) do
                        if b == bird then
                            --todo
                            table.remove(me.birdArr, i)
                            break;
                        end
                    end
                    end)
                ))
        end
        end)

    -- 添加触摸事件
    self.touchEvent = cc.EventListenerTouchOneByOne:create()
    self.touchEvent:registerScriptHandler(function(touch,event)
        -- 处理触摸事件
        for  i = #me.birdArr,1 ,-1 do
            local bird = me.birdArr[i]
            local box = bird:getBoundingBox();
            if cc.rectContainsPoint(box,touch:getLocation()) then
                --todo
                local audio = cc.SimpleAudioEngine:getInstance()
                 audio:playEffect("yoho.mp3", false);
                me.scoreValue = me.scoreValue + 1;
                me.score:setString(me.scoreValue);
                table.remove(me.birdArr,i)
                bird:removeFromParent()
                break;
            end
        end


        end,cc.Handler.EVENT_TOUCH_BEGAN)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(self.touchEvent, self)

end

function GameScene:onExit()
    -- 移除定时器
    local scheduler = require(cc.PACKAGE_NAME..".scheduler");
    scheduler.unscheduleGlobal(self.updateid) 
    -- 移除当前的触摸事件
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.touchEvent)
end

return GameScene
