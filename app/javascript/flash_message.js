document.addEventListener("turbo:load", function() {
  setTimeout(function() {
    var notice = document.getElementById("flash_notice");
    if (notice) {
      notice.style.display = "none";
    }

    var alert = document.getElementById("flash_alert");
    if (alert) {
      alert.style.display = "none";
    }
  }, 4000);
});
