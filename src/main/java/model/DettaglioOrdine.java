package model;

public class DettaglioOrdine {
    
    private int id;
    private int idOrdine;
    private int idLibro;
    private double prezzoSingolo;
    private int quantita;
    private boolean recensito;
    private Libro libro;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getIdOrdine() {
        return idOrdine;
    }

    public void setIdOrdine(int idOrdine) {
        this.idOrdine = idOrdine;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public double getPrezzoSingolo() {
        return prezzoSingolo;
    }

    public void setPrezzoSingolo(double prezzoSingolo) {
        this.prezzoSingolo = prezzoSingolo;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    public boolean isRecensito() {
        return recensito;
    }

    public void setRecensito(boolean recensito) {
        this.recensito = recensito;
    }

    public Libro getLibro() {
        return libro;
    }

    public void setLibro(Libro libro) {
        this.libro = libro;
    }
}