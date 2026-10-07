<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.DettaglioOrdine" %>
<%
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
    <link rel="stylesheet" href="styles/catalogo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .checkout-container { max-width: 650px; margin: 40px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .form-row { display: flex; gap: 15px; margin-bottom: 15px; }
        .form-row .col { flex: 1; }
        .form-group { margin-bottom: 15px; }
        .form-group label, .form-row label { display: block; margin-bottom: 8px; font-weight: 600; color: #444; font-size: 0.95rem; }
        .form-input, .form-select { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 1rem; box-sizing: border-box; transition: border-color 0.3s; }
        .form-input:focus, .form-select:focus { border-color: #3498db; outline: none; }
        .btn-submit { width: 100%; background-color: #27ae60; color: white; padding: 15px; border: none; border-radius: 4px; font-size: 1.2rem; font-weight: bold; cursor: pointer; margin-top: 20px; transition: background 0.3s; }
        .btn-submit:hover { background-color: #219653; }
        .section-title { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-bottom: 25px; margin-top: 25px;}
    </style>
</head>
<body>
    <header>
        <div class="header-spacer"></div>
        <a href="index.jsp" class="logo-container">
            <img src="images/logo.png" alt="BookMarker Logo">
        </a>
        <nav class="nav-buttons">
            <a href="CarrelloServlet" class="btn">Torna al Carrello</a>
        </nav>
    </header>

    <main class="checkout-container">
        <div style="background-color: #f8f9fa; padding: 20px; border-radius: 6px; border: 1px solid #e9ecef; display: flex; justify-content: space-between; align-items: center;">
            <h2 style="margin: 0; color: #2c3e50;">Totale da pagare:</h2>
            <span style="color: #27ae60; font-size: 1.8rem; font-weight: bold;">€ <%= String.format("%.2f", totale) %></span>
        </div>

        <h3 class="section-title"><i class="fa-solid fa-truck-fast"></i> Dettagli Spedizione</h3>

        <form action="CheckoutServlet" method="POST">
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
                <div class="col" style="flex: 2;">
                    <label for="citta">Città</label>
                    <input type="text" id="citta" name="citta" class="form-input" placeholder="Città" required>
                </div>
                <div class="col">
                    <label for="cap">CAP</label>
                    <input type="text" id="cap" name="cap" class="form-input" placeholder="00100" pattern="[0-9]{5}" maxlength="5" title="Inserisci 5 numeri" required>
                </div>
                <div class="col">
                    <label for="provincia">Prov.</label>
                    <input type="text" id="provincia" name="provincia" class="form-input" placeholder="RM" maxlength="2" style="text-transform: uppercase;" required>
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