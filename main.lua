local love = require "love"
local enemy = require "Enemy"
local button = require "Button"
local helpers = require "Helpers"

math.randomseed(os.time())

local game = {
    difficulty = 1,
    state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    },
    points = 0,
    levels = {4, 6, 8, 10}
}

local buttons = {
    menu_state = {}
}

local player = {
    radius = 20,
    x = 20,
    y = 20
}

local enemies = {}

local function changeGameState(state)
    game.state["menu"] = state == "menu"
    game.state["paused"] = state == "paused"
    game.state["running"] = state == "running"
    game.state["ended"] = state == "ended"
end

local function startNewGame()
    changeGameState("running")

    game.points = 0
    enemies = { enemy(1)}
end

function love.load()
    love.window.setTitle("Save The Ball")
    love.mouse.setVisible(false)

    buttons.menu_state.play_game = button("Play Game", startNewGame, nil, 90, 30)
    buttons.menu_state.settings = button("Settings", nil, nil, 90, 30)
    buttons.menu_state.exit_game = button("Exit", love.event.quit, nil, 90, 30)
end


function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:checkPressed(x, y, player.radius)
                end
            end
        end
    end
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    if game.state["running"] then
        for i = 1, #enemies do
            enemies[i]:move(player.x, player.y)
        end
        game.points = game.points + dt
    end
end

function love.draw()
    love.graphics.printf(
        "FPS: ".. love.timer.getFPS(),
        love.graphics.newFont(16),
        10,
        love.graphics.getHeight() - 30,
        love.graphics.getWidth()
    )

    if game.state["running"] then
        if helpers.getTableLength(game.levels) > 0 then
            if game.points >= game.levels[1] then
                game.difficulty = game.difficulty + 1
                table.insert(enemies, enemy(game.difficulty))
                table.remove(game.levels, 1)
            end
        end
        for i = 1, #enemies do
            enemies[i]:draw()
        end

        love.graphics.circle('fill', player.x, player.y, player.radius)

        love.graphics.printf(math.floor(game.points), love.graphics.newFont(20), 0, 10, love.graphics.getWidth(), "center")
    elseif game.state["menu"] then
        buttons.menu_state.play_game:draw(10, 20, 8, 8)
        buttons.menu_state.settings:draw(10, 70, 8, 8)
        buttons.menu_state.exit_game:draw(10, 120, 8, 8)
    end

    if not game.state["running"] then
        love.graphics.circle('fill', player.x, player.y, player.radius / 2)
    end
end
