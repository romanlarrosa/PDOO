/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeloqytetet;
import java.util.ArrayList;
import java.util.Collections;
import java.lang.reflect.Field;

/**
 *
 * @author romanlarrosa
 */
public class Qytetet {
    
    public int MAX_JUGADORES = 4;
    int NUM_SORPRESAS = 10;
    public int NUM_CASILLAS = 20;
    int PRECIO_LIBERTAD = 200;
    int SALDO_SALIDA = 1000;       
    private ArrayList<Sorpresa> mazo = new ArrayList<>();
    private Tablero tablero;
    
    protected Dado dado = Dado.getInstance();
    protected Sorpresa cartaActual=null;
    protected Jugador jugadorActual=null;
    public int indiceJugadorActual = 0;
    protected ArrayList<Jugador> jugadores =new ArrayList<>();
    protected EstadoJuego estado;
    
    private static final Qytetet instance = new Qytetet();  //Crear la unica instancia de la clase
    
    private Qytetet(){
        this.InicializarTablero();
    }
    
    public static Qytetet getInstance() {
        return instance;
    }
    
    ArrayList<Sorpresa> GetMazo(){
        return mazo;
    }
    
    
    private void inicializarCartasSorpresa(){
        //Modificado para examen, primera carta de tipo PAGARCOBRAR, cartas sorpresa no se barajan 
        mazo.add(new Sorpresa("Felicidades, ahora eres un Especulador. Aprovechate. ", TipoSorpresa.CONVERTIRME, 3000));
        
        mazo.add(new Sorpresa("Te hemos pillado con chanclas y calcetines,lo sentimos, ¡debes ir a la carcel!", TipoSorpresa.IRACASILLA, tablero.getCarcel().getNumeroCasilla())); 

        mazo.add(new Sorpresa("¡Felicidades! Has acertado la quiniela. ¡Puedes cobrar tu premio!", TipoSorpresa.PAGARCOBRAR, 200));
        
        mazo.add(new Sorpresa("Te han pillado conduciendo un poco \"afectado\". Te toca pasar por caja.", TipoSorpresa.PAGARCOBRAR, -200));
                        
        mazo.add(new Sorpresa("Te ha salido un casting gracias a tu agencia y tu representante, Paquita. Ve sin tardanza a la casilla 12", TipoSorpresa.IRACASILLA, 12));
                                
        mazo.add(new Sorpresa("Estás cansado de tanto dar vueltas. Ve a descansar y a comerte una palmera de chocolate al Parking", TipoSorpresa.IRACASILLA, 10));
                                        
        mazo.add(new Sorpresa("Pierdes una apuesta. Invita a todos los jugadores a cenar en una marisquería", TipoSorpresa.PORJUGADOR, 100));
        
        mazo.add(new Sorpresa("¡Felicidades! Hoy es el día de tu no cumpleaños, recibes un regalo de todos", TipoSorpresa.PORJUGADOR, -200));
        
        mazo.add(new Sorpresa("Recibes un premio por alojamiento pintoresco. Cobras 100 por cada casa y cada hotel de tu propiedad", TipoSorpresa.PORCASAHOTEL, 100));
        
        mazo.add(new Sorpresa("Decides reformar tu imagen corporativa. Paga 80 por cada casa y cada hotel de tu propiedad", TipoSorpresa.PORCASAHOTEL, -80));
        
        mazo.add(new Sorpresa("Usa esta carta si caes en la carcel para salir del trullo.", TipoSorpresa.SALIRCARCEL, 0));
        
        mazo.add(new Sorpresa("Con tu nuevo titulo de Especulador puedes ser une chique male. ;)", TipoSorpresa.CONVERTIRME, 5000));
        
        Collections.shuffle(mazo);
    }

    public Tablero getTablero() {
        return tablero;
    }
    
    private void InicializarTablero(){
        tablero = new Tablero();
    }
    
    void actuarSiEnCasillaEdificable(){
        boolean deboPagar = jugadorActual.deboPagarAlquiler();
        if (deboPagar){
            jugadorActual.pagarAlquiler();
            if(jugadorActual.getSaldo() <= 0){
                setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
            }
        }
        boolean tengoPropietario = ((Calle)obtenerCasillaJugadorActual()).tengoPropietario();
        if(estado != EstadoJuego.ALGUNJUGADORENBANCARROTA){
            if (tengoPropietario){
                setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
            }
            else
                setEstadoJuego(EstadoJuego.JA_PUEDECOMPRAROGESTIONAR);
                 
        }
    }
    
    void actuarSiEnCasillaNoEdificable(){
       setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
       Casilla casillaActual = jugadorActual.getCasillaActual();
       if (casillaActual.getTipo() == TipoCasilla.IMPUESTO){
           jugadorActual.pagarImpuesto();
       }
       else if(casillaActual.getTipo() == TipoCasilla.JUEZ){
           if(jugadorActual.deboIrACarcel())
           encarcelarJugador();
       }
       else if(casillaActual.getTipo() == TipoCasilla.SORPRESA){
           if (mazo.isEmpty()) {
               System.out.println("mazo vacío");
           }
           cartaActual = mazo.remove(0);
           setEstadoJuego(EstadoJuego.JA_CONSORPRESA);
       }
    }
    
    public void aplicarSorpresa(){
        setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        
        if(cartaActual.GetTipo() == TipoSorpresa.SALIRCARCEL){
            jugadorActual.setCartaLibertad(cartaActual);
        }
        else {
            mazo.add(cartaActual);
        if (null != cartaActual.GetTipo())switch (cartaActual.GetTipo()) {
                case PAGARCOBRAR:
                    jugadorActual.modificarSaldo(cartaActual.GetValor());
                    if(jugadorActual.getSaldo() < 0){
                        setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
                    }       break;
                case IRACASILLA:
                    int valor = cartaActual.GetValor();
                    boolean casillaCarcel = tablero.esCasillaCarcel(valor);
                    if(casillaCarcel && jugadorActual.deboIrACarcel()){
                        encarcelarJugador();
                    }
                    else
                        mover(valor);
                    break;
                case PORCASAHOTEL:
                    int cantidad = cartaActual.GetValor();
                    int numeroTotal = jugadorActual.cuantasCasasHotelesTengo();
                    jugadorActual.modificarSaldo(cantidad*numeroTotal);
                    if(jugadorActual.getSaldo() < 0){
                        setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
                    }       break;
                case PORJUGADOR:
                    for(Jugador i: jugadores){
                        if(jugadorActual != i){
                            i.modificarSaldo(cartaActual.GetValor());
                            if(i.getSaldo() < 0){
                                setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
                            }
                            jugadorActual.modificarSaldo(-cartaActual.GetValor());
                            if (jugadorActual.getSaldo() < 0){
                                setEstadoJuego(EstadoJuego.ALGUNJUGADORENBANCARROTA);
                            }
                        }
                    }       break;
                case CONVERTIRME:
                    Especulador especulador = jugadorActual.convertirme(cartaActual.GetValor());
                    System.out.println("Convirtiendo en especulador...");
                    jugadores.set(indiceJugadorActual, especulador);
                    break;
                default:
                    break;
            }
        }
    }
    
    public boolean cancelarHipoteca(int numeroCasilla){
       TituloPropiedad titulo = tablero.obtenerCasillaNumero(numeroCasilla).getTitulo();
       boolean cancelada = jugadorActual.cancelarHipoteca(titulo);
       setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
       return cancelada;
    }
    
    public boolean comprarTituloPropiedad(){
        boolean comprado = jugadorActual.comprarTituloPropiedad();
         if (comprado){
            setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        }
        return comprado;
    }
    
    public boolean edificarCasa(int numeroCasilla){
        boolean edificada = false;
        Casilla casilla = tablero.obtenerCasillaNumero(numeroCasilla);
        TituloPropiedad titulo = casilla.getTitulo();
        edificada = jugadorActual.edificarCasa(titulo);
        if (edificada){
            setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        }
        return edificada;
    }
    
    public boolean edificarHotel(int numeroCasilla){
        boolean edificado = false;
        Casilla casilla = tablero.obtenerCasillaNumero(numeroCasilla);
        TituloPropiedad titulo = casilla.getTitulo();
        edificado = jugadorActual.edificarHotel(titulo);
        if (edificado){
            setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        }
        return edificado;
    }
    
    private void encarcelarJugador(){
        if(!jugadorActual.tengoCartaLibertad()){
            System.out.println("Te pilla el juez. Te envía a la carcel");
            Casilla casillaCarcel = tablero.getCarcel();
            jugadorActual.irACarcel(casillaCarcel);
            setEstadoJuego(EstadoJuego.JA_ENCARCELADO);
        }
        else{
            System.out.println("El juez te ha pillado, pero por suerte tenías una carta para salir.");
            Sorpresa carta = jugadorActual.devolverCartaLibretad();
            mazo.add(carta);
            setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
        }
    }
    
    public Sorpresa getCartaActual(){
        return cartaActual;
    }
    
    Dado getDado(){
        return dado;
    }
    
    public Jugador getJugadorActual(){
        return jugadorActual;
    }
    
    public ArrayList<Jugador> getJugadores(){
        return jugadores;
    }
   
    public int getValorDado(){
        return dado.getValor();
    }

    public EstadoJuego getEstadoJuego() {
        return estado;
    }
    
    
    public void hipotecarPropiedad(int numeroCasilla){
        Casilla casilla = tablero.obtenerCasillaNumero(numeroCasilla);
        TituloPropiedad titulo = casilla.getTitulo();
        jugadorActual.hipotecarPropiedad(titulo);
        setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
    }
    
    public void inicializarJuego(ArrayList<String> nombres){
        this.inicializarJugadores(nombres);
        this.InicializarTablero();
        this.inicializarCartasSorpresa();
        salidaJugadores();
    }
    
