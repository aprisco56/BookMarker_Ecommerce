package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.LibroDAO;
import model.Libro;
import service.LibroService;

@WebServlet("/LibriServlet")
public class LibriServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LibroDAO dao = new LibroDAO();
        LibroService service = new LibroService(dao);

        try {
            List<Libro> libriTrovati = service.getCatalogoCompleto();
            request.setAttribute("elencoLibri", libriTrovati);
            request.getRequestDispatcher("catalogo.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore durante il caricamento del catalogo.");
            request.getRequestDispatcher("catalogo.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}