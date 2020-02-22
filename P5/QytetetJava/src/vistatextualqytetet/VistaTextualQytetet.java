/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vistatextualqytetet;
import controladorqytetet.ControladorQytetet;
import controladorqytetet.OpcionMenu;
import modeloqytetet.Qytetet;
import java.util.ArrayList;
import modeloqytetet.Jugador;
import java.util.Scanner;

/**
 *
 * @author pedrohueneja
 */
public class VistaTextualQytetet {
    private static Qytetet modelo = Qytetet.getInstance();
    private static ControladorQytetet controlador = ControladorQytetet.getInstance();
    Scanner in = new Scanner(System.in);
    
    
    public ArrayList<String> obtenerNombreJugadores(){
        ArrayList<String> _jugadores = new ArrayList<>();
        System.out.println("Indica el número de jugadores (de 2 a " + modelo.MAX_JUGADORES + "): ");
        String s = in.nextLine();
        
        for(int i=0; i < Integer.parseInt(s); i++){
            System.out.println("Introduce un nombre: ");
            String nombre = in.nextLine();
            _jugadores.add(nombre);
        }
        return _jugadores;
        
    }
    public int elegirCasilla(int opcionMenu){
        ArrayList<Integer> casillasValidas = controlador.obtenerCasillasValidas(opcionMenu);
        if(casillasValidas.isEmpty()){
            return -1;
        }
        else{
            //Mostrar Lista
            //Pasar a string la lista
            ArrayList<String> convertidos = new ArrayList<String>();
             System.out.println("Elige el numero de casilla: ");
            for(Integer i: casillasValidas){
                System.out.println(i + "  ");
                convertidos.add(Integer.toString(i));
            }
            return Integer.parseInt(leerValorCorrecto(convertidos));            
        }
    }
    
    public String leerValorCorrecto(ArrayList<String> valoresCorrectos){
        //leer en un string lo que el usuario escribe por consola
        String s = in.nextLine();
        //comprobar si el valor pertenece a la lista de valores
        while(!valoresCorrectos.contains(s)){
            System.out.print("Error, el elemento introducido no pertenece a la lista de opciones.\nIntroduzca un valor correcto: ");
            s = in.nextLine();
        }
        return s;
    }
    
    public int elegirOperacion(){
        ArrayList<Integer> listaOpciones = controlador.obtenerOperacionesJuegoValidas();
        ArrayList<String> convertidos = new ArrayList<String>();
        if(!modelo.getJugadores().isEmpty())
        System.out.println("Es el turno de " + modelo.getJugadorActual().getNombre());
        //Mostrar las opciones disponibles:
        for(int i: listaOpciones){
            System.out.println(i + ": " + OpcionMenu.values()[i]);
        }
        
        for(Integer i: listaOpciones){
            convertidos.add(Integer.toString(i));
        }
        String aux = leerValorCorrecto(convertidos);
        return Integer.parseInt(aux);
    }
    
     public static void main(String[] args) {
        VistaTextualQytetet ui = new VistaTextualQytetet();        
        controlador.setNombreJugadores(ui.obtenerNombreJugadores());
        int operacionElegida,casillaElegida = 0;
        boolean necesitaElegirCasilla;
        
        do{
            operacionElegida = ui.elegirOperacion();
            necesitaElegirCasilla = controlador.necesitaElegirCasilla(operacionElegida);
            if(necesitaElegirCasilla)
                casillaElegida = ui.elegirCasilla(operacionElegida);
            if(!necesitaElegirCasilla || casillaElegida >= 0)
                System.out.println(controlador.realizarOperacion(operacionElegida, casillaElegida));
        }while(true);
    }
}
