document.addEventListener("DOMContentLoaded", () => {
    
    const form = document.getElementById("regForm");
    const inputNome = document.getElementById("nome");
    const inputCognome = document.getElementById("cognome");
    const inputCf = document.getElementById("codice_fiscale");
    const inputEmail = document.getElementById("email");
    const inputPwd = document.getElementById("password");
    const inputPwdConfirm = document.getElementById("conferma_password");

    const regexNomeCognome = /^[a-zA-Z\s']+$/;
    const regexCF = /^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$/i;
    const regexEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const regexPwd = /^.{8,}$/;

    function showError(elementId, isValid, message) {
        const errorSpan = document.getElementById(elementId);
        if (!isValid) {
            errorSpan.textContent = message;
            errorSpan.classList.add("active");
            return false;
        } else {
            errorSpan.classList.remove("active");
            return true;
        }
    }

    inputNome.addEventListener("change", (e) => {
        showError("nomeError", regexNomeCognome.test(e.target.value.trim()), "Il nome deve contenere solo lettere.");
    });

    inputCognome.addEventListener("change", (e) => {
        showError("cognomeError", regexNomeCognome.test(e.target.value.trim()), "Il cognome deve contenere solo lettere.");
    });

    inputCf.addEventListener("change", (e) => {
        const cf = e.target.value.trim().toUpperCase();
        e.target.value = cf;
        showError("cfError", regexCF.test(cf), "Formato Codice Fiscale non valido (16 caratteri alfanumerici).");
    });

    inputPwd.addEventListener("change", (e) => {
        showError("pwdError", regexPwd.test(e.target.value), "La password deve essere lunga almeno 8 caratteri.");
    });

    inputPwdConfirm.addEventListener("change", (e) => {
        showError("pwdConfirmError", e.target.value === inputPwd.value, "Le password non coincidono.");
    });

    inputEmail.addEventListener("change", (e) => {
        const email = e.target.value.trim();
        if (!showError("emailError", regexEmail.test(email), "Formato email non valido.")) {
            return;
        }
        
        fetch("VerificaEmailServlet?email=" + encodeURIComponent(email))
            .then(response => response.json()) 
            .then(data => {
                if (data.occupata) { 
                    showError("emailError", false, "Questa email è già registrata! Prova ad accedere.");
                } else {
                    showError("emailError", true, "");
                }
            })
            .catch(error => {});
    });

    form.addEventListener("submit", (e) => {
        e.preventDefault();

        const validNome = regexNomeCognome.test(inputNome.value.trim());
        const validCognome = regexNomeCognome.test(inputCognome.value.trim());
        const validCF = regexCF.test(inputCf.value.trim());
        const validPwd = regexPwd.test(inputPwd.value);
        const validPwdConfirm = (inputPwd.value === inputPwdConfirm.value);

        showError("nomeError", validNome, "Il nome deve contenere solo lettere.");
        showError("cognomeError", validCognome, "Il cognome deve contenere solo lettere.");
        showError("cfError", validCF, "Formato Codice Fiscale non valido.");
        showError("pwdError", validPwd, "La password deve essere lunga almeno 8 caratteri.");
        showError("pwdConfirmError", validPwdConfirm, "Le password non coincidono.");

        const email = inputEmail.value.trim();
        let isEmailAvailable = false;

        if (showError("emailError", regexEmail.test(email), "Formato email non valido.")) {
            fetch("VerificaEmailServlet?email=" + encodeURIComponent(email))
                .then(response => response.json())
                .then(data => {
                    if (data.occupata) { 
                        showError("emailError", false, "Questa email è già registrata! Prova ad accedere.");
                    } else {
                        showError("emailError", true, "");
                        isEmailAvailable = true;
                    }

                    if (validNome && validCognome && validCF && validPwd && validPwdConfirm && isEmailAvailable) {
                        form.submit();
                    }
                })
                .catch(error => {
                    showError("emailError", false, "Errore di connessione con il server.");
                });
        }
    });

});