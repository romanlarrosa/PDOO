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
public class Calle extends Casilla{
    private TipoCasilla tipo;
    private TituloPropiedad titulo;
    
    public Calle(int num, TituloPropiedad _titulo){
        super(num, _titulo.getPrecioCompra());
        tipo = TipoCasilla.CALLE;
        titulo = _titulo;
    }
    
    @Override
    protected TipoCasilla getTipo(){
        return tipo;
    }
    
    @Override
    protected boolean soyEdificable(){
        if(tipo == TipoCasilla.CALLE)
           return true;
       else
           return false;
    }
    
    @Override
    public String toString(){  
        return  super.toString() +
                "\n Tipo = " + tipo + 
                "\n" + titulo.toString() + "\n";
    }
    
    @Override
    protected TituloPropiedad getTitulo(){
        return titulo;
    }
    
    public void asignarPropietario(Jugador jugador){
        titulo.setPropietario(jugador); 
    }
    
    int pagarAlquiler(){
        int costeAlquiler = titulo.pagarAlquiler();
        return costeAlquiler;
    } 
    
    private void setTitulo(TituloPropiedad _titulo){
        titulo = _titulo;
    }
    
    boolean tengoPropietario(){
        return titulo.tengoPropietario();
    }
    
    boolean propietarioEncarcelado(){
        return titulo.propietarioEncarcelado();
    }
    
    
}
