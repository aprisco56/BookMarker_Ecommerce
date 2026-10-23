<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Ordine" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String nomeUtente = (String) session.getAttribute("utenteLoggato");
    if (nomeUtente == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    List<Ordine> ordini = (List<Ordine>) request.getAttribute("listaOrdini");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>I Miei Ordini - BookMarker</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/admin.css">
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
            <span class="user-greeting">Ciao, <b><%= nomeUtente %></b></span>
            <a href="LogoutServlet" class="btn btn-logout">Logout</a>
        </nav>
    </header>

    <main class="cart-container">
        <h2 class="cart-title"><i class="fa-solid fa-box-open"></i> Storico Ordini</h2>

        <% if (ordini == null || ordini.isEmpty()) { %>
            <div class="empty-cart">
                <i class="fa-solid fa-receipt empty-cart-icon"></i>
                <h3>Non hai ancora effettuato nessun ordine!</h3>
                <p class="empty-cart-action">
                    <a href="LibriServlet" class="btn btn-primary">Inizia lo Shopping</a>
                </p>
            </div>
        <% } else { %>
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>N° Ordine</th>
                        <th>Data</th>
                        <th>Indirizzo di Spedizione</th>
                        <th>Metodo di Pagamento</th>
                        <th>Totale</th>
                        <th>Stato</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    for (Ordine o : ordini) { 
                        String badgeClass = "badge-elaborazione";
                        if ("Completato".equalsIgnoreCase(o.getStato())) badgeClass = "badge-completato";
                        else if ("Spedito".equalsIgnoreCase(o.getStato())) badgeClass = "badge-spedito";
                    %>
                    <tr>
                        <td><strong>#<%= o.getIdOrdine() %></strong></td>
                        <td><%= o.getDataOrdine() != null ? sdf.format(o.getDataOrdine()) : "" %></td>
                        <td><%= o.getIndirizzoSpedizione() %></td>
                        <td><%= o.getMetodoPagamento() %></td>
                        <td><strong class="text-green">€ <%= String.format("%.2f", o.getTotale()) %></strong></td>
                        <td><span class="badge <%= badgeClass %>"><%= o.getStato() %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </main>

</body>
</html>