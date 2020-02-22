#encoding:utf-8
# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#dd = Dado.instance


require "singleton"

module ModeloQytetet
  class Dado
    include Singleton
    
    attr_reader :valor
    
    def initialize()
      @valor = 1
    
    end
    
    def tirar()
      @valor = 1 + rand(6)
      return @valor
    end
  end
end


