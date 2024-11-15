from django import template
from django.urls import reverse

register = template.Library()

@register.inclusion_tag('store/includes/cart_button.html', takes_context=True)
def render_cart_button(context, product):
    request = context['request']
    return {
        'product': product,
        'is_in_cart': product.is_in_cart(request),
        'cart_url': reverse('store_app:cart')
    }