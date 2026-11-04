package control;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.DBUtil;

@WebServlet("/VerificaEmailServlet")
public class VerificaEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        boolean esiste = false;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT email FROM utenti WHERE email = ?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    esiste = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (esiste) {
            response.getWriter().write("{\"occupata\": true}");
        } else {
            response.getWriter().write("{\"occupata\": false}");
        }
    }
}