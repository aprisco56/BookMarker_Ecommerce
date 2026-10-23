<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Libro" %>
<%@ page import="model.Recensione" %>

<%
    if (session.getAttribute("csrfToken") == null) {
        session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    }

    Libro libro = (Libro) request.getAttribute("libroDettaglio");
    String nomeUtente = (String) session.getAttribute("utenteLoggato");
    List<Recensione> elencoRecensioni = (List<Recensione>) request.getAttribute("listaRecensioni");
    
    if (libro == null) { 
        response.sendRedirect("LibriServlet"); 
        return; 
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= libro.getTitolo() %> - Dettaglio</title>
    
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/catalogo.css"> 
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/dettaglio.css"> 
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
            <a href="CarrelloServlet" class="btn btn-cart"><i class="fa-solid fa-cart-shopping"></i> Carrello</a>
            <% if (nomeUtente != null) { %>
                <a href="MieiOrdiniServlet" class="btn">I Miei Ordini</a>
                <a href="LogoutServlet" class="btn btn-logout">Logout</a>
            <% } else { %>
                <a href="LoginServlet" class="btn">Login</a>
            <% } %>
        </nav>
    </header>

    <main class="detail-wrapper">
        <div class="white-box">
            <div class="product-hero">
                <div class="hero-image-container">
                    <button type="button" class="favorite-btn" title="Aggiungi ai preferiti">
                        <i class="fa-regular fa-heart"></i>
                    </button>
                    <% if (libro.getCopertina() != null && !libro.getCopertina().isEmpty()) { %>
                        <img src="<%= request.getContextPath() %>/images/<%= libro.getCopertina() %>" alt="<%= libro.getTitolo() %>">
                    <% } else { %>
                        <i class="fa-regular fa-image placeholder-icon"></i>
                    <% } %>
                </div>

                <div class="hero-details">
                    <h1><%= libro.getTitolo() %></h1>
                    
                    <div class="detail-meta">
                        <strong>Autore:</strong> <%= libro.getAutore() %><br>
                        <strong>Genere:</strong> <%= libro.getGenere() != null ? libro.getGenere() : "Non specificato" %><br>
                        <strong>Data Pubblicazione:</strong> <%= libro.getDataPubblicazione() %><br><br>
                        <strong class="detail-price">Prezzo: € <%= String.format("%.2f", libro.getPrezzo()) %></strong><br><br>
                        
                        <% String msg = request.getParameter("msg"); %>
                        <% if ("add_cart_ok".equals(msg)) { %>
                            <div class="success-message success-cart-msg">
                                <i class="fa-solid fa-check-circle"></i> Articolo aggiunto al carrello!
                            </div>
                        <% } else if ("add_cart_err".equals(msg)) { %>
                            <div class="error-cart-msg">
                                <i class="fa-solid fa-circle-exclamation"></i> Impossibile aggiungere: libro esaurito o quantità massima disponibile già nel carrello.
                            </div>
                        <% } %>

                        <% if(libro.getDisponibilita() > 0) { %>
                            <span class="availability-ok">
                                <i class="fa-solid fa-check"></i> Disponibile
                            </span>

                            <form id="cartForm" action="CarrelloServlet" method="post" class="form-add-to-cart-detail">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="idLibro" value="<%= libro.getIdLibro() %>">
                                
                                <button type="button" id="openCartModalBtn" class="btn-prenota btn-add-cart-detail">
                                    <i class="fa-solid fa-cart-plus"></i> Aggiungi al Carrello
                                </button>
                            </form>
                        <% } else { %>
                            <span class="availability-ko">
                                <i class="fa-solid fa-xmark"></i> Esaurito
                            </span>
                        <% } %>
                    </div>
                    
                    <p class="description-text">
                        <%= (libro.getDescrizione() != null) ? libro.getDescrizione() : "Nessuna descrizione disponibile per questo libro." %>
                    </p>

                    <button type="button" id="scrollReviewsBtn" class="btn-black">Visualizza recensioni</button>
                </div>
            </div>

            <div class="reviews-section" id="reviewsAnchor">
                <h3 class="reviews-title">Recensioni</h3>
                <% if (elencoRecensioni == null || elencoRecensioni.isEmpty()) { %>
                    <div class="no-reviews-msg">
                        Non ci sono ancora recensioni per questo libro.
                    </div>
                <% } else {
                    for (Recensione rec : elencoRecensioni) { %>
                    <div class="review-card">
                        <div class="review-header">
                            <span>
                                <i class="fa-solid fa-user review-user-icon"></i>
                                <%= rec.getEmailUtente() %>
                            </span>
                            
                            <div class="review-meta-right">
                                <small class="review-date">
                                    <% if(rec.getDataInserimento() != null) out.print(rec.getDataInserimento()); %>
                                </small>
                                
                                <% if (nomeUtente != null) { %>
                                    <button type="button" class="btn-report" data-recensione-id="<%= rec.getId() %>">
                                        <i class="fa-solid fa-flag"></i> Segnala
                                    </button>
                                <% } %>
                            </div>
                        </div>
                        
                        <div class="review-stars review-stars-container">
                            <% int voto = rec.getVoto();
                               for (int i = 0; i < 5; i++) {
                                   if (i < voto) { %>
                                    <i class="fa-solid fa-star"></i>
                                   <% } else { %>
                                    <i class="fa-regular fa-star review-star-empty"></i>
                                   <% }
                               } %>
                        </div>
                        <div class="review-body">
                            <%= rec.getTesto() %>
                        </div>
                    </div>
                <% } } %>
            </div>
        </div>
    </main>

    <div id="confirmModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-title">Conferma Aggiunta</div>
            <div class="modal-text">
                Vuoi aggiungere <strong><%= libro.getTitolo() %></strong> al carrello per <strong class="modal-price-highlight">€ <%= String.format("%.2f", libro.getPrezzo()) %></strong>?
            </div>
            <div class="modal-buttons">
                <button type="button" id="cancelCartModalBtn" class="btn-modal-cancel">Annulla</button>
                <button type="button" id="confirmCartModalBtn" class="btn-modal-confirm">Conferma</button>
            </div>
        </div>
    </div>

    <div id="reportModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-title modal-title-warning"><i class="fa-solid fa-triangle-exclamation"></i> Segnala Recensione</div>
            <div class="modal-text">
                Descrivi il motivo della segnalazione. Il testo deve contenere almeno <strong>20 caratteri</strong>.
            </div>
            
            <form id="formSegnalazione" action="SegnalaRecensioneServlet" method="post">
                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                <input type="hidden" name="idLibro" value="<%= libro.getIdLibro() %>">
                <input type="hidden" id="reportRecensioneId" name="idRecensione" value="">
                
                <textarea name="motivo" id="motivoSegnalazione" class="modal-textarea" placeholder="Esempio: Contenuto offensivo, spoiler non segnalato..."></textarea>
                <div id="motivoError" class="error-text modal-error-msg">Il motivo è troppo breve (min. 20 caratteri).</div>

                <div class="modal-buttons">
                    <button type="button" id="cancelReportModalBtn" class="btn-modal-cancel">Annulla</button>
                    <button type="submit" class="btn-modal-submit">Invia Segnalazione</button>
                </div>
            </form>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/scripts/dettaglio.js"></script>
</body>
</html>