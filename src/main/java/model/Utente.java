package model;

import java.sql.Timestamp;

public class Utente {
    private String email;
    private String nome;
    private String cognome;
    private String codiceFiscale;
    private String password;
    private Timestamp dataRegistrazione;
    private String recapito;
    private String ruolo;
    private String stato;
    private String domandaSicurezza;
    private String rispostaSicurezza;

    public Utente() {}

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getCognome() { return cognome; }
    public void setCognome(String cognome) { this.cognome = cognome; }

    public String getCodiceFiscale() { return codiceFiscale; }
    public void setCodiceFiscale(String codiceFiscale) { this.codiceFiscale = codiceFiscale; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Timestamp getDataRegistrazione() { return dataRegistrazione; }
    public void setDataRegistrazione(Timestamp dataRegistrazione) { this.dataRegistrazione = dataRegistrazione; }

    public String getRecapito() { return recapito; }
    public void setRecapito(String recapito) { this.recapito = recapito; }

    public String getRuolo() { return ruolo; }
    public void setRuolo(String ruolo) { this.ruolo = ruolo; }

    public String getStato() { return stato; }
    public void setStato(String stato) { this.stato = stato; }

    public String getDomandaSicurezza() { return domandaSicurezza; }
    public void setDomandaSicurezza(String domandaSicurezza) { this.domandaSicurezza = domandaSicurezza; }

    public String getRispostaSicurezza() { return rispostaSicurezza; }
    public void setRispostaSicurezza(String rispostaSicurezza) { this.rispostaSicurezza = rispostaSicurezza; }
}