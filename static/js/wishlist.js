(function () {

    function toggleWishlist(event, productId) {
        if (event) {
            event.preventDefault();
            event.stopPropagation();
        }

        const btn = document.getElementById(`wishlist-icon-${productId}`);
        if (!btn) return;

        const icon = btn.querySelector('i');
        const url = btn.dataset.url;
        const csrf = btn.dataset.csrf;

        const wishlistCountEls = document.querySelectorAll('.wishlist-count');

        const wasInWishlist = icon.classList.contains('fa-solid');

        // Optimistic UI
        icon.className = wasInWishlist ? 'icon-heart-o' : 'fa-solid fa-heart';
        if (!wasInWishlist) icon.style.color = 'red';

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': csrf,
            },
            body: JSON.stringify({ productId }),
        })
        .then(res => res.json())
        .then(data => {
            // Final UI from backend truth
            if (data.added) {
                icon.className = 'fa-solid fa-heart';
                icon.style.color = 'red';
            } else {
                icon.className = 'icon-heart-o';
                icon.style.color = '';
            }

            wishlistCountEls.forEach(el => {
                el.textContent = data.wishlist_count;
            });
        })
        .catch(() => {
            // rollback
            icon.className = wasInWishlist ? 'fa-solid fa-heart' : 'icon-heart-o';
            if (wasInWishlist) icon.style.color = 'red';
        });
    }

    // expose globally
    window.toggleWishlist = toggleWishlist;

})();
