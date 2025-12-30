(function () {

    function toggleWishlist(event, productId) {
        event.preventDefault();
        event.stopPropagation();

        const clickedBtn = event.currentTarget;
        const url = clickedBtn.dataset.url;
        const csrf = clickedBtn.dataset.csrf;

        // 🔥 SELECT ALL HEARTS FOR THIS PRODUCT
        const allButtons = document.querySelectorAll(
            `.wishlist-card-btn[data-product-id="${productId}"]`
        );

        if (!allButtons.length) return;

        const wasInWishlist = allButtons[0]
            .querySelector('i')
            .classList.contains('fa-solid');

        // ✅ Optimistic UI (update ALL hearts)
        allButtons.forEach(btn => {
            const icon = btn.querySelector('i');
            icon.className = wasInWishlist
                ? 'icon-heart-o'
                : 'fa-solid fa-heart';
            icon.style.color = wasInWishlist ? '' : 'red';
        });

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
            allButtons.forEach(btn => {
                const icon = btn.querySelector('i');
                if (data.added) {
                    icon.className = 'fa-solid fa-heart';
                    icon.style.color = 'red';
                } else {
                    icon.className = 'icon-heart-o';
                    icon.style.color = '';
                }
            });

            document.querySelectorAll('.wishlist-count')
                .forEach(el => el.textContent = data.wishlist_count);
        })
        .catch(() => {
            // rollback on error
            allButtons.forEach(btn => {
                const icon = btn.querySelector('i');
                icon.className = wasInWishlist
                    ? 'fa-solid fa-heart'
                    : 'icon-heart-o';
                icon.style.color = wasInWishlist ? 'red' : '';
            });
        });
    }

    window.toggleWishlist = toggleWishlist;

})();