    private void inicializarJugadores(ArrayList<String> nombres){
        for(int i=0; i<nombres.size(); i++){
           jugadores.add(new Jugador(nombres.get(i)));
        }
        
    }
    
    public boolean intentarSalirCarcel(MetodoSalirCarcel metodo){
        if(metodo == MetodoSalirCarcel.TIRANDODADO){
            int resultado = tirarDado();
            System.out.print("\nTe ha salido un " + resultado + "\n");
            if(resultado >= 5){
                System.out.print("Enhorabuena, consigues salir con el valor del dado!\n");
                jugadorActual.setEncarcelado(false);
            }
        }
        else if(metodo == MetodoSalirCarcel.PAGANDOLIBERTAD){
            jugadorActual.pagarLibertad(PRECIO_LIBERTAD);    
        }
        boolean encarcelado = jugadorActual.getEncarcelado();
        if (encarcelado){
            setEstadoJuego(EstadoJuego.JA_ENCARCELADO);
        }
        else{
            setEstadoJuego(EstadoJuego.JA_PREPARADO);
        }
        return encarcelado;
    }
    
    public void jugar(){
        Casilla c = tablero.obtenerCasillaFinal(jugadorActual.getCasillaActual(), tirarDado());
        //System.out.print("El dado ha sacado " + dado.getValor() + ".\n La casilla final es "
        //        + c.toString());
        //****************FUNCIONA*****************
        mover(c.getNumeroCasilla());
        //System.out.print("El jugador actual ha sido movido a la casilla " + jugadorActual.getCasillaActual().toString() );
    }
    
    private void mover(int numCasillaDestino){
        Casilla casillaInicial = jugadorActual.getCasillaActual();
        Casilla casillaFinal = tablero.obtenerCasillaNumero(numCasillaDestino);
        jugadorActual.setCasillaActual(casillaFinal);
        if(numCasillaDestino < casillaInicial.getNumeroCasilla()){
            jugadorActual.modificarSaldo(SALDO_SALIDA);
        }
        if(casillaFinal.soyEdificable()){
            actuarSiEnCasillaEdificable();
        }
        else{
            actuarSiEnCasillaNoEdificable();
        }
    }
    
    public Casilla obtenerCasillaJugadorActual(){
        return jugadorActual.getCasillaActual();
    }
    
    public ArrayList<Casilla> obtenerCasillasTablero(){
        return  tablero.getCasillas();
    }
    
    public ArrayList<Integer> obtenerPropiedadesJugador(){
        ArrayList<Integer> numeros = new ArrayList<>();
        for (TituloPropiedad i: jugadorActual.getPropiedades()){
            for(Casilla j: tablero.getCasillas()){
                if(j.getTitulo() == i){
                    numeros.add(j.getNumeroCasilla());
                }
            }
        }
        return numeros;
    }
    
    public ArrayList<Integer> obtenerPropiedadesJugadorSegunEstadoHipoteca(boolean estadoHipoteca){
        ArrayList<Integer> numeros = new ArrayList<>();
        for(TituloPropiedad i: jugadorActual.obtenerPropiedades(estadoHipoteca)){
            for(Casilla j: tablero.getCasillas()){
                if (i == j.getTitulo()){
                    numeros.add(j.getNumeroCasilla());
                }
            }
        }
        return numeros;
    }
    
    public void obtenerRanking(){
        Collections.sort(jugadores);
    }
    
    public int obtenerSaldoJugadorActual(){
        return jugadorActual.getSaldo();
    }
     
    private void salidaJugadores(){
        
        //Metodo modificado para el examen, que Batman empiece siempre el primero
        for(Jugador i: jugadores){
            i.casillaActual = tablero.getCasillas().get(0);
        }
        indiceJugadorActual = (int) (Math.random() * jugadores.size());
        jugadorActual = jugadores.get(indiceJugadorActual);
        estado = EstadoJuego.JA_PREPARADO;
        
    }

    private void setCartaActual(Sorpresa cartaActual) {
        this.cartaActual = cartaActual;
    }

    public void setEstadoJuego(EstadoJuego estado) {
        this.estado = estado;
    }
    
    
    
    public void siguienteJugador(){
        indiceJugadorActual = (indiceJugadorActual + 1) % jugadores.size();
        jugadorActual = jugadores.get(indiceJugadorActual);
        if(jugadorActual.getEncarcelado()){
            estado = EstadoJuego.JA_ENCARCELADOCONOPCIONDELIBERTAD;
        } 
        else{
            estado = EstadoJuego.JA_PREPARADO;
        }
    }
    
    int tirarDado(){
        return dado.tirar();
    }
    
    public void venderPropiedad(int numeroCasilla){
        Casilla casilla = tablero.obtenerCasillaNumero(numeroCasilla);
        jugadorActual.venderPropiedad(casilla);
        setEstadoJuego(EstadoJuego.JA_PUEDEGESTIONAR);
    }
    
  
    
    
    
}

