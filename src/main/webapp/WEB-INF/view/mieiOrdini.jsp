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

    String msg = request.getParameter("msg");
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
        <div style="background-color: white; padding: 30px; border-radius: 15px; box-shadow: 0 8px 20px rgba(0,0,0,0.2); max-width: 1000px; margin: 40px auto; width: 90%;">
            <h2 class="cart-title" style="color: #333; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-top: 0;"><i class="fa-solid fa-box-open"></i> Storico Ordini</h2>

            <% if ("gia_recensito".equals(msg)) { %>
                <div style="background-color: #fff3cd; color: #856404; padding: 15px; border-radius: 8px; border-left: 5px solid #ffeeba; margin-bottom: 20px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> <strong>Attenzione:</strong> Hai già recensito questo articolo.
                </div>
            <% } else if ("recensione_ok".equals(msg)) { %>
                <div style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 8px; border-left: 5px solid #c3e6cb; margin-bottom: 20px;">
                    <i class="fa-solid fa-check-circle"></i> <strong>Successo:</strong> Recensione pubblicata correttamente! Grazie per il tuo contributo.
                </div>
            <% } else if ("errore".equals(msg)) { %>
                <div style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; border-left: 5px solid #f5c6cb; margin-bottom: 20px;">
                    <i class="fa-solid fa-circle-xmark"></i> <strong>Errore:</strong> Si è verificato un problema tecnico. Riprova più tardi.
                </div>
            <% } %>

            <% if (ordini == null || ordini.isEmpty()) { %>
                <div class="empty-cart" style="text-align: center; padding: 40px 0;">
                    <i class="fa-solid fa-receipt empty-cart-icon" style="font-size: 3rem; color: #ccc;"></i>
                    <h3 style="color: #333; margin: 15px 0;">Non hai ancora effettuato nessun ordine!</h3>
                    <p class="empty-cart-action">
                        <a href="LibriServlet" class="btn btn-neutral" style="background-color: #27ae60; color: white; padding: 10px 20px;">Inizia lo Shopping</a>
                    </p>
                </div>
            <% } else { %>
                <table class="cart-table" style="width: 100%; border-collapse: collapse; margin-top: 20px;">
                    <thead>
                        <tr style="background-color: #f8f9fa; border-bottom: 2px solid #dee2e6;">
                            <th style="padding: 12px; text-align: left; color: #333;">N° Ordine</th>
                            <th style="padding: 12px; text-align: left; color: #333;">Data</th>
                            <th style="padding: 12px; text-align: left; color: #333;">Indirizzo di Spedizione</th>
                            <th style="padding: 12px; text-align: left; color: #333;">Metodo di Pagamento</th>
                            <th style="padding: 12px; text-align: left; color: #333;">Totale</th>
                            <th style="padding: 12px; text-align: left; color: #333;">Stato</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        for (Ordine o : ordini) { 
                            String badgeClass = "badge-elaborazione";
                            if ("Completato".equalsIgnoreCase(o.getStato())) badgeClass = "badge-completato";
                            else if ("Spedito".equalsIgnoreCase(o.getStato())) badgeClass = "badge-spedito";
                        %>
                        <tr style="border-bottom: 1px solid #dee2e6;">
                            <td style="padding: 12px; color: #333;"><strong>#<%= o.getIdOrdine() %></strong></td>
                            <td style="padding: 12px; color: #333;"><%= o.getDataOrdine() != null ? sdf.format(o.getDataOrdine()) : "" %></td>
                            <td style="padding: 12px; color: #333;"><%= o.getIndirizzoSpedizione() %></td>
                            <td style="padding: 12px; color: #333;"><%= o.getMetodoPagamento() %></td>
                            <td style="padding: 12px;"><strong class="text-green" style="color: #27ae60;">€ <%= String.format("%.2f", o.getTotale()) %></strong></td>
                            <td style="padding: 12px;"><span class="badge <%= badgeClass %>" style="background-color: #27ae60; color: white; padding: 5px 10px; border-radius: 4px;"><%= o.getStato() %></span></td>
                        </tr>
                    
                        <tr style="border-bottom: 2px solid #ccc; background-color: #fcfcfc;">
                            <td colspan="6" style="padding: 15px;">
                                <strong style="color: #555; font-size: 0.9rem;">Articoli acquistati:</strong>
                                <ul style="list-style: none; padding: 0; margin: 10px 0 0 0;">
                                    <% if(o.getDettagli() != null) { 
                                        for(model.DettaglioOrdine d : o.getDettagli()) { %>
                                        <li style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; padding-bottom: 8px; border-bottom: 1px dashed #eee;">
                                            <span style="color: #333;">- <%= d.getLibro().getTitolo() %> (Qtà: <%= d.getQuantita() %>)</span>
                                            <a href="ScriviRecensioneServlet?idLibro=<%= d.getLibro().getIdLibro() %>" style="background-color: #f39c12; color: white; padding: 6px 12px; font-size: 0.85rem; border-radius: 4px; text-decoration: none; font-weight: bold;">
                                                <i class="fa-solid fa-star"></i> Recensisci
                                            </a>
                                        </li>
                                    <%  } 
                                       } %>
                                </ul>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </main>

</body>
</html>