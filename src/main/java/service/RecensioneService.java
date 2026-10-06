package service;

import dao.RecensioneDAO;
import java.util.List;
import java.sql.SQLException;
import model.Recensione;
import model.DettaglioOrdine;
import java.util.HashMap;
import java.util.Map;

public class RecensioneService {

    private RecensioneDAO recensioneDAO;

    public RecensioneService(RecensioneDAO recensioneDAO) {
        this.recensioneDAO = recensioneDAO;
    }

    public void aggiungiRecensione(String emailUtente, String idLibroStr, String testo, String votoStr) throws SQLException {
        if (idLibroStr != null && votoStr != null) {
            try {
                int idLibro = Integer.parseInt(idLibroStr);
                int voto = Integer.parseInt(votoStr);

                Recensione recensione = new Recensione();
                recensione.setEmailUtente(emailUtente);
                recensione.setIdLibro(idLibro);
                recensione.setTesto(testo);
                recensione.setVoto(voto);
                recensione.setAttivo(true);
                recensione.setNascosto(false);

                recensioneDAO.doSave(recensione);
                
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
    }
    
    public List<Recensione> getRecensioniPubbliche(int idLibro) throws SQLException {
        return recensioneDAO.doRetrieveAllPubblicheByLibro(idLibro);
    }

    public List<Recensione> getRecensioniPerModeratore(int idLibro) throws SQLException {
        return recensioneDAO.doRetrieveAllByLibro(idLibro);
    }
    
    public Map<Integer, Recensione> getMappaRecensioniPerStorico(String email, List<DettaglioOrdine> storicoAcquisti) throws SQLException {
        Map<Integer, Recensione> mappa = new HashMap<>();
        
        if (email == null || storicoAcquisti == null) {
            return mappa; 
        }

        for (DettaglioOrdine d : storicoAcquisti) {
            if (d.isRecensito()) {
                Recensione r = recensioneDAO.doRetrieveByUtenteAndLibro(email, d.getIdLibro());
                if (r != null) {
                    mappa.put(d.getIdLibro(), r);
                }
            }
        }
        return mappa;
    }
    
    public void deleteRecensioneUtente(String emailUtente, String idLibroStr) throws SQLException {
        if (emailUtente == null || idLibroStr == null) return;
        
        try {
            int idLibro = Integer.parseInt(idLibroStr);
            Recensione r = recensioneDAO.doRetrieveByUtenteAndLibro(emailUtente, idLibro);
            if(r != null) {
               r.setAttivo(false);
               recensioneDAO.doUpdate(r);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    public void impostaVisibilita(String idStr, boolean visibile) throws SQLException {
        try {
            int id = Integer.parseInt(idStr);
            Recensione r = recensioneDAO.doRetrieveById(id);
            if(r != null){
                r.setNascosto(!visibile);
                recensioneDAO.doUpdate(r);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
}