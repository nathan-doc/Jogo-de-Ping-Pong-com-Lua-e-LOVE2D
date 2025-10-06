-- ball.lua
-- Classe Ball para representar a bola do jogo

Ball = {}
Ball.__index = Ball

function Ball:new()
    -- Cria uma nova instância de Ball com posição central e atributos iniciais
    local self = setmetatable({}, Ball)
    self.size = 10
    self.x = 800 / 2 - self.size / 2
    self.y = 600 / 2 - self.size / 2
    self.speed = 200
    self.dx = 0
    self.dy = 0
    return self
end

function Ball:reset()
    -- Reseta a posição da bola para o centro e para a velocidade zero
    self.x = 800 / 2 - self.size / 2
    self.y = 600 / 2 - self.size / 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    -- Atualiza a posição da bola baseado na velocidade
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- Rebate nas bordas superior e inferior
    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
    elseif self.y + self.size >= 600 then
        self.y = 600 - self.size
        self.dy = -self.dy
    end
end

function Ball:draw()
    -- Desenha a bola na tela como um quadrado preenchido
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
end

function Ball:collides(paddle)
    -- Verifica se a bola colide com um paddle usando AABB (Axis-Aligned Bounding Box)
    return self.x < paddle.x + paddle.width and
           paddle.x < self.x + self.size and
           self.y < paddle.y + paddle.height and
           paddle.y < self.y + self.size
end
