from .models import Category
from .utils import cartData, cookieWishlist
from django.db.models import Count, Q
from django.core.paginator import Paginator, EmptyPage, InvalidPage
from .models import Wishlist


def menu_link(request): # this function don't wanna call to work, it's defined in setting to work
    # Get categories that have at least one product
    links_list = Category.objects.annotate(
        num_products=Count('product', filter=Q(product__active=True))
    ).filter(num_products__gt=0).order_by('priority', 'name')

    paginator3 = Paginator(links_list, 8)
    try:
        page = int(request.GET.get('page', '1'))
    except:
        page = 1

    try:
        links = paginator3.page(page)
    except (InvalidPage, EmptyPage):
        links = paginator3.page(paginator3.num_pages)

    return dict(links=links)


def cart_data(request):
    data = cartData(request)
    cartItems = data['cartItems']
    return {'cartItems': cartItems}


def wishlist_count(request):
    if request.user.is_authenticated:
        wishlist_count = Wishlist.objects.filter(user=request.user).count()
    else:
        cookie_data = cookieWishlist(request)
        wishlist_count = cookie_data['wishlist_count']
    return {'wishlist_count': wishlist_count}
