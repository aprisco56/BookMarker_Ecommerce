document.addEventListener("DOMContentLoaded", () => {
    const heartBtn = document.querySelector(".favorite-btn");
    if (heartBtn) {
        heartBtn.addEventListener("click", function() {
            this.classList.toggle("liked");
            const icon = this.querySelector("i");
            if (this.classList.contains("liked")) {
                icon.classList.remove("fa-regular");
                icon.classList.add("fa-solid");
            } else {
                icon.classList.remove("fa-solid");
                icon.classList.add("fa-regular");
            }
        });
    }

    const scrollReviewsBtn = document.getElementById("scrollReviewsBtn");
    const reviewsSection = document.getElementById("reviewsAnchor");
    if (scrollReviewsBtn && reviewsSection) {
        scrollReviewsBtn.addEventListener("click", () => {
            reviewsSection.scrollIntoView({ behavior: "smooth" });
        });
    }

    const confirmModal = document.getElementById("confirmModal");
    const openCartModalBtn = document.getElementById("openCartModalBtn");
    const cancelCartModalBtn = document.getElementById("cancelCartModalBtn");
    const confirmCartModalBtn = document.getElementById("confirmCartModalBtn");
    const cartForm = document.getElementById("cartForm");

    if (openCartModalBtn && confirmModal) {
        openCartModalBtn.addEventListener("click", () => {
            confirmModal.classList.add("active");
        });
    }

    if (cancelCartModalBtn && confirmModal) {
        cancelCartModalBtn.addEventListener("click", () => {
            confirmModal.classList.remove("active");
        });
    }

    if (confirmCartModalBtn && cartForm) {
        confirmCartModalBtn.addEventListener("click", () => {
            cartForm.submit();
        });
    }

    const reportModal = document.getElementById("reportModal");
    const reportButtons = document.querySelectorAll(".btn-report");
    const cancelReportModalBtn = document.getElementById("cancelReportModalBtn");
    const formSegnalazione = document.getElementById("formSegnalazione");
    const motivoSegnalazione = document.getElementById("motivoSegnalazione");
    const motivoError = document.getElementById("motivoError");
    const reportRecensioneId = document.getElementById("reportRecensioneId");

    if (reportButtons.length > 0 && reportModal) {
        reportButtons.forEach(btn => {
            btn.addEventListener("click", function() {
                const idRecensione = this.getAttribute("data-recensione-id");
                if (motivoSegnalazione) motivoSegnalazione.value = "";
                if (motivoError) motivoError.classList.remove("active");
                if (reportRecensioneId) reportRecensioneId.value = idRecensione;
                reportModal.classList.add("active");
            });
        });
    }

    if (cancelReportModalBtn && reportModal) {
        cancelReportModalBtn.addEventListener("click", () => {
            reportModal.classList.remove("active");
        });
    }

    if (formSegnalazione && motivoSegnalazione && motivoError) {
        formSegnalazione.addEventListener("submit", (e) => {
            const testo = motivoSegnalazione.value.trim();
            if (testo.length < 20) {
                e.preventDefault();
                motivoError.classList.add("active");
            } else {
                motivoError.classList.remove("active");
            }
        });
    }

    window.addEventListener("click", (event) => {
        if (confirmModal && event.target === confirmModal) {
            confirmModal.classList.remove("active");
        }
        if (reportModal && event.target === reportModal) {
            reportModal.classList.remove("active");
        }
    });
});