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
        <div style="background-color: white; padding: 30px; border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.2); max-width: 1000px; margin: 40px auto; width: 90%; color: #333;">
            <div class="cart-header-bar" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px;">
                <h2 class="cart-title" style="margin: 0; color: #333;">Il tuo Carrello</h2>
                <% if (carrello != null && !carrello.isEmpty()) { %>
                    <form action="CarrelloServlet" method="POST" class="form-inline">
                        <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                        <input type="hidden" name="action" value="clear">
                        <button type="submit" class="btn-clear-cart" style="background: #e74c3c; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer;">
                            <i class="fa-solid fa-trash-can"></i> Svuota Carrello
                        </button>
                    </form>
                <% } %>
            </div>

            <% if ("max_stock".equals(msg)) { %>
                <div class="error-cart-msg" style="color: #d32f2f; background-color: #fde0dc; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
                    <i class="fa-solid fa-circle-exclamation"></i> La quantità richiesta supera la disponibilità in magazzino. È stata impostata la quantità massima disponibile.
                </div>
            <% } %>

            <% if (carrello == null || carrello.isEmpty()) { %>
                <div class="empty-cart" style="text-align: center; padding: 40px 0;">
                    <i class="fa-solid fa-cart-arrow-down empty-cart-icon" style="font-size: 3rem; color: #ccc; margin-bottom: 15px;"></i>
                    <h3 style="color: #333;">Il tuo carrello è vuoto!</h3>
                    <p class="empty-cart-action" style="margin-top: 20px;">
                        <a href="LibriServlet" class="btn btn-primary" style="background-color: #27ae60; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">Torna al Catalogo</a>
                    </p>
                </div>
            <% } else { %>
                <table class="cart-table" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                            <th style="padding: 12px; text-align: left; color: #333;">Prodotto</th>
                            <th style="padding: 12px; text-align: left; color: #333;">Dettagli</th>
                            <th style="padding: 12px; text-align: left; color: #333;">Prezzo</th>
                            <th style="padding: 12px; text-align: center; color: #333;">Quantità</th>
                            <th style="padding: 12px; text-align: left; color: #333;">Subtotale</th>
                            <th style="padding: 12px; text-align: center; color: #333;">Rimuovi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        for (DettaglioOrdine d : carrello) { 
                            Libro libro = d.getLibro();
                            double subtotale = d.getQuantita() * d.getPrezzoSingolo();
                            totaleCarrello += subtotale;
                        %>
                        <tr style="border-bottom: 1px solid #dee2e6;">
                            <td style="padding: 12px;">
                                <% if (libro.getCopertina() != null && !libro.getCopertina().isEmpty()) { %>
                                    <img src="<%= request.getContextPath() %>/images/<%= libro.getCopertina() %>" alt="Copertina" class="cart-item-img" style="max-width: 60px; border-radius: 4px;">
                                <% } else { %>
                                    <i class="fa-regular fa-image cart-item-placeholder" style="font-size: 2rem; color: #ccc;"></i>
                                <% } %>
                            </td>
                            <td style="padding: 12px;">
                                <strong class="cart-item-title" style="color: #333;"><%= libro.getTitolo() %></strong><br>
                                <small class="cart-item-author" style="color: #666;"><%= libro.getAutore() %></small>
                            </td>
                            <td style="padding: 12px; color: #333;">€ <%= String.format("%.2f", d.getPrezzoSingolo()) %></td>
                            <td style="padding: 12px; text-align: center;">
                                <form action="CarrelloServlet" method="POST" class="cart-qty-form" style="display: flex; justify-content: center;">
                                    <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="idLibro" value="<%= d.getIdLibro() %>">
                                    <input type="number" name="quantita" value="<%= d.getQuantita() %>" min="1" max="<%= libro.getDisponibilita() %>" class="cart-qty-input" required style="width: 60px; padding: 5px; text-align: center; border: 1px solid #ccc; border-radius: 4px;">
                                </form>
                            </td>
                            <td class="cart-item-subtotal" style="padding: 12px; font-weight: bold; color: #27ae60;">€ <%= String.format("%.2f", subtotale) %></td>
                            <td style="padding: 12px; text-align: center;">
                                <form action="CarrelloServlet" method="POST" class="form-inline">
                                    <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="idLibro" value="<%= d.getIdLibro() %>">
                                    <button type="submit" class="btn-remove" title="Rimuovi" style="background: none; border: none; color: #e74c3c; cursor: pointer; font-size: 1.2rem;"><i class="fa-solid fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <div class="cart-total-container" style="display: flex; justify-content: space-between; align-items: center; margin-top: 30px; padding-top: 20px; border-top: 2px solid #eee;">
                    <p class="cart-total-text" style="font-size: 1.2rem; color: #333; margin: 0;">Totale: <strong class="cart-total-amount" style="font-size: 1.5rem; color: #27ae60;">€ <%= String.format("%.2f", totaleCarrello) %></strong></p>
                    <% if (isLoggato) { %>
                        <a href="CheckoutServlet" class="btn-checkout" style="background-color: #27ae60; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold;"><i class="fa-solid fa-credit-card"></i> Procedi all'Ordine</a>
                    <% } else { %>
                        <a href="LoginServlet" class="btn-checkout" style="background-color: #267bbc; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold;"><i class="fa-solid fa-lock"></i> Accedi per Completare l'Ordine</a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>

<script src="<%= request.getContextPath() %>/scripts/carrello.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>