# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module ModeloQytetet
class Calle < Casilla
  
attr_accessor :titulo
  
    def initialize(num,titulo_prop)
    @titulo = titulo_prop
    super(num , TipoCasilla::CALLE , @titulo.precioCompra)
  end
  
  public
  def soyEdificable()
    if(self.tipo == TipoCasilla::CALLE)
      return true
    else
      return false
    end
  end
  
  public
  def to_s()
    return super.to_s
    "Tipo: #{super.tipo}
    #{@titulo.to_s}"
    
  end
  
  def asignarPropietario(jugador)
    @titulo.propietario = jugador
  end
  
  def pagarAlquiler()
    costeAlquiler = @titulo.pagarAlquiler()
    return costeAlquiler
  end
  
  def tengoPropietario()
    return @titulo.tengoPropietario()
  end
  
  def propietarioEncarcelado()
    return @titulo.propietarioEncarcelado()
  end
end
end