package model;

import java.sql.Date;

public class Recensione {
    private int id;
    private String emailUtente;
    private int idLibro;
    private String testo;
    private int voto;
    private Date dataInserimento;
    private boolean attivo;
    private boolean nascosto;
    private String nomeUtenteDisplay;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmailUtente() {
        return emailUtente;
    }

    public void setEmailUtente(String emailUtente) {
        this.emailUtente = emailUtente;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public String getTesto() {
        return testo;
    }

    public void setTesto(String testo) {
        this.testo = testo;
    }

    public int getVoto() {
        return voto;
    }

    public void setVoto(int voto) {
        this.voto = voto;
    }

    public Date getDataInserimento() {
        return dataInserimento;
    }

    public void setDataInserimento(Date dataInserimento) {
        this.dataInserimento = dataInserimento;
    }

    public boolean isAttivo() {
        return attivo;
    }

    public void setAttivo(boolean attivo) {
        this.attivo = attivo;
    }

    public boolean isNascosto() {
        return nascosto;
    }

    public void setNascosto(boolean nascosto) {
        this.nascosto = nascosto;
    }

    public String getNomeUtenteDisplay() {
        return nomeUtenteDisplay;
    }

    public void setNomeUtenteDisplay(String nomeUtenteDisplay) {
        this.nomeUtenteDisplay = nomeUtenteDisplay;
    }
}