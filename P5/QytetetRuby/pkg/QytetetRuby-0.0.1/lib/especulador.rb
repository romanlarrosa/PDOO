# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module ModeloQytetet
  class Especulador < Jugador
    
    attr_reader :fianza
    
    def self.copia(unJugador, fianza)
      super.copia(unJugador)
      @fianza = fianza;
      return self
    end
    
    protected
    def pagarImpuesto()
      modificarSaldo(-(@casillaActual.coste / 2))
    end
    
    def convertirme(fianza)
      return self
    end
    
    def deboIrACarcel()
      if (super.deboIrACarcel() && !pagarFianza())
        return true
      else
        return false
      end
    end
    
    private
    def pagarFianza()
      if ( getSaldo() > @fianza)
        modificarSaldo(-@fianza)
        return true
      else
        return false
      end
    end
    
    protected
    def puedoEdificarCasa(titulo)
      if ( titulo.numHoteles < 8 && getSaldo() > titulo.precioEdificar)
        return true
      else
        return false
      end
    end
    
    def puedoEdificarHotel(titulo)
      if ( titulo.numHoteles < 8 && getSaldo() > titulo.precioEdificar)
        return true
      else
        return false
      end
    end
    
    def to_s
      super.to_s()
    end
    
  end
end
