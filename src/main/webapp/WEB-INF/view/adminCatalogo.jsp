<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Libro" %>
<%
    String ruolo = (String) session.getAttribute("ruoloUtente");
    if (ruolo == null || !ruolo.equals("ADMIN")) {
        response.sendRedirect("LoginServlet");
        return;
    }
    List<Libro> catalogo = (List<Libro>) request.getAttribute("catalogo");
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
            <img src="<%= request.getContextPath() %>/images/logo.png" alt="BookMarker Logo">
        </a>
        <nav class="nav-buttons">
            <a href="LibriServlet" class="btn">Vista Cliente</a>
            <a href="LogoutServlet" class="btn btn-logout-admin">Logout</a>
        </nav>
    </header>

    <main class="admin-container">
        <div class="action-header">
            <h2><i class="fa-solid fa-gears"></i> Pannello di Amministrazione - Catalogo</h2>
            <div>
                <a href="GestioneOrdiniServlet" class="btn-add btn-ordini"><i class="fa-solid fa-box-open"></i> Visualizza Ordini</a>
                <a href="AggiungiLibroServlet" class="btn-add"><i class="fa-solid fa-plus"></i> Aggiungi Nuovo Libro</a>
            </div>
        </div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Copertina</th>
                    <th>Titolo</th>
                    <th>Autore</th>
                    <th>Prezzo</th>
                    <th>Disp.</th>
                    <th>Azioni</th>
                </tr>
            </thead>
            <tbody>
                <% if (catalogo != null) { 
                    for (Libro l : catalogo) { 
                        boolean hasImg = (l.getCopertina() != null && !l.getCopertina().trim().isEmpty());
                %>
                <tr>
                    <td><%= l.getIdLibro() %></td>
                    <td>
                        <% if (hasImg) { %>
                            <img src="<%= request.getContextPath() %>/images/<%= l.getCopertina() %>" alt="Cover" class="admin-table-img">
                        <% } else { %>
                            <i class="fa-regular fa-image cart-item-placeholder"></i>
                        <% } %>
                    </td>
                    <td><strong><%= l.getTitolo() %></strong></td>
                    <td><%= l.getAutore() %></td>
                    <td>€ <%= String.format("%.2f", l.getPrezzo()) %></td>
                    <td><%= l.getDisponibilita() %></td>
                    <td>
                        <a href="ModificaLibroServlet?id=<%= l.getIdLibro() %>" class="btn-action btn-edit"><i class="fa-solid fa-pen"></i></a>
                        <a href="RimuoviLibroServlet?id=<%= l.getIdLibro() %>" class="btn-action btn-delete"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </main>

    <script src="<%= request.getContextPath() %>/scripts/admin.js"></script>
</body>
</html>