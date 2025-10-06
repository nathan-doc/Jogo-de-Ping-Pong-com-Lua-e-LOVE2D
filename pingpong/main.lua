-- main.lua
-- Importa as classes Player, Ball e AI
require "player"
require "ball"
require "ai"

function love.load()
    -- Inicializa os jogadores com posições e controles
    player1 = Player:new(10, (600 - 100) / 2, {up = "w", down = "s"})
    player2 = Player:new(800 - 10 - 10, (600 - 100) / 2, {up = "up", down = "down"})

    -- Inicializa a bola
    ball = Ball:new()

    -- Estado do jogo: menu, start, serve, play
    gameState = "menu"
    -- Modo de jogo: "single" para um jogador, "multi" para dois jogadores
    gameMode = nil
    -- Temporizador para o delay do saque
    serveTimer = 0
    serveDelay = 1 -- segundos

    -- Fonte para exibir o placar
    scoreFont = love.graphics.newFont(40)

    -- Instância da IA (inicialmente nil)
    ai = nil
end

function love.update(dt)
    -- Atualiza o jogador 1 (sempre controlado por teclado)
    player1:update(dt)

    -- Atualiza o jogador 2: IA no modo single player, teclado no modo multiplayer
    if gameMode == "single" then
        if ai == nil then
            ai = AI:new(player2, ball)
        end
        ai:update(dt)
    else
        player2:update(dt)
    end

    -- Lógica do estado serve: delay antes da bola começar a se mover
    if gameState == "serve" then
        serveTimer = serveTimer + dt
        if serveTimer >= serveDelay then
            -- Define a direção e velocidade inicial da bola
            ball.dx = (math.random(2) == 1 and -1 or 1) * ball.speed
            ball.dy = (math.random() * 2 - 1) * ball.speed
            gameState = "play"
        end
    elseif gameState == "play" then
        -- Atualiza a posição da bola
        ball:update(dt)

        -- Verifica colisão da bola com os jogadores e altera direção
        if ball:collides(player1) then
            ball.x = player1.x + player1.width
            ball.dx = -ball.dx * 1.03
            ball.dy = ball.dy + (math.random() * 60 - 30)
        elseif ball:collides(player2) then
            ball.x = player2.x - ball.size
            ball.dx = -ball.dx * 1.03
            ball.dy = ball.dy + (math.random() * 60 - 30)
        end

        -- Verifica se a bola saiu da tela para marcar pontos
        if ball.x < 0 then
            player2.score = player2.score + 1
            resetBall()
        elseif ball.x > 800 then
            player1.score = player1.score + 1
            resetBall()
        end
    end
end

function love.draw()
    -- Limpa a tela com cor preta
    love.graphics.clear(0, 0, 0)

    -- Desenha o jogo se não estiver no menu
    if gameState ~= "menu" then
        love.graphics.setColor(1, 1, 1)
        player1:draw()
        player2:draw()
        ball:draw()

        -- Desenha o placar
        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1.score), 300, 20)
        love.graphics.print(tostring(player2.score), 480, 20)
    end

    -- Desenha o menu e outras mensagens
    love.graphics.setFont(love.graphics.newFont(20))
    if gameState == "menu" then
        love.graphics.printf("Jogo Pong", 0, 200, 800, "center")
        -- Botões do menu para selecionar modo de jogo
        love.graphics.rectangle("line", 300, 250, 200, 50)
        love.graphics.printf("Jogador Único", 300, 260, 200, "center")
        love.graphics.rectangle("line", 300, 310, 200, 50)
        love.graphics.printf("Multijogador", 300, 320, 200, "center")
        love.graphics.printf("Pressione Escape para Sair", 0, 380, 800, "center")
    elseif gameState == "start" then
        love.graphics.printf("Pressione Enter para Iniciar", 0, 280, 800, "center")
    elseif gameState == "serve" then
        love.graphics.printf("Pressione Enter para Sacar", 0, 280, 800, "center")
    end
end

function love.keypressed(key)
    -- Sai do jogo se apertar escape
    if key == "escape" then
        love.event.quit()
    -- Inicia o jogo ao apertar enter ou return
    elseif key == "return" or key == "enter" then
        if gameState == "start" then
            gameState = "serve"
            serveTimer = 0
        elseif gameState == "serve" then
            serveTimer = 0
        end
    end
end

function love.mousepressed(x, y, button)
    -- Detecta clique do mouse no menu para selecionar modo de jogo
    if gameState == "menu" and button == 1 then
        if x >= 300 and x <= 500 and y >= 250 and y <= 300 then
            gameMode = "single"
            gameState = "start"
        elseif x >= 300 and x <= 500 and y >= 310 and y <= 360 then
            gameMode = "multi"
            gameState = "start"
        end
    end
end

function resetBall()
    -- Reseta a posição da bola e muda o estado para serve
    ball:reset()
    serveTimer = 0
    gameState = "serve"
end
