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
public class Dado {
    private int valor;
    private static final Dado instance = new Dado();  //creamos la unica instancia de la clase
    
    private Dado(){
       valor = 1;
    }
    
    public static Dado getInstance() {
        return instance;
    }
    
    
    
    int tirar(){
        valor = (int) (Math.random()*6)+1;
        return valor;
    }
    
    public int getValor(){
        return valor;
    }
}
