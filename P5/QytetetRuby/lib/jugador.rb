#encoding:utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'casilla'
require_relative 'titulo_propiedad'
#require_relative 'especulador'
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
    
    
    public
    def copia(otroJugador)
      #new(otroJugador.nombre)
      @nombre = otroJugador.nombre
      @encarcelado = otroJugador.encarcelado
      @saldo = otroJugador.saldo
      @propiedades = Array.new
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
        cancelada = tit.cancelarHipoteca
      end
      return cancelada
    end
    
    public
    def convertirme(fianza)
      puts "Convirtiendo en especulador..."
      require_relative "especulador"
      espe = Especulador.new(self, fianza)
      return espe
    end
    
    public
    def getCasillaActual()
      return @casillaActual
    end
    
    def comprarTituloPropiedad()
      comprado = false
      costeCompra=@casillaActual.coste
      if(costeCompra < @saldo)
        @casillaActual.asignarPropietario(self)
        titulo = @casillaActual.titulo
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
    
    public
    def deboIrACarcel()
      if tengoCartaLibertad()
        puts "Felicidades, tienes la carta que te ofrece la libertad de la carcel"
      end
      return !tengoCartaLibertad()
    end
    
    public
    def deboPagarAlquiler()
      titulo = @casillaActual.titulo
      esDeMiPropiedad = esDeMiPropiedad(titulo)
      #puts "Es de mi propiedad = #{esDeMiPropiedad}"
      tienePropietario = titulo.tengoPropietario()
      #puts "Tiene Propietario = #{tienePropietario}"
      propietarioEncarcelado = titulo.propietarioEncarcelado()
      #puts "Encarcelado = #{propietarioEncarcelado}"
      estaHipotecada = titulo.hipotecada
      #puts "Hipotecada = #{estaHipotecada}"
      #puts "#{!esDeMiPropiedad & tienePropietario & !propietarioEncarcelado & !estaHipotecada}"
      return (!esDeMiPropiedad & tienePropietario & !propietarioEncarcelado & !estaHipotecada)
    end
    
    def devolverCartaLibertad()
      aux = @cartalibertad
      @cartalibertad = nil
      return aux
    end
    
    def edificarCasa(tit)
      numCasas = tit.numCasas
      edificada = false
      if (puedoEdificarCasa(tit))
        costeEdificarCasa = tit.precioEdificar
        tengoSaldo = tengoSaldo(costeEdificarCasa)
        if(tengoSaldo)
          tit.edificarCasa
          modificarSaldo(-costeEdificarCasa)
          edificada = true
        end
      end
      return edificada
    end
    
    def edificarHotel(tit)
      numCasas= tit.numCasas
      numHoteles = tit.numHoteles
      edificado = false
      if(numCasas >= 4 && puedoEdificarHotel(tit))
        costeEdificarHotel = tit.precioEdificar
        tengoSaldo = tengoSaldo(costeEdificarHotel)
        if(tengoSaldo)
          tit.edificarHotel
          modificarSaldo(-costeEdificarHotel)
          edificado = true
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
      loEs = false
      for i in @propiedades
        if (i == tit)
          loEs=true
        end
      end
      return loEs
    end
    
    public
    def estoyEnCalleLibre()
      raise NotImplementedError
      #return bool
    end
    
    def hipotecarPropiedad(tit)
      costeHipoteca = tit.hipotecar
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
        @encarcelado = false
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
    
    private
    def eliminarDeMisPropiedades(titulo)
       propiedades.delete(titulo)
       titulo.setPropietario(null) 
    end
    
    public
    def to_s()
      str = ""
      for i in 0..@propiedades.size
        str += @propiedades[i].to_s
      end
      return "\nJugador: 
      Nombre: #{@nombre}
      Saldo: #{@saldo}
      Capital: #{obtenerCapital}
      Encarcelado: #{@encarcelado}
      Carta Libertad: #{@cartaLibertad}
      Casilla Actual: #{@casillaActual.to_s}
      Propiedades: #{str}"
    end
    
    def <=> (otroJugador)
      otroJugador.obtenerCapital <=> obtenerCapital
    end
  
  end
end
