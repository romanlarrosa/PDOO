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
public class Especulador extends Jugador{
    
    private int fianza;
    
    @Override
    void pagarAlquiler(){
        int costeAlquiler = ((Calle)casillaActual).pagarAlquiler();
        modificarSaldo(-costeAlquiler);    
    }
    
    
    @Override
    void pagarLibertad(int cantidad){
        boolean tengoSaldo = tengoSaldo(fianza); 
            if ( tengoSaldo){
                setEncarcelado(false);
                modificarSaldo(-fianza); 
            }
    }
    
    
    @Override
    protected void pagarImpuesto(){
        modificarSaldo(-(casillaActual.getCoste()) / 2);
    }
    
    protected Especulador(Jugador _jugador, int _fianza){
        super(_jugador);
        fianza=_fianza;
    }
    
    protected Especulador convertirme(){
        return this;
    }
    
    @Override
    protected boolean deboIrACarcel(){
        if(super.deboIrACarcel() && !pagarFianza()){
            return true;
        }
        else
            return false;
    }
    
    private boolean pagarFianza(){
        
        if (getSaldo() > fianza){
            System.out.println("Especulador, tienes saldo suficiente para pagar la fianza");
            modificarSaldo(-fianza);
            return true;
        }
        else
            System.out.println("Especulador, NO TIENES EL SALDO SUFICIENTE PARA LA FIANZA");
            return false;
    }
    
    @Override
    protected boolean puedoEdificarCasa(TituloPropiedad titulo){
        if(titulo.getNumCasas() < 8 && getSaldo() > titulo.getPrecioEdificar())
            return true;
        else
            return false;
    }
    
    @Override
    protected boolean puedoEdificarHotel(TituloPropiedad titulo){
        if(titulo.getNumHoteles() < 8 && getSaldo() > titulo.getPrecioEdificar())
            return true;
        else
            return false;
    }
    
    @Override
    public String toString(){
        String str = super.toString();
        str += "\n ES ESPECULADOR" +
               "\n Fianza: " + fianza;
        return str;
    }
    
    
    
}
