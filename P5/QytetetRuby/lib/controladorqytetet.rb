#encoding:utf-8
require "singleton"
require_relative 'metodo_salir_carcel'
require_relative 'EstadoJuego'
require_relative 'qytetet'

module ControladorQytetet
    class ControladorQytetet
      include Singleton
      def initialize()
        @nombreJugadores = Array.new
        @modelo = ModeloQytetet::Qytetet.instance
      end
      
      attr_accessor:nombreJugadores
      public  
      def obtenerOperacionesDeJuegoValidas()
        ov = Array.new
        
        if(@modelo.jugadores.empty?)
          ov << OpcionMenu.index(:INICIARJUEGO)
          return ov
        end
        
        #puts "El estado de juego es " + @modelo.EstadoJuego.to_s
        case @modelo.EstadoJuego
        when :ja_encarcelado
          ov << OpcionMenu.index(:PASARTURNO)
          ov << OpcionMenu.index(:MOSTRARTABLERO)
          ov << OpcionMenu.index(:MOSTRARJUGADORES)
          ov << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          ov << OpcionMenu.index(:TERMINARJUEGO)
         
        when :ja_encarceladoconopciondelibertad
          
          ov << OpcionMenu.index(:MOSTRARTABLERO)
          ov << OpcionMenu.index(:MOSTRARJUGADORES)
          ov << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          ov << OpcionMenu.index(:TERMINARJUEGO)
          ov << OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)
          ov << OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO)
           
        when :ja_preparado
          ov << OpcionMenu.index(:JUGAR)
          ov << OpcionMenu.index(:MOSTRARTABLERO)
          ov << OpcionMenu.index(:MOSTRARJUGADORES)
          ov << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          ov << OpcionMenu.index(:TERMINARJUEGO)
          
        when :algunjugadorenbancarrota
           ov << OpcionMenu.index(:OBTENERRANKING)
          ov << OpcionMenu.index(:MOSTRARTABLERO)
          ov << OpcionMenu.index(:MOSTRARJUGADORES)
          ov << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          ov << OpcionMenu.index(:TERMINARJUEGO)
          
        when :ja_puedegestionar
          ov << OpcionMenu.index(:PASARTURNO)
          ov << OpcionMenu.index(:MOSTRARTABLERO)
          ov << OpcionMenu.index(:MOSTRARJUGADORES)
          ov << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          ov << OpcionMenu.index(:TERMINARJUEGO)
          ov << OpcionMenu.index(:VENDERPROPIEDAD)
          ov << OpcionMenu.index(:HIPOTECARPROPIEDAD)
          ov << OpcionMenu.index(:CANCELARHIPOTECA)
          ov << OpcionMenu.index(:EDIFICARCASA)
          ov << OpcionMenu.index(:EDIFICARHOTEL)
          
        when :ja_consorpresa
          ov << OpcionMenu.index(:APLICARSORPRESA)
          ov << OpcionMenu.index(:MOSTRARTABLERO)
          ov << OpcionMenu.index(:MOSTRARJUGADORES)
          ov << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          ov << OpcionMenu.index(:TERMINARJUEGO)
          
        when :ja_puedecomprarogestionar
          ov << OpcionMenu.index(:PASARTURNO)
          ov << OpcionMenu.index(:MOSTRARTABLERO)
          ov << OpcionMenu.index(:MOSTRARJUGADORES)
          ov << OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          ov << OpcionMenu.index(:TERMINARJUEGO)
          ov << OpcionMenu.index(:VENDERPROPIEDAD)
          ov << OpcionMenu.index(:HIPOTECARPROPIEDAD)
          ov << OpcionMenu.index(:CANCELARHIPOTECA)
          ov << OpcionMenu.index(:EDIFICARCASA)
          ov << OpcionMenu.index(:EDIFICARHOTEL)
          ov << OpcionMenu.index(:COMPRARTITULOPROPIEDAD)
        end
        return ov
      end
      
      def necesitaElegirCasilla(opcionMenu)
        ret = false
        if(opcionMenu == OpcionMenu.index(:HIPOTECARPROPIEDAD) ||
           opcionMenu == OpcionMenu.index(:CANCELARHIPOTECA) ||
           opcionMenu == OpcionMenu.index(:EDIFICARCASA) ||
           opcionMenu == OpcionMenu.index(:EDIFICARHOTEL) ||
           opcionMenu == OpcionMenu.index(:VENDERPROPIEDAD))
           ret = true
        end
        return ret
      end
      
      def obtenerCasillasValidas(opcionMenu)
        casillas = Array.new
        case OpcionMenu[opcionMenu]
        when :VENDERPROPIEDAD
          casillas = @modelo.obtenerPropiedadesJugador()
          
        when :HIPOTECARPROPIEDAD
          casillas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
         
        when :CANCELARHIPOTECA
          casillas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true)
          
        when :EDIFICARCASA
          casillas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
          
        when :EDIFICARHOTEL
          casillas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
        end
        
        return casillas
      end
      
      def realizarOperacion(opcionElegida, casillaElegida)
        casillas = Array.new
        aux = " "
        case OpcionMenu[opcionElegida]
        when :INICIARJUEGO
          @modelo.inicializarJuego(@nombreJugadores)
        
        when :JUGAR
          @modelo.jugar()
          aux = "Consigues con el dado un " + @modelo.getValorDado.to_s + " y caes en la casilla " + @modelo.obtenerCasillaJugadorActual().to_s();
       
        when :APLICARSORPRESA
          aux = @modelo.cartaActual.to_s
          @modelo.aplicarSorpresa();
        
        when :INTENTARSALIRCARCELPAGANDOLIBERTAD
          if((@modelo.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::PAGANDOLIBERTAD)))
            aux = "No se ha podido salir de la carcel pagando la libertad"
          end
          
        when :INTENTARSALIRCARCELTIRANDODADO
          require_relative 'metodo_salir_carcel'
          if((@modelo.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::TIRANDODADO)))
            aux = "No se ha podido salir de la carcel con el valor del dado"
          end
        
        when :COMPRARTITULOPROPIEDAD
          a = @modelo.comprarTituloPropiedad()
          if(!a)
            aux = "No se ha podido comprar el titulo de propiedad"
          end
        
        when :HIPOTECARPROPIEDAD
          @modelo.hipotecarPropiedad(casillaElegida)
        
        when :CANCELARHIPOTECA
          @modelo.cancelarHipoteca(casillaElegida)
        
        when :EDIFICARCASA
          if(!@modelo.edificarCasa(casillaElegida))
            aux = "No se ha podido edificar una casa en la casilla elegida"
          end
          
        when :EDIFICARHOTEL
          if(!@modelo.edificarHotel(casillaElegida))
            aux = "No se ha podido edificar una casa en la casilla elegida"
          end
          
        when :VENDERPROPIEDAD
          @modelo.venderPropiedad(casillaElegida)
          
        when :PASARTURNO
          @modelo.siguienteJugador()
        
        when :OBTENERRANKING
          @modelo.obtenerRanking()
          puts "Jugadores, por orden"
          for j in @modelo.jugadores
            j.to_s
          end
        
        when :TERMINARJUEGO
          @modelo.obtenerRanking()
          #mostrar los jugadores en orden
          puts "********************************FIN DEL JUEGO***************************************2
 \nJugadores, por orden:\n"
          for j in @modelo.jugadores
            puts j.to_s
          end
          exit(0)
          
        when :MOSTRARJUGADORACTUAL
          puts @modelo.jugadores[@modelo.indiceJugadorActual].to_s
    
        when :MOSTRARJUGADORES
          for i in @modelo.jugadores
            puts i.to_s
            end
        when :MOSTRARTABLERO
          puts @modelo.tablero.to_s
        end
        
        return aux
      end
      
      
      
    end
end
