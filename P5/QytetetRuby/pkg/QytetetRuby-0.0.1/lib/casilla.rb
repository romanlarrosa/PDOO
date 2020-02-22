#encoding:utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'jugador'
require_relative 'titulo_propiedad'

module ModeloQytetet
  class Casilla
    
    #Consultores
    attr_accessor :num_casilla, :coste, :tipo, :titulo
    
    def initialize (num, tipo, coste)
      @num_casilla = num
     # @titulo = tit
      @coste = coste
      @tipo = tipo
    end 
    
    
    
    def to_s
      str = ""
      if @tipo == TipoCasilla::CALLE
        str = " \n         Numero de casilla: #{@num_casilla} 
         Tipo: #{@tipo}
         #{@titulo.to_s()}  \n\n\n"
      end
      if @tipo != TipoCasilla::CALLE
        str = " \n        Numero de casilla: #{@num_casilla}
        Tipo: #{@tipo}"
      end
      
      return str
       
      
    end
  
    
    def soyEdificable()
        return false
    end
    
    
  end
end
