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
public class Sorpresa {
    private String Texto;
    private TipoSorpresa Tipo;
    private int Valor;
    
    public Sorpresa(String texto, TipoSorpresa tipo, int valor){
        Texto = texto;
        Tipo = tipo;
        Valor = valor;
    }
    
    String GetTexto(){
        return Texto;
    }
    
    TipoSorpresa GetTipo(){
        return Tipo;
    }
    
    int GetValor(){
        return Valor;
    }
    
    @Override
    public String toString() {
        return "\nSorpresa: " + 
                "\nTexto: " + Texto + 
                "\nValor: " + Valor + 
                "\nTipo: " + Tipo + "\n";
    } 
    
    
    
}
