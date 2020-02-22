/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeloqytetet;

/**
 *
 * @author romanlarrosa
 */
public class OtraCasilla extends Casilla {
    
    TipoCasilla tipo;
    
    public OtraCasilla( int num, TipoCasilla _tipo, int coste){
        super(num, coste);
        tipo = _tipo;
    }
    
    @Override
    protected TipoCasilla getTipo(){
        return tipo;
    }
    
    @Override
    protected TituloPropiedad getTitulo(){
        return null;
    }
    
    @Override
    public String toString(){
         return super.toString() + 
                "\n Tipo = " + tipo + "\n";
    }
    
}
