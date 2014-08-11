require 'gosu'

class Bota

  attr_reader :pos_x, :pos_y
  
  def initialize(janela)
    @janela = janela
    @pos_x = rand(@janela.width) 
    @pos_y = -50 
    @imagem = Gosu::Image.new(@janela, "imagens/bota.png", true)
  end 

  def update
    @pos_y += 4
    if (@pos_y > @janela.width) then
      @pos_y = -rand(600)
      @pos_x = rand(@janela.width)
    end
  end

  def draw
    @imagem.draw(@pos_x, @pos_y, 1)
  end
end
