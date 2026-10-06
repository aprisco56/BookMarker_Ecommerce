package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.DettaglioOrdine;

public class DettaglioOrdineDAO {

    public void doSave(DettaglioOrdine dettaglio) throws SQLException {
        String query = "INSERT INTO dettagli_ordine (ordine_id, libro_id, quantita, prezzo_acquisto) VALUES (?, ?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, dettaglio.getIdOrdine());
            ps.setInt(2, dettaglio.getIdLibro());
            ps.setInt(3, dettaglio.getQuantita());
            ps.setDouble(4, dettaglio.getPrezzoSingolo());
            ps.executeUpdate();
        }
    }

    public List<DettaglioOrdine> doRetrieveByOrdineId(int ordineId) throws SQLException {
        String query = "SELECT * FROM dettagli_ordine WHERE ordine_id = ?";
        List<DettaglioOrdine> dettagli = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, ordineId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DettaglioOrdine dettaglio = new DettaglioOrdine();
                    dettaglio.setId(rs.getInt("id_dettaglio"));
                    dettaglio.setIdOrdine(rs.getInt("ordine_id"));
                    dettaglio.setIdLibro(rs.getInt("libro_id"));
                    dettaglio.setQuantita(rs.getInt("quantita"));
                    dettaglio.setPrezzoSingolo(rs.getDouble("prezzo_acquisto"));
                    dettagli.add(dettaglio);
                }
            }
        }
        return dettagli;
    }
}