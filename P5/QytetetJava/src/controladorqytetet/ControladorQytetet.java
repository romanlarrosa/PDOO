/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controladorqytetet;
import java.util.ArrayList;
import modeloqytetet.EstadoJuego;
import modeloqytetet.MetodoSalirCarcel;
import modeloqytetet.Qytetet;
import modeloqytetet.Jugador;
/**
 *
 * @author pedrohueneja
 */
public class ControladorQytetet {
    private ArrayList<String> nombreJugadores = new ArrayList();
    private static Qytetet modelo =Qytetet.getInstance();
    private static final ControladorQytetet instance = new ControladorQytetet(); 
    
    public static ControladorQytetet getInstance(){
        return instance;
    }

    public void setNombreJugadores(ArrayList<String> nombreJugadores) {
        this.nombreJugadores = nombreJugadores;
    }
    
    public ArrayList<Integer> obtenerOperacionesJuegoValidas(){
        ArrayList<Integer> OV = new ArrayList<>();
        //Devuelve una lista de las operaciones permitidas segun el estado del juego actual
        if(modelo.getJugadores().isEmpty()){   //SI aun no hay jugador actual ni nadie jugando
            OV.add(OpcionMenu.INICIARJUEGO.ordinal());
            return OV;
        }
        switch(modelo.getEstadoJuego()){
            case JA_ENCARCELADO:
                OV.add(OpcionMenu.PASARTURNO.ordinal());
                OV.add(OpcionMenu.MOSTRARTABLERO.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORES.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORACTUAL.ordinal());
                OV.add(OpcionMenu.TERMINARJUEGO.ordinal());
            break;
            
            case JA_ENCARCELADOCONOPCIONDELIBERTAD:
                OV.add(OpcionMenu.TERMINARJUEGO.ordinal());
                OV.add(OpcionMenu.MOSTRARTABLERO.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORES.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORACTUAL.ordinal());
                /////
                OV.add(OpcionMenu.INTENTARSALIRCARCELPAGANDOLIBERTAD.ordinal());
                OV.add(OpcionMenu.INTENTARSALIRCARCELTIRANDODADO.ordinal());
            break;
            
            case JA_PREPARADO:
                OV.add(OpcionMenu.TERMINARJUEGO.ordinal());
                OV.add(OpcionMenu.MOSTRARTABLERO.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORES.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORACTUAL.ordinal());
                ////////
                OV.add(OpcionMenu.JUGAR.ordinal());
            break;
            
            case ALGUNJUGADORENBANCARROTA:
                OV.add(OpcionMenu.TERMINARJUEGO.ordinal());
                OV.add(OpcionMenu.MOSTRARTABLERO.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORES.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORACTUAL.ordinal());
                ///////////
                OV.add(OpcionMenu.OBTENERRANKING.ordinal());
            break;
            
            case JA_PUEDEGESTIONAR:
                OV.add(OpcionMenu.PASARTURNO.ordinal());
                OV.add(OpcionMenu.TERMINARJUEGO.ordinal());
                OV.add(OpcionMenu.MOSTRARTABLERO.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORES.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORACTUAL.ordinal());
                ///////////////
                OV.add(OpcionMenu.VENDERPROPIEDAD.ordinal());
                OV.add(OpcionMenu.HIPOTECARPROPIEDAD.ordinal());
                OV.add(OpcionMenu.CANCELARHIPOTECA.ordinal());
                OV.add(OpcionMenu.EDIFICARCASA.ordinal());
                OV.add(OpcionMenu.EDIFICARHOTEL.ordinal());
            break;
            
            case JA_CONSORPRESA:
                OV.add(OpcionMenu.TERMINARJUEGO.ordinal());
                OV.add(OpcionMenu.MOSTRARTABLERO.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORES.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORACTUAL.ordinal());
                ///////////
                OV.add(OpcionMenu.APLICARSORPRESA.ordinal());
            break;
            
            case JA_PUEDECOMPRAROGESTIONAR:
                OV.add(OpcionMenu.PASARTURNO.ordinal());
                OV.add(OpcionMenu.TERMINARJUEGO.ordinal());
                OV.add(OpcionMenu.MOSTRARTABLERO.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORES.ordinal());
                OV.add(OpcionMenu.MOSTRARJUGADORACTUAL.ordinal());
                ///////////////
                OV.add(OpcionMenu.COMPRARTITULOPROPIEDAD.ordinal());
                OV.add(OpcionMenu.VENDERPROPIEDAD.ordinal());
                OV.add(OpcionMenu.HIPOTECARPROPIEDAD.ordinal());
                OV.add(OpcionMenu.CANCELARHIPOTECA.ordinal());
                OV.add(OpcionMenu.EDIFICARCASA.ordinal());
                OV.add(OpcionMenu.EDIFICARHOTEL.ordinal());
            break;         
        }
        return OV;
    }
    
    public boolean necesitaElegirCasilla(int opcionMenu){
        boolean ret = false;
        if(OpcionMenu.values()[opcionMenu] == OpcionMenu.HIPOTECARPROPIEDAD || 
           OpcionMenu.values()[opcionMenu] == OpcionMenu.CANCELARHIPOTECA ||
           OpcionMenu.values()[opcionMenu] == OpcionMenu.EDIFICARCASA || 
           OpcionMenu.values()[opcionMenu] == OpcionMenu.EDIFICARHOTEL || 
           OpcionMenu.values()[opcionMenu] == OpcionMenu.VENDERPROPIEDAD){
            ret = true;
        }
        return ret;
    }
    
    public ArrayList<Integer> obtenerCasillasValidas(int opcionMenu){
        ArrayList<Integer> casillas = new ArrayList<>();
        switch(OpcionMenu.values()[opcionMenu]){
            case VENDERPROPIEDAD:
                    casillas = modelo.obtenerPropiedadesJugador();
            break;
            
            case HIPOTECARPROPIEDAD:
                    casillas = modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false);
            break;
            
            case CANCELARHIPOTECA:
                    casillas = modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true);
            break;
            
            case EDIFICARCASA:
                    casillas = modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false);
            break;
            
            case EDIFICARHOTEL:
                    casillas = modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false);
            break;
            
        }
        return casillas;
    }
    
    public String realizarOperacion(int opcionElegida, int casillaElegida){
        String aux = "";
        switch(OpcionMenu.values()[opcionElegida]){
            case INICIARJUEGO:
                //Pedir los nombres de los jugadores
                //Inicializar los jugadores
                //iniciar el juego
                modelo.inicializarJuego(nombreJugadores);
            break;
            
            case JUGAR:
                modelo.jugar();
                aux = "Consigues con el dado un " + modelo.getValorDado() + " y caes en la casilla " + modelo.obtenerCasillaJugadorActual().toString();
            break;
            
            case APLICARSORPRESA:
                aux = modelo.getCartaActual().toString();
                modelo.aplicarSorpresa();
            break;
            
            case INTENTARSALIRCARCELPAGANDOLIBERTAD:
                if((modelo.intentarSalirCarcel(MetodoSalirCarcel.PAGANDOLIBERTAD))){
                    aux = "No se ha podido salir de la carcel pagando la libertad";
                };
            break;
            
            case INTENTARSALIRCARCELTIRANDODADO:
                if((modelo.intentarSalirCarcel(MetodoSalirCarcel.TIRANDODADO))){
                    aux = "No se ha podido salir de la carcel con el valor del dado";
                };
            break;
            
            case COMPRARTITULOPROPIEDAD:
                boolean a = modelo.comprarTituloPropiedad();
                if(!a){
                    aux = "No se ha podido comprar el titulo de propiedad";
                }
            break;
            
            case HIPOTECARPROPIEDAD:
                modelo.hipotecarPropiedad(casillaElegida);
            break;
            
            case CANCELARHIPOTECA:
                modelo.cancelarHipoteca(casillaElegida);
            break;
            
            case EDIFICARCASA:
               if(!modelo.edificarCasa(casillaElegida)){
                   aux = "No se ha podido edificar una casa en la casilla elegida";
               }
                        
            break;
            
            case EDIFICARHOTEL:
                if(!modelo.edificarHotel(casillaElegida)){
                   aux = "No se ha podido edificar un hotel en la casilla elegida";
               }
            break;
            
            case VENDERPROPIEDAD:
                modelo.venderPropiedad(casillaElegida);
            break;
            
            case PASARTURNO:
                modelo.siguienteJugador();
            break;
            
            case OBTENERRANKING:
                modelo.obtenerRanking();
                for(Jugador i: modelo.getJugadores()){
                   System.out.println(i.toString() + "\n");
                }
            break;
            
            case TERMINARJUEGO:
                modelo.obtenerRanking();
                for(Jugador i: modelo.getJugadores()){
                   System.out.println(i.toString() + "\n");
                }
                System.exit(0);
            break;
            
            case MOSTRARJUGADORACTUAL:
                System.out.print(modelo.getJugadores().get(modelo.indiceJugadorActual).toString());
            break;
            
            case MOSTRARJUGADORES:
                for(Jugador i: modelo.getJugadores()){
                    System.out.print(i.toString());
                }
            break;
            
            case MOSTRARTABLERO:
                System.out.print(modelo.getTablero().toString());
            break;
                
                
        }
        
        return aux;
    }
}
