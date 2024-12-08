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
    
    offer_list = Product.objects.filter(active=True, old_price__gt=0, stock__gt=0)
    
    paginator1 = Paginator(products_list, 6)
    paginator2 = Paginator(offer_list, 6)
    
    try:
        page = int(request.GET.get('page', '1'))
    except:
        page = 1
    
    try:
        products = paginator1.page(page)
        offer = paginator2.page(page)
    except (InvalidPage, EmptyPage):
        products = paginator1.page(paginator1.num_pages)
        offer = paginator2.page(paginator2.num_pages)
    
    message_list = []
    for message in messages.get_messages(request):
        message_list.append({
            'message': message.message,
            'tags': message.tags
        })
    
    return render(request, 'store/category.html', {
        'category': c_page,
        'products': products,
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
    
    paginator = Paginator(products_list, 14)
    
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
        'categories': categories,  # Pass all categories to the template
    })


def offerProductListing(request):
    products_list = Product.objects.filter(old_price__gt=0, active=True)
    categories = Category.objects.all().order_by('priority', 'name')  # Get all categories
    
    paginator = Paginator(products_list, 14)
    
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
        return str(product.id) in cookie_data['wishlist_items']


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
    order, created = Order.objects.get_or_create(customer=customer, complete=False)
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

    context = {
        'items': items,
        'order': order,
        # 'cartItems': cartItems,
        'total_price_difference': total_price_difference,
        'all_states': all_states,
        'selected_state': selected_state,
        'shipping_charge': shipping_charge,
        'cart_items_data': json.dumps(cart_items_data),
    }

    print('................first Order.................')
    print('order_id: ',order.order_id)
    print('order_created: ',order.order_created)
    print('complete: ',order.complete)
    print('total_price: ',order.total_price)
    print('Shipping_charge: ',order.Shipping_charge)
    print('status: ',order.status)
    print('date_ordered: ',order.date_ordered)
    print()

    return render(request, 'store/Cart.html', context)


