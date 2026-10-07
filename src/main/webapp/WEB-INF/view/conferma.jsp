<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String idOrdine = request.getParameter("id");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ordine Confermato</title>
    <link rel="stylesheet" href="styles/catalogo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .success-container { max-width: 600px; margin: 80px auto; text-align: center; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <header>
        <div class="header-spacer"></div>
        <a href="index.jsp" class="logo-container">
            <img src="images/logo.png" alt="BookMarker Logo">
        </a>
        <nav class="nav-buttons">
            <a href="LibriServlet" class="btn">Torna al Catalogo</a>
        </nav>
    </header>

    <main class="success-container">
        <i class="fa-solid fa-circle-check" style="font-size: 5rem; color: #27ae60; margin-bottom: 20px;"></i>
        <h1 style="color: #2c3e50; margin-bottom: 10px;">Ordine Completato!</h1>
        <p style="font-size: 1.1rem; color: #555; margin-bottom: 20px;">
            Grazie per il tuo acquisto. Il tuo numero d'ordine è: <strong>#<%= idOrdine != null ? idOrdine : "Sconosciuto" %></strong>
        </p>
        <a href="LibriServlet" class="btn" style="background-color: #3498db; color: white; padding: 12px 25px; font-size: 1.1rem;">Continua lo Shopping</a>
    </main>
</body>
</html>