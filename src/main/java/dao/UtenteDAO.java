package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Utente;

public class UtenteDAO {

    public void doSave(Utente utente) throws SQLException {
        String query = "INSERT INTO utenti (email, nome, cognome, codice_fiscale, password, recapito, ruolo, stato, domanda_sicurezza, risposta_sicurezza) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, utente.getEmail());
            ps.setString(2, utente.getNome());
            ps.setString(3, utente.getCognome());
            ps.setString(4, utente.getCodiceFiscale());
            ps.setString(5, utente.getPassword());
            ps.setString(6, utente.getRecapito());
            ps.setString(7, utente.getRuolo());
            ps.setString(8, utente.getStato());
            ps.setString(9, utente.getDomandaSicurezza());
            ps.setString(10, utente.getRispostaSicurezza());
            ps.executeUpdate();
        }
    }

    public Utente doRetrieveByEmail(String email) throws SQLException {
        String query = "SELECT * FROM utenti WHERE email = ?";
        Utente utente = null;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    utente = new Utente();
                    utente.setEmail(rs.getString("email"));
                    utente.setNome(rs.getString("nome"));
                    utente.setCognome(rs.getString("cognome"));
                    utente.setCodiceFiscale(rs.getString("codice_fiscale"));
                    utente.setPassword(rs.getString("password"));
                    utente.setDataRegistrazione(rs.getTimestamp("data_registrazione"));
                    utente.setRecapito(rs.getString("recapito"));
                    utente.setRuolo(rs.getString("ruolo"));
                    utente.setStato(rs.getString("stato"));
                    utente.setDomandaSicurezza(rs.getString("domanda_sicurezza"));
                    utente.setRispostaSicurezza(rs.getString("risposta_sicurezza"));
                }
            }
        }
        return utente;
    }

    public void doUpdate(Utente utente) throws SQLException {
        String query = "UPDATE utenti SET nome = ?, cognome = ?, codice_fiscale = ?, password = ?, recapito = ?, ruolo = ?, stato = ?, domanda_sicurezza = ?, risposta_sicurezza = ? WHERE email = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, utente.getNome());
            ps.setString(2, utente.getCognome());
            ps.setString(3, utente.getCodiceFiscale());
            ps.setString(4, utente.getPassword());
            ps.setString(5, utente.getRecapito());
            ps.setString(6, utente.getRuolo());
            ps.setString(7, utente.getStato());
            ps.setString(8, utente.getDomandaSicurezza());
            ps.setString(9, utente.getRispostaSicurezza());
            ps.setString(10, utente.getEmail());
            ps.executeUpdate();
        }
    }
}