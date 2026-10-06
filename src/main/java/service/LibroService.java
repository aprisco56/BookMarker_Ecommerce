package service;

import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import dao.LibroDAO;
import model.Libro;
import service.exception.GenericException.*;
import service.exception.LibroServiceException.*;

public class LibroService {

    private LibroDAO libroDAO;

    public LibroService(LibroDAO libroDAO) {
        this.libroDAO = libroDAO;
    }

    public void aggiungiLibro(String titolo, String autore, String genere, String copieStr, String dataPubStr, String copertina, String descrizione, String prezzoStr) 
            throws FormatoDatiNonValidoException, DataNonValidaException, CopieNegativeException, SQLException {
        
        if (titolo == null || titolo.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("Il titolo è obbligatorio.");
        }
        if (autore == null || autore.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("L'autore è obbligatorio.");
        }
        if (genere == null || genere.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("Il genere è obbligatorio.");
        }
        if (copieStr == null || copieStr.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("Il numero di copie è obbligatorio.");
        }
        if (dataPubStr == null || dataPubStr.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("La data di pubblicazione è obbligatoria.");
        }
        if (copertina == null || copertina.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("La copertina è obbligatoria.");
        }
        if (descrizione == null || descrizione.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("La descrizione è obbligatoria.");
        }
        if (prezzoStr == null || prezzoStr.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("Il prezzo è obbligatorio.");
        }

        String copertinaLower = copertina.toLowerCase();
        if (!copertinaLower.endsWith(".jpg") && !copertinaLower.endsWith(".jpeg") && !copertinaLower.endsWith(".png")) {
            throw new FormatoDatiNonValidoException("Il file della copertina deve essere nei formati: jpg, png, jpeg");
        }

        int copie;
        try {
            copie = Integer.parseInt(copieStr);
        } catch (NumberFormatException e) {
            throw new FormatoDatiNonValidoException("Il campo 'Copie' deve contenere un numero intero valido.");
        }

        if (copie < 0) {
            throw new CopieNegativeException("Il numero di copie non può essere negativo.");
        }

        double prezzo;
        try {
            prezzo = Double.parseDouble(prezzoStr.replace(",", "."));
        } catch (NumberFormatException e) {
            throw new FormatoDatiNonValidoException("Il campo 'Prezzo' deve contenere un valore numerico valido.");
        }

        if (prezzo <= 0) {
            throw new FormatoDatiNonValidoException("Il prezzo deve essere maggiore di zero.");
        }

        Date dataPub;
        try {
            dataPub = Date.valueOf(dataPubStr);
        } catch (IllegalArgumentException e) {
            throw new DataNonValidaException("Formato data non valido.");
        }

        LocalDate localDataPub = dataPub.toLocalDate();
        if (localDataPub.getYear() > LocalDate.now().getYear()) {
            throw new DataNonValidaException("La data di pubblicazione non è valida");
        }

        Libro libro = new Libro();
        libro.setTitolo(titolo);
        libro.setAutore(autore);
        libro.setGenere(genere);
        libro.setDisponibilita(copie);
        libro.setDataPubblicazione(dataPub);
        libro.setCopertina(copertina);
        libro.setDescrizione(descrizione);
        libro.setPrezzo(prezzo);
        libro.setAttivo(true);

        libroDAO.doSave(libro); 
    }

    public void aggiornaDisponibilita(String idStr, String quantitaStr) 
            throws FormatoDatiNonValidoException, CopieNegativeException, LibroNonTrovatoException, SQLException {
            
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("ID libro mancante.");
        }
        if (quantitaStr == null || quantitaStr.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("Quantità mancante.");
        }
        
        int id;
        int nuoveCopie;

        try {
            id = Integer.parseInt(idStr.trim());
            nuoveCopie = Integer.parseInt(quantitaStr.trim());
        } catch (NumberFormatException e) {
            throw new FormatoDatiNonValidoException("Devi inserire un numero intero valido.");
        }

        if (nuoveCopie < 0) {
            throw new CopieNegativeException("Il numero di copie non può essere negativo.");
        }
        
        Libro libro = libroDAO.doRetrieveById(id);
        if (libro == null) {
            throw new LibroNonTrovatoException("Errore: Impossibile aggiornare, libro non trovato.");
        }
        
        libro.setDisponibilita(nuoveCopie);
        libroDAO.doUpdate(libro);
    }

    public void disattivaLibro(String idStr) throws LibroNonTrovatoException, FormatoDatiNonValidoException, SQLException {
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("ID mancante");
        }
        
        try {
            int id = Integer.parseInt(idStr);
            Libro libro = libroDAO.doRetrieveById(id);
            
            if (libro == null) {
                throw new LibroNonTrovatoException("Libro non trovato.");
            }
            
            libro.setAttivo(false);
            libroDAO.doUpdate(libro);
            
        } catch (NumberFormatException e) {
            throw new FormatoDatiNonValidoException("ID non valido");
        }
    }

    public List<Libro> getCatalogoCompleto() throws SQLException {
        return libroDAO.doRetrieveAll();
    }

    public Libro getDettaglioLibro(int id) throws SQLException {
        return libroDAO.doRetrieveById(id);
    }
}