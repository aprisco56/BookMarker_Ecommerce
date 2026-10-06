package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Segnalazione;

public class SegnalazioneDAO {

    public void doSave(Segnalazione segnalazione) throws SQLException {
        String query = "INSERT INTO segnalazioni (utente_email, recensione_id, motivo, data_segnalazione, stato, note_chiusura) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, segnalazione.getUtenteEmail());
            ps.setInt(2, segnalazione.getRecensioneId());
            ps.setString(3, segnalazione.getMotivo());
            ps.setDate(4, segnalazione.getDataSegnalazione());
            ps.setString(5, segnalazione.getStato());
            ps.setString(6, segnalazione.getNoteChiusura());
            ps.executeUpdate();
        }
    }

    public List<Segnalazione> doRetrieveAll() throws SQLException {
        String query = "SELECT * FROM segnalazioni";
        List<Segnalazione> segnalazioni = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Segnalazione segnalazione = new Segnalazione();
                segnalazione.setId(rs.getInt("id"));
                segnalazione.setUtenteEmail(rs.getString("utente_email"));
                segnalazione.setRecensioneId(rs.getInt("recensione_id"));
                segnalazione.setMotivo(rs.getString("motivo"));
                segnalazione.setDataSegnalazione(rs.getDate("data_segnalazione"));
                segnalazione.setStato(rs.getString("stato"));
                segnalazione.setNoteChiusura(rs.getString("note_chiusura"));
                segnalazioni.add(segnalazione);
            }
        }
        return segnalazioni;
    }

    public void doUpdateStato(int id, String stato, String noteChiusura) throws SQLException {
        String query = "UPDATE segnalazioni SET stato = ?, note_chiusura = ? WHERE id = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, stato);
            ps.setString(2, noteChiusura);
            ps.setInt(3, id);
            ps.executeUpdate();
        }
    }
}