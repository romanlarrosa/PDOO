#encoding:utf-8
#qyt = Qytetet.instance
require_relative 'controladorqytetet'
require_relative 'opcion_menu'
require_relative 'qytetet'
require_relative 'jugador'

module VistaTextualQytetet
    class VistaTextualQytetet
      def initialize()
        @modelo = ModeloQytetet::Qytetet.instance
        @controlador = ControladorQytetet::ControladorQytetet.instance
      end
      public
      def obtenerNombreJugadores()
        jugadores = Array.new 
        puts "Indica el numero de jugadores(de 2 a 4)"
        #meter el numero de jugadores
        i = gets.chomp
        i.to_i.times do |j|
          puts "Introduce un nombre: \n"
          s = gets.chomp
          jugadores << s
        end
        #bucle en el que se añaden los jugadores
        return jugadores
      end
      
      def elegirCasilla(opcionMenu)
        casillasValidas = Array.new
        casillasValidas = @controlador.obtenerCasillasValidas(opcionMenu)
        if(casillasValidas.empty?)
          puts "No hay casillas validas"
          return -1
        else
          convertidos = Array.new
          puts "Elige el numero de casilla: "
          for i in casillasValidas
            puts i.to_s + " "
            convertidos << i.to_s
          end
          return leerValorCorrecto(convertidos).to_i
        end
      end
      
      def leerValorCorrecto(valoresCorrectos)
        #leer en un string lo que el usuario escribe por consola
        s = gets.chomp
        #comprobar si el valor pertenece a la lista de valores
        while(!valoresCorrectos.include?(s))
          puts "Error, el elemento introducido no pertenece a la lista de opciones.\nIntroduzca un valor correcto: "
          s = gets.chomp
        end
        return s
      end
      
      def elegirOperacion()
        listaOperaciones = Array.new
        listaOperaciones = @controlador.obtenerOperacionesDeJuegoValidas()
        convertidos = Array.new
        
        if(!@modelo.jugadores.empty?)
          puts "Es el turno de #{@modelo.jugadorActual.nombre}"
        end
        
        for i in listaOperaciones
          puts i.to_s + ": " + ControladorQytetet::OpcionMenu[i].to_s
        end
        
        for i in listaOperaciones
          convertidos << i.to_s
        end
        
        aux = leerValorCorrecto(convertidos)
        return aux.to_i
      end
      
      def main()
        ui = VistaTextualQytetet.new
        @controlador.nombreJugadores = ui.obtenerNombreJugadores()
        operacionElegida=0
        casillaElegida=0
        necesitaElegirCasilla=false
        while(true)
          operacionElegida = ui.elegirOperacion()
          necesitaElegirCasilla = @controlador.necesitaElegirCasilla(operacionElegida)
          if(necesitaElegirCasilla)
            casillaElegida=ui.elegirCasilla(operacionElegida)
          end
          if(!necesitaElegirCasilla || casillaElegida >=0)
            puts "#{@controlador.realizarOperacion(operacionElegida, casillaElegida)}"
          end
        end 
      end     
    end
    
    
    
    
    a = VistaTextualQytetet.new
    a.main
end
