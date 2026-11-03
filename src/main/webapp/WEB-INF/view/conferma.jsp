<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String nomeUtente = (String) session.getAttribute("utenteLoggato");
    String idOrdine = request.getParameter("id");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ordine Completato - BookMarker</title>
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
            <a href="LibriServlet" class="btn">Torna al Catalogo</a>
            <% if (nomeUtente != null) { %>
                <span class="user-greeting">Ciao, <b><%= nomeUtente %></b></span>
            <% } %>
        </nav>
    </header>

    <main style="display: flex; justify-content: center; align-items: center; padding: 4rem 2rem;">
        <div style="background-color: white; padding: 40px 30px; border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.2); width: 100%; max-width: 500px; text-align: center; color: #333;">
            
            <i class="fa-solid fa-circle-check" style="color: #27ae60; font-size: 5rem; margin-bottom: 20px;"></i>
            
            <h2 style="color: #333; margin-top: 0; margin-bottom: 15px; font-size: 2.2rem;">Ordine Completato!</h2>
            
            <p style="font-size: 1.2rem; color: #555; margin-bottom: 5px;">Grazie per il tuo acquisto.</p>
            <p style="font-size: 1.1rem; color: #555; margin-bottom: 30px;">Il tuo numero d'ordine è: <strong style="color: #267bbc; font-size: 1.4rem;">#<%= idOrdine != null ? idOrdine : "" %></strong></p>
            
            <div style="display: flex; flex-direction: column; gap: 15px; align-items: center;">
                <a href="MieiOrdiniServlet" style="background-color: #267bbc; color: white; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: bold; width: 80%; transition: 0.3s;">
                    <i class="fa-solid fa-box-open"></i> I Miei Ordini
                </a>
                <a href="LibriServlet" style="background-color: #27ae60; color: white; padding: 12px 25px; text-decoration: none; border-radius: 8px; font-weight: bold; width: 80%; transition: 0.3s;">
                    <i class="fa-solid fa-cart-shopping"></i> Continua lo Shopping
                </a>
            </div>
        </div>
    </main>
</body>
</html>