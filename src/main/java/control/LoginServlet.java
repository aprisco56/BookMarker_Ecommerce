package control;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UtenteDAO;
import model.Utente;
import service.UtenteService;
import service.exception.UtenteServiceException.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UtenteDAO dao = new UtenteDAO();
        UtenteService service = new UtenteService(dao);

        try {
            Utente utenteTrovato = service.login(email, password);

            HttpSession session = request.getSession();
            
            session.setAttribute("utenteLoggato", utenteTrovato.getNome());
            session.setAttribute("emailUtente", utenteTrovato.getEmail());
            session.setAttribute("utenteObj", utenteTrovato);
            
            session.setMaxInactiveInterval(30 * 60);

            String ruoloDB = utenteTrovato.getRuolo();
            if (ruoloDB != null && ruoloDB.equalsIgnoreCase("ADMIN")) {
                session.setAttribute("ruoloUtente", "ADMIN");
                response.sendRedirect("GestioneCatalogoServlet");
            } else {
                session.setAttribute("ruoloUtente", "CLIENTE"); 
                response.sendRedirect("LibriServlet");
            }

        } catch (CredenzialiNonValideException | UtenteNonAbilitatoException e) {
            sendError(request, response, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            sendError(request, response, "Si è verificato un errore di sistema.");
        }
    }

    private void sendError(HttpServletRequest request, HttpServletResponse response, String message) throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/view/login.jsp");
        rd.forward(request, response);
    }
}