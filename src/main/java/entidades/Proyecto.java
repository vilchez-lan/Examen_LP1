package entidades;

public class Proyecto {
    private String nombre;
    private String descripcion;
    private String fechaInicio;
    private String fechaFin;
    private String asesor;
    private String presupuesto;

    public Proyecto(String nombre, String descripcion, String fechaInicio,
                    String fechaFin, String asesor, String presupuesto) {
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.asesor = asesor;
        this.presupuesto = presupuesto;
    }

    public String getNombre() { return nombre; }
    public String getDescripcion() { return descripcion; }
    public String getFechaInicio() { return fechaInicio; }
    public String getFechaFin() { return fechaFin; }
    public String getAsesor() { return asesor; }
    public String getPresupuesto() { return presupuesto; }
}