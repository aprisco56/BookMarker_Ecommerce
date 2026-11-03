package control;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.OrdineDAO;
import model.Ordine;

@WebServlet("/GestioneOrdiniServlet")
public class GestioneOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String ruolo = (String) session.getAttribute("ruoloUtente");

        if (ruolo == null || !ruolo.equals("ADMIN")) {
            response.sendRedirect("LoginServlet");
            return;
        }

        String emailFiltro = request.getParameter("emailCliente");
        String dataDa = request.getParameter("dataDa");
        String dataA = request.getParameter("dataA");

        OrdineDAO dao = new OrdineDAO();
        try {
            List<Ordine> ordini = dao.doRetrieveByFiltri(emailFiltro, dataDa, dataA);
            request.setAttribute("listaOrdini", ordini);
            request.setAttribute("emailCliente", emailFiltro);
            request.setAttribute("dataDa", dataDa);
            request.setAttribute("dataA", dataA);
            
            request.getRequestDispatcher("/WEB-INF/view/adminOrdini.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("GestioneCatalogoServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}