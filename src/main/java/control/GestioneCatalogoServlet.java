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

import dao.LibroDAO;
import model.Libro;
import service.LibroService;

@WebServlet("/GestioneCatalogoServlet")
public class GestioneCatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String ruolo = (String) session.getAttribute("ruoloUtente");

        if (ruolo == null || !ruolo.equals("ADMIN")) {
            response.sendRedirect("LibriServlet");
            return;
        }

        LibroDAO dao = new LibroDAO();
        LibroService service = new LibroService(dao);

        try {
            List<Libro> catalogo = service.getCatalogoCompleto();
            request.setAttribute("catalogo", catalogo);
            request.getRequestDispatcher("/WEB-INF/view/adminCatalogo.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("LibriServlet?errore=db");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}