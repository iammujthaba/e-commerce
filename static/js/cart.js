document.addEventListener('DOMContentLoaded', function() {
    var updateBtns = document.getElementsByClassName('update-cart');
    for (var i = 0; i < updateBtns.length; i++) {
        updateBtns[i].addEventListener('click', function() {
            var productId = this.dataset.product;
            var action = this.dataset.action;
            var stock = parseInt(this.dataset.quantity);
            var currentQuantity = 1;  // Always set to 1 for 'add' and 'remove' actions

            // Only get the actual quantity for 'remove-all' action
            if (action === 'remove-all') {
                var quantityInput = this.closest('.card-body') ? 
                    this.closest('.card-body').querySelector('.cart-quantity') : 
                    document.getElementById('cart-quantity');
                
                if (quantityInput) {
                    currentQuantity = parseInt(quantityInput.value) || 1;
                }
            }

            console.log('productId:', productId, 'Action:', action, 'stock:', stock, 'currentQuantity:', currentQuantity);
            console.log('USER:', user);

            if (user === 'AnonymousUser') {
                addCookieItem(productId, action, stock, currentQuantity);
            } else {
                updateUserOrder(productId, action, currentQuantity);
            }
        });
    }
});

document.addEventListener('DOMContentLoaded', function() {
    // Initialize button states based on cart contents
    const cartData = document.getElementById('cart-data');
    if (cartData) {
        const cartItems = JSON.parse(cartData.dataset.cartItems || '{}');
        for (const productId in cartItems) {
            updateButtonState(productId, true);
        }
    }
});

function updateUserOrder(productId, action, currentQuantity = NaN) {
    console.log('User is authenticated, sending data...');
    var url = '/update_item/';
    
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrftoken,
        },
        body: JSON.stringify({
            'productId': productId,
            'action': action,
            'currentQuantity': currentQuantity
        })
    })
    .then(response => response.json())
    .then(data => {
        console.log('Data:', data);
        if (data.added == false) {
            showWarningAlert(data.message, () => {
                // Code to execute if the user confirms the alert
            });
            return;
        } else {
            updateCartCount(data.cartItems);
            updateCartTotal(data.cartTotal);
            updateTotalPriceDifference(data.totalPriceDifference);
            updateTotalWithShipping();

            // Update button state after successful addition
            if (action === 'add') {
                updateButtonState(productId, true);
            } else if (action === 'remove-all') {
                updateButtonState(productId, false);
            }

            if (data.itemQuantity <= 0) {
                removeCartItem(productId);
            } else {
                updateCartItemQuantity(productId, data.itemQuantity);
                updateCartItemTotal(productId, data.itemTotal);
            }

            if (data.cartItems === 0) {
                showEmptyCartMessage();
            }
        }
    });
}

// Add new function to update button state
function updateButtonState(productId, isInCart) {
    const buttons = document.querySelectorAll(`button[data-product="${productId}"]`);
    buttons.forEach(button => {
        const container = button.parentElement;
        if (isInCart) {
            const viewCartBtn = document.createElement('a');
            viewCartBtn.href = '/cart/';
            viewCartBtn.className = 'btn btn-success btn-lg btn-block view-cart-btn';
            viewCartBtn.textContent = 'View on Cart';
            container.replaceChild(viewCartBtn, button);
        } else {
            const addCartBtn = document.createElement('button');
            addCartBtn.dataset.quantity = button.dataset.quantity;
            addCartBtn.dataset.product = productId;
            addCartBtn.dataset.action = 'add';
            addCartBtn.className = 'btn btn-primary btn-lg btn-block add-to-cart add-btn update-cart';
            addCartBtn.textContent = 'Add to Cart';
            container.replaceChild(addCartBtn, button);
            addCartBtn.addEventListener('click', updateCartHandler);
        }
    });
}

function updateShippingCharge() {
    let state = document.getElementById('state').value;
    if (!state) return;
    let items = [];
    document.querySelectorAll('.card[data-product-id]').forEach(card => {
        let productId = card.getAttribute('data-product-id');
        let quantity = parseInt(card.querySelector('.cart-quantity').value);
        items.push({productId, quantity});
    });
    fetch('/calculate-shipping/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCookie('csrftoken')
        },
        body: JSON.stringify({state, items})
    })
    .then(response => response.json())
    .then(data => {
        document.querySelector('.shipping-charge').textContent = '₹ ' + data.shipping_charge.toFixed(2);
        updateTotalWithShipping();
    });
}

function updateTotalWithShipping() {
    let cartTotal = parseFloat(document.querySelector('.cart-total').textContent.replace('₹', ''));
    let shippingCharge = parseFloat(document.querySelector('.shipping-charge').textContent.replace('₹', '')) || 0;
    let total = cartTotal + shippingCharge;
    document.querySelector('.cart-total-with-shipping').textContent = '₹ ' + total.toFixed(2);
}

function updateCartTotal(total) {
    const cartTotalElements = document.querySelectorAll('.cart-total');
    cartTotalElements.forEach(el => {
        el.textContent = '₹ ' + parseFloat(total).toFixed(2);
    });
}

function updateTotalPriceDifference(difference) {
    const savingsElement = document.querySelector('.total-price-difference');
    if (savingsElement) {
        savingsElement.textContent = '₹ ' + parseFloat(difference).toFixed(2);
    }
}

function updateCartItemTotal(productId, total) {
    const totalElement = document.querySelector(`[data-product-id="${productId}"] .item-total`);
    if (totalElement) {
        totalElement.textContent = '₹ ' + parseFloat(total).toFixed(2);
    }
}

function updateCartTotalWithShipping(total) {
    const shippingCost = 0; // shipping cost is always 0 as default
    const totalWithShipping = parseFloat(total) + shippingCost;
    const totalWithShippingElement = document.querySelector('.cart-total-with-shipping');
    if (totalWithShippingElement) {
        totalWithShippingElement.textContent = '₹ ' + totalWithShipping.toFixed(2);
    }
}

function updateCartDataForUnauthorizedUser() {
    let cartItems = getCartItemCount();
    updateCartCount(cartItems);
    updateCartTotals();
    updateCartItemsDisplay();
}

function updateCartItemsDisplay() {
    const cartContainer = document.querySelector('.cart-items-container');
    if (!cartContainer) return;

    let cartHTML = '';
    let cartTotal = 0;
    let totalPriceDifference = 0;

    for (let productId in cart) {
        const product = getProductDetails(productId);
        if (product) {
            const quantity = cart[productId]['quantity'];
            const itemTotal = quantity * product.new_price;
            cartTotal += itemTotal;
            const priceDifference = (product.old_price - product.new_price) * quantity;
            totalPriceDifference += priceDifference;

            cartHTML += `
                <div class="card mb-3" data-product-id="${product.id}">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div class="d-flex flex-row align-items-center">
                                <div class="ms-3">
                                    <h5>${product.name}</h5>
                                </div>
                            </div>
                            <div class="d-flex flex-row align-items-center">
                                <div style="width: 50px;">
                                    <h5 class="fw-normal mb-0">${quantity}</h5>
                                </div>
                                <div style="width: 80px;">
                                    <h5 class="mb-0 item-total">₹ ${itemTotal.toFixed(2)}</h5>
                                </div>
                                <a href="#!" style="color: #cecece;"><i class="fas fa-trash-alt"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }
    }

    cartContainer.innerHTML = cartHTML;
    updateCartTotal(cartTotal);
    updateTotalPriceDifference(totalPriceDifference);
    updateCartTotalWithShipping(cartTotal);
}

function getProductDetails(productId) {
    const productCard = document.querySelector(`.card[data-product-id="${productId}"]`);
    if (productCard) {
        return {
            id: productId,
            name: productCard.dataset.productName,
            new_price: parseFloat(productCard.dataset.productNewPrice),
            old_price: parseFloat(productCard.dataset.productOldPrice),
            stock: parseInt(productCard.dataset.productStock)
        };
    }
    return null;
}

function addCookieItem(productId, action, stock, currentQuantity = 1) {
    console.log('User is not authenticated');
    console.log('productId:', productId, 'Action:', action, 'stock:', stock, 'currentQuantity:', currentQuantity);

    if (action == 'add') {
        if (cart[productId] == undefined) {
            cart[productId] = {'quantity': 0};
        }
        if (cart[productId]['quantity'] + 1 <= stock) {
            cart[productId]['quantity'] += 1;
            // Update button state after successful addition
            updateButtonState(productId, true);
        } else {
            showWarningAlert('There is no more stock available. If you want more, please contact us.', () => {
                // Code to execute if the user confirms the alert
            });
            return;
        }
    }

    if (action == 'remove') {
        if (cart[productId] && cart[productId]['quantity'] > 0) {
            cart[productId]['quantity'] -= 1;
            if (cart[productId]['quantity'] <= 0) {
                console.log('Item should be deleted');
                delete cart[productId];
                removeCartItem(productId);
            }
        }
    }

    if (action == 'remove-all') {
        delete cart[productId];
        removeCartItem(productId);
    }

    console.log('CART:', cart);
    document.cookie = 'cart=' + JSON.stringify(cart) + ";domain=;path=/";
    
    updateCartDataForUnauthorizedUser();
    updateCartItemQuantity(productId, cart[productId] ? cart[productId]['quantity'] : 0);
    updateCartTotals();
    updateTotalWithShipping();

    if (Object.keys(cart).length === 0) {
        showEmptyCartMessage();
    }
}

function updateCartTotals() {
    let cartTotal = 0;
    let totalPriceDifference = 0;
    for (let productId in cart) {
        const product = getProductDetails(productId);
        if (product) {
            const quantity = cart[productId]['quantity'];
            cartTotal += quantity * product.new_price;
            totalPriceDifference += quantity * (product.old_price - product.new_price);
        }
    }
    updateCartTotal(cartTotal);
    updateTotalPriceDifference(totalPriceDifference);
    updateTotalWithShipping();
}

// Make sure to call updateCartDataForUnauthorizedUser on page load for unauthorized users
document.addEventListener('DOMContentLoaded', function() {
    if (user === 'AnonymousUser' && (
        document.querySelector('.cart-count') ||
        document.querySelector('.cart-total') ||
        document.querySelector('.total-price-difference') ||
        document.querySelector('.cart-total-with-shipping')
    )) {
        updateCartDataForUnauthorizedUser();
    }
});

// Add event listener for state change
document.addEventListener('DOMContentLoaded', function() {
    const stateSelect = document.getElementById('state');
    if (stateSelect) {
        stateSelect.addEventListener('change', updateShippingCharge);
    }
});

function updateCartCount(cartItems) {
    const cartCountElements = document.querySelectorAll('.cart-count');
    cartCountElements.forEach(el => {
        el.textContent = cartItems;
        el.dataset.cartItems = cartItems;
    });
}

function getCartItemCount() {
    var totalItems = 0;
    for (var key in cart) {
        if (cart.hasOwnProperty(key)) {
            totalItems += cart[key].quantity;
        }
    }
    return totalItems;
}

function removeCartItem(productId) {
    var cartItem = document.querySelector(`[data-product="${productId}"]`).closest('.card');
    if (cartItem) {
        cartItem.remove();
    }

    // Check if cart is empty after removing the item
    const remainingItems = document.querySelectorAll('.card[data-product-id]');
    if (remainingItems.length === 0) {
        showEmptyCartMessage();
    }
}

function showEmptyCartMessage() {
    const cartContainer = document.querySelector('.empty-cart-message');
    cartContainer.innerHTML = `
	<div>
		<div class="text-center mb-3">
			<br>
			<h2>Your shopping cart is empty.</h2>
			<p class="mt-4">Please click <a href="{% url 'store_app:allProdCat' %}"><b>here</b></a> to
				continue shopping.</p>
		</div>
	</div>
    `;
}

function updateCartItemQuantity(productId, quantity) {
    var quantityInput = document.querySelector(`[data-product-id="${productId}"] .cart-quantity`);
    if (quantityInput) {
        quantityInput.value = quantity;
    }

    // Update item total
    const product = getProductDetails(productId);
    if (product) {
        const itemTotal = quantity * product.new_price;
        updateCartItemTotal(productId, itemTotal);
    }
}

function showWarningAlert(message, callback) {
    Swal.fire({
        icon: "warning",
        title: "Warning...",
        text: message,
    }).then((result) => {
        if (result.isConfirmed) {
            callback();
        }
    });
}
