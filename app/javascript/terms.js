document.addEventListener("turbo:load", function() {
    function getCookie(name) {
      let value = "; " + document.cookie;
      let parts = value.split("; " + name + "=");
      if (parts.length === 2) return parts.pop().split(";").shift();
    }
  
    function setCookie(name, value, days) {
      let expires = "";
      if (days) {
        let date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
      }
      document.cookie = name + "=" + (value || "") + expires + "; path=/";
    }
  
    const termsModal = document.getElementById("termsModal");
    const acceptTermsCheckbox = document.getElementById("acceptTerms");
    const closeModalButton = document.getElementById("closeModal");
  
    // Check if the cookie 'termsAccepted' is not set
    if (!getCookie("termsAccepted")) {
      termsModal.style.display = "block"; // Show the terms modal
    }
  
    closeModalButton.addEventListener("click", function() {
      if (acceptTermsCheckbox.checked) {
        setCookie("termsAccepted", "true", 365); // Set cookie for 1 year when terms are accepted
      }
      termsModal.style.display = "none"; // Hide the modal after closing
    });
  });
  