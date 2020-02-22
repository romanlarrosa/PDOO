#encoding:utf-8
require_relative "qytetet"
require_relative "sorpresa"
require_relative "tipo_sorpresa"
module ModeloQytetet
  class PruebaQytetet
   
      @@juego = Qytetet.instance
      @@mazo = Array.new
   
  
    def self.SorpresasPositivas()
     vector = Array.new
     for i in @@juego.mazo
       if(i.valor > 0)
         vector << i
         vector << "\n"
       end
     end
     vector
    end
     
    def self.SorpresasIrACasilla()
      vector = Array.new
      for i in @@juego.mazo
        if i.tipo == TipoSorpresa::IRACASILLA
          vector << i
          vector << "\n"
        end
      
      end
      vector
    end
    
    def self.SorpresasDe(tip)
      vector = Array.new
      for i in @@juego.mazo
        if(i.tipo == tip)
          vector << i
          vector << "\n"
        end
      end
      vector
    end
    
    def self.getNombreJugadores()
      str = "Hay #{@@juego.jugadores.size} jugadores: \n" 
      for i in @@juego.jugadores
        str = str + i.nombre + "\n"
      end
      return str
    end
  
    def self.main
#      @@juego.inicializarCartasSorpresa()
#      #COMPROBAR SI SE HA INICIADO EL TABLERO Y MOSTRAR LAS CASILLAS
#      @@juego.tablero.inicializar
#      puts @@juego.tablero.to_s()

      _jugadores = Array.new
      _jugadores << String.new("Carmen Polo")
      _jugadores << String.new("Eva Anna Paula Braun")
      _jugadores << String.new("Patrocinio")
      
      @@juego.inicializarJuego(_jugadores)
      
     while (true)
      @@juego.jugar
     end
      
##      #Mostramos jugadores
##      puts "JUGADORES
#      **********************************************************************************************************************************#"
##      puts getNombreJugadores()
##      
##      #Mostrar cartas sorpresa
##      puts "CARTAS SORPRESA
#      **********************************************************************************************************************************#"
##      str = ""
##      for i in @@juego.mazo
##        str += i.to_s + "\n\n"
##      end
##      puts str
##      
##      #Mostrar casillas
##      puts "CASILLAS
#      ***********************************************************************************************************************************#"
##      str = ""
##      for i in @@juego.tablero.casillas
##        str += i.to_s
##      end
##      puts str
      

    
    
  end
end
  

PruebaQytetet.main
end
