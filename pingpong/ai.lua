-- ai.lua
-- Classe AI para controlar o movimento do paddle automaticamente

AI = {}
AI.__index = AI

function AI:new(paddle, ball)
    -- Cria uma nova instância da IA associada a um paddle e a bola
    local self = setmetatable({}, AI)
    self.paddle = paddle
    self.ball = ball
    self.speed = paddle.speed
    return self
end

function AI:update(dt)
    -- Atualiza a posição do paddle para seguir a bola verticalmente
    if self.ball.y + self.ball.size / 2 < self.paddle.y + self.paddle.height / 2 then
        self.paddle.y = self.paddle.y - self.speed * dt
    elseif self.ball.y + self.ball.size / 2 > self.paddle.y + self.paddle.height / 2 then
        self.paddle.y = self.paddle.y + self.speed * dt
    end

    -- Limita o paddle para não sair da tela
    self.paddle.y = math.max(0, math.min(600 - self.paddle.height, self.paddle.y))
end
