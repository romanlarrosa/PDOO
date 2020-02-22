#encoding:utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'casilla'
require_relative 'titulo_propiedad'
module ModeloQytetet
  class Jugador
    
    attr_accessor :cartaLibertad, :casillaActual, :encarcelado, :nombre, :propiedades, :saldo
    
    def initialize(nom)
      @encarcelado = false
      @nombre = nom
      @saldo = 7500
      @propiedades = Array.new
      @cartaLibertad = nil
      @casillaActual = nil
    end
    
    def self.nuevo(nombre)
      new(nombre)
    end
    
    def self.copia(otroJugador)
      new(otroJugador.nombre)
      @encarcelado = otroJugador.encarcelado
      @saldo = otroJugador.saldo
      for i in  otroJugador.propiedades
        @propiedades << i        
      end
      @cartaLibertad = otroJugador.cartaLibertad
      @casillaActual = otroJugador.casillaActual
    end
    
    def cancelarHipoteca(tit)
      tengoSaldo = tengoSaldo(tit.calcularCosteCancelar)
      cancelada = false
      if(tengoSaldo)
        modificarSaldo(-tit.calcularCosteCancelar)
        cancelada = titulo.cancelarHipoteca
      end
      return cancelada
    end
    
    protected
    def convertirme(fianza)
      return (Especulador.new(fianza))
    end
    
    public
    def getCasillaActual()
      return @casillaActual
    end
    
    def comprarTituloPropiedad()
      comprado = false
      costeCompra=@casillaActual.coste
      if(costeCompra < @saldo)
        titulo = @casillaActual.asignarPropietario(this)
        @propiedades << titulo
        comprado = true
        modificarSaldo(-costeCompra)
      end
      return comprado
    end
    
    def cuantasCasasHotelesTengo()
     contador = 0
      for i in @propiedades
        contador += i.numCasas + i.numHoteles;
      end
      return contador
    end
    
    protected
    def deboIrACarcel()
      tengoCartaLibertad()
    end
    
    public
    def deboPagarAlquiler()
      titulo = @casillaActual.titulo
      esDeMiPropiedad = esDeMiPropiedad(titulo);
      tienePropietario = titulo.tengoPropietario();
      propietarioEncarcelado = titulo.propietarioEncarcelado();
      estaHipotecada = titulo.hipotecada
      return (!esDeMiPropiedad & tienePropietario & !propietarioEncarcelado & !estaHipotecada);
    end
    
    def devolverCartaLibertad()
      aux = @cartalibertad
      @cartalibertad = nil
      return aux
    end
    
    def edificarCasa(tit)
      numCasas = @titulo.numCasas
      edificada = false
      if (puedoEdificarCasa)
        costeEdificarCasa = @titulo.precioEdificar
        tengoSaldo = tengoSaldo(costeEdificarCasa)
        if(tengoSaldo)
          @titulo.edificarCasa
          modificarSaldo(-costeEdificarCasa)
          edificar = true
        end
      end
      return edificada
    end
    
    def edificarHotel(tit)
      numCasas= @titulo.numCasas
      numHoteles = @tiutlo.numHoteles
      edificado = false
      if(numCasas >= 4 && puedoEdificarHotel)
        costeEdificarHotel = @titulo.precioEdificar
        tengoSaldo = tengoSaldo(costeEdificarHotel)
        if(tengoSaldo)
          @titulo.edificarHotel
          modificarSaldo(-costeEdificar)
          edificado = false
        end
      end
      return edificado
    end
    
    private
    def eliminarDeMisPropiedades(tit)
      @propiedades.delete(tit)
      titulo.propietario(nil)
    end
    
    def esDeMiPropiedad(tit)
      for i in @propiedades
        if (i.nombre == tit.nombre)
          return true
        else
          return false
        end
      end
    end
    
    public
    def estoyEnCalleLibre()
      raise NotImplementedError
      #return bool
    end
    
    def hipotecarPropiedad(tit)
      costeHipoteca = titulo.hipotecar
      modificarSaldo(costeHipoteca)
     
    end
    
    def irACarcel(casilla)
      @casillaActual = casilla;
      @encarcelado = true 
    end
    
    def modificarSaldo(cant)
      @saldo += cant
      return @saldo
    end
    
    def obtenerCapital()
      valor = @saldo
      for i in @propiedades
        valor += (i.numCasas + i.numHoteles)* i.precioEdificar + i.precioCompra
        if (i.hipotecada)
          valor -= i.hipotecaBase
        end
      end
      return valor
    end
    
    def obtenerPropiedades(hipotecada)
      filtro = Array.new 
      for i in @propiedades
        if ( i.hipotecada == hipotecada)
          filtro << i
        end
      end
      return filtro
    end
    
    def pagarAlquiler()
      costeAlquiler = @casillaActual.pagarAlquiler
      modificarSaldo(-costeAlquiler)
      
    end
    
    public
    def pagarImpuesto()
      @saldo -= @casillaActual.coste
    end
    
    public
    def pagarLibertad(cant)
      tengoSaldo = tengoSaldo(cant)
      if(tengoSaldo)
        encarcelado(false)
        modificarSaldo(-cant)
      end
    end
    
    protected
    def puedoEdificarCasa(titulo)
      if ( titulo.numCasas < 4 && @saldo > titulo.precioEdificar)
        return true
      else
        return false
      end
    end
    
    def puedoEdificarHotel(titulo)
      if ( titulo.numHoteles < 4 && @saldo > titulo.precioEdificar)
        return true
      else
        return false
      end
    end
    
    public
    def setEncarceladoSinPoderSalir(bool)
      raise NotImplementedError
    end
    
    public
    def setHaTiradoDado()
      raise NotImplementedError
    end
    
    def tengoCartaLibertad()
      if(@cartaLibertad == nil)
        return false
      else
        return true
      end
    end
    
    protected
    def tengoSaldo(cant)
      if(@saldo < cant)
        return false
      else
        return true
      end
      #return bool
    end
    
    public
    def venderPropiedad(casilla)
      titulo = casilla.titulo
      eliminardemisPropiedades(titulo)
      precioVenta = titulo.calcularPrecioVenta
      modificarSaldo(precioVenta)
    end
    
    def to_s()
      str = ""
      for i in @propiedades
        str = str + i.to_s
      end
      return "\nJugador: 
      Encarcelado: #{@encarcelado}
      Nombre: #{@nombre}
      Saldo: #{@saldo}
      Capital: #{this.obtenerCapital}
      Propiedades: #{str}
      Carta Libertad: #{this.cartaLibertad}
      Casilla Actual: #{@casillaActual.to_s}"
    end
    
    def <=> (otroJugador)
      otroJugador.obtenerCapital <=> obtenerCapital
    end
  
  end
end
