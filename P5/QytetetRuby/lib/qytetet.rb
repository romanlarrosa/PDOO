#encoding:utf-8
#qyt = Qytetet.instance

require_relative 'sorpresa'
require_relative 'casilla'
require_relative 'jugador'
require_relative 'tipo_sorpresa'
require_relative 'tablero'
require_relative 'dado'
require_relative 'EstadoJuego'
require "singleton"

module ModeloQytetet
  class Qytetet
    include Singleton
    def initialize()
    @mazo = Array.new
    @tablero = Tablero.new
    @@MAX_JUGADORES = 4
    @@NUM_SORPRESAS = 10
    @@NUM_CASILLAS = 20
    @@PRECIO_LIBERTAD = 200
    @@SALDO_SALIDA = 1000
    @dado = Dado.instance
    @cartaActual = nil
    @jugadorActual
    @indiceJugadorActual = 0
    @jugadores = Array.new
    @EstadoJuego
    
    
   end
    
    attr_accessor:mazo,:tablero, :cartaActual, :dado, :jugadorActual, :jugadores, :EstadoJuego, :indiceJugadorActual
    
    private
    def inicializarCartasSorpresa
      
      
      
      @mazo << Sorpresa.new("Felicidades, ahora eres un Especulador. Aprovechate. ", TipoSorpresa::CONVERTIRME, 3000)
      
      @mazo << Sorpresa.new("¡Felicidades! Has acertado la quiniela. ¡Puedes cobrar tu premio!", TipoSorpresa::PAGARCOBRAR, 200) 
    
      @mazo << Sorpresa.new("Te han pillado conduciendo un poco \"afectado\". Te toca pasar por caja.", TipoSorpresa::PAGARCOBRAR, -200)
    
      @mazo << Sorpresa.new("Te hemos pillado con chanclas y calcetines,lo sentimos, ¡debes ir a la carcel!", TipoSorpresa::IRACASILLA, 5)
    
      @mazo << Sorpresa.new("Te ha salido un casting gracias a tu agencia y tu representante, Paquita. Ve sin tardanza a la casilla 12", TipoSorpresa::IRACASILLA, 12)
    
      @mazo << Sorpresa.new("Estás cansado de tanto dar vueltas. Ve a descansar y a comerte una palmera de chocolate al Parking", TipoSorpresa::IRACASILLA, 10)
    
      @mazo << Sorpresa.new("Pierdes una apuesta. Invita a todos los jugadores a cenar en una marisquería", TipoSorpresa::PORJUGADOR, -100)
    
      @mazo << Sorpresa.new("¡Felicidades! Hoy es el día de tu no cumpleaños, recibes un regalo de todos", TipoSorpresa::PORJUGADOR, 200)
    
      @mazo << Sorpresa.new("Recibes un premio por alojamiento pintoresco. Cobras 100 por cada casa y cada hotel de tu propiedad", TipoSorpresa::PORCASAHOTEL, 100)
    
      @mazo << Sorpresa.new("Decides reformar tu imagen corporativa. Paga 80 por cada casa y cada hotel de tu propiedad", TipoSorpresa::PORCASAHOTEL, -80)
    
      @mazo << Sorpresa.new("Usa esta carta si caes en la carcel para salir del trullo.", TipoSorpresa::SALIRCARCEL, 0)
      
      @mazo << Sorpresa.new("Con tu nuevo titulo de Especulador puedes ser une chique male. ;)", TipoSorpresa::CONVERTIRME, 5000)
    
      #barajar las cartas
      @mazo.shuffle!
    end
    
    public
    def actuarSiEnCasillaEdificable()
      deboPagar = @jugadorActual.deboPagarAlquiler
      if(deboPagar)
        puts "Hay que pagar el alquiler"
        @jugadorActual.pagarAlquiler()
        if(@jugadorActual.saldo <= 0)
         @EstadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
        end
      end
      tengoPropietario = obtenerCasillaJugadorActual.tengoPropietario
      if(@estado != EstadoJuego::ALGUNJUGADORENBANCARROTA)
        if (tengoPropietario)
          @EstadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
        else
          @EstadoJuego = EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
        end
      end
    end
    
    def actuarSiEnCasillaNoEdificable()
      @EstadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      casillaActual = @jugadorActual.casillaActual
      if(casillaActual.tipo == TipoCasilla::IMPUESTO)
        @jugadorActual.pagarImpuesto();
      else if(casillaActual.tipo == TipoCasilla::JUEZ)
          if(@jugadorActual.deboIrACarcel)
          encarcelarJugador
          end
      else if(casillaActual.tipo == TipoCasilla::SORPRESA)
          @cartaActual = @mazo.at(0); #preguntar mañana
          #como eliminar del mazo la casilla
          @mazo.delete_at(0)
          @EstadoJuego = EstadoJuego::JA_CONSORPRESA
          
      end
    end
      end
      end
      
    
    def aplicarSorpresa()
      @EstadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      
      if(@cartaActual.tipo == TipoSorpresa::SALIRCARCEL)
        @jugadorActual.cartaLibertad = @cartaActual
      else
        @mazo << @cartaActual
      end
      if(@cartaActual.tipo == TipoSorpresa::PAGARCOBRAR)
        @jugadorActual.saldo += @cartaActual.valor
        if(@jugadorActual.saldo < 0)
          @EstadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
        end
      else if(@cartaActual.tipo == TipoSorpresa::IRACASILLA)
          valor = @cartaActual.valor
          casillaCarcel = @tablero.esCasillaCarcel(valor)
          if(casillaCarcel)
            encarcelarJugador
          else
            mover(valor);
          end
      else if (@cartaActual.tipo == TipoSorpresa::PORJUGADOR)
          for i in @jugadores
            if(@jugadorActual != i)
              i.saldo -= @cartaActual.valor
              if(i.saldo < 0)
                @EstadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
              @jugadorActual.saldo += @cartaActual.valor
              if(@jugadorActual.saldo < 0)
                @EstadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
              end
            end
          end
      else if(@cartaActual.tipo == TipoSorpresa::PORCASAHOTEL)
          cantidad = @cartaActual.valor
          numeroTotal = @jugadorActual.cuantasCasasHotelesTengo
          @jugadorActual.saldo += cantidad*numeroTotal
          if(@jugadorActual.saldo < 0)
            @EstadoJuego = EstadoJuego::ALGUNJUGADORENBANCARROTA
          end
      else if(@cartaActual.tipo == TipoSorpresa::CONVERTIRME)
          #especulador = Especulador.new
          especulador = @jugadorActual.convertirme(@cartaActual.valor)
          @jugadores[@indiceJugadorActual] = especulador
      end
        end
      end
      end
      end
      
    end
    
    def cancelarHipoteca(numCasilla)
      titulo = @tablero.obtenerCasillaNumero(numCasilla).titulo
      cancelada = @jugadorActual.cancelarHipoteca(titulo)
      @EstadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      return cancelada
    end
    
    def comprarTituloPropiedad()
      comprado = @jugadorActual.comprarTituloPropiedad
      if(comprado)
        @EstadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      return comprado
    end
    
    def edificarCasa(numcasilla)
      edificada = false
      casilla = @tablero.obtenerCasillaNumero(numcasilla)
      titulo = casilla.titulo
      edificada = @jugadorActual.edificarCasa(titulo)
      if(edificada)
         @EstadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      return edificada
    end
    
    def edificarHotel(numcasilla)
      edificado  = false
      casilla = @tablero.obtenerCasillaNumero(numcasilla)
      titulo = casilla.titulo
      edificado = @jugadorActual.edificarHotel(titulo)
      if(edificado)
        @EstadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      return edificado
    end
    
    private
    def encarcelarJugador()
      if(!@jugadorActual.tengoCartaLibertad())
        puts "Te pilla el juez. Te envía a la carcel"
        casilla = @tablero.carcel
        @jugadorActual.irACarcel(casilla)
        @EstadoJuego = EstadoJuego::JA_ENCARCELADO
      else
        puts "El juez te ha pillado, pero por suerte tenías una carta para salir."
        carta = @jugadorActual.devolverCartaLibertad
        @mazo << carta
        @EstadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
    end
    
    public
    def getValorDado()
      return @dado.valor
    end
    
    def hipotecarPropiedad(numcasilla)
      casilla = @tablero.obtenerCasillaNumero(numcasilla)
      titulo = casilla.titulo
      @jugadorActual.hipotecarPropiedad(titulo)
    end
    
    def inicializarJuego(nombresArray)
      inicializarJugadores(nombresArray)
      @tablero.inicializar
      inicializarCartasSorpresa
      salidaJugadores
    end
    
    private
    def inicializarJugadores(nombresArray)
      for i in nombresArray
        @jugadores << Jugador.nuevo(i)
      end
    end
    
    public
    def intentarSalirCarcel(metodoSC)
      if(metodoSC == MetodoSalirCarcel::TIRANDODADO)
        resultado = tirarDado();
        puts "Has sacado un #{resultado}\n"
        if(resultado >=5)
          puts "\bEs mayor que 5, sales de la carcel\n"
          @jugadorActual.encarcelado =false 
        else
          puts "\bNo consigues suficiente puntuacion. Permaneces en la carcel\n"
        end
      else
        if(metodoSC == MetodoSalirCarcel::PAGANDOLIBERTAD)
          @jugadorActual.pagarLibertad(@@PRECIO_LIBERTAD)
        end
      end
      enLaCarcel = @jugadorActual.encarcelado
      if(enLaCarcel)
        @EstadoJuego = EstadoJuego::JA_ENCARCELADO
      else
        @EstadoJuego = EstadoJuego::JA_PREPARADO
      end
      return enLaCarcel
    end
    
    def jugar()
      c = @tablero.obtenerCasillaFinal(@jugadorActual.getCasillaActual, tirarDado())
      #puts "El dado ha sacado #{@dado.valor}. 
      #La casilla final es #{c.to_s}"
      #*************FUNCIONA ******************
      mover(c.num_casilla)
      #puts "El jugador actual #{@jugadorActual.nombre} ha sido movio a la casilla: #{@jugadorActual.casillaActual.to_s}"
      
    end
    
    def mover(numcasilladestino)
      casillaInicial = @jugadorActual.casillaActual
      casillaFinal = @tablero.obtenerCasillaNumero(numcasilladestino)
      @jugadorActual.casillaActual = casillaFinal
      if(numcasilladestino < casillaInicial.num_casilla)
        @jugadorActual.modificarSaldo(@@SALDO_SALIDA)
      end
      if(casillaFinal.soyEdificable)
        actuarSiEnCasillaEdificable
      else
        actuarSiEnCasillaNoEdificable
      end
     end
    def obtenerCasillaJugadorActual()
      
      return @jugadorActual.casillaActual
    end
    
    def obtenerCasillasTablero()
      return @tablero.casillas
    end
    
    def obtenerPropiedadesJugador()
      numeros = Array.new
      for i in @jugadorActual.propiedades
        for j in @tablero.casillas
          if j.titulo == i
            numeros << j.num_casilla
          end
        end
      end
      return numeros
    end
    
    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estadoH)
      numeros = Array.new
      for i in @jugadorActual.obtenerPropiedades(estadoH)
        for j in @tablero.casillas
          if (i.equal?(j.titulo))
            numeros << j.num_casilla
          end
        end
      end
      return numeros
    end
    
    def obtenerRanking()
      @jugadores = @jugadores.sort
    end
    
    def obtenerSaldoJugadorActual()
      
      return @jugadorActual.saldo
    end
    
    private
    def salidaJugadores()
      for i in @jugadores
        i.casillaActual = @tablero.casillas[0]
      end
      @indiceJugadorActual = rand(@jugadores.size)
      @jugadorActual = @jugadores[@indiceJugadorActual]
      @EstadoJuego = EstadoJuego::JA_PREPARADO
    end
    
    public
    def siguienteJugador()
      @indiceJugadorActual = (@indiceJugadorActual + 1) % @jugadores.size
      @jugadorActual = @jugadores[@indiceJugadorActual]
      if @jugadorActual.encarcelado
        @EstadoJuego = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      else
        @EstadoJuego = EstadoJuego::JA_PREPARADO
      end
    end
    
    def tirarDado()
      
      return @dado.tirar;
    end
    
    def venderPropiedad(numcasilla)
      casilla = @tablero.obtenerCasillaNumero(numcasilla)
      @jugadorActual.venderPropiedad(casilla)
      @EstadoJuego = EstadoJuego::JA_PUEDEGESIONAR
      
    end
  end
end
