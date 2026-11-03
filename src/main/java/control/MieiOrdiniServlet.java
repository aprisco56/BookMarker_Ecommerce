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

import dao.OrdineDAO;
import model.Ordine;

@WebServlet("/MieiOrdiniServlet")
public class MieiOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String emailUtente = (String) session.getAttribute("emailUtente");

        if (emailUtente == null) {
            response.sendRedirect("LoginServlet");
            return;
        }

        OrdineDAO ordineDAO = new OrdineDAO();
        try {
            List<Ordine> mieiOrdini = ordineDAO.doRetrieveAllByEmail(emailUtente);
            request.setAttribute("listaOrdini", mieiOrdini);
            request.getRequestDispatcher("/WEB-INF/view/mieiOrdini.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("LibriServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}