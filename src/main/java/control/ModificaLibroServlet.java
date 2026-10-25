package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.LibroDAO;
import model.Libro;

@WebServlet("/ModificaLibroServlet")
public class ModificaLibroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String ruolo = (String) session.getAttribute("ruoloUtente");

        if (ruolo == null || !ruolo.equals("ADMIN")) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                LibroDAO dao = new LibroDAO();
                Libro libro = dao.doRetrieveById(id);
                
                if (libro != null) {
                    request.setAttribute("libroDaModificare", libro);
                    request.getRequestDispatcher("/WEB-INF/view/modificaLibro.jsp").forward(request, response);
                } else {
                    response.sendRedirect("GestioneCatalogoServlet");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("GestioneCatalogoServlet");
            }
        } else {
            response.sendRedirect("GestioneCatalogoServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String sessionToken = (String) request.getSession().getAttribute("csrfToken");
    	String requestToken = request.getParameter("csrfToken");

    	if (sessionToken == null || requestToken == null || !sessionToken.equals(requestToken)) {
    	    response.sendError(HttpServletResponse.SC_FORBIDDEN);
    	    return;
    	}
        HttpSession session = request.getSession();
        String ruolo = (String) session.getAttribute("ruoloUtente");

        if (ruolo == null || !ruolo.equals("ADMIN")) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String titolo = request.getParameter("titolo");
            String autore = request.getParameter("autore");
            double prezzo = Double.parseDouble(request.getParameter("prezzo"));
            int disponibilita = Integer.parseInt(request.getParameter("disponibilita"));
            String copertina = request.getParameter("copertina");

            if (copertina == null || copertina.trim().isEmpty()) {
                copertina = "default.jpg";
            }

            Libro libroAggiornato = new Libro();
            libroAggiornato.setIdLibro(id);
            libroAggiornato.setTitolo(titolo);
            libroAggiornato.setAutore(autore);
            libroAggiornato.setPrezzo(prezzo);
            libroAggiornato.setDisponibilita(disponibilita);
            libroAggiornato.setCopertina(copertina);

            LibroDAO dao = new LibroDAO();
            dao.doUpdate(libroAggiornato);

            response.sendRedirect("GestioneCatalogoServlet?msg=edit_success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("GestioneCatalogoServlet?errore=edit_fail");
        }
    }
}