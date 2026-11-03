document.addEventListener("DOMContentLoaded", () => {
    const deleteButtons = document.querySelectorAll(".btn-delete");

    deleteButtons.forEach(button => {
        button.addEventListener("click", (event) => {
            const confermato = confirm("Sei sicuro di voler eliminare questo libro?");
            if (!confermato) {
                event.preventDefault();
            }
        });
    });
});