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
public class Jugador implements Comparable{
    private boolean encarcelado = false;
    private String nombre = "Unknown";
    private int saldo = 7500;
    
    
    protected ArrayList<TituloPropiedad> propiedades = new ArrayList();
    protected Sorpresa cartaLibertad = null;
    protected Casilla casillaActual = null;
    
    
    
    
    //constructor
    public Jugador(String name){
        nombre = name;
    }
    
    public Jugador(Jugador otro){
        encarcelado = otro.encarcelado;
        nombre = otro.nombre;
        saldo = otro.saldo;
        
        propiedades = otro.propiedades;
        cartaLibertad = otro.cartaLibertad;
        casillaActual = otro.casillaActual;
        
    }
    
    //METODOS
    boolean cancelarHipoteca(TituloPropiedad titulo){
        boolean tengoSaldo = tengoSaldo(titulo.calcularCosteCancelar());
        boolean cancelada = false;
        if(tengoSaldo){
            modificarSaldo(-titulo.calcularCosteCancelar());
            cancelada = titulo.cancelarHipoteca();
        }
        return cancelada;
    }
    
    boolean comprarTituloPropiedad(){
        boolean comprado = false;
        int costeCompra = casillaActual.getCoste();
        if (costeCompra < saldo){
            ((Calle)casillaActual).asignarPropietario(this);
            TituloPropiedad titulo = casillaActual.getTitulo();
            propiedades.add(titulo);
            comprado = true;
            modificarSaldo(-costeCompra);
        }
       return comprado;
    }
    
    protected Especulador convertirme(int fianza){
        Especulador nuevo = new Especulador(this, fianza);
        return nuevo;
    }
    
    int cuantasCasasHotelesTengo(){
        int contador = 0;
        for(TituloPropiedad i: propiedades){
            contador = i.getNumCasas() + i.getNumHoteles();
        }
        return contador;
    }
    
    protected boolean deboIrACarcel(){
        if (tengoCartaLibertad())
            System.out.println("Felicidades, tienes la carta de libertad");
        return !tengoCartaLibertad();
    }
    
    boolean deboPagarAlquiler(){
        TituloPropiedad titulo = casillaActual.getTitulo();
        boolean esDeMiPropiedad = esDeMiPropiedad(titulo);
        boolean tienePropietario = titulo.tengoPropietario();
        boolean propietarioEncarcelado = titulo.propietarioEncarcelado();
        boolean estaHipotecada = titulo.getHipotecada();
        return (!esDeMiPropiedad & tienePropietario & !propietarioEncarcelado & !estaHipotecada);
    }
    
    Sorpresa devolverCartaLibretad(){
        Sorpresa aux = cartaLibertad;
        cartaLibertad = null;
        return aux;
    }
    
    boolean edificarCasa(TituloPropiedad titulo){
        int numCasas = titulo.getNumCasas();
        boolean edificada = false;
        if(puedoEdificarCasa(titulo)){
            int costeEdificarCasa = titulo.getPrecioEdificar();
            boolean tengoSaldo = tengoSaldo(costeEdificarCasa);
            if(tengoSaldo){
                titulo.edificarCasa();
                modificarSaldo(-costeEdificarCasa);
                edificada = true;
            }
        }
        return edificada;
    }
    
    boolean edificarHotel(TituloPropiedad titulo){
        int numCasas = titulo.getNumCasas();
        int numHoteles = titulo.getNumHoteles();
        boolean edificado = false;
        if (numCasas == 4 && puedoEdificarHotel(titulo) ){
            int costeEdificarHotel = titulo.getPrecioEdificar();
            boolean tengoSaldo = tengoSaldo(costeEdificarHotel);
            if(tengoSaldo){
                titulo.edificarHotel();
                modificarSaldo(-costeEdificarHotel);
                edificado = true;
            }
        }
        return edificado;
    }
    
    private void eliminarDeMisPropiedades(TituloPropiedad titulo){
       propiedades.remove(titulo);
       titulo.setPropietario(null);  
    }
    
    private boolean esDeMiPropiedad(TituloPropiedad titulo){
        boolean loEs=false;
        for(TituloPropiedad i: propiedades){
            if(i.getNombre() == titulo.getNombre()){
                loEs=true;
            }
        }
        return loEs;
    }
    
    boolean estoyEnCalleLibre(){
        throw new UnsupportedOperationException("Sin Implementar");
    }
    
    Sorpresa getCartaLibertad(){
        return cartaLibertad;
    }
    
