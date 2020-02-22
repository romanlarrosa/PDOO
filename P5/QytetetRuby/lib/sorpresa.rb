#encoding:utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
module ModeloQytetet
  class Sorpresa
    
    attr_accessor :texto,:valor,:tipo
        
    def initialize(desc, tip, val)
      @texto = desc
      @valor = val
      @tipo = tip
    end
  
    def to_s
      "Texto: #{@texto}
Valor: #{@valor}
Tipo: #{@tipo}"
    end
  end 
end

