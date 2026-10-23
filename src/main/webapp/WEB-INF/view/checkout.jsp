<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.DettaglioOrdine" %>
<%
    if (session.getAttribute("csrfToken") == null) {
        session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    }

    String nomeUtente = (String) session.getAttribute("utenteLoggato");
    if (nomeUtente == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<DettaglioOrdine> carrello = (List<DettaglioOrdine>) session.getAttribute("carrello");
    if (carrello == null || carrello.isEmpty()) {
        response.sendRedirect("CarrelloServlet");
        return;
    }

    double totale = 0;
    for (DettaglioOrdine d : carrello) {
        totale += (d.getPrezzoSingolo() * d.getQuantita());
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - BookMarker Store</title>
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
            <a href="CarrelloServlet" class="btn">Torna al Carrello</a>
        </nav>
    </header>

    <main class="checkout-container">
        <div class="checkout-total-box">
            <h2 class="checkout-total-label">Totale da pagare:</h2>
            <span class="checkout-total-amount">€ <%= String.format("%.2f", totale) %></span>
        </div>

        <h3 class="section-title"><i class="fa-solid fa-truck-fast"></i> Dettagli Spedizione</h3>

        <form action="CheckoutServlet" method="POST">
            <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
            
            <div class="form-row">
                <div class="col">
                    <label for="nome">Nome</label>
                    <input type="text" id="nome" name="nome" class="form-input" placeholder="Il tuo nome" required>
                </div>
                <div class="col">
                    <label for="cognome">Cognome</label>
                    <input type="text" id="cognome" name="cognome" class="form-input" placeholder="Il tuo cognome" required>
                </div>
            </div>

            <div class="form-group">
                <label for="via">Indirizzo e Numero Civico</label>
                <input type="text" id="via" name="via" class="form-input" placeholder="Es. Via Roma, 10" required>
            </div>

            <div class="form-row">
                <div class="col col-wide">
                    <label for="citta">Città</label>
                    <input type="text" id="citta" name="citta" class="form-input" placeholder="Città" required>
                </div>
                <div class="col">
                    <label for="cap">CAP</label>
                    <input type="text" id="cap" name="cap" class="form-input" placeholder="00100" pattern="[0-9]{5}" maxlength="5" title="Inserisci 5 numeri" required>
                </div>
                <div class="col">
                    <label for="provincia">Prov.</label>
                    <input type="text" id="provincia" name="provincia" class="form-input uppercase-input" placeholder="RM" maxlength="2" required>
                </div>
            </div>

            <h3 class="section-title"><i class="fa-solid fa-credit-card"></i> Metodo di Pagamento</h3>

            <div class="form-group">
                <select id="pagamento" name="pagamento" class="form-select" required>
                    <option value="" disabled selected>-- Seleziona un metodo --</option>
                    <option value="Carta di Credito">Carta di Credito / Prepagata</option>
                    <option value="PayPal">PayPal</option>
                    <option value="Bonifico Bancario">Bonifico Bancario</option>
                    <option value="Contrassegno">Pagamento alla Consegna (+2.00€)</option>
                </select>
            </div>

            <button type="submit" class="btn-submit">Conferma e Paga Ora <i class="fa-solid fa-angle-right"></i></button>
        </form>
    </main>
</body>
</html>