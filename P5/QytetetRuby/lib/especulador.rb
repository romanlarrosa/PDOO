# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
#require_relative 'jugador'
require_relative 'jugador'

module ModeloQytetet
  class Especulador < Jugador
    
    attr_accessor :fianza
    public
    def initialize(unJugador, fianza)
      copia(unJugador)
      @fianza = fianza;
      return self
    end
    
    def pagarLibertad(cant)
      tengoSaldo = tengoSaldo(@fianza)
      if(tengoSaldo)
        @encarcelado = false
        modificarSaldo(-@fianza)
      end
    end
    
    
    def pagarImpuesto()
      modificarSaldo(-(@casillaActual.coste / 2))
    end
    
    
    def convertirme(fianza)
      return self
    end
    
    def deboIrACarcel()
      if (super && !pagarFianza())
        return true
      else
        return false
      end
    end
    
    private
    def pagarFianza()
      if ( @saldo > @fianza)
        puts "Especulador, tienes saldo suficiente para pagar la fianza"
        modificarSaldo(-@fianza)
        return true
      else
        puts "Especulador, NO TIENES EL SALDO SUFICIENTE PARA LA FIANZA"
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
    
    public
    def to_s
      str = super
      str += "\n      SOY ESPECULADOR
      Fianza: #{@fianza}"
    end
    
  end
end
