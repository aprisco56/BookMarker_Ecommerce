package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Recensione;

public class RecensioneDAO {

    public void doSave(Recensione r) throws SQLException {
        String sql = "INSERT INTO recensioni (utente_email, libro_id, testo, voto, data_inserimento, attivo, nascosto) VALUES (?, ?, ?, ?, NOW(), ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getEmailUtente());
            ps.setInt(2, r.getIdLibro());
            ps.setString(3, r.getTesto());
            ps.setInt(4, r.getVoto());
            ps.setBoolean(5, r.isAttivo());
            ps.setBoolean(6, r.isNascosto());
            ps.executeUpdate();
        }
    }

    public void doUpdate(Recensione r) throws SQLException {
        String sql = "UPDATE recensioni SET testo = ?, voto = ?, attivo = ?, nascosto = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getTesto());
            ps.setInt(2, r.getVoto());
            ps.setBoolean(3, r.isAttivo());
            ps.setBoolean(4, r.isNascosto());
            ps.setInt(5, r.getId());
            ps.executeUpdate();
        }
    }

    public Recensione doRetrieveById(int id) throws SQLException {
        String sql = "SELECT * FROM recensioni WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRecensione(rs, false);
                }
            }
        }
        return null;
    }

    public List<Recensione> doRetrieveAllPubblicheByLibro(int idLibro) throws SQLException {
        List<Recensione> lista = new ArrayList<>();
        String sql = "SELECT r.*, u.nome, u.cognome FROM recensioni r JOIN utenti u ON r.utente_email = u.email WHERE r.libro_id = ? AND r.attivo = true AND r.nascosto = false ORDER BY r.data_inserimento DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapRecensione(rs, true));
                }
            }
        }
        return lista;
    }

    public List<Recensione> doRetrieveAllByLibro(int idLibro) throws SQLException {
        List<Recensione> lista = new ArrayList<>();
        String sql = "SELECT r.*, u.nome, u.cognome FROM recensioni r JOIN utenti u ON r.utente_email = u.email WHERE r.libro_id = ? ORDER BY r.data_inserimento DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapRecensione(rs, true));
                }
            }
        }
        return lista;
    }

    public Recensione doRetrieveByUtenteAndLibro(String email, int idLibro) throws SQLException {
        String sql = "SELECT * FROM recensioni WHERE utente_email = ? AND libro_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRecensione(rs, false);
                }
            }
        }
        return null;
    }

    private Recensione mapRecensione(ResultSet rs, boolean joinUtente) throws SQLException {
        Recensione r = new Recensione();
        r.setId(rs.getInt("id"));
        r.setEmailUtente(rs.getString("utente_email"));
        r.setIdLibro(rs.getInt("libro_id"));
        r.setTesto(rs.getString("testo"));
        r.setVoto(rs.getInt("voto"));
        r.setDataInserimento(rs.getDate("data_inserimento"));
        r.setAttivo(rs.getBoolean("attivo"));
        r.setNascosto(rs.getBoolean("nascosto"));
        
        if (joinUtente) {
            r.setNomeUtenteDisplay(rs.getString("nome") + " " + rs.getString("cognome"));
        }
        return r;
    }
}