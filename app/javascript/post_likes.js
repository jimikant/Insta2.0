document.addEventListener("turbo:load", function() {
  const likeBtns = document.querySelectorAll('.like-btn');

  likeBtns.forEach(function(likeBtn) {
      likeBtn.addEventListener('click', function(event) {
          event.preventDefault(); // Prevent the form from submitting immediately

          const form = this.closest('form');
          const likeText = this.querySelector('.like-text');
          const likesCountElement = form.closest('.d-flex').querySelector('.likes-count');
          let likesCount = parseInt(likesCountElement.textContent);

          const isLiked = this.id === "liked";

          if (isLiked) {
              // Dislike action
              likeText.textContent = 'Like';
              this.classList.remove('active');
              this.id = "like";
              likesCount -= 1; // Decrease the like count
          } else {
              // Like action
              likeText.textContent = 'Liked';
              this.classList.add('active');
              this.id = "liked";
              likesCount += 1; // Increase the like count
          }

          // Update the like count on the page
          likesCountElement.textContent = likesCount;

          // Submit the form via Turbo
          form.requestSubmit();
      });
  });
});
