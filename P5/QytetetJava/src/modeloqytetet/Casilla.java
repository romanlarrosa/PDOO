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
public abstract class Casilla {
    private int numeroCasilla;
    private int coste;
//    private TipoCasilla tipo;
//    private TituloPropiedad titulo;
    
    public Casilla(int num, int _coste){
        numeroCasilla = num; 
        coste = _coste;
    }
    

    int getNumeroCasilla() {
        return numeroCasilla;
    }

    int getCoste() {
        return coste;
    }
    
    public void setCoste(int _coste){
        coste = _coste;
    }

    protected abstract TipoCasilla getTipo();

    protected abstract TituloPropiedad getTitulo();


    @Override
    public String toString() {
        return "\nCasilla numero " + numeroCasilla + 
                "\n Coste = " + coste; 
    }

    protected boolean soyEdificable(){
        return false;
    }
    
    
    
    
}
