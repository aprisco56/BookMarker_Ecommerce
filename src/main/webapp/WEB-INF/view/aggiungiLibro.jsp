<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
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
    <title>Aggiungi Libro</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css">
    <style>
        .form-container { max-width: 600px; margin: 40px auto; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn-submit { background-color: #27ae60; color: white; padding: 10px 15px; border: none; border-radius: 5px; cursor: pointer; font-size: 1rem; width: 100%; }
        .error-msg { color: #e74c3c; margin-bottom: 15px; }
    </style>
</head>
<body>
    <header>
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