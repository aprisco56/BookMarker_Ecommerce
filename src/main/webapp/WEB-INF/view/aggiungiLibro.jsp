<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("csrfToken") == null) {
        session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    }

    String ruolo = (String) session.getAttribute("ruoloUtente");
    if (ruolo == null || !ruolo.equals("ADMIN")) {
        response.sendRedirect("LoginServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Catalogo - Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
 <header>
    <div class="header-spacer"></div>
    <a href="GestioneCatalogoServlet" class="logo-container">
        <img src="<%= request.getContextPath() %>/images/logo.png" alt="Logo">
    </a>
    <nav class="nav-buttons">
        <a href="GestioneCatalogoServlet" class="btn">Indietro</a>
    </nav>
</header>
    <main class="form-container">
        <h2>Aggiungi Nuovo Libro</h2>
        
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error-msg"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <form action="AggiungiLibroServlet" method="POST">
            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
            
            <div class="form-group">
                <label for="titolo">Titolo *</label>
                <input type="text" id="titolo" name="titolo" required>
            </div>
            
            <div class="form-group">
                <label for="autore">Autore *</label>
                <input type="text" id="autore" name="autore" required>
            </div>
            
            <div class="form-group">
                <label for="prezzo">Prezzo (€) *</label>
                <input type="number" id="prezzo" name="prezzo" step="0.01" min="0" required>
            </div>
            
            <div class="form-group">
                <label for="disponibilita">Quantità Disponibile *</label>
                <input type="number" id="disponibilita" name="disponibilita" min="0" required>
            </div>
            
            <div class="form-group">
                <label for="copertina">Nome file copertina (es. book1.jpg)</label>
                <input type="text" id="copertina" name="copertina">
            </div>
            
            <button type="submit" class="btn-submit">Salva Libro</button>
        </form>
    </main>
</body>
</html>