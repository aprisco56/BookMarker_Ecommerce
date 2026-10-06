package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Libro;

public class LibroDAO {

    public void doSave(Libro libro) throws SQLException {
        String query = "INSERT INTO libri (titolo, autore, genere, disponibilita, data_pubblicazione, descrizione, copertina, attivo, prezzo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, libro.getTitolo());
            ps.setString(2, libro.getAutore());
            ps.setString(3, libro.getGenere());
            ps.setInt(4, libro.getDisponibilita());
            ps.setDate(5, libro.getDataPubblicazione());
            ps.setString(6, libro.getDescrizione());
            ps.setString(7, libro.getCopertina());
            ps.setBoolean(8, libro.isAttivo());
            ps.setDouble(9, libro.getPrezzo());
            ps.executeUpdate();
        }
    }

    public Libro doRetrieveById(int id) throws SQLException {
        String query = "SELECT * FROM libri WHERE id_libro = ?";
        Libro libro = null;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    libro = new Libro();
                    libro.setIdLibro(rs.getInt("id_libro"));
                    libro.setTitolo(rs.getString("titolo"));
                    libro.setAutore(rs.getString("autore"));
                    libro.setGenere(rs.getString("genere"));
                    libro.setDisponibilita(rs.getInt("disponibilita"));
                    libro.setDataPubblicazione(rs.getDate("data_pubblicazione"));
                    libro.setDescrizione(rs.getString("descrizione"));
                    libro.setCopertina(rs.getString("copertina"));
                    libro.setAttivo(rs.getBoolean("attivo"));
                    libro.setPrezzo(rs.getDouble("prezzo"));
                }
            }
        }
        return libro;
    }

    public List<Libro> doRetrieveAll() throws SQLException {
        String query = "SELECT * FROM libri";
        List<Libro> libri = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Libro libro = new Libro();
                libro.setIdLibro(rs.getInt("id_libro"));
                libro.setTitolo(rs.getString("titolo"));
                libro.setAutore(rs.getString("autore"));
                libro.setGenere(rs.getString("genere"));
                libro.setDisponibilita(rs.getInt("disponibilita"));
                libro.setDataPubblicazione(rs.getDate("data_pubblicazione"));
                libro.setDescrizione(rs.getString("descrizione"));
                libro.setCopertina(rs.getString("copertina"));
                libro.setAttivo(rs.getBoolean("attivo"));
                libro.setPrezzo(rs.getDouble("prezzo"));
                libri.add(libro);
            }
        }
        return libri;
    }

    public void doUpdate(Libro libro) throws SQLException {
        String query = "UPDATE libri SET titolo = ?, autore = ?, genere = ?, disponibilita = ?, data_pubblicazione = ?, descrizione = ?, copertina = ?, attivo = ?, prezzo = ? WHERE id_libro = ?";
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, libro.getTitolo());
            ps.setString(2, libro.getAutore());
            ps.setString(3, libro.getGenere());
            ps.setInt(4, libro.getDisponibilita());
            ps.setDate(5, libro.getDataPubblicazione());
            ps.setString(6, libro.getDescrizione());
            ps.setString(7, libro.getCopertina());
            ps.setBoolean(8, libro.isAttivo());
            ps.setDouble(9, libro.getPrezzo());
            ps.setInt(10, libro.getIdLibro());
            ps.executeUpdate();
        }
    }
}