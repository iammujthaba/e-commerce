from django import template
from django.urls import reverse

register = template.Library()

@register.inclusion_tag('store/includes/cart_button.html', takes_context=True)
def render_cart_button(context, product):
    request = context['request']
    template_name = context.get('request').resolver_match.url_name
    return {
        'product': product,
        'is_in_cart': product.is_in_cart(request),
        'cart_url': reverse('store_app:cart'),
        'template_name': template_name
    }