/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeloqytetet;
import java.util.ArrayList;

/**
 *
 * @author romanlarrosa
 */
public class Tablero {
    private ArrayList<Casilla> casillas = new ArrayList<>();
    private Casilla carcel;
    int NUM_CASILLAS = 20;
    int casillaFinal = NUM_CASILLAS -1;

    public Tablero() {
        inicializar();
    }

    public ArrayList<Casilla> getCasillas() {
        return casillas;
    }

    public Casilla getCarcel() {
        return carcel;
    }

    public String toString() {
        String cas = "";
        for(Casilla j: casillas){
          cas += j.toString();
        }
       return "Tablero: \n" + cas;
       
       
    }
    
    private void inicializar(){
        casillas = new ArrayList();
        //CALLES
        casillas.add(new OtraCasilla(0, TipoCasilla.SALIDA, 0));
        
        TituloPropiedad auxiliar;
        auxiliar = new TituloPropiedad("C/ Corazón de Jesús", 500, 10, 250, 250, 50);
        casillas.add(new Calle(1, auxiliar));
        
        auxiliar = new TituloPropiedad("C/ Barranco", 550, 10, 275, 300, 55);
        casillas.add(new Calle(2, auxiliar));
        
        casillas.add(new OtraCasilla(3, TipoCasilla.SORPRESA, 0));
        
        auxiliar = new TituloPropiedad("Albaycin", 600, 12, 300, 350, 60);
        casillas.add(new Calle(4, auxiliar));
        
        casillas.add(new OtraCasilla(5, TipoCasilla.CARCEL, 0));
        carcel = casillas.get(5);
        
        auxiliar = new TituloPropiedad("C/ Castillo", 625, 12, 312, 375, 62);
        casillas.add(new Calle(6, auxiliar));
        
        casillas.add(new OtraCasilla(7, TipoCasilla.SORPRESA, 0));
        
        auxiliar = new TituloPropiedad("C/ Barrichillo", 650, 12, 325, 400, 65);
        casillas.add(new Calle(8, auxiliar));
        
        auxiliar = new TituloPropiedad("C/ Ramblilla", 700, 14, 350, 450, 70);
        casillas.add(new Calle(9, auxiliar));
        
        casillas.add(new OtraCasilla(10, TipoCasilla.PARKING, 0));
        
        auxiliar = new TituloPropiedad("Once Casas", 750, 14, 375, 500, 75);
        casillas.add(new Calle(11, auxiliar));
        
        casillas.add(new OtraCasilla(12, TipoCasilla.IMPUESTO, 500));
        
        auxiliar = new TituloPropiedad("C/ Los Baños", 800, 16, 400, 550, 80);
        casillas.add(new Calle(13, auxiliar));
        
        auxiliar = new TituloPropiedad("C/ Santa Ana", 800, 16, 400, 550, 80);
        casillas.add(new Calle(14, auxiliar));
        
        casillas.add(new OtraCasilla(15, TipoCasilla.JUEZ, 0));
        
        auxiliar = new TituloPropiedad("C/ Real", 850, 18, 425, 600, 85);
        casillas.add(new Calle(16, auxiliar));
        
        casillas.add(new OtraCasilla(17, TipoCasilla.SORPRESA, 0));
        
        auxiliar = new TituloPropiedad("C/ Granada", 950, 20, 475, 700, 95);
        casillas.add(new Calle(18, auxiliar));
        
        auxiliar = new TituloPropiedad("C/ Ayuntamiento", 1000, 20, 500, 750, 100);
        casillas.add(new Calle(19, auxiliar));
                
}
    boolean esCasillaCarcel(int numeroCasilla){
        if(carcel.getNumeroCasilla() == numeroCasilla)
            return true;
        else
            return false;
                    
    }
    
    Casilla obtenerCasillaFinal(Casilla casilla,int desplazamiento){
        return casillas.get((casilla.getNumeroCasilla()+desplazamiento) % NUM_CASILLAS);
    }
    
    Casilla obtenerCasillaNumero(int numeroCasilla){
        return casillas.get(numeroCasilla);
    }
            
    
}