@csrf_protect
def checkout(request):
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
                    
                    'frequent_customer_areas': ["Kerala", "Karnataka", "Tamil Nadu"],
                    'other_states': [
                        "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", 
                        "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh",
                        "Jharkhand", "Madhya Pradesh", "Maharashtra", "Manipur", 
                        "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", 
                        "Rajasthan", "Sikkim", "Telangana", "Tripura", 
                        "Uttar Pradesh", "Uttarakhand", "West Bengal"
                    ],
                })

            # Store shipping info in session
            request.session['shipping_info'] = shipping_info
            
            # Redirect to the payment page
            return redirect('store_app:payment')

        # Fetch the last saved address for pre-filling
        last_shipping = ShippingAddress.objects.filter(customer=customer).order_by('-date_added').first()
        
        context = {
            'last_shipping': last_shipping,
            'frequent_customer_areas': ["Kerala", "Karnataka", "Tamil Nadu"],
            'other_states': [
                "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", 
                "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh",
                "Jharkhand", "Madhya Pradesh", "Maharashtra", "Manipur", 
                "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", 
                "Rajasthan", "Sikkim", "Telangana", "Tripura", 
                "Uttar Pradesh", "Uttarakhand", "West Bengal"
            ],
        }
        return render(request, 'store/Checkout.html', context)
    else:
        return redirect('store_app:account_info')


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

        # Create a Razorpay order
        razorpay_order = client.order.create({
            'amount': int(order.total_price * 100),  # Amount in paise
            'currency': 'INR',
            'payment_capture': '1',
            "receipt": f"order_rcptid_{order.id}"
        })

        # Create a new PaymentRecord
        payment_record = PaymentRecord.objects.create(
            order=order,
            razorpay_order_id=razorpay_order['id'],
            payment_status='Incomplete',
            amount=order.total_price
        )


        print('................second Order.................')
        print('order_id: ',order.order_id)
        print('order_created: ',order.order_created)
        print('complete: ',order.complete)
        print('total_price: ',order.total_price)
        print('Shipping_charge: ',order.Shipping_charge)
        print('status: ',order.status)
        print('date_ordered: ',order.date_ordered)
        print()
        print('................first PaymentRecord.................')
        print('razorpay_order_id: ',payment_record.razorpay_order_id)
        print('razorpay_payment_id: ',payment_record.razorpay_payment_id)
        print('payment_status: ',payment_record.payment_status)
        print('amount: ',payment_record.amount)
        print('created_at: ',payment_record.created_at)
        print('details: ',payment_record.details)
        print('.....................................')


        context = {
            'items': items,
            'order': order,
            'shipping_addres': shipping_addres,
            'shipping_charge': shipping_charge,
            'razorpay_key_id': settings.RAZORPAY_KEY_ID,
            'razorpay_order_id': payment_record.razorpay_order_id,
            'total_amount': order.total_price,
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
        logger.exception("Unexpected error during payment processing")
        messages.error(request, "An unexpected error occurred. Please Check Your internet connection Or Please try again later.")

    # Redirect back to the checkout page if any error occurs
    return redirect('store_app:payment')

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
    payment_record.payment_status = 'Success'
    order = payment_record.order  # Access the related order
    # order = Order.objects.get(customer=customer, complete=False, razorpay_order_id=razorpay_order_id)

    try:
        total = payment_record.order.total_price
        # payment_record.payment_status = 'Success'
        payment_record.save()

        order.complete = False
        order.order_created = False
        order.save()

        if not all([razorpay_payment_id, razorpay_order_id, razorpay_signature]):
            PaymentRecord.objects.create(
                order=order,
                razorpay_order_id=razorpay_order_id,
                payment_status='Success',
                amount=total,
                details="Missing payment information."
            )
            return JsonResponse({'success': False, 'message': 'Missing Razorpay payment information.'})

        # Verify the payment signature
        try:
            client.utility.verify_payment_signature({
                'razorpay_order_id': razorpay_order_id,
                'razorpay_payment_id': razorpay_payment_id,
                'razorpay_signature': razorpay_signature,
            })
        except razorpay.errors.SignatureVerificationError:
            PaymentRecord.objects.create(
                order=order,
                razorpay_order_id=razorpay_order_id,
                payment_status='Success',
                amount=total,
                details="Invalid payment signature."
            )
            return JsonResponse({'success': False, 'message': 'Invalid payment signature.'})

    
        if PaymentRecord.objects.filter(razorpay_payment_id=razorpay_payment_id).exists():
            PaymentRecord.objects.create(
                order=order,
                razorpay_order_id=razorpay_order_id,
                payment_status='Success',
                amount=total,
                details="razorpay ID already exists."
            )
            return JsonResponse({'success': False, 'message': 'This payment has already been processed.'})

        # Fetch payment details to verify amount
        payment_details = client.payment.fetch(razorpay_payment_id)
        paid_amount = Decimal(payment_details['amount']) / 100  # Convert paise to INR

        if paid_amount != Decimal(order.total_price):
            PaymentRecord.objects.create(
                order=order,
                razorpay_order_id=razorpay_order_id,
                payment_status='Success',
                amount=total,
                details="Payment total mismatch."
            )
            return JsonResponse({'success': False, 'message': 'Payment amount mismatch'})

        # Payment Success
        # order.razorpay_payment_id = razorpay_payment_id
        order.complete = True
        order.order_created = True
        order.status = 'Order Placed'
        order.placed_time = timezone.now()
        order.save()

        # payment_record.payment_status = 'Success'
        payment_record.razorpay_payment_id = razorpay_payment_id
        payment_record.details = "Order successful."
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

        print('................last Order.................')
        print('order_id: ',order.order_id)
        print('order_created: ',order.order_created)
        print('complete: ',order.complete)
        print('total_price: ',order.total_price)
        print('Shipping_charge: ',order.Shipping_charge)
        print('status: ',order.status)
        print('date_ordered: ',order.date_ordered)
        print()
        print('................last PaymentRecord.................')
        print('razorpay_order_id: ',payment_record.razorpay_order_id)
        print('razorpay_payment_id: ',payment_record.razorpay_payment_id)
        print('payment_status: ',payment_record.payment_status)
        print('amount: ',payment_record.amount)
        print('created_at: ',payment_record.created_at)
        print('details: ',payment_record.details)
        print('.....................................')

        # Clear the cart
        if 'cart' in request.session:
            del request.session['cart']
            request.session.modified = True
        # request.session.modified = True 
        # (Chat GPT ofter requsted to make this line under 'if' conditon [i dont know why])

        logger.info(f"Order {order.id} placed successfully")
        return JsonResponse({'success': True, 'message': f'{payment_record.razorpay_order_id} \n Order placed successfully!'})

    except PaymentRecord.DoesNotExist:
        return JsonResponse({'success': False, 'message': 'Payment record not found.'})

    except Exception as e:
        return JsonResponse({'success': False, 'message': f'An error occurred: {str(e)}'})

@login_required
def payment_status(request):
    if not request.user.is_authenticated:
        return redirect('auth_app:login')
    
    orders = Order.objects.filter(customer=request.user.customer).order_by('-date_ordered')
    payment_records = PaymentRecord.objects.filter(order__in=orders).order_by('-created_at')
    
    context = {'orders': orders, 'payment_records': payment_records}
    return render(request, 'store/payment_status.html', context)

def myorders(request):
    if not request.user.is_authenticated:
        return redirect('auth_app:login')

    customer = request.user.customer

    if request.path == '/delivered/':
        orders = Order.objects.filter(customer=customer, complete=True, status='Product Delivered').order_by('-date_ordered')
    else:
        orders = Order.objects.filter(customer=customer, complete=True).exclude(status='Product Delivered').order_by('-date_ordered')

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
        'user': request.user,
        'shipping_info': last_shipping,
    }
    return render(request, 'store/account_info.html', context)


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

