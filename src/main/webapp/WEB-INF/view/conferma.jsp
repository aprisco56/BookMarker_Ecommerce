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
        </nav>
    </header>

    <main class="success-container">
        <i class="fa-solid fa-circle-check success-icon"></i>
        <h1 class="success-title">Ordine Completato!</h1>
        <p class="success-message">
            Grazie per il tuo acquisto. Il tuo numero d'ordine è: <strong>#<%= idOrdine != null ? idOrdine : "Sconosciuto" %></strong>
        </p>
        <a href="LibriServlet" class="btn btn-continue-shopping">Continua lo Shopping</a>
    </main>
</body>
</html>