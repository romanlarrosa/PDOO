#encoding:utf-8
require_relative 'casilla'
require_relative 'tipo_casilla'
require_relative 'titulo_propiedad'
require_relative 'calle'
module ModeloQytetet
  class Tablero
    def initialize
      @@NUM_CASILLAS = 20
      @@casillaFinal = @@NUM_CASILLAS - 1
      @casillas = Array.new
      @carcel
    end
    
    attr_accessor:casillas, :carcel
    
    def inicializar()
      @casillas << Casilla.new(0, TipoCasilla::SALIDA,0)
      
      auxiliar = TituloPropiedad.new("C/ Corazón de Jesús", 500, 10, 250, 250)
      @casillas << Calle.new(1, auxiliar)
      
      auxiliar = TituloPropiedad.new("C/ Barranco", 550, 10, 275, 300)
      @casillas << Calle.new(2, auxiliar)
      
      @casillas << Casilla.new(3, TipoCasilla::SORPRESA,0)
      
      auxiliar = TituloPropiedad.new("Albaycin", 600, 12, 300, 350)
      @casillas << Calle.new(4, auxiliar)
      
      @casillas << Casilla.new(5, TipoCasilla::CARCEL,0)
      self.carcel = @casillas[5]
      
      auxiliar = TituloPropiedad.new("C/ Castillo", 625, 12, 312, 375)
      @casillas << Calle.new(6, auxiliar)
      
      @casillas << Casilla.new(7, TipoCasilla::SORPRESA, 0)
      
      auxiliar = TituloPropiedad.new("C/ Barrichillo", 650, 12, 325, 400)
      @casillas << Calle.new(8, auxiliar)
      
      auxiliar = TituloPropiedad.new("C/ Ramblilla", 700, 14, 350, 450)
      @casillas << Calle.new(9, auxiliar)
      
      @casillas << Casilla.new(10, TipoCasilla::PARKING, 0)
      
      auxiliar = TituloPropiedad.new("Once Casas", 750, 14, 375, 500)
      @casillas << Calle.new(11, auxiliar)
      
      @casillas << Casilla.new(12, TipoCasilla::IMPUESTO,500)
      
      auxiliar = TituloPropiedad.new("C/ Los Baños", 800, 16, 400, 550)
      @casillas << Calle.new(13, auxiliar)
      
      auxiliar = TituloPropiedad.new("C/ Santa Ana", 800, 16, 400, 550)
      @casillas << Calle.new(14, auxiliar)
      
      @casillas << Casilla.new(15, TipoCasilla::JUEZ,0)
      
      auxiliar = TituloPropiedad.new("C/ Real", 850, 18, 425, 600)
      @casillas << Calle.new(16, auxiliar)
      
      @casillas << Casilla.new(17, TipoCasilla::SORPRESA, 0)
      
      auxiliar = TituloPropiedad.new("C/ Granada", 950, 20, 475, 700)
      @casillas << Calle.new(18, auxiliar)
      
      auxiliar = TituloPropiedad.new("C/ Ayuntamiento", 1000, 20, 500, 750)
      @casillas << Calle.new(19, auxiliar)
    end
    
    def esCasillaCarcel(numeroCasilla)
      if(@carcel.num_casilla == numeroCasilla)
        return true
      else
        return false
      end
      #return bool
    end
    
    def obtenerCasillaFinal(casilla, desplazamiento)
      return @casillas[(casilla.num_casilla + desplazamiento) % @@NUM_CASILLAS]
    end
    
    def obtenerCasillaNumero(numcasilla)
      return @casillas[numcasilla]
    end
    
    
    def to_s()
      cadena = "\n"
      @casillas.each{|casilla| cadena = "\n" + cadena + casilla.to_s()}
        
      
    end
    
    
    
    
    
    
    
    
    
  end
end