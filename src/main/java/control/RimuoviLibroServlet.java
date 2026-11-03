package control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.LibroDAO;

@WebServlet("/RimuoviLibroServlet")
public class RimuoviLibroServlet extends HttpServlet {
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
                dao.doDelete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect("GestioneCatalogoServlet?msg=delete_success");
    }
}