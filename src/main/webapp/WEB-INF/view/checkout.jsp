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

    <main class="checkout-container" style="display: flex; justify-content: center; align-items: center; padding: 2rem;">
        <div style="background-color: white; padding: 30px; border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.2); width: 100%; max-width: 800px; color: #333;">
            
            <div class="checkout-total-box" style="margin-bottom: 20px; border-bottom: 2px solid #eee; padding-bottom: 15px;">
                <h2 class="checkout-total-label" style="color: #333; margin: 0;">Totale da pagare:</h2>
                <span class="checkout-total-amount" style="font-size: 1.5rem; font-weight: bold; color: #27ae60;">€ <%= String.format("%.2f", totale) %></span>
            </div>

            <h3 class="section-title" style="color: #333;"><i class="fa-solid fa-truck-fast"></i> Dettagli Spedizione</h3>

            <form action="CheckoutServlet" method="POST" style="display: flex; flex-direction: column; gap: 1rem; margin-top: 15px;">
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                
                <div class="form-row" style="display: flex; gap: 1rem;">
                    <div class="col" style="flex: 1;">
                        <label for="nome" style="color: #555; font-weight: bold;">Nome</label>
                        <input type="text" id="nome" name="nome" class="form-input" placeholder="Il tuo nome" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; margin-top: 5px;">
                    </div>
                    <div class="col" style="flex: 1;">
                        <label for="cognome" style="color: #555; font-weight: bold;">Cognome</label>
                        <input type="text" id="cognome" name="cognome" class="form-input" placeholder="Il tuo cognome" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; margin-top: 5px;">
                    </div>
                </div>

                <div class="form-group">
                    <label for="via" style="color: #555; font-weight: bold;">Indirizzo e Numero Civico</label>
                    <input type="text" id="via" name="via" class="form-input" placeholder="Es. Via Roma, 10" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; margin-top: 5px;">
                </div>

                <div class="form-row" style="display: flex; gap: 1rem;">
                    <div class="col col-wide" style="flex: 2;">
                        <label for="citta" style="color: #555; font-weight: bold;">Città</label>
                        <input type="text" id="citta" name="citta" class="form-input" placeholder="Città" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; margin-top: 5px;">
                    </div>
                    <div class="col" style="flex: 1;">
                        <label for="cap" style="color: #555; font-weight: bold;">CAP</label>
                        <input type="text" id="cap" name="cap" class="form-input" placeholder="00100" pattern="[0-9]{5}" maxlength="5" title="Inserisci 5 numeri" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; margin-top: 5px;">
                    </div>
                    <div class="col" style="flex: 1;">
                        <label for="provincia" style="color: #555; font-weight: bold;">Prov.</label>
                        <input type="text" id="provincia" name="provincia" class="form-input uppercase-input" placeholder="RM" maxlength="2" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; margin-top: 5px; text-transform: uppercase;">
                    </div>
                </div>

                <h3 class="section-title" style="color: #333; margin-top: 20px;"><i class="fa-solid fa-credit-card"></i> Metodo di Pagamento</h3>

                <div class="form-group">
                    <select id="pagamento" name="pagamento" class="form-select" required style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; margin-top: 5px; cursor: pointer;">
                        <option value="" disabled selected>-- Seleziona un metodo --</option>
                        <option value="Carta di Credito">Carta di Credito / Prepagata</option>
                        <option value="PayPal">PayPal</option>
                        <option value="Bonifico Bancario">Bonifico Bancario</option>
                        <option value="Contrassegno">Pagamento alla Consegna (+2.00€)</option>
                    </select>
                </div>

                <button type="submit" class="btn-submit" style="background-color: #27ae60; color: white; border: none; padding: 15px; border-radius: 5px; font-weight: bold; font-size: 1.1rem; cursor: pointer; margin-top: 20px; width: 100%;">Conferma e Paga Ora <i class="fa-solid fa-angle-right"></i></button>
            </form>
        </div>
    </main>
</body>
</html>