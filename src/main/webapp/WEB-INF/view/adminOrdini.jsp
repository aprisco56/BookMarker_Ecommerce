<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Ordine" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String ruolo = (String) session.getAttribute("ruoloUtente");
    if (ruolo == null || !ruolo.equals("ADMIN")) {
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
    <title>Gestione Ordini - Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
    <header>
        <div class="header-spacer"></div>
        <a href="GestioneCatalogoServlet" class="logo-container">
            <img src="<%= request.getContextPath() %>/images/logo.png" alt="BookMarker Logo">
        </a>
        <nav class="nav-buttons">
            <a href="GestioneCatalogoServlet" class="btn">Catalogo Admin</a>
            <a href="LogoutServlet" class="btn btn-logout-admin">Logout</a>
        </nav>
    </header>

    <main class="admin-container">
        <h2><i class="fa-solid fa-box-open"></i> Gestione Ordini Globali</h2>

        <form action="GestioneOrdiniServlet" method="GET" class="filter-section">
            <div>
                <label for="emailCliente">Email Cliente:</label>
                <input type="text" id="emailCliente" name="emailCliente" value="<%= request.getAttribute("emailCliente") != null ? request.getAttribute("emailCliente") : "" %>" placeholder="Cerca email...">
            </div>
            <div>
                <label for="dataDa">Da data:</label>
                <input type="date" id="dataDa" name="dataDa" value="<%= request.getAttribute("dataDa") != null ? request.getAttribute("dataDa") : "" %>">
            </div>
            <div>
                <label for="dataA">A data:</label>
                <input type="date" id="dataA" name="dataA" value="<%= request.getAttribute("dataA") != null ? request.getAttribute("dataA") : "" %>">
            </div>
            <button type="submit" class="btn-filter"><i class="fa-solid fa-filter"></i> Filtra</button>
            <a href="GestioneOrdiniServlet" class="btn btn-reset-admin">Reset</a>
        </form>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID Ordine</th>
                    <th>Data</th>
                    <th>Cliente</th>
                    <th>Spedizione</th>
                    <th>Metodo</th>
                    <th>Totale</th>
                    <th>Stato</th>
                </tr>
            </thead>
            <tbody>
                <% if (ordini != null && !ordini.isEmpty()) { 
                    for (Ordine o : ordini) { 
                        String badgeClass = "badge-elaborazione";
                        if ("Completato".equalsIgnoreCase(o.getStato())) badgeClass = "badge-completato";
                        else if ("Spedito".equalsIgnoreCase(o.getStato())) badgeClass = "badge-spedito";
                %>
                <tr>
                    <td>#<%= o.getIdOrdine() %></td>
                    <td><%= o.getDataOrdine() != null ? sdf.format(o.getDataOrdine()) : "" %></td>
                    <td><%= o.getUtenteEmail() %></td>
                    <td><%= o.getIndirizzoSpedizione() %></td>
                    <td><%= o.getMetodoPagamento() %></td>
                    <td><strong>€ <%= String.format("%.2f", o.getTotale()) %></strong></td>
                    <td><span class="badge <%= badgeClass %>"><%= o.getStato() %></span></td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="7" class="text-center">Nessun ordine trovato con i filtri attuali.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </main>
</body>
</html>