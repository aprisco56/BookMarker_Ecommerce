<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.DettaglioOrdine" %>
<%@ page import="model.Libro" %>

<%
    if (session.getAttribute("csrfToken") == null) {
        session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    }

    String nomeUtente = (String) session.getAttribute("utenteLoggato");
    boolean isLoggato = (nomeUtente != null);
    
    List<DettaglioOrdine> carrello = (List<DettaglioOrdine>) session.getAttribute("carrello");
    double totaleCarrello = 0.0;
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrello - BookMarker Store</title>
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
            <a href="LibriServlet" class="btn">Continua lo Shopping</a>
            <% if (isLoggato) { %>
                <span class="user-greeting">Ciao, <b><%= nomeUtente %></b></span>
                <a href="MieiOrdiniServlet" class="btn">I Miei Ordini</a>
                <a href="LogoutServlet" class="btn btn-logout">Logout</a>
            <% } else { %>
                <a href="RegistrazioneServlet" class="btn">Registrati</a>
                <a href="LoginServlet" class="btn">Login</a>
            <% } %>
        </nav>
    </header>

    <main class="cart-container">
        <div class="cart-header-bar">
            <h2 class="cart-title">Il tuo Carrello</h2>
            <% if (carrello != null && !carrello.isEmpty()) { %>
                <form action="CarrelloServlet" method="POST" class="form-inline">
                    <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="btn-clear-cart">
                        <i class="fa-solid fa-trash-can"></i> Svuota Carrello
                    </button>
                </form>
            <% } %>
        </div>

        <% if ("max_stock".equals(msg)) { %>
            <div class="error-cart-msg">
                <i class="fa-solid fa-circle-exclamation"></i> La quantità richiesta supera la disponibilità in magazzino. È stata impostata la quantità massima disponibile.
            </div>
        <% } %>

        <% if (carrello == null || carrello.isEmpty()) { %>
            <div class="empty-cart">
                <i class="fa-solid fa-cart-arrow-down empty-cart-icon"></i>
                <h3>Il tuo carrello è vuoto!</h3>
                <p class="empty-cart-action">
                    <a href="LibriServlet" class="btn btn-primary">Torna al Catalogo</a>
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
                        <th>Rimuovi</th>
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
                                <img src="<%= request.getContextPath() %>/images/<%= libro.getCopertina() %>" alt="Copertina" class="cart-item-img">
                            <% } else { %>
                                <i class="fa-regular fa-image cart-item-placeholder"></i>
                            <% } %>
                        </td>
                        <td>
                            <strong class="cart-item-title"><%= libro.getTitolo() %></strong><br>
                            <small class="cart-item-author"><%= libro.getAutore() %></small>
                        </td>
                        <td>€ <%= String.format("%.2f", d.getPrezzoSingolo()) %></td>
                        <td>
                            <form action="CarrelloServlet" method="POST" class="cart-qty-form">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="idLibro" value="<%= d.getIdLibro() %>">
                                <input type="number" name="quantita" value="<%= d.getQuantita() %>" min="1" max="<%= libro.getDisponibilita() %>" class="cart-qty-input" required>
                            </form>
                        </td>
                        <td class="cart-item-subtotal">€ <%= String.format("%.2f", subtotale) %></td>
                        <td>
                            <form action="CarrelloServlet" method="POST" class="form-inline">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
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
                <p class="cart-total-text">Totale: <strong class="cart-total-amount">€ <%= String.format("%.2f", totaleCarrello) %></strong></p>
                <% if (isLoggato) { %>
                    <a href="CheckoutServlet" class="btn-checkout"><i class="fa-solid fa-credit-card"></i> Procedi all'Ordine</a>
                <% } else { %>
                    <a href="LoginServlet" class="btn-checkout"><i class="fa-solid fa-lock"></i> Accedi per Completare l'Ordine</a>
                <% } %>
            </div>
        <% } %>
    </main>

<script src="<%= request.getContextPath() %>/scripts/carrello.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>