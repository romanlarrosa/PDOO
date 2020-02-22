#encoding:utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'jugador'

module ModeloQytetet
  class TituloPropiedad
    #Consultores
      attr_accessor :nombre, :precioCompra, :factorRevalorizacion, :hipotecaBase, :precioEdificar, :hipotecada, :numCasas, :numHoteles, :propietario, :alquilerBase
      
    
     
    def initialize(nom, p_compra, f_rev, h_base, p_edif)
      @numCasas = 0
      @numHoteles = 0
      @hipotecada = false
      @nombre = nom
      @precioCompra = p_compra
      @factorRevalorizacion = f_rev
      @hipotecaBase = h_base
      @precioEdificar = p_edif
      @propietario = Jugador.new("Desconocido")
      @alquilerBase
    end
    
    def to_s
      " \n         Nombre: #{@nombre} 
         Precio de compra: #{@precioCompra}
         Factor de revalorizacion: #{@factorRevalorizacion} 
         Hipoteca Base: #{@hipotecaBase}
         Precio de edificación: #{@precioEdificar} 
         Hipotecada: #{@hipotecada} 
         Alquiler Base: #{@alquilerBase} 
         Propietario: #{@propietario.nombre} 
         Numero de casas y hoteles: #{@numCasas} / #{@numHoteles} \n\n\n"
    end
    
    def setHipotecada(bool)
      @hipotecada = bool
    end
    
    def calcularCosteCancelar()
      coste = to_i(calcularCosteHipotecar + calcularCosteHipotecar*0.1)
      return coste
    end
    
    def calcularCosteHipotecar()
      costeHipoteca = to_i(@hipotecaBase + @numCasas*(1.0/2)*@hipotecaBase + @numHoteles*@hipotecaBase)
      return costeHipoteca
    end
    
    def calcularImporteAlquiler()
      costeAlquiler = to_i(@alquilerBase + (@numCasas * (1.0/2)+@numHoteles * 2))
      return costeAlquiler
      #return int
    end
    
    def calcularPrecioVenta()
      precioVenta = @precioCompra + (@numCasas +@numHoteles) *@precioEdificar * @factorRevalorizacion
      return precioVenta
    end
    
    def cancelarHipoteca()
      @hipotecada = false
      return true
    end
    
    def cobrarAlquiler(costeint)
      @propietario.modificarSaldo(costeint)
    end
    
    def edificarCasa()
      @numCasas = @numCasas + 1
    end
    
    def edificarHotel()
      @numCasas = 0
      @numHoteles = @numHoteles + 1
    end
    
    def hipotecar()
      @hipotecada = true
      costeHipoteca = calcularCosteHipotecar  
      return costeHipoteca
    end
    
    def pagarAlquiler()
      costeAlquiler = calcularImporteAlquiler
      @propietario.modificarSaldo(costeAlquiler)
      return costeAlquiler
      #return int
    end
    
    def propietarioEncarcelado()
      if(@propietario.encarcelado)
        return true
      else
        return false
      end
     
    end
    
    def tengoPropietario()
      if(@propietario !=nil)
        return true
      else
        return false
      end
    end
    
  end
end