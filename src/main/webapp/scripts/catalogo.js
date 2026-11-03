document.addEventListener("DOMContentLoaded", () => {
    
    const filterBtn = document.getElementById('filterBtn');
    const filterMenu = document.getElementById('filterDropdown');

    if (filterBtn && filterMenu) {
        filterBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            filterMenu.classList.toggle('active');
        });

        document.addEventListener('click', function(e) {
            const wrapper = document.querySelector('.filter-wrapper');
            if (wrapper && !wrapper.contains(e.target)) {
                filterMenu.classList.remove('active');
            }
        });

        filterMenu.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    }

    const cards = document.querySelectorAll('.search-item');
    const selectGenere = document.getElementById('filterGenere');
    const generiTrovati = new Set(); 

    if (cards.length > 0 && selectGenere) {
        cards.forEach((card, index) => {
            card.setAttribute('data-original-index', index);
            const genere = card.getAttribute('data-genere');
            if (genere && genere !== "null" && genere !== "Non specificato") {
                generiTrovati.add(genere);
            }
        });

        generiTrovati.forEach(genere => {
            const option = document.createElement('option');
            option.value = genere;
            option.textContent = genere;
            selectGenere.appendChild(option);
        });
    }

    const searchInput = document.getElementById('searchInput');
    const selectSort = document.getElementById('sortOrder');
    const container = document.getElementById('containerLibri');
    const resetFiltersBtn = document.getElementById('resetFiltersBtn');
    const resetSearchBtn = document.getElementById('resetSearchBtn');
    const noResultsMsg = document.getElementById('noFilterResultsMsg');

    function applicaFiltri() {
        if(!searchInput || !selectGenere || !selectSort || !container) return;

        const searchTerm = searchInput.value.toLowerCase();
        const selectedGenre = selectGenere.value;
        const sortMode = selectSort.value;

        let cardArray = Array.from(document.querySelectorAll('.search-item'));
        let visibleCount = 0;

        cardArray.forEach(card => {
            const titleElement = card.querySelector('.book-title');
            const authorElement = card.querySelector('.book-author');
            
            const title = titleElement ? titleElement.innerText.toLowerCase() : '';
            const author = authorElement ? authorElement.innerText.toLowerCase() : '';
            const cardGenre = card.getAttribute('data-genere');

            const matchSearch = title.includes(searchTerm) || author.includes(searchTerm);
            const matchGenre = (selectedGenre === 'all') || (cardGenre === selectedGenre);

            if (matchSearch && matchGenre) {
                card.classList.remove('hidden');
                visibleCount++;
            } else {
                card.classList.add('hidden');
            }
        });

        if (sortMode === 'prezzoCrescente') {
            cardArray.sort((a, b) => {
                const prezzoA = parseFloat(a.getAttribute('data-prezzo')) || 0;
                const prezzoB = parseFloat(b.getAttribute('data-prezzo')) || 0;
                return prezzoA - prezzoB; 
            });
        } else {
            cardArray.sort((a, b) => {
                const indexA = parseInt(a.getAttribute('data-original-index'));
                const indexB = parseInt(b.getAttribute('data-original-index'));
                return indexA - indexB;
            });
        }
        
        cardArray.forEach(card => container.appendChild(card));

        if (noResultsMsg) {
            container.appendChild(noResultsMsg);
            if (visibleCount === 0 && cardArray.length > 0) {
                noResultsMsg.classList.remove('hidden');
            } else {
                noResultsMsg.classList.add('hidden');
            }
        }
    }

    if (searchInput) searchInput.addEventListener('keyup', applicaFiltri);
    if (selectGenere) selectGenere.addEventListener('change', applicaFiltri);
    if (selectSort) selectSort.addEventListener('change', applicaFiltri);
    
    if (resetSearchBtn) {
        resetSearchBtn.addEventListener('click', () => {
            searchInput.value = '';
            applicaFiltri();
        });
    }

    if (resetFiltersBtn) {
        resetFiltersBtn.addEventListener('click', () => {
            selectGenere.value = 'all';
            selectSort.value = 'default';
            searchInput.value = '';
            applicaFiltri();
        });
    }

    applicaFiltri();

    const scrollBtn = document.getElementById("scrollTopBtn");
    
    window.addEventListener("scroll", () => {
        if (scrollBtn) {
            if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
                scrollBtn.classList.add("show");
            } else {
                scrollBtn.classList.remove("show");
            }
        }
    });

    if (scrollBtn) {
        scrollBtn.addEventListener("click", () => {
            window.scrollTo({ top: 0, behavior: "smooth" });
        });
    }
});