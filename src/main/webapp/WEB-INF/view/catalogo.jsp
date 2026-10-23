<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Libro" %>

<%
    if (session.getAttribute("csrfToken") == null) {
        session.setAttribute("csrfToken", java.util.UUID.randomUUID().toString());
    }

    String nomeUtente = (String) session.getAttribute("utenteLoggato");
    boolean isLoggato = (nomeUtente != null);

    List<Libro> elencoLibri = (List<Libro>) request.getAttribute("elencoLibri");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo - BookMarker Store</title>
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
            <a href="CarrelloServlet" class="btn btn-cart"><i class="fa-solid fa-cart-shopping"></i> Carrello</a>
            <% if (isLoggato) { %>
                <span class="user-greeting">Ciao, <b><%= nomeUtente %></b></span>
                <a href="MieiOrdiniServlet" class="btn">I Miei Ordini</a>
                <%
                String ruoloAttuale = (String) session.getAttribute("ruoloUtente");
                if ("ADMIN".equals(ruoloAttuale)) {
                %>
                <a href="GestioneCatalogoServlet" class="btn btn-admin">Area Admin</a>
                <%
                }
                %>
                <a href="LogoutServlet" class="btn btn-logout">Logout</a>
            <% } else { %>
                <a href="RegistrazioneServlet" class="btn">Registrati</a>
                <a href="LoginServlet" class="btn">Login</a>
            <% } %>
        </nav>
    </header>

    <main>
        <section class="blue-bar">
            <div class="container-inner">
                <div class="title-wrapper">
                    <h2 class="section-title">Catalogo</h2>
                </div>
                
                <div class="search-wrapper">
                    <div class="search-box-inner">
                        <input type="text" id="searchInput" placeholder="Cerca per titolo o autore..." class="search-input">
                        <i class="fa-solid fa-xmark close-icon" id="resetSearchBtn"></i>
                    </div>
                </div>

                <div class="filter-wrapper">
                    <div class="filter-trigger" id="filterBtn">
                        <i class="fa-solid fa-filter filter-icon"></i>
                        <span>Filtri</span>
                    </div>
                    
                    <div class="filter-dropdown" id="filterDropdown"> 
                        
                        <div class="filter-group">
                            <label for="filterGenere">Genere:</label>
                            <select id="filterGenere" class="filter-select">
                                <option value="all">Tutti</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="sortOrder">Ordina per:</label>
                            <select id="sortOrder" class="filter-select">
                                <option value="default" selected>Default</option>
                                <option value="prezzoCrescente">Prezzo: dal più basso</option>
                            </select>
                        </div>
                        
                        <div class="filter-reset-container">
                            <small class="btn-reset-filters" id="resetFiltersBtn">
                                Resetta filtri
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <div class="book-container" id="containerLibri">
            
            <% 
            if (elencoLibri == null || elencoLibri.isEmpty()) { 
            %>
                <div class="no-books-msg">
                    <p>Nessun libro presente nel catalogo.</p>
                </div>
            <% 
            } else {
                for (Libro libro : elencoLibri) {
                    String imgPath = libro.getCopertina();
                    boolean hasImg = (imgPath != null && !imgPath.isEmpty());
                    String genereLibro = (libro.getGenere() != null && !libro.getGenere().trim().isEmpty() && !libro.getGenere().equalsIgnoreCase("null")) ? libro.getGenere() : "Non specificato";
            %>

            <div class="book-card-stroke search-item" 
                 data-genere="<%= genereLibro %>" 
                 data-prezzo="<%= libro.getPrezzo() %>">
                 
                <div class="book-asset">
                    <% if (hasImg) { %>
                        <img src="<%= request.getContextPath() %>/images/<%= imgPath %>" alt="Copertina" class="book-cover-img">
                    <% } else { %>
                        <i class="fa-regular fa-image book-cover-placeholder"></i>
                    <% } %>
                </div>
                
                <div class="book-content">
                    
                    <a href="DettaglioLibroServlet?id=<%= libro.getIdLibro() %>" class="book-title-link">
                        <h3 class="book-title"><%= libro.getTitolo() %></h3>
                    </a>
                    
                    <p class="book-author book-author-text">
                        <%= libro.getAutore() %>
                    </p>

                    <p class="book-genre-text">Genere: <span class="book-genre"><%= genereLibro %></span></p>

                    <p class="book-desc"><%= libro.getDescrizione() != null ? (libro.getDescrizione().length() > 100 ? libro.getDescrizione().substring(0, 100) + "..." : libro.getDescrizione()) : "Nessuna descrizione." %></p>
                    
                    <div class="button-group book-action-group">
                        <span class="detail-text book-price">€ <%= String.format("%.2f", libro.getPrezzo()) %></span>
                        
                        <% if (libro.getDisponibilita() > 0) { %>
                            <form action="CarrelloServlet" method="POST" class="form-add-cart">
                                <input type="hidden" name="csrfToken" value="<%= session.getAttribute("csrfToken") %>">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="idLibro" value="<%= libro.getIdLibro() %>">
                                <button type="submit" class="btn btn-add-cart">
                                    <i class="fa-solid fa-cart-plus"></i> Aggiungi
                                </button>
                            </form>
                        <% } else { %>
                            <button type="button" class="btn btn-esaurito" disabled>
                                <i class="fa-solid fa-ban"></i> Esaurito
                            </button>
                        <% } %>
                    </div>
                </div>
            </div>

            <% 
                } 
            %>
                <div id="noFilterResultsMsg" class="no-books-msg hidden">
                    <p>Nessun libro corrisponde ai criteri di ricerca.</p>
                </div>
            <%
            } 
            %>
            
        </div>
    </main>

    <button id="scrollTopBtn" title="Torna su">
        <i class="fa-solid fa-arrow-up"></i>
    </button>

    <script src="<%= request.getContextPath() %>/scripts/catalogo.js"></script>
</body>
</html>