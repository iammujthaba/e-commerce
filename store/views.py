from django.contrib import messages
from django.shortcuts import get_object_or_404, render, redirect
from django.core.paginator import Paginator, EmptyPage, InvalidPage
from django.http import JsonResponse
import json
from .models import *
from .utils import cartData, cookieWishlist
from django.contrib.auth.decorators import login_required
import logging
from django.views.decorators.csrf import csrf_protect, ensure_csrf_cookie
from django.middleware.csrf import get_token
from django.conf import settings
import razorpay
from decimal import Decimal
from django.db.models import Sum

client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
logger = logging.getLogger(__name__)

def allProdCat(request, c_slug=None):
    c_page = None
    offer = None
    products_list = None
    categories = Category.objects.all().order_by('priority', 'name')  # Get all categories
    
    if c_slug is not None:
        c_page = get_object_or_404(Category, slug=c_slug)
        products_list = Product.objects.filter(category=c_page, active=True, stock__gt=0)
    else:
        products_list = Product.objects.filter(active=True, stock__gt=0)

    if request.user.is_authenticated:
        wishlist_ids = set(
            Wishlist.objects.filter(user=request.user)
            .values_list('product_id', flat=True)
        )
    else:
        cookie_data = cookieWishlist(request)
        wishlist_ids = set(map(int, cookie_data['wishlist_ids']))  # ✅ FIX

    
    offer = Product.objects.filter(active=True, old_price__gt=0, stock__gt=0)
    
    paginator1 = Paginator(products_list, 12)
    
    try:
        page = int(request.GET.get('page', '1'))
    except:
        page = 1
    
    try:
        products = paginator1.page(page)
    except (InvalidPage, EmptyPage):
        products = paginator1.page(paginator1.num_pages)

    message_list = []
    for message in messages.get_messages(request):
        message_list.append({
            'message': message.message,
            'tags': message.tags
        })
    
    return render(request, 'store/category.html', {
        'category': c_page,
        'products': products,
        'wishlist_ids': wishlist_ids,
        'offer': offer,
        'messages': message_list,
        'categories': categories,  # Pass all categories to the template
    })


def proDetail(request, c_slug, product_slug):
    try:
        product = Product.objects.get(category__slug=c_slug, slug=product_slug)

        in_wishlist = is_product_in_wishlist(request, product)

        if request.user.is_authenticated:
            wishlist_count = Wishlist.objects.filter(user=request.user).count()
        else:
            cookie_data = cookieWishlist(request)
            wishlist_count = cookie_data['wishlist_count']

    except Product.DoesNotExist:
        logger.error(f"Product not found: category_slug={c_slug}, product_slug={product_slug}")
        return render(request, 'store/error.html')

    if c_slug:
        c_page = get_object_or_404(Category, slug=c_slug)
        products_list = Product.objects.filter(category=c_page, active=True)
        paginator = Paginator(products_list, 5)
        try:
            page = int(request.GET.get('page', '1'))
        except (ValueError, TypeError):
            page = 1
        try:
            products = paginator.page(page)
        except (InvalidPage, EmptyPage):
            products = paginator.page(paginator.num_pages)

        return render(request, 'store/product.html', {
            'product': product,
            'products': products,
            'in_wishlist': in_wishlist,
            'wishlist_count': wishlist_count
        })
    else:
        return render(request, 'store/product.html', {
            'product': product,
            'in_wishlist': in_wishlist,
            'wishlist_count': wishlist_count
        })


def Category_list(request):
    categorys_list = Category.objects.all().order_by('priority', 'name')
    return render(request, 'store/category_listing.html', {'categorys_list': categorys_list})


def allProductListing(request):
    products_list = Product.objects.filter(active=True)
    categories = Category.objects.all().order_by('priority', 'name')  # Get all categories

    if request.user.is_authenticated:
        wishlist_ids = set(
            Wishlist.objects.filter(user=request.user)
            .values_list('product_id', flat=True)
        )
    else:
        cookie_data = cookieWishlist(request)
        wishlist_ids = set(map(int, cookie_data['wishlist_ids']))  # ✅ FIX
    
    paginator = Paginator(products_list, 18)
    
    try:
        page = int(request.GET.get('page', '1'))
    except:
        page = 1
    
    try:
        products = paginator.page(page)
    except (InvalidPage, EmptyPage):
        products = paginator.page(paginator.num_pages)
    
    return render(request, 'store/shop.html', {
        'products': products,
        'wishlist_ids': wishlist_ids,
        'categories': categories,  # Pass all categories to the template
    })


def offerProductListing(request):
    products_list = Product.objects.filter(old_price__gt=0, active=True)
    categories = Category.objects.all().order_by('priority', 'name')  # Get all categories
    
    paginator = Paginator(products_list, 18)

    if request.user.is_authenticated:
        wishlist_ids = set(
            Wishlist.objects.filter(user=request.user)
            .values_list('product_id', flat=True)
        )
    else:
        cookie_data = cookieWishlist(request)
        wishlist_ids = set(map(int, cookie_data['wishlist_ids']))  # ✅ FIX
    
    try:
        page = int(request.GET.get('page', '1'))
    except:
        page = 1
    
    try:
        products = paginator.page(page)
    except (InvalidPage, EmptyPage):
        products = paginator.page(paginator.num_pages)
    
    return render(request, 'store/shop.html', {
        'products': products,
        'wishlist_ids': wishlist_ids,
        'page': 'offer',
        'categories': categories,  # Pass all categories to the template
    })


def wishlist(request):
    wishlist_items = []

    if request.user.is_authenticated:
        # Fetch wishlist items for authenticated users
        wishlist_objects = Wishlist.objects.filter(user=request.user).select_related('product')
        for item in wishlist_objects:
            product = item.product
            wishlist_items.append({
                'id': product.id,
                'name': product.name,
                'stock': product.stock,
                'image_url': product.imageURL,
                'new_price': product.new_price,
                'old_price': product.old_price,
                'get_url': product.get_url(),
                'discount_percentage': product.get_discounted_price() if product.old_price and product.old_price > product.new_price else None,
                'product': product  # Add the product object for cart_tags
            })
    else:
        # Use cookie data for unauthenticated users
        cookie_data = cookieWishlist(request)
        wishlist_items = cookie_data['wishlist_items']
        # Process each item to ensure consistent structure
        for item in wishlist_items:
            product = Product.objects.get(id=item['id'])
            item.update({
                'get_url': product.get_url(),
                'discount_percentage': (
                    int(round(((item['old_price'] - item['new_price']) / item['old_price']) * 100))
                    if item['old_price'] and item['new_price'] < item['old_price'] 
                    else None
                ),
                'product': product  # Add the product object for cart_tags
            })

    wishlist_count = len(wishlist_items)
    
    return render(request, 'store/Wishlist.html', {
        'wishlist_items': wishlist_items,
        'wishlist_count': wishlist_count,
    })


