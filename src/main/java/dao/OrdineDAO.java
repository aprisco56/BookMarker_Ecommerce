package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Ordine;

public class OrdineDAO {

    public int doSave(Ordine ordine) throws SQLException {
        String query = "INSERT INTO ordini (utente_email, totale, indirizzo_spedizione, metodo_pagamento, stato) VALUES (?, ?, ?, ?, ?)";
        int idGenerato = -1;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, ordine.getUtenteEmail());
            ps.setDouble(2, ordine.getTotale());
            ps.setString(3, ordine.getIndirizzoSpedizione());
            ps.setString(4, ordine.getMetodoPagamento());
            ps.setString(5, ordine.getStato());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    idGenerato = rs.getInt(1);
                    ordine.setIdOrdine(idGenerato);
                }
            }
        }
        return idGenerato;
    }

    public Ordine doRetrieveById(int id) throws SQLException {
        String query = "SELECT * FROM ordini WHERE id_ordine = ?";
        Ordine ordine = null;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ordine = new Ordine();
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setUtenteEmail(rs.getString("utente_email"));
                    ordine.setDataOrdine(rs.getTimestamp("data_ordine"));
                    ordine.setTotale(rs.getDouble("totale"));
                    ordine.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                    ordine.setMetodoPagamento(rs.getString("metodo_pagamento"));
                    ordine.setStato(rs.getString("stato"));
                }
            }
        }
        return ordine;
    }

    public List<Ordine> doRetrieveAllByEmail(String email) throws SQLException {
        String query = "SELECT * FROM ordini WHERE utente_email = ? ORDER BY data_ordine DESC";
        List<Ordine> ordini = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ordine ordine = new Ordine();
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setUtenteEmail(rs.getString("utente_email"));
                    ordine.setDataOrdine(rs.getTimestamp("data_ordine"));
                    ordine.setTotale(rs.getDouble("totale"));
                    ordine.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                    ordine.setMetodoPagamento(rs.getString("metodo_pagamento"));
                    ordine.setStato(rs.getString("stato"));
                    ordini.add(ordine);
                }
            }
        }
        return ordini;
    }
    
    public void doUpdateStato(int idOrdine, String nuovoStato) throws SQLException {
        String query = "UPDATE ordini SET stato = ? WHERE id_ordine = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, nuovoStato);
            ps.setInt(2, idOrdine);
            ps.executeUpdate();
        }
    }
}