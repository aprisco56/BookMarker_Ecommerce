package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.LibroDAO;
import dao.RecensioneDAO;
import model.Libro;
import model.Recensione;
import service.LibroService;
import service.RecensioneService;

@WebServlet("/DettaglioLibroServlet")
public class DettaglioLibroServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                
                LibroDAO libriDao = new LibroDAO();
                RecensioneDAO recDao = new RecensioneDAO();
                
                LibroService libroService = new LibroService(libriDao);
                RecensioneService recService = new RecensioneService(recDao);

                Libro libro = libroService.getDettaglioLibro(id);
                List<Recensione> recensioni = recService.getRecensioniPubbliche(id);
                
                request.setAttribute("libroDettaglio", libro);
                request.setAttribute("listaRecensioni", recensioni);
                
                request.getRequestDispatcher("/WEB-INF/view/dettaglioLibro.jsp").forward(request, response);
                
            } catch (Exception e) {

                e.printStackTrace();
                response.sendRedirect("LibriServlet");
            }
        } else {
            response.sendRedirect("LibriServlet");
        }
    }
}