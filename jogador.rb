require 'gosu'

class Jogador 
  attr_reader :placar
  attr_reader :vidas
  
  def initialize (janela)
    @janela = janela
    @imagem = Gosu::Image.new(@janela,"imagens/shrek.png", true) #Recebe a imagem do jogador (shrek)
    @pos_x = @janela.width / 2 #Inicia o jogador no meio do eixo x
    @pos_y = 550 #Inicia o jogador na parte inferior da tela, colado em baixo
    @placar = 0 #Inicia o placar zerado
    
    @mordida = Gosu::Sample.new(@janela, "toques/mordida.wav") #Recebe o som, que será iniciado quando o jogador pegar alguma comida
    @pancada = Gosu::Sample.new(@janela, "toques/pancada.wav") #Recebe o som, que será iniciado quando o jogador pegar alguma elemento que não pode ser comido

    #Recebe a imagem do coração
    @imagem_gvida = Gosu::Image.new(@janela, "imagens/coracao1.png", true)
    @imagem_pvida = Gosu::Image.new(@janela, "imagens/coracao2.png", true)
    @vidas = 3
  end 

  def draw
    # Deixar o ângulo na boca do Shrek
    offs_x = 40
    offs_y = 40
    @imagem.draw(@pos_x - offs_x, @pos_y - offs_y, 0)
    
    # Organizar os corações nos lugares desejados e deixá-los brancos de acordo com as vidas
    if (@vidas == 3) then
      @imagem_gvida.draw(10,40,50)
      @imagem_gvida.draw(40,40,50)
      @imagem_gvida.draw(70,40,50)
    elsif (@vidas == 2) then
      @imagem_gvida.draw(10,40,50)
      @imagem_gvida.draw(40,40,50)
      @imagem_pvida.draw(70,40,50)
    elsif (@vidas == 1) then
      @imagem_gvida.draw(10,40,50)
      @imagem_pvida.draw(40,40,50)
      @imagem_pvida.draw(70,40,50)
    else
      @imagem_pvida.draw(10,40,50)
      @imagem_pvida.draw(40,40,50)
      @imagem_pvida.draw(70,40,50)
    end
  end
  
  #Função para mover o jogador, no eixo x, de 10 em 10
  def movi_direita
    @pos_x = @pos_x + 10
    if (@pos_x > @janela.width-(@imagem.width-105)) then
      @pos_x = @janela.width-(@imagem.width-105)
    end
  end

  #Função para mover o jogador, no eixo x, de 10 em 10
  def movi_esquerda
    @pos_x = @pos_x - 10
    if (@pos_x < -25) then
       @pos_x = -25
    end
  end

  #criar a função para retirar o elemento quando a distância for menor que 35, usando o reject!
  def come_rato(ratos)
    n_ratos = ratos.size
    ratos.reject! do |rato|
      Gosu::distance(@pos_x, @pos_y, rato.pos_x, rato.pos_y) < 35
    end
    n = n_ratos - ratos.size
    n.times do @mordida.play end #Inicia o som quando o elemento é retirado
    @placar += n * 10 #Acrescenta 10 pontos quando o elemento é retirado
  end

  def come_lagarto(lagartos)
    n_lagartos = lagartos.size
    lagartos.reject! do |lagarto|
      Gosu::distance(@pos_x, @pos_y, lagarto.pos_x, lagarto.pos_y) < 35
    end
    n = n_lagartos - lagartos.size
    n.times do @mordida.play end
    @placar += n * 10
  end

  def come_sapo(sapos)
    n_sapos = sapos.size
    sapos.reject! do |sapo|
      Gosu::distance(@pos_x, @pos_y, sapo.pos_x, sapo.pos_y) < 35
    end
    n = n_sapos - sapos.size
    n.times do @mordida.play end
    @placar += n * 10
  end

  def come_bota(botas)
    n_botas = botas.size
    botas.reject! do |bota|
      Gosu::distance(@pos_x, @pos_y, bota.pos_x, bota.pos_y) < 35
    end
    n = n_botas - botas.size
    @placar -= n * 5 #Retira 5 pontos quando o elemento é retirado
    n.times do @vidas -= 1 end #Retira 1 vida quando o elemento é retirado
    n.times do @pancada.play end #Inicia o som quando o elemento é retirado
  end
  
  def come_martelo(martelos)
    n_martelos = martelos.size
    martelos.reject! do |martelo|
      Gosu::distance(@pos_x, @pos_y, martelo.pos_x, martelo.pos_y) < 35
    end
    n = n_martelos - martelos.size
    @placar -= n * 10 #Retira 10 pontos quando o elemento é retirado
    n.times do @vidas -= 1 end
    n.times do @pancada.play end
  end

  def come_serrador(serradores)
    n_serradores = serradores.size
    serradores.reject! do |serrador|
      Gosu::distance(@pos_x, @pos_y, serrador.pos_x, serrador.pos_y) < 35
    end
    n = n_serradores - serradores.size
    @placar -= n * 7 #Retira 7 pontos quando o elemento é retirado
    n.times do @vidas -= 1 end
    n.times do @pancada.play end
  end
end