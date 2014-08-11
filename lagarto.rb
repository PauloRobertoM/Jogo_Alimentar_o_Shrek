require 'gosu'

class Lagarto

  attr_reader :pos_x, :pos_y #Atributo legível, visto exteriormente
  
  def initialize(janela)
    @janela = janela
    @pos_x = rand(@janela.width) #Criar em posição radômica no eixo x (Aleatoriedade)
    @pos_y = -50 #Criar por fora da tela no eixo y
    @imagem = Gosu::Image.new(@janela, "imagens/lagarto.png", true) 
  end 

  def update
    @pos_y += 2 #Velocidade de descida do Objeto
    if (@pos_y > @janela.width) then  
      @pos_y = -rand(200) #Frequência de criação
      @pos_x = rand(@janela.width)
    end
  end

  def draw
    @imagem.draw(@pos_x, @pos_y, 1)
  end
end