@csrf_protect
def add_to_wishlist(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        product_id = data.get('productId')

        if request.user.is_authenticated:
            product = Product.objects.get(id=product_id)
            wishlist_item, created = Wishlist.objects.get_or_create(user=request.user, product=product)
            if not created:
                wishlist_item.delete()
                added = False
            else:
                added = True
            wishlist_count = Wishlist.objects.filter(user=request.user).count()
        else:
            wishlist = json.loads(request.COOKIES.get('wishlist', '{}'))
            if str(product_id) in wishlist:
                del wishlist[str(product_id)]
                added = False
            else:
                wishlist[str(product_id)] = True
                added = True
            wishlist_count = len(wishlist)

        response = JsonResponse({'added': added, 'wishlist_count': wishlist_count})

        if not request.user.is_authenticated:
            response.set_cookie('wishlist', json.dumps(wishlist))

        return response

    return JsonResponse({'error': 'Invalid request'}, status=400)


@csrf_protect
def remove_from_wishlist(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        product_id = data.get('productId')

        if request.user.is_authenticated:
            product = Product.objects.get(id=product_id)
            wishlist_item = Wishlist.objects.filter(user=request.user, product=product).first()
            if wishlist_item:
                wishlist_item.delete()
                removed = True
            else:
                removed = False
            wishlist_count = Wishlist.objects.filter(user=request.user).count()
        else:
            wishlist = json.loads(request.COOKIES.get('wishlist', '{}'))
            if str(product_id) in wishlist:
                del wishlist[str(product_id)]
                removed = True
            else:
                removed = False
            wishlist_count = len(wishlist)

        response = JsonResponse({'removed': removed, 'wishlist_count': wishlist_count})

        if not request.user.is_authenticated:
            response.set_cookie('wishlist', json.dumps(wishlist))

        return response

    return JsonResponse({'error': 'Invalid request'}, status=400)


def is_product_in_wishlist(request, product):
    if request.user.is_authenticated:
        return Wishlist.objects.filter(user=request.user, product=product).exists()
    else:
        cookie_data = cookieWishlist(request)
        return str(product.id) in cookie_data['wishlist_ids']


def calculate_shipping(state, items):
    try:
        rate = ShippingRate.objects.get(state=state)
        base_rate = rate.base_rate
        additional_rate = rate.additional_item_rate
    except ShippingRate.DoesNotExist:
        # Default rates for other states
        base_rate = Decimal('180.00')
        additional_rate = Decimal('40.00')

    # Count total quantity of items
    total_quantity = sum(item.quantity if hasattr(item, 'quantity') else item['quantity'] for item in items)

    # Calculate additional charge based on total quantity
    additional_charge = additional_rate * (total_quantity - 1) if total_quantity > 1 else Decimal('0.00')

    total_shipping = base_rate + additional_charge
    return total_shipping


@csrf_protect
def calculate_shipping_ajax(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        state = data.get('state')
        items = data.get('items')
        
        # Convert items to the format expected by calculate_shipping
        formatted_items = [type('obj', (object,), {'quantity': item['quantity']}) for item in items]
        
        shipping_charge = calculate_shipping(state, formatted_items)
        
        return JsonResponse({'shipping_charge': float(shipping_charge)})
    return JsonResponse({'error': 'Invalid request'}, status=400)


@csrf_protect
def updateItem(request):
    data = json.loads(request.body)
    productId = data['productId']
    action = data['action']
    customer = request.user.customer if request.user.is_authenticated else None
    product = Product.objects.get(id=productId)
    order, created = Order.objects.get_or_create(customer=customer, order_created=False, payment_success = False)
    orderItem, created = OrderItem.objects.get_or_create(order=order, product=product)

    added = True
    message = ""

    if action == 'add':
        if orderItem.quantity + 1 <= product.stock:
            orderItem.quantity += 1
            orderItem.save()
        else:
            added = False
            message = "There is no more stock available. If you want more, please contact us."
    elif action == 'remove':
        orderItem.quantity -= 1
        if orderItem.quantity <= 0:
            orderItem.delete()
        else:
            orderItem.save()
    elif action == 'remove-all':
        orderItem.delete()

    cart_total = order.get_cart_total
    cart_items = order.get_cart_items
    total_price_difference = sum((item.product.old_price - item.product.new_price if item.product.old_price else 0) * item.quantity for item in order.orderitem_set.all())

    return JsonResponse({
        'added': added,
        'message': message,
        'cartItems': cart_items,
        'cartTotal': cart_total,
        'totalPriceDifference': total_price_difference,
        'itemQuantity': orderItem.quantity if orderItem.id else 0,
        'itemTotal': orderItem.get_total if orderItem.id else 0,
    }, safe=False)


@ensure_csrf_cookie
def cart(request):
    data = cartData(request)
    # cartItems = data['cartItems']
    order = data['order']
    items = data['items']
    total_price_difference = data['total_price_difference']

    # Get all states for the dropdown
    all_states = ShippingRate.objects.values_list('state', flat=True)

    # Initialize cart_items_data dictionary
    cart_items_data = {}
    
    # Handle both authenticated and unauthenticated users
    if request.user.is_authenticated:
        # For authenticated users, items is a QuerySet of OrderItem objects
        for item in items:
            cart_items_data[item.product.id] = item.quantity
    else:
        # For unauthenticated users, items is a list of dictionaries
        for item in items:
            cart_items_data[item['product']['id']] = item['quantity']

    # Get the selected state or use the saved state for returning customers
    selected_state = request.GET.get('state')
    if not selected_state and request.user.is_authenticated:
        last_shipping = ShippingAddress.objects.filter(customer=request.user.customer).order_by('-date_added').first()
        if last_shipping:
            selected_state = last_shipping.state

    # Calculate shipping
    shipping_charge = calculate_shipping(selected_state, items) if selected_state else Decimal('0.00')

    message_list = []
    for message in messages.get_messages(request):
        message_list.append({
            'message': message.message,
            'tags': message.tags
        })

    show_old_cart_alert = request.session.pop('show_old_cart_alert', False)

    context = {
        'items': items,
        'order': order,
        'messages': message_list,
        # 'cartItems': cartItems,
        'show_old_cart_alert': show_old_cart_alert,
        'total_price_difference': total_price_difference,
        'all_states': all_states,
        'selected_state': selected_state,
        'shipping_charge': shipping_charge,
        'cart_items_data': json.dumps(cart_items_data),
    }

    return render(request, 'store/Cart.html', context)


@csrf_protect
def checkout(request):

    all_states = ShippingRate.objects.values_list('state', flat=True)
            
    if request.user.is_authenticated:
        customer = request.user.customer
        
        if request.method == 'POST':
            # Capture the form data and validate each field
            shipping_info = {
                'number': request.POST.get('number'),
                'whatsapp': request.POST.get('whatsapp'),
                'address': request.POST.get('address'),
                'city': request.POST.get('city'),
                'state': request.POST.get('state'),
                'zipcode': request.POST.get('zipcode'),
            }

            # Validate that all fields are provided (you can add more validation if needed)
            if not all(shipping_info.values()):
                # If any field is empty, redirect with an error message
                return render(request, 'store/Checkout.html', {
                    'error_message': 'All fields are required.',
                    'last_shipping': shipping_info,
                    'all_states': all_states,
                })

            # Store shipping info in session
            request.session['shipping_info'] = shipping_info
            
            # Redirect to the payment page
            return redirect('store_app:payment')

        # Fetch the last saved address for pre-filling
        last_shipping = ShippingAddress.objects.filter(customer=customer).order_by('-date_added').first()
        
        context = {
            'last_shipping': last_shipping,
            'all_states': all_states,
            'customer_number': customer.contact_number,
        }
        return render(request, 'store/Checkout.html', context)
    else:
        return redirect('auth_app:account_info')


@csrf_protect
def payment(request):
    if not request.user.is_authenticated:
        return redirect('store_app:account_info')

    try:
        # Fetch cart and order data
        data = cartData(request)
        order = data['order']
        items = data['items']

        # Retrieve shipping info from session
        shipping_addres = request.session.get('shipping_info', {})

        # Calculate shipping charge and total price
        shipping_charge = calculate_shipping(shipping_addres.get('state'), items)
        order.total_price = order.get_cart_total + shipping_charge
        order.Shipping_charge = shipping_charge
        order.save()

        # Check if a PaymentRecord with 'Incomplete' status already exists for this order
        payment_record = PaymentRecord.objects.filter(
            order=order,
            payment_status='Incomplete'
        ).first()

        # Create or update Razorpay order
        if not payment_record or payment_record.amount != order.total_price:
            # If the total price has changed or there's no existing record, create a new Razorpay order
            razorpay_order = client.order.create({
                'amount': int(order.total_price * 100),  # Amount in paise
                'currency': 'INR',
                'payment_capture': '1',
                "receipt": f"order_rcptid_{order.id}"
            })

            # Create or update PaymentRecord
            if not payment_record:
                payment_record = PaymentRecord.objects.create(
                    order=order,
                    razorpay_order_id=razorpay_order['id'],
                    payment_status='Incomplete',
                    amount=order.total_price,
                    details="Waiting for payment."
                )
            else:
                # Update existing PaymentRecord
                payment_record.razorpay_order_id = razorpay_order['id']
                payment_record.amount = order.total_price
                payment_record.details = "Waiting for payment."
                payment_record.save()
        
        context = {
            'items': items,
            'order': order,
            'shipping_addres': shipping_addres,
            'shipping_charge': shipping_charge,
            'razorpay_key_id': settings.RAZORPAY_KEY_ID,
            'razorpay_order_id': payment_record.razorpay_order_id,
            'csrf_token': get_token(request),
        }

        return render(request, 'store/payment.html', context)

    except razorpay.errors.BadRequestError as e:
        logger.error(f"Razorpay BadRequestError: {str(e)}")
        messages.error(request, "There was an issue with the payment request. Please try again.")
    except razorpay.errors.ServerError as e:
        logger.error(f"Razorpay ServerError: {str(e)}")
        messages.error(request, "The payment gateway is currently experiencing issues. Please try again later.")
    except Exception as e:
        logger.exception(f"Unexpected error during payment processing: {str(e)}")
        messages.error(request, "An unexpected error occurred!, Please Check Your internet connection and Please try again.")

    # Redirect back to the checkout page if any error occurs
    return redirect('store_app:cart')

# order validation and creation
# this function only work after successfull peyment
@csrf_protect
def processOrder(request):
    if request.method != 'POST':
        return JsonResponse({'success': False, 'message': 'Invalid request method.'})

    if not request.user.is_authenticated:
        return JsonResponse({'success': False, 'message': 'User not authenticated.'})
    
    data = json.loads(request.body)
    razorpay_payment_id = data.get('razorpay_payment_id')
    razorpay_order_id = data.get('razorpay_order_id')
    razorpay_signature = data.get('razorpay_signature')

    # Fetch order details from the database
    customer = request.user.customer
    payment_record = PaymentRecord.objects.get(razorpay_order_id=razorpay_order_id)
    payment_record.payment_status = 'Payment Successful'
    payment_record.save()

    order = payment_record.order  # Access the related order
    order.payment_success = True
    order.save()

    try:
        total = payment_record.order.total_price

        if not all([razorpay_payment_id, razorpay_order_id, razorpay_signature]):
            payment_record = PaymentRecord.objects.get(
                order=order,
                razorpay_order_id=razorpay_order_id,
            )
            payment_record.payment_status='Payment Successful'
            payment_record.amount=total
            payment_record.details="Missing payment information."
            payment_record.razorpay_payment_id = razorpay_payment_id
            payment_record.save()
            return JsonResponse({'success': False, 'message': 'Missing Razorpay payment information.'})

        # Verify the payment signature
        try:
            client.utility.verify_payment_signature({
                'razorpay_order_id': razorpay_order_id,
                'razorpay_payment_id': razorpay_payment_id,
                'razorpay_signature': razorpay_signature,
            })
        except razorpay.errors.SignatureVerificationError:
            payment_record = PaymentRecord.objects.get(
                order=order,
                razorpay_order_id=razorpay_order_id,
            )
            payment_record.payment_status='Payment Successful'
            payment_record.amount=total
            payment_record.details="Invalid payment signature."
            payment_record.razorpay_payment_id = razorpay_payment_id
            payment_record.save()
            return JsonResponse({'success': False, 'message': 'Invalid payment signature.'})

    
        if PaymentRecord.objects.filter(razorpay_payment_id=razorpay_payment_id).exists():
            payment_record = PaymentRecord.objects.get(
                order=order,
                razorpay_order_id=razorpay_order_id,
            )
            payment_record.payment_status='Payment Successful'
            payment_record.amount=total
            payment_record.details="razorpay ID already exists."
            payment_record.razorpay_payment_id = razorpay_payment_id
            payment_record.save()
            return JsonResponse({'success': False, 'message': 'This payment has already been processed.'})

        # Fetch payment details to verify amount
        payment_details = client.payment.fetch(razorpay_payment_id)
        paid_amount = Decimal(payment_details['amount']) / 100  # Convert paise to INR

        if paid_amount != Decimal(order.total_price):
            payment_record = PaymentRecord.objects.get(
                order=order,
                razorpay_order_id=razorpay_order_id,
            )
            payment_record.payment_status='Payment Successful'
            payment_record.amount=total
            payment_record.details="Payment total mismatch."
            payment_record.razorpay_payment_id = razorpay_payment_id
            payment_record.save()
            return JsonResponse({'success': False, 'message': 'Payment amount mismatch'})

        # Payment Success
        # order.razorpay_payment_id = razorpay_payment_id
        order.order_created = True
        order.status = 'Order Placed'
        order.placed_time = timezone.now()
        order.save()

        payment_record.payment_status='Payment Successful'
        payment_record.amount=total
        payment_record.details="Order successful."
        payment_record.razorpay_payment_id = razorpay_payment_id
        payment_record.save()

        # saving shipping address
        ShippingAddress.objects.create(
            customer=customer,
            order=order,
            number=data.get('number'),
            whatsapp=data.get('whatsapp'),
            address=data.get('address'),
            city=data.get('city'),
            state=data.get('state'),
            zipcode=data.get('zipcode'),
        )

        # substracting order items from product quntity
        items = order.orderitem_set.all()
        for item in items:
            product = item.product
            product.stock -= item.quantity
            product.save()

        PurchaseHistory.objects.create(
            customer=customer,
            product=product,
            price_at_purchase=item.price_at_purchase
        )

        # Clear the cart
        if 'cart' in request.session:
            del request.session['cart']
            request.session.modified = True
        # request.session.modified = True 
        # (Chat GPT ofter requsted to make this line under 'if' conditon [i dont know why])

        logger.info(f"Order {order.id} placed successfully")
        return JsonResponse({'success': True, 'message': f'Your Order placed successfully!'})

    except PaymentRecord.DoesNotExist:
        return JsonResponse({'success': False, 'message': 'Payment record not found.'})

    except Exception as e:
        return JsonResponse({'success': False, 'message': f'An error occurred: {str(e)}'})


def payment_cards(request):
    if not request.user.is_authenticated:
        return redirect('auth_app:login')

    payment_records = PaymentRecord.objects.filter(order__customer=request.user.customer).order_by('-created_at')
    return render(request, 'store/payment_cards.html', {'payment_records': payment_records})

def payment_details(request, payment_id):
    if not request.user.is_authenticated:
        return redirect('auth_app:login')
    
    payment_record = get_object_or_404(PaymentRecord, id=payment_id, order__customer=request.user.customer)
    return render(request, 'store/payment_details.html', {'payment_record': payment_record})


def myorders(request):
    if not request.user.is_authenticated:
        return redirect('auth_app:login')

    customer = request.user.customer
    orders = Order.objects.filter(customer=customer, order_created=True, payment_success=True).order_by('-date_ordered')

    orders_with_details = []
    for order in orders:
        total_quantity = OrderItem.objects.filter(order=order).aggregate(Sum('quantity'))['quantity__sum']

        orders_with_details.append({
            'order': order,
            'total_quantity': total_quantity or 0,
            'total_amount': order.total_price,
            'date_ordered': order.date_ordered,
            'status': order.status,
        })

    context = {
        'user': request.user,
        'orders_with_details': orders_with_details,
    }
    return render(request, 'store/myorder.html', context)


def updateOrderStatus(request, order_id):
    if request.method == "POST":
        status = request.POST.get("status")
        order = get_object_or_404(Order, id=order_id)
        order.status = status
        order.save()
        messages.success(request, f"Order status updated to {status}")
        return redirect('some_view_to_redirect_to')
    else:
        return redirect('some_view_to_redirect_to')


@login_required
def trackOrder(request, order_id):
    if not request.user.is_authenticated:
        return redirect('auth_app:login')

    order = get_object_or_404(Order, id=order_id, customer=request.user.customer)
    order_items = OrderItem.objects.filter(order=order)
    shipping_address = ShippingAddress.objects.filter(order=order).first()

    context = {
        'order': order,
        'order_items': order_items,
        'shipping_address': shipping_address,
    }
    return render(request, 'store/trackOrder.html', context)


def account_info(request):
    if not request.user.is_authenticated:
        return redirect('auth_app:loginOrRegister')

    customer = request.user.customer
    last_shipping = ShippingAddress.objects.filter(customer=customer).order_by('-date_added').first()

    context = {
        'user': customer.name,
        'number': customer.contact_number,
        'shipping_info': last_shipping,
    }
    return render(request, 'store/account_info.html', context)

def terms_and_conditions(request):
    return render(request, 'resources/terms_and_conditions.html')

def refund_policy(request):
    return render(request, 'resources/refunds.html')

def shipping_info(request):
    return render(request, 'resources/shipment.html')

def privacy_policy(request):
    return render(request, 'resources/privacy.html')

def about(request):
    return render(request, 'resources/about.html')

def gallery(request):
    return render(request, 'resources/gallery.html')

def contact(request):
    return render(request, 'resources/contact.html')

def faq(request):
    return render(request, 'resources/faq.html')

def devolopper(request):
    return render(request, 'resources/About_Devolopper.html')

