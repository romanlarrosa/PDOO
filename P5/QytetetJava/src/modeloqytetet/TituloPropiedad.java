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
public class TituloPropiedad {
    private String nombre;
    private boolean hipotecada;
    private int precioCompra;
    private float factorRevalorizacion;   
    private int hipotecaBase;
    private int precioEdificar;
    private int numHoteles, numCasas;
    private int alquilerBase;
    private Jugador propietario;
    
    
    public TituloPropiedad(String nom, int p_compra, int f_rev, int h_base, int p_edif, int a_base){
        numHoteles = 0;
        numCasas = 0;
        hipotecada = false;
        nombre = nom;
        precioCompra = p_compra;
        factorRevalorizacion = f_rev;
        hipotecaBase = h_base;
        precioEdificar = p_edif;
        alquilerBase = a_base;
}

    String getNombre() {
        return nombre;
    }

    boolean getHipotecada() {
        return hipotecada;
    }

    int getPrecioCompra() {
        return precioCompra;
    }

    float getFactorRevalorizacion() {
        return factorRevalorizacion;
    }

    int getHipotecaBase() {
        return hipotecaBase;
    }
    
    int getAlquilerBase(){
        return alquilerBase;
    }

    int getPrecioEdificar() {
        return precioEdificar;
    }

    int getNumHoteles() {
        return numHoteles;
    }

    int getNumCasas() {
        return numCasas;
    }
    
    Jugador getPropietario(){
        return propietario;
    }

    void setHipotecada(boolean hipotecada) {
        this.hipotecada = hipotecada;
    }

    @Override
    public String toString() {
        return  "\nTitulo de Propiedad:" + 
                "\nNombre: " + nombre + 
                "\nHipotecada=" + hipotecada + 
                "\nPrecio de Compra: " + precioCompra + 
                "\nFactor de Revalorizacion: " + factorRevalorizacion + 
                "\nHipotecaBase: " + hipotecaBase + 
                "\nPrecio Edificar: " + precioEdificar + 
                "\nNumero de Hoteles: " + numHoteles + 
                "\nNumero de Casas: " + numCasas + 
                "\nAlquiler Base: " + alquilerBase + 
                "\nPropietario: " + (propietario != null ? propietario.getNombre() : "Sin propietario") + '\n';
    }

    
    
    int calcularCosteCancelar(){
        return (int)(calcularCosteHipotecar() + calcularCosteHipotecar()*(1.0/10));      
    }
    
    int calcularCosteHipotecar(){
        int costeHipoteca = (int)(hipotecaBase *(1 + numCasas*(1.0/2)*hipotecaBase + numHoteles*hipotecaBase));
        return costeHipoteca;
    }
    
    int calcularPrecioVenta(){
        int precioVenta = (int)(precioCompra + (numCasas + numHoteles)*precioEdificar*factorRevalorizacion/100);
        return precioVenta;
    }
    
    int calcularImporteAlquiler(){
        int costeAlquiler = (int)(alquilerBase * (1 + (numCasas * (1.0/2)+numHoteles * 2)));
        //System.out.println("Se procede a cobrar el alquiler: " + costeAlquiler);
        return costeAlquiler;
    }
    
    boolean cancelarHipoteca(){
       hipotecada = false;
       return true;
    }
    
    void cobrarAlquiler(int coste){
        propietario.modificarSaldo(coste);
    }
    
    void edificarCasa(){
        numCasas++;
    }
    
    void edificarHotel(){
        numCasas = 0;
        numHoteles = numHoteles + 1;
    }
    
    int hipotecar(){
        setHipotecada(true);
        int costeHipoteca = calcularCosteHipotecar();
        return costeHipoteca;
    }
    
    int pagarAlquiler(){
        int costeAlquiler = calcularImporteAlquiler();
        propietario.modificarSaldo(costeAlquiler);
        return costeAlquiler;
    }
    
    boolean propietarioEncarcelado(){
        if(propietario != null && propietario.getEncarcelado())
            return true;
        else
            return false;
    }
    
    void setPropietario(Jugador propietario){
        this.propietario = propietario;
    }
    
    boolean tengoPropietario(){
        if(propietario != null)
            return true;
        else
            return false;
                    
    }
    
    
}
