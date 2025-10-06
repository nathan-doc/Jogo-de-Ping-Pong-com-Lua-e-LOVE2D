-- player.lua
-- Classe Player para representar um jogador com paddle

Player = {}
Player.__index = Player

function Player:new(x, y, controls)
    -- Cria uma nova instância de Player com posição inicial, controles e atributos
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    self.score = 0
    self.width = 10
    self.height = 100
    self.speed = 300
    self.controls = controls -- {up, down} teclas para mover para cima e para baixo
    return self
end

function Player:update(dt)
    -- Atualiza a posição do paddle baseado nas teclas pressionadas
    if love.keyboard.isDown(self.controls.up) then
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown(self.controls.down) then
        self.y = self.y + self.speed * dt
    end
    -- Limita o paddle para não sair da tela
    self.y = math.max(0, math.min(600 - self.height, self.y))
end

function Player:draw()
    -- Desenha o paddle na tela como um retângulo preenchido
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
