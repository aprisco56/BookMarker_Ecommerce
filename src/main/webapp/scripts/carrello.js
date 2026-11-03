document.addEventListener("DOMContentLoaded", () => {
    const qtyInputs = document.querySelectorAll(".cart-qty-input");
    let timer;

    qtyInputs.forEach(input => {
        input.addEventListener("input", function() {
            clearTimeout(timer);
            
            timer = setTimeout(() => {
                if (this.value !== "" && parseInt(this.value) > 0) {
                    this.closest("form").submit();
                }
            }, 500);
        });
    });
});