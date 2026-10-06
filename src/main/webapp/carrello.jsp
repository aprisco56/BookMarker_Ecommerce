<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.DettaglioOrdine" %>
<%@ page import="model.Libro" %>

<%
    String nomeUtente = (String) session.getAttribute("utenteLoggato");
    if (nomeUtente == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<DettaglioOrdine> carrello = (List<DettaglioOrdine>) session.getAttribute("carrello");
    double totaleCarrello = 0.0;
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrello - BookMarker Store</title>
    <link rel="stylesheet" href="css/catalogo.css"> 
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .cart-container { max-width: 900px; margin: 40px auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .cart-table { width: 100%; border-collapse: collapse; }
        .cart-table th, .cart-table td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
        .cart-table th { background-color: #f8f9fa; color: #333; }
        .cart-item-img { width: 60px; height: 90px; object-fit: cover; border-radius: 4px; }
        .cart-total-container { text-align: right; margin-top: 20px; font-size: 1.5rem; }
        .btn-checkout { background-color: #27ae60; color: white; padding: 12px 25px; border: none; border-radius: 4px; font-size: 1.1rem; cursor: pointer; text-decoration: none; display: inline-block; margin-top: 15px; }
        .btn-remove { background-color: #c0392b; color: white; padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; }
        .empty-cart { text-align: center; padding: 50px; color: #777; }
    </style>
</head>
<body>

    <header>
        <div class="header-spacer"></div>
        <a href="index.jsp" class="logo-container"> 
            <img src="img/logo.png" alt="BookMarker Logo">
        </a>
        <nav class="nav-buttons">
            <a href="LibriServlet" class="btn">Continua lo Shopping</a>
            <span class="user-greeting">Ciao, <b><%= nomeUtente %></b></span>
            <a href="logout.jsp" class="btn" style="background-color: #c0392b; color: white;">Logout</a>
        </nav>
    </header>

    <main class="cart-container">
        <h2 style="color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-bottom: 20px;">Il tuo Carrello</h2>

        <% if (carrello == null || carrello.isEmpty()) { %>
            <div class="empty-cart">
                <i class="fa-solid fa-cart-arrow-down" style="font-size: 4rem; color: #ccc; margin-bottom: 15px;"></i>
                <h3>Il tuo carrello è vuoto!</h3>
                <p style="margin-top: 10px;">
                    <a href="LibriServlet" class="btn" style="background-color: #3498db; color: white;">Torna al Catalogo</a>
                </p>
            </div>
        <% } else { %>
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Prodotto</th>
                        <th>Dettagli</th>
                        <th>Prezzo</th>
                        <th>Quantità</th>
                        <th>Subtotale</th>
                        <th>Azione</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    for (DettaglioOrdine d : carrello) { 
                        Libro libro = d.getLibro();
                        double subtotale = d.getQuantita() * d.getPrezzoSingolo();
                        totaleCarrello += subtotale;
                    %>
                    <tr>
                        <td>
                            <% if (libro.getCopertina() != null && !libro.getCopertina().isEmpty()) { %>
                                <img src="<%= libro.getCopertina() %>" alt="Copertina" class="cart-item-img">
                            <% } else { %>
                                <i class="fa-regular fa-image" style="font-size: 2rem; color: #ccc;"></i>
                            <% } %>
                        </td>
                        <td>
                            <strong style="font-size: 1.1rem;"><%= libro.getTitolo() %></strong><br>
                            <small style="color: #777;"><%= libro.getAutore() %></small>
                        </td>
                        <td>€ <%= String.format("%.2f", d.getPrezzoSingolo()) %></td>
                        <td><strong><%= d.getQuantita() %></strong></td>
                        <td style="font-weight: bold; color: #27ae60;">€ <%= String.format("%.2f", subtotale) %></td>
                        <td>
                            <form action="CarrelloServlet" method="POST" style="margin: 0;">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="idLibro" value="<%= d.getIdLibro() %>">
                                <button type="submit" class="btn-remove" title="Rimuovi"><i class="fa-solid fa-trash"></i></button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="cart-total-container">
                <p style="color: #333; margin-bottom: 10px;">Totale: <strong style="color: #27ae60;">€ <%= String.format("%.2f", totaleCarrello) %></strong></p>
                <a href="CheckoutServlet" class="btn-checkout"><i class="fa-solid fa-credit-card"></i> Procedi all'Ordine</a>
            </div>
        <% } %>
    </main>
</body>
</html>