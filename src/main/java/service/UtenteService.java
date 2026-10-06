package service;

import java.sql.SQLException;
import java.util.regex.Pattern;
import org.mindrot.jbcrypt.BCrypt;
import dao.UtenteDAO;
import model.Utente;
import service.exception.GenericException.*;
import service.exception.UtenteServiceException.*;

public class UtenteService {

    private UtenteDAO utenteDAO;

    private static final Pattern NOME_PATTERN = Pattern.compile("^[a-zA-Z\\s]+$");
    private static final Pattern CF_PATTERN = Pattern.compile("^[A-Z0-9]{16}$");
    private static final Pattern PASS_PATTERN = Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=!._-]).{8,}$");

    public UtenteService(UtenteDAO utenteDAO) {
        this.utenteDAO = utenteDAO;
    }

    public void registraUtente(String nome, String cognome, String cf, String email, String password, String confirmPassword, String domanda, String risposta) 
            throws FormatoDatiNonValidoException, FormatoPasswordNonValidoException, PasswordNonCorrispondentiException, EmailGiaRegistrataException, CodiceFiscaleGiaRegistratoException, SQLException {

        if (password == null || !password.equals(confirmPassword)) {
            throw new PasswordNonCorrispondentiException("Le password non corrispondono.");
        }
        if (!isNomeValido(nome)) {
            throw new FormatoDatiNonValidoException("Il nome deve contenere solo lettere.");
        }
        if (!isNomeValido(cognome)) {
            throw new FormatoDatiNonValidoException("Il cognome deve contenere solo lettere.");
        }
        if (!isCodiceFiscaleValido(cf)) {
            throw new FormatoDatiNonValidoException("Il Codice Fiscale deve essere di 16 caratteri alfanumerici.");
        }
        if (!isEmailFormatoValido(email)) {
            throw new FormatoDatiNonValidoException("Inserisci un indirizzo email valido (con @ e .).");
        }
        if (!isPasswordValida(password)) {
            throw new FormatoPasswordNonValidoException("La password deve contenere almeno 8 caratteri, una maiuscola, un numero e un simbolo.");
        }
        if (domanda == null || domanda.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("Seleziona una domanda di sicurezza.");
        }
        if (risposta == null || risposta.trim().isEmpty()) {
            throw new FormatoDatiNonValidoException("La risposta alla domanda di sicurezza è obbligatoria.");
        }
        if (utenteDAO.doRetrieveByEmail(email) != null) {
            throw new EmailGiaRegistrataException("L'email inserita è già registrata.");
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        
        Utente nuovoUtente = new Utente();
        nuovoUtente.setNome(nome);
        nuovoUtente.setCognome(cognome);
        nuovoUtente.setCodiceFiscale(cf);
        nuovoUtente.setEmail(email);
        nuovoUtente.setPassword(hashedPassword);
        nuovoUtente.setDomandaSicurezza(domanda);
        nuovoUtente.setRispostaSicurezza(risposta);
        nuovoUtente.setRuolo("CLIENTE");
        nuovoUtente.setStato("attivo");
        
        utenteDAO.doSave(nuovoUtente);
    }

    public Utente login(String email, String password) throws CredenzialiNonValideException, UtenteNonAbilitatoException, SQLException {
        Utente utente = utenteDAO.doRetrieveByEmail(email);

        if (utente == null || !BCrypt.checkpw(password, utente.getPassword())) {
            throw new CredenzialiNonValideException("Email o password non validi.");
        }

        String stato = utente.getStato();
        if (stato != null) {
            if ("in_attesa".equals(stato)) {
                throw new UtenteNonAbilitatoException("Registrazione in attesa di approvazione.");
            }
        }

        return utente;
    }

    public Utente getDatiUtente(String email) throws SQLException {
        if (email == null) return null;
        return utenteDAO.doRetrieveByEmail(email);
    }

    public void accettaUtente(String email) throws FormatoDatiNonValidoException, UtenteNonTrovatoException, StatoUtenteNonValidoException, SQLException {
        if (email == null) {
            throw new FormatoDatiNonValidoException("Email null.");
        }
        Utente u = utenteDAO.doRetrieveByEmail(email);
        if (u == null) {
            throw new UtenteNonTrovatoException("Email non valida.");
        }
        if (!"in_attesa".equals(u.getStato())) {
            throw new StatoUtenteNonValidoException("L'utente non è In Attesa.");
        }
        u.setStato("attivo");
        utenteDAO.doUpdate(u);
    }

    public String recuperaDomanda(String email) throws UtenteNonTrovatoException, SQLException {
        Utente utente = utenteDAO.doRetrieveByEmail(email);
        if (utente == null) {
            throw new UtenteNonTrovatoException("Email non trovata.");
        }
        return utente.getDomandaSicurezza();
    }

    public void verificaRispostaSicurezza(String email, String risposta) throws UtenteNonTrovatoException, RispostaSicurezzaErrataException, SQLException {
        Utente utente = utenteDAO.doRetrieveByEmail(email);
        if (utente == null) {
            throw new UtenteNonTrovatoException("Email non trovata.");
        }
        if (!utente.getRispostaSicurezza().equalsIgnoreCase(risposta)) {
            throw new RispostaSicurezzaErrataException("Risposta di sicurezza errata.");
        }
    }

    public void resetPassword(String email, String rispostaSicurezza, String nuovaPassword, String confermaPassword) 
            throws UtenteNonTrovatoException, RispostaSicurezzaErrataException, FormatoPasswordNonValidoException, PasswordNonCorrispondentiException, SQLException {

        Utente utente = utenteDAO.doRetrieveByEmail(email);

        if (utente == null) {
            throw new UtenteNonTrovatoException("Email non trovata.");
        }
        if (!utente.getRispostaSicurezza().equalsIgnoreCase(rispostaSicurezza)) {
            throw new RispostaSicurezzaErrataException("Risposta di sicurezza errata.");
        }
        if (!isPasswordValida(nuovaPassword)) {
            throw new FormatoPasswordNonValidoException("La password non rispetta il formato richiesto.");
        }
        if (!nuovaPassword.equals(confermaPassword)) {
            throw new PasswordNonCorrispondentiException("I campi password e conferma password non corrispondono.");
        }

        String hashedPassword = BCrypt.hashpw(nuovaPassword, BCrypt.gensalt());
        utente.setPassword(hashedPassword);
        utenteDAO.doUpdate(utente);
    }

    private boolean isNomeValido(String testo) {
        if (testo == null) return false;
        return NOME_PATTERN.matcher(testo).matches();
    }

    private boolean isCodiceFiscaleValido(String cf) {
        if (cf == null) return false;
        return CF_PATTERN.matcher(cf.toUpperCase()).matches();
    }

    private boolean isEmailFormatoValido(String email) {
        if (email == null) return false;
        return email.contains("@") && email.contains(".");
    }

    private boolean isPasswordValida(String password) {
        if (password == null) return false;
        return PASS_PATTERN.matcher(password).matches();
    }
}