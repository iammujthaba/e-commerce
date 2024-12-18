from .views import get_order_counts

def order_counts_context(request):
    if request.user.is_authenticated and request.user.is_staff:
        return {"order_counts": get_order_counts(request)}
    return {}