    Casilla getCasillaActual(){
        return casillaActual;
    }

    boolean getEncarcelado() {
        return encarcelado;
    }

     public String getNombre() {
        return nombre;
    }
    
    ArrayList<TituloPropiedad> getPropiedades(){
        return propiedades;
    }

    public int getSaldo() {
        return saldo;
    }
    
    void hipotecarPropiedad(TituloPropiedad titulo){
        int costeHipoteca = titulo.hipotecar();
        modificarSaldo(costeHipoteca);
    }
    
    void irACarcel(Casilla casilla){
        setCasillaActual(casilla);
        setEncarcelado(true);
    }
    
    
    
    int modificarSaldo(int cantidad){
        saldo += cantidad;
        return saldo;
    }
    
    int obtenerCapital(){
        int valor = saldo;
        for(TituloPropiedad i: propiedades){
            valor += (i.getNumCasas()+i.getNumHoteles())*i.getPrecioEdificar() + i.getPrecioCompra();
            if(i.getHipotecada())
                valor-=i.getHipotecaBase();
        }
        return valor;
    }
    
    ArrayList<TituloPropiedad> obtenerPropiedades(boolean hipotecada){
        ArrayList<TituloPropiedad> filtro = new ArrayList<>();
        for(TituloPropiedad i: propiedades){
            if(i.getHipotecada()==hipotecada){
                filtro.add(i);
            }
        }
        
        return filtro;
    }
    
    void pagarAlquiler(){
        int costeAlquiler = ((Calle)casillaActual).pagarAlquiler();
        modificarSaldo(-costeAlquiler);    
    }
    
    protected void pagarImpuesto(){
        saldo -= casillaActual.getCoste();
        
    }
    
    void pagarLibertad(int cantidad){
        boolean tengoSaldo = tengoSaldo(cantidad); 
            if ( tengoSaldo){
                setEncarcelado(false);
                modificarSaldo(-cantidad); 
            }
    }
    
    protected boolean puedoEdificarCasa(TituloPropiedad titulo){
        if(titulo.getNumCasas() < 4 && saldo > titulo.getPrecioEdificar())
            return true;
        else
            return false;
            
    }
    
    protected boolean puedoEdificarHotel(TituloPropiedad titulo){
        if(titulo.getNumHoteles()< 4 && saldo > titulo.getPrecioEdificar())
            return true;
        else
            return false;
    }
    
    void setEncarcelado(boolean encarcelado) {
        this.encarcelado = encarcelado;
    }

    /*
    void setSaldo(int saldo) {
        this.saldo = saldo;
    }
    */

    void setCartaLibertad(Sorpresa carta) {
        this.cartaLibertad = carta;
    }

    void setCasillaActual(Casilla casilla) {
        this.casillaActual = casilla;
    }
    
    void setEncarceladoSinPoderSalir(boolean encarceladoSinPoderSalir){
        throw new UnsupportedOperationException("Sin Implementar");
    }
    
    public void setHaTiradoDado(boolean haTiradoDado){
        throw new UnsupportedOperationException("Sin Implementar");
    }
    
    boolean tengoCartaLibertad(){
        if(cartaLibertad == null)
            return false;
        else
            return true;
    }
    
    protected boolean tengoSaldo(int cantidad){
        boolean tengo = true;
        if(saldo < cantidad){
            tengo = false;
        }
        return tengo;
    }
    
    void venderPropiedad(Casilla casilla){
        TituloPropiedad titulo = casilla.getTitulo();
        eliminarDeMisPropiedades(titulo);
        int precioVenta = titulo.calcularPrecioVenta();
        modificarSaldo(precioVenta);
    }

    @Override
    public String toString() {
        String prop="";
        for(int i=0; i<propiedades.size(); i++){
            prop = prop + propiedades.get(i).toString();
        }
        return "\nJugador:" + 
                "\nEncarcelado: " + encarcelado + 
                "\nNombre: " + nombre + 
                "\nSaldo: " + saldo + 
                "\nCapital: " + this.obtenerCapital() +
                "\nPropiedades: " + prop +  //for de todas las propiedades + propiedades.toString()
                "\nCarta Libertad:" + this.tengoCartaLibertad() + 
                "\nCasilla Actual:" + casillaActual.getNumeroCasilla() + '\n';
    }

    @Override
    public int compareTo(Object o) {
       int otroCapital = ((Jugador) o).obtenerCapital();
       return otroCapital - obtenerCapital();
    }
    
    
    
}
