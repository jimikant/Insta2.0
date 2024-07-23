document.addEventListener('turbo:load', function() {
  var avatars = document.getElementsByClassName('useravtar');
  for (var i = 0; i < avatars.length; i++) {
    avatars[i].addEventListener('click', function() {
      // Remove the 'enlarged' class from any currently enlarged avatar
      var currentlyEnlarged = document.querySelector('.useravtar.enlarged');
      if (currentlyEnlarged && currentlyEnlarged !== this) {
        currentlyEnlarged.classList.remove('enlarged');
      }
      // Toggle the 'enlarged' class on the clicked avatar
      this.classList.toggle('enlarged');
    });
  }
});

