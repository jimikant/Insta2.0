document.addEventListener("turbo:load", function() {
    const likeBtns = document.querySelectorAll('.like-btn');
  
    likeBtns.forEach(function(likeBtn) {
      likeBtn.addEventListener('click', function() {
        const likeInput = this.previousElementSibling; // Get the previous sibling (the hidden radio input)
        const likeText = this.querySelector('.like-text'); // Get the like-text span inside the label
        const isLiked = likeInput.checked;
  
        if (isLiked) {
          likeInput.checked = false;
          likeText.textContent = 'Like';
        } else {
          likeInput.checked = true;
          likeText.textContent = 'Liked'; 
        }
  
        // Submit the form
        this.closest('form').submit();
      });
    });
});