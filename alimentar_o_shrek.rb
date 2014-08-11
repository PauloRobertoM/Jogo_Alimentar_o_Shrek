$LOAD_PATH << '.'

require 'gosu'
require 'jogador'
require 'rato'
require 'lagarto'
require 'sapo'
require 'bota'
require 'martelo'
require 'serrador'

class AlimentarOShrek < Gosu::Window
  @@formato = [3, 1.5, 1.5, 0x68686868] #Configura o formato, tamanho e cor do placar
  @@formato2 = [3, 1.5, 1.5, 0xFFFFFFFF] #Configura o formato, tamanho e cor das mensagens de início e fim
  
  def initialize 
    super(800,600,false) #Tamanho da tela
    self.caption = "Alimentar o Shrek"
    @imagem_fundo = Gosu::Image.new(self, "imagens/fundo.png", true) #Carrega o plano de fundo durante o jogo
    @imagem_inicio = Gosu::Image.new(self, "imagens/fundo_inicio.png", true) #Carrega o plano de fundo do início do jogo
    @imagem_fim = Gosu::Image.new(self, "imagens/fundo_final.png", true) #Carrega o plano de fundo do final do jogo

    @toque_inicio = Gosu::Song.new(self, "toques/toque_inicio.ogg") #Carrega o toque do início e fim do jogo
    @toque_meio = Gosu::Song.new(self, "toques/toque_meio.ogg") #Carrega o toque durante o jogo

    @jogador = Jogador.new(self)

    #Inicia os arrays dos objetos que vão cair
    @ratos = []
    @lagartos = []
    @sapos = []             
    @botas = []
    @martelos = []
    @serradores = []

    @fonte = Gosu::Font.new(self, Gosu::default_font_name, 20) #Define a fonte, com o tamanho da letra da mensagem

    @vidas = 3   
    @estado = "INICIO"
  end 

  ############  DRAW  ##############
  def draw
    @imagem_fundo.draw(0,0,0)

    #Estados do jogo
    if (@estado == "INICIO") then
      draw_inicio
    elsif (@estado == "JOGANDO") then
      draw_jogando
    else
      draw_fim
    end
  end
  
  private
  def draw_inicio
    @toque_inicio.play #Inicia o toque do inicio
    msg = "PRESSIONE [ESPACO] PARA COMECAR" #Mensagem de inicio
    @fonte.draw(msg, 170, 250, *@@formato2) #Recebe a fonte, já definida la em cima, e localização e a formatação
    @imagem_inicio.draw(0,0,0)
  end

  def draw_jogando
    @toque_meio.play #Inicia o toque do meio do jogo
    @imagem_fundo.draw(0,0,0)
    @jogador.draw()
    @fonte.draw("Placar: #{@jogador.placar}", 10, 10, *@@formato) #Recebe a fonte, já definida la em cima, e localização e a formatação

    #Desenha cada elemento de cada array
    for rato in @ratos do
      rato.draw
    end

    for lagarto in @lagartos do
      lagarto.draw
    end

    for sapo in @sapos do
      sapo.draw
    end

    for bota in @botas do
      bota.draw
    end

    for martelo in @martelos do
      martelo.draw
    end

    for serrador in @serradores do
      serrador.draw
    end
  end

  def draw_fim
    @toque_inicio.play #Inicia o toque do fim
    msg = "FIM DE JOGO, VOCE FEZ #{@jogador.placar} PONTOS" #Mensagem
    @fonte.draw(msg, 170, 250, *@@formato2) #Recebe a fonte, já definida la em cima, e localização e a formatação
	  msg2 = "PRESSIONE A TECLA [S] PARA SAIR" #Mensagem
	  @fonte.draw(msg2, 170, 300, *@@formato2) #Recebe a fonte, já definida la em cima, e localização e a formatação
    @imagem_fim.draw(0,0,0)
  end

  ############  UPDATE  ##############
  public
  def update

    #Estados do jogo
    if (@estado == "INICIO") then
      update_inicio      
    elsif (@estado == "JOGANDO") then
      update_jogando
    else
		  update_fim
	  end
  end

  private 
  def update_inicio
    #Condição para verificar se o botão espaço esta pressionado e inicia o jogo
    @estado = "JOGANDO" if button_down?(Gosu::Button::KbSpace)
  end

  def update_jogando

    #Chama as funções de movimento do jogador
    if (button_down?(Gosu::Button::KbRight)) then
      @jogador.movi_direita
    end
    if (button_down?(Gosu::Button::KbLeft)) then
      @jogador.movi_esquerda
    end

    #Cria mais objetos quando o tamanho da condição if é favorecida
    if rand(100) < 10 and @ratos.size < 2 then
      @ratos.push(Rato.new(self))
    end 
    @jogador.come_rato(@ratos) #Chama a função, relativa a cada objeto, para retirar (reject!) o elemento com distancia menor que 35

    #Lógica para da o update em cada elemento de cada array
    for rato in @ratos do
      rato.update
    end

    if rand(100) < 10 and @lagartos.size < 1 then
      @lagartos.push(Lagarto.new(self))
    end 
    @jogador.come_lagarto(@lagartos)
    for lagarto in @lagartos do
      lagarto.update
    end

    if rand(100) < 10 and @sapos.size < 1 then
      @sapos.push(Sapo.new(self))
    end 
    @jogador.come_sapo(@sapos)
    for sapo in @sapos do
      sapo.update
    end

    if rand(100) < 10 and @botas.size < 3 then
      @botas.push(Bota.new(self))
    end 
    @jogador.come_bota(@botas)
    for bota in @botas do
      bota.update
    end

    if rand(100) < 10 and @martelos.size < 3 then
      @martelos.push(Martelo.new(self))
    end 
    @jogador.come_martelo(@martelos)
    for martelo in @martelos do
      martelo.update
    end

    if rand(100) < 10 and @serradores.size < 3 then
      @serradores.push(Serrador.new(self))
    end 
    @jogador.come_serrador(@serradores)
    for serrador in @serradores do
      serrador.update
    end
    
    #Se as vidas zerarem, o jogo passa para o estado final    
    @estado = "FIM" if @jogador.vidas == 0
  end

  def update_fim
    if button_down?(Gosu::Button::KbS) then #Aqui ele aguarda o jogador apretar S para sair
		  exit
	  end
  end
end