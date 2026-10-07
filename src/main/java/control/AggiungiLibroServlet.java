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

@WebServlet("/AggiungiLibroServlet")
public class AggiungiLibroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String ruolo = (String) session.getAttribute("ruoloUtente");

        if (ruolo == null || !ruolo.equals("ADMIN")) {
            response.sendRedirect("LoginServlet");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/view/aggiungiLibro.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String ruolo = (String) session.getAttribute("ruoloUtente");

        if (ruolo == null || !ruolo.equals("ADMIN")) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            String titolo = request.getParameter("titolo");
            String autore = request.getParameter("autore");
            double prezzo = Double.parseDouble(request.getParameter("prezzo"));
            int disponibilita = Integer.parseInt(request.getParameter("disponibilita"));
            String copertina = request.getParameter("copertina");

            if (copertina == null || copertina.trim().isEmpty()) {
                copertina = "default.jpg";
            }

            Libro nuovoLibro = new Libro();
            nuovoLibro.setTitolo(titolo);
            nuovoLibro.setAutore(autore);
            nuovoLibro.setPrezzo(prezzo);
            nuovoLibro.setDisponibilita(disponibilita);
            nuovoLibro.setCopertina(copertina);

            LibroDAO dao = new LibroDAO();
            dao.doSave(nuovoLibro);

            response.sendRedirect("GestioneCatalogoServlet?msg=add_success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore nell'inserimento. Controlla i formati di prezzo e disponibilità.");
            request.getRequestDispatcher("/WEB-INF/view/aggiungiLibro.jsp").forward(request, response);
        }
    }
}