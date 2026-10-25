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

        List<DettaglioOrdine> carrello = (List<DettaglioOrdine>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new ArrayList<>();
            session.setAttribute("carrello", carrello);
        }

        request.getRequestDispatcher("/WEB-INF/view/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String sessionToken = (String) request.getSession().getAttribute("csrfToken");
    	String requestToken = request.getParameter("csrfToken");

    	if (sessionToken == null || requestToken == null || !sessionToken.equals(requestToken)) {
    	    response.sendError(HttpServletResponse.SC_FORBIDDEN);
    	    return;
    	}
        HttpSession session = request.getSession();

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
                boolean aggiunto = false;

                if (libro != null && libro.getDisponibilita() > 0) {
                    boolean trovato = false;
                    for (DettaglioOrdine d : carrello) {
                        if (d.getIdLibro() == idLibro) {
                            if (d.getQuantita() < libro.getDisponibilita()) {
                                d.setQuantita(d.getQuantita() + 1);
                                aggiunto = true;
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
                        aggiunto = true;
                    }
                }

                if (aggiunto) {
                    response.sendRedirect("DettaglioLibroServlet?id=" + idLibro + "&msg=add_cart_ok");
                } else {
                    response.sendRedirect("DettaglioLibroServlet?id=" + idLibro + "&msg=add_cart_err");
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("LibriServlet");
            }
        } else if ("update".equals(action)) {
            try {
                int idLibro = Integer.parseInt(request.getParameter("idLibro"));
                int nuovaQuantita = Integer.parseInt(request.getParameter("quantita"));

                if (nuovaQuantita <= 0) {
                    carrello.removeIf(d -> d.getIdLibro() == idLibro);
                    response.sendRedirect("CarrelloServlet");
                    return;
                }

                Libro libro = libroDAO.doRetrieveById(idLibro);
                if (libro != null) {
                    for (DettaglioOrdine d : carrello) {
                        if (d.getIdLibro() == idLibro) {
                            if (nuovaQuantita <= libro.getDisponibilita()) {
                                d.setQuantita(nuovaQuantita);
                                response.sendRedirect("CarrelloServlet");
                            } else {
                                d.setQuantita(libro.getDisponibilita());
                                response.sendRedirect("CarrelloServlet?msg=max_stock");
                            }
                            return;
                        }
                    }
                }
                response.sendRedirect("CarrelloServlet");
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("CarrelloServlet");
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
        } else if ("clear".equals(action)) {
            carrello.clear();
            response.sendRedirect("CarrelloServlet");
        } else {
            response.sendRedirect("CarrelloServlet");
        }
    }
}