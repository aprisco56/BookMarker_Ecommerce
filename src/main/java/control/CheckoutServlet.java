package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.DettaglioOrdineDAO;
import dao.LibroDAO;
import dao.OrdineDAO;
import model.DettaglioOrdine;
import model.Libro;
import model.Ordine;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrdineDAO ordineDAO;
    private DettaglioOrdineDAO dettaglioDAO;
    private LibroDAO libroDAO;

    public void init() {
        ordineDAO = new OrdineDAO();
        dettaglioDAO = new DettaglioOrdineDAO();
        libroDAO = new LibroDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("emailUtente") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        List<DettaglioOrdine> carrello = (List<DettaglioOrdine>) session.getAttribute("carrello");
        if (carrello == null || carrello.isEmpty()) {
            response.sendRedirect("CarrelloServlet");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String emailUtente = (String) session.getAttribute("emailUtente");

        if (emailUtente == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        List<DettaglioOrdine> carrello = (List<DettaglioOrdine>) session.getAttribute("carrello");
        if (carrello == null || carrello.isEmpty()) {
            response.sendRedirect("CarrelloServlet");
            return;
        }

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String via = request.getParameter("via");
        String citta = request.getParameter("citta");
        String cap = request.getParameter("cap");
        String provincia = request.getParameter("provincia");
        String pagamento = request.getParameter("pagamento");

        
        String indirizzoCompleto = nome + " " + cognome + " - " + via + ", " + cap + " " + citta + " (" + provincia.toUpperCase() + ")";

        double totale = 0;
        for (DettaglioOrdine d : carrello) {
            totale += (d.getPrezzoSingolo() * d.getQuantita());
        }

        Ordine ordine = new Ordine();
        ordine.setUtenteEmail(emailUtente);
        ordine.setTotale(totale);
        ordine.setIndirizzoSpedizione(indirizzoCompleto); 
        ordine.setMetodoPagamento(pagamento);
        ordine.setStato("Completato");

        try {
            int idOrdine = ordineDAO.doSave(ordine);

            for (DettaglioOrdine d : carrello) {
                d.setIdOrdine(idOrdine);
                dettaglioDAO.doSave(d);

                Libro libro = libroDAO.doRetrieveById(d.getIdLibro());
                if (libro != null) {
                    int nuovaDisponibilita = libro.getDisponibilita() - d.getQuantita();
                    if (nuovaDisponibilita < 0) nuovaDisponibilita = 0;
                    libro.setDisponibilita(nuovaDisponibilita);
                    libroDAO.doUpdate(libro);
                }
            }

           
            session.removeAttribute("carrello");
           
            response.sendRedirect("ConfermaServlet?id=" + idOrdine);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("CarrelloServlet?errore=db");
        }
    }
}