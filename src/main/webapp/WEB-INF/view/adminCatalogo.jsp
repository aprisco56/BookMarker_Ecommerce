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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .admin-container { max-width: 1200px; margin: 40px auto; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .admin-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .admin-table th, .admin-table td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; vertical-align: middle; }
        .admin-table th { background-color: #2c3e50; color: white; }
        .btn-action { padding: 8px 12px; border-radius: 4px; color: white; text-decoration: none; font-size: 0.9rem; margin-right: 5px; }
        .btn-edit { background-color: #f39c12; }
        .btn-delete { background-color: #e74c3c; }
        .btn-add { background-color: #27ae60; padding: 10px 15px; text-decoration: none; color: white; border-radius: 5px; font-weight: bold; }
        .action-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    </style>
</head>
<body>
    <header>
        <div class="header-spacer"></div>
        <a href="GestioneCatalogoServlet" class="logo-container">
            <img src="<%= request.getContextPath() %>/images/logo.png" alt="BookMarker Logo">
        </a>
        <nav class="nav-buttons">
            <a href="LibriServlet" class="btn">Vista Cliente</a>
            <a href="LogoutServlet" class="btn" style="background-color: #c0392b; color: white;">Logout</a>
        </nav>
    </header>

    <main class="admin-container">
        <div class="action-header">
            <h2><i class="fa-solid fa-gears"></i> Pannello di Amministrazione - Catalogo</h2>
            <a href="AggiungiLibroServlet" class="btn-add"><i class="fa-solid fa-plus"></i> Aggiungi Nuovo Libro</a>
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
                    for (Libro l : catalogo) { %>
                <tr>
                    <td><%= l.getIdLibro() %></td>
                    <td><img src="<%= request.getContextPath() %>/images/<%= l.getCopertina() %>" alt="Cover" style="width: 40px; height: auto;"></td>
                    <td><strong><%= l.getTitolo() %></strong></td>
                    <td><%= l.getAutore() %></td>
                    <td>€ <%= String.format("%.2f", l.getPrezzo()) %></td>
                    <td><%= l.getDisponibilita() %></td>
                    <td>
                        <a href="ModificaLibroServlet?id=<%= l.getIdLibro() %>" class="btn-action btn-edit"><i class="fa-solid fa-pen"></i></a>
                        <a href="RimuoviLibroServlet?id=<%= l.getIdLibro() %>" class="btn-action btn-delete" onclick="return confirm('Sei sicuro di voler eliminare questo libro?');"><i class="fa-solid fa-trash"></i></a>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
    </main>
</body>
</html>