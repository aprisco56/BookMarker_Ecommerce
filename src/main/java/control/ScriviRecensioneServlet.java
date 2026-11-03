package control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.LibroDAO;
import dao.RecensioneDAO;
import model.Libro;
import model.Recensione;

@WebServlet("/ScriviRecensioneServlet")
public class ScriviRecensioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String emailUtente = (String) session.getAttribute("emailUtente");

        if (emailUtente == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        int idLibro = Integer.parseInt(request.getParameter("idLibro"));
        RecensioneDAO recensioneDAO = new RecensioneDAO();
        LibroDAO libroDAO = new LibroDAO();

        try {
            Recensione esistente = recensioneDAO.doRetrieveByUtenteAndLibro(emailUtente, idLibro);
            if (esistente != null) {
                response.sendRedirect("MieiOrdiniServlet?msg=gia_recensito");
                return;
            }

            Libro libro = libroDAO.doRetrieveById(idLibro);
            request.setAttribute("libro", libro);
            request.getRequestDispatcher("/WEB-INF/view/scriviRecensione.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("MieiOrdiniServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String emailUtente = (String) session.getAttribute("emailUtente");

        if (emailUtente == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        int idLibro = Integer.parseInt(request.getParameter("idLibro"));
        int voto = Integer.parseInt(request.getParameter("voto"));
        String testo = request.getParameter("testo");

        Recensione r = new Recensione();
        r.setEmailUtente(emailUtente);
        r.setIdLibro(idLibro);
        r.setVoto(voto);
        r.setTesto(testo);
        r.setAttivo(true);  
        r.setNascosto(false); 

        RecensioneDAO recensioneDAO = new RecensioneDAO();
        try {
            recensioneDAO.doSave(r); 
            response.sendRedirect("MieiOrdiniServlet?msg=recensione_ok");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("MieiOrdiniServlet?msg=errore");
        }
    }
}