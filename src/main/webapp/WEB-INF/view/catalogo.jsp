<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Libro" %>

<%
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
    <link rel="stylesheet" href="styles/catalogo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <header>
        <div class="header-spacer"></div>
        <a href="index.jsp" class="logo-container"> 
            <img src="images/logo.png" alt="BookMarker Logo">
        </a>
        
        <nav class="nav-buttons">
            <% if (isLoggato) { %>
                <span class="user-greeting">Ciao, <b><%= nomeUtente %></b></span>
                <a href="CarrelloServlet" class="btn" style="background-color: #f1c40f; color: #333;"><i class="fa-solid fa-cart-shopping"></i> Carrello</a>
                <%
    String ruoloAttuale = (String) session.getAttribute("ruoloUtente");
    if ("ADMIN".equals(ruoloAttuale)) {
%>
    <a href="GestioneCatalogoServlet" class="btn" style="background-color: #f39c12; color: white; margin-right: 10px; padding: 8px 12px; text-decoration: none; border-radius: 5px; font-weight: bold;">Area Admin</a>
<%
    }
%>
                <a href="LogoutServlet" class="btn" style="background-color: #c0392b; color: white;">Logout</a>
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
                        <i class="fa-solid fa-xmark close-icon" onclick="resetSearch()"></i>
                    </div>
                </div>

                <div class="filter-wrapper" onclick="toggleFilters(event)">
                    <div class="filter-trigger">
                        <i class="fa-solid fa-filter filter-icon"></i>
                        <span>Filtri</span>
                    </div>
                    
                    <div class="filter-dropdown" id="filterDropdown" onclick="event.stopPropagation()"> 
                        
                        <div class="filter-group">
                            <label for="filterGenere">Genere:</label>
                            <select id="filterGenere" class="filter-select" onchange="applicaFiltri()">
                                <option value="all">Tutti</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="sortOrder">Ordina per:</label>
                            <select id="sortOrder" class="filter-select" onchange="applicaFiltri()">
                                <option value="default" selected>Default</option>
                                <option value="prezzoCrescente">Prezzo: dal più basso</option>
                            </select>
                        </div>
                        
                        <div style="text-align: right; margin-top: 15px;">
                            <small style="color: white; background-color: #c0392b; padding: 6px 12px; border-radius: 4px; cursor: pointer; display: inline-block;" onclick="resetFiltri()">
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
                <div style="text-align:center; padding: 20px; background: white; width: 100%;">
                    <p>Nessun libro presente nel catalogo.</p>
                </div>
            <% 
            } else {
                for (Libro libro : elencoLibri) {
                    String imgPath = libro.getCopertina();
                    boolean hasImg = (imgPath != null && !imgPath.isEmpty());
            %>

            <div class="book-card-stroke search-item" 
                 data-genere="<%= libro.getGenere() %>" 
                 data-prezzo="<%= libro.getPrezzo() %>">
                 
                <div class="book-asset">
                    <% if (hasImg) { %>
                        <img src="<%= imgPath %>" alt="Copertina" style="max-width:100%; max-height:100%;">
                    <% } else { %>
                        <i class="fa-regular fa-image" style="font-size: 3rem; color: #ccc;"></i>
                    <% } %>
                </div>
                
                <div class="book-content">
                    
                    <a href="DettaglioLibroServlet?id=<%= libro.getIdLibro() %>" style="text-decoration: none; color: inherit;">
                        <h3 class="book-title"><%= libro.getTitolo() %></h3>
                    </a>
                    
                    <p class="book-author" style="font-weight: bold; color: #555; margin-bottom: 5px;">
                        <%= libro.getAutore() %>
                    </p>

                    <p style="font-size: 0.9rem; color: #888; margin: 0;">Genere: <span class="book-genre"><%= libro.getGenere() %></span></p>

                    <p class="book-desc"><%= libro.getDescrizione() != null ? (libro.getDescrizione().length() > 100 ? libro.getDescrizione().substring(0, 100) + "..." : libro.getDescrizione()) : "Nessuna descrizione." %></p>
                    
                    <div class="button-group" style="display: flex; justify-content: space-between; align-items: center; margin-top: 15px;">
                        <span class="detail-text" style="font-size: 1.2rem; font-weight: bold; color: #2c3e50;">€ <%= String.format("%.2f", libro.getPrezzo()) %></span>
                        
                        <form action="CarrelloServlet" method="POST" style="margin: 0;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="idLibro" value="<%= libro.getIdLibro() %>">
                            <button type="submit" class="btn" style="background-color: #27ae60; color: white; border: none; padding: 8px 15px; cursor: pointer; border-radius: 4px;">
                                <i class="fa-solid fa-cart-plus"></i> Aggiungi
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <% 
                } 
            } 
            %>
            
        </div>
    </main>

    <button onclick="scrollToTop()" id="scrollTopBtn" title="Torna su">
        <i class="fa-solid fa-arrow-up"></i>
    </button>

    <script>
        function toggleFilters(event) {
            const menu = document.getElementById('filterDropdown');
            menu.classList.toggle('active');
            event.stopPropagation();
        }

        document.addEventListener('click', function(event) {
            const wrapper = document.querySelector('.filter-wrapper');
            const menu = document.getElementById('filterDropdown');
            if (wrapper && !wrapper.contains(event.target)) {
                menu.classList.remove('active');
            }
        });

        document.addEventListener("DOMContentLoaded", () => {
            const cards = document.querySelectorAll('.search-item');
            const selectGenere = document.getElementById('filterGenere');
            const generiTrovati = new Set(); 

            cards.forEach((card, index) => {
                card.setAttribute('data-original-index', index);
                const genere = card.getAttribute('data-genere');
                if (genere) generiTrovati.add(genere);
            });

            generiTrovati.forEach(genere => {
                const option = document.createElement('option');
                option.value = genere;
                option.textContent = genere;
                selectGenere.appendChild(option);
            });

            applicaFiltri();
        });

        const searchInput = document.getElementById('searchInput');
        const selectGenere = document.getElementById('filterGenere');
        const selectSort = document.getElementById('sortOrder');

        function applicaFiltri() {
            const searchTerm = searchInput.value.toLowerCase();
            const selectedGenre = selectGenere.value;
            const sortMode = selectSort.value;

            const container = document.getElementById('containerLibri');
            let cards = Array.from(document.querySelectorAll('.search-item'));

            cards.forEach(card => {
                const title = card.querySelector('.book-title').innerText.toLowerCase();
                const author = card.querySelector('.book-author').innerText.toLowerCase();
                const cardGenre = card.getAttribute('data-genere');

                const matchSearch = title.includes(searchTerm) || author.includes(searchTerm);
                const matchGenre = (selectedGenre === 'all') || (cardGenre === selectedGenre);

                if (matchSearch && matchGenre) {
                    card.style.display = 'flex';
                } else {
                    card.style.display = 'none';
                }
            });

            if (sortMode === 'prezzoCrescente') {
                cards.sort((a, b) => {
                    const prezzoA = parseFloat(a.getAttribute('data-prezzo')) || 0;
                    const prezzoB = parseFloat(b.getAttribute('data-prezzo')) || 0;
                    return prezzoA - prezzoB; 
                });
            } else {
                cards.sort((a, b) => {
                    const indexA = parseInt(a.getAttribute('data-original-index'));
                    const indexB = parseInt(b.getAttribute('data-original-index'));
                    return indexA - indexB;
                });
            }
            
            cards.forEach(card => container.appendChild(card));
        }
        
        searchInput.addEventListener('keyup', applicaFiltri);

        function resetSearch() {
            searchInput.value = '';
            applicaFiltri();
        }

        function resetFiltri() {
            selectGenere.value = 'all';
            selectSort.value = 'default';
            searchInput.value = '';
            applicaFiltri();
        }

        const scrollBtn = document.getElementById("scrollTopBtn");

        window.onscroll = function() {
            if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
                scrollBtn.style.display = "block";
            } else {
                scrollBtn.style.display = "none";
            }
        };

        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: "smooth"
            });
        }
    </script>
</body>
</html>