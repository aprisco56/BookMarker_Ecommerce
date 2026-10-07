package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dao.LibroDAO;
import model.DettaglioOrdine;
import model.Libro;

@WebServlet("/CarrelloServlet")
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LibroDAO libroDAO;

    public void init() {
        libroDAO = new LibroDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String emailUtente = (String) session.getAttribute("emailUtente");

        if (emailUtente == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        List<DettaglioOrdine> carrello = (List<DettaglioOrdine>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new ArrayList<>();
            session.setAttribute("carrello", carrello);
        }

        request.getRequestDispatcher("/WEB-INF/view/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String emailUtente = (String) session.getAttribute("emailUtente");

        if (emailUtente == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String action = request.getParameter("action");
        List<DettaglioOrdine> carrello = (List<DettaglioOrdine>) session.getAttribute("carrello");

        if (carrello == null) {
            carrello = new ArrayList<>();
            session.setAttribute("carrello", carrello);
        }

        if ("add".equals(action)) {
            try {
                int idLibro = Integer.parseInt(request.getParameter("idLibro"));
                Libro libro = libroDAO.doRetrieveById(idLibro);

                if (libro != null && libro.getDisponibilita() > 0) {
                    boolean trovato = false;
                    for (DettaglioOrdine d : carrello) {
                        if (d.getIdLibro() == idLibro) {
                            if (d.getQuantita() < libro.getDisponibilita()) {
                                d.setQuantita(d.getQuantita() + 1);
                            }
                            trovato = true;
                            break;
                        }
                    }

                    if (!trovato) {
                        DettaglioOrdine nuovoDettaglio = new DettaglioOrdine();
                        nuovoDettaglio.setIdLibro(libro.getIdLibro());
                        nuovoDettaglio.setLibro(libro);
                        nuovoDettaglio.setQuantita(1);
                        nuovoDettaglio.setPrezzoSingolo(libro.getPrezzo());
                        carrello.add(nuovoDettaglio);
                    }
                }
                response.sendRedirect("DettaglioLibroServlet?id=" + idLibro + "&msg=add_cart_ok");
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("LibriServlet");
            }
        } else if ("remove".equals(action)) {
            try {
                int idLibro = Integer.parseInt(request.getParameter("idLibro"));
                carrello.removeIf(d -> d.getIdLibro() == idLibro);
                response.sendRedirect("CarrelloServlet");
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("CarrelloServlet");
            }
        } else {
            response.sendRedirect("CarrelloServlet");
        }
    }
}