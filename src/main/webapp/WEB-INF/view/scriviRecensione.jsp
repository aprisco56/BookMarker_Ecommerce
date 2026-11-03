<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Libro" %>
<%
    String nomeUtente = (String) session.getAttribute("utenteLoggato");
    if (nomeUtente == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
    Libro libro = (Libro) request.getAttribute("libro");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scrivi Recensione - BookMarker</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <header>
        <div class="header-spacer"></div>
        <a href="index.jsp" class="logo-container"> 
            <img src="<%= request.getContextPath() %>/images/logo.png" alt="BookMarker Logo">
        </a>
        <nav class="nav-buttons">
            <a href="MieiOrdiniServlet" class="btn">Annulla</a>
            <span class="user-greeting">Ciao, <b><%= nomeUtente %></b></span>
        </nav>
    </header>

<main style="display: flex; justify-content: center; align-items: center; padding: 2rem;">
        <div style="background-color: white; padding: 30px; border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.2); width: 100%; max-width: 600px;">
            <h2 style="color: #333; margin-bottom: 5px;"><i class="fa-solid fa-pen-nib"></i> La tua recensione</h2>
            <h3 style="color: #267bbc; margin-top: 0; text-align: center; font-style: italic;"><%= libro != null ? libro.getTitolo() : "Libro sconosciuto" %></h3>

            <form action="ScriviRecensioneServlet" method="POST" style="display: flex; flex-direction: column; gap: 1.5rem; margin-top: 20px;">
                <input type="hidden" name="idLibro" value="<%= libro != null ? libro.getIdLibro() : "" %>">

                <div class="form-group">
                    <label for="voto" style="color: #555; font-weight: bold;">Valutazione:</label>
                    <select name="voto" id="voto" required style="padding: 12px; border-radius: 8px; border: 1px solid #ccc; font-size: 1rem; width: 100%; cursor: pointer;">
                        <option value="5">⭐⭐⭐⭐⭐ - 5 (Eccellente)</option>
                        <option value="4">⭐⭐⭐⭐ - 4 (Molto Buono)</option>
                        <option value="3">⭐⭐⭐ - 3 (Nella media)</option>
                        <option value="2">⭐⭐ - 2 (Poco entusiasmante)</option>
                        <option value="1">⭐ - 1 (Pessimo)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="testo" style="color: #555; font-weight: bold;">Cosa ne pensi?</label>
                    <textarea name="testo" id="testo" rows="6" required placeholder="Scrivi qui la tua opinione sul libro..." style="padding: 12px; border-radius: 8px; border: 1px solid #ccc; font-size: 1rem; resize: vertical; width: 100%; box-sizing: border-box; font-family: inherit;"></textarea>
                </div>

                <button type="submit" style="background-color: #27ae60; border: none; padding: 15px; border-radius: 8px; color: white; font-weight: bold; font-size: 1.1rem; cursor: pointer; transition: 0.3s; margin-top: 10px;">
                    <i class="fa-solid fa-paper-plane"></i> Pubblica Recensione
                </button>
            </form>
        </div>
    </main>

</body>
</html>