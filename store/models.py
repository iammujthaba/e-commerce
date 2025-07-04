import json
from django.db import models
from django.contrib.auth.models import User
from django.urls import reverse
from django.utils import timezone
from django.core.exceptions import ValidationError
from django.core.validators import MinValueValidator
from django.utils.text import slugify
import uuid
# from django import forms


class Category(models.Model):
    name = models.CharField(max_length=250, unique=True)
    slug = models.SlugField(max_length=250, unique=True, blank=True)  # Make blank=True
    image = models.ImageField(upload_to='category', blank=True)
    priority = models.IntegerField(default=0, validators=[MinValueValidator(0)])

    class Meta:
        ordering = ['priority', 'name']
        verbose_name = 'category'
        verbose_name_plural = 'categories'  # Fixed typo: 'categorys' to 'categories'

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = self._generate_unique_slug()
        super().save(*args, **kwargs)

    def _generate_unique_slug(self):
        base_slug = slugify(self.name)
        unique_slug = base_slug
        num = 1
        while Category.objects.filter(slug=unique_slug).exists():
            unique_slug = f"{base_slug}-{num}"
            num += 1
        return unique_slug

    def get_url(self):
        return reverse('store_app:product_by_category', args=[self.slug])

    def __str__(self):
        return self.name


class Product(models.Model):

    PRODUCT_STATUS_CHOICES = [
        ('in_stock', 'In Stock'),
        ('out_of_stock', 'Out of Stock'),
    ]
        
    name = models.CharField(max_length=250, unique=True)
    slug = models.SlugField(max_length=250, unique=True, blank=True)  # Make blank=True
    description = models.TextField(blank=True)
    old_price = models.DecimalField(max_digits=7, blank=True, null=True, decimal_places=0) # change model name to MRP
    new_price = models.DecimalField(max_digits=7, blank=False, decimal_places=0) # change model name to MOP
    category = models.ForeignKey(Category, on_delete=models.SET_NULL, null=True)
    image_1 = models.ImageField(upload_to='product')
    image_2 = models.ImageField(upload_to='product', blank=True)
    image_3 = models.ImageField(upload_to='product', blank=True)
    video_url = models.URLField(max_length=200, blank=True)
    stock = models.IntegerField()
    status = models.CharField(max_length=20, choices=PRODUCT_STATUS_CHOICES, default='in_stock')
    active = models.BooleanField(default=True) # change model name to active (activate or deactivate)
    new = models.BooleanField(default=True)
    created = models.DateTimeField(auto_now_add=True)
    update = models.DateField(auto_now=True)
    priority = models.IntegerField(default=0, validators=[MinValueValidator(0)])    
    
    def get_url(self):
        return reverse('store_app:proDetail', args=[self.category.slug, self.slug])
    
    def get_discounted_price(self):
        if self.old_price and self.new_price:
            diff = self.old_price - self.new_price
            discount_percentage = ((diff) / self.old_price) * 100
            percentage = int(round(discount_percentage))
            return dict(percentage=percentage, diff=diff)
        return None

    def is_in_cart(self, request):
        """Check if product is in cart for both authenticated and anonymous users"""
        if request.user.is_authenticated:
            return OrderItem.objects.filter(
                order__customer=request.user.customer,
                order__payment_success=False,
                product=self
            ).exists()
        else:
            try:
                cart = json.loads(request.COOKIES.get('cart', '{}'))
                return str(self.id) in cart
            except:
                return False
    
    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = self._generate_unique_slug()
        if self.stock == 0:
            self.status = 'out_of_stock'
        super().save(*args, **kwargs)

    def clean(self):
        if self.stock == 0 and self.status == 'in_stock':
            raise ValidationError("Cannot set status to 'In Stock' when stock is 0.")
        elif self.stock > 0 and self.status == 'out_of_stock':
            self.status = 'in_stock'

    def _generate_unique_slug(self):
        base_slug = slugify(self.name)
        unique_slug = base_slug
        num = 1
        while Product.objects.filter(slug=unique_slug).exists():
            unique_slug = f"{base_slug}-{num}"
            num += 1
        return unique_slug
    
    class Meta:
        ordering = ['priority', 'name']
        verbose_name = 'product'
        verbose_name_plural = 'products'
    
    class Meta:
        ordering = ['priority', 'name']  # Update ordering to use priority first

    def __str__(self):
        return self.name
    
    @property
    def imageURL(self):
        try:
            url = self.image_1.url
        except:
            url = ''
        return url


class Wishlist(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    added_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'product')

    def __str__(self):
        return f"{self.user.username} - {self.product.name}"


class Customer(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=200, null=True)
    contact_number = models.CharField(max_length=12, unique=True, null=True)

    def __str__(self):
        return self.name


class Order(models.Model):
    STATUS_CHOICES = [
        ('Order Abandoned', 'Order Abandoned'),  # New status for abandoned orders
        ('Order Placed', 'Order Placed'),
        ('Order Confirmed', 'Order Confirmed'),
        ('Product Shipped', 'Product Shipped'),
        ('Product Delivered', 'Product Delivered'),
    ]

    customer = models.ForeignKey(Customer, on_delete=models.SET_NULL, null=True, blank=True)
    order_id = models.CharField(max_length=100, unique=True, default=uuid.uuid4, editable=False)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Order Abandoned')
    # automaticaly add order creation time if its abandoned or placed order
    date_ordered = models.DateTimeField(auto_now_add=True)
    placed_time = models.DateTimeField(null=True, blank=True)
    confirmed_time = models.DateTimeField(null=True, blank=True)
    shipped_time = models.DateTimeField(null=True, blank=True)
    delivered_time = models.DateTimeField(null=True, blank=True)
    total_price = models.DecimalField(max_digits=7, decimal_places=0, null=True, blank=True)
    Shipping_charge = models.DecimalField(max_digits=7, blank=False, decimal_places=0, default=0.00)
    payment_success = models.BooleanField(default=False)
    order_created = models.BooleanField(default=False)

    def __str__(self):
        return str(self.id)

    @property
    def get_cart_total(self):
        orderitems = self.orderitem_set.all()
        total = sum([item.get_total for item in orderitems])
        return total

    @property
    def get_cart_items(self):
        orderitems = self.orderitem_set.all()
        total = sum([item.quantity for item in orderitems])
        return total

    @property
    def current_payment_status(self):
        """Get the most recent payment status for this order."""
        latest_payment = self.payment_records.order_by('-created_at').first()
        return latest_payment.payment_status if latest_payment else "No Payments"

    def save(self, *args, **kwargs):
        if self.status == 'Order Placed' and not self.placed_time:
            self.placed_time = timezone.now()
        elif self.status == 'Order Confirmed' and not self.confirmed_time:
            self.confirmed_time = timezone.now()
        elif self.status == 'Product Shipped' and not self.shipped_time:
            self.shipped_time = timezone.now()
        elif self.status == 'Product Delivered' and not self.delivered_time:
            self.delivered_time = timezone.now()
        super().save(*args, **kwargs)

class PaymentRecord(models.Model):
    STATUS_CHOICES = [
        ('Payment Successful', 'Payment Successful'),
        ('Failed', 'Failed'),
        ('Incomplete', 'Incomplete'),
    ]
        
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="payment_records")
    razorpay_order_id = models.CharField(max_length=100, null=True, blank=True)
    razorpay_payment_id = models.CharField(max_length=100, unique=True, null=True, blank=True)
    payment_status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Incomplete')
    amount = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    details = models.TextField(null=True, blank=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['order', 'razorpay_order_id'], name='unique_payment_record_per_order'),
        ]

    def __str__(self):
        return f"{self.order} - {self.payment_status}"


class ShippingRate(models.Model):
    state = models.CharField(max_length=100, unique=True)
    base_rate = models.DecimalField(max_digits=6, decimal_places=2)
    additional_item_rate = models.DecimalField(max_digits=6, decimal_places=2)

    def __str__(self):
        return f"{self.state}: ₹{self.base_rate} (₹{self.additional_item_rate} per additional item)"
    

class OrderItem(models.Model):
    product = models.ForeignKey(Product, on_delete=models.SET_NULL, null=True)
    order = models.ForeignKey(Order, on_delete=models.SET_NULL, null=True)
    quantity = models.IntegerField(default=0, null=True, blank=True)
    date_added = models.DateTimeField(auto_now_add=True)
    price_at_purchase = models.DecimalField(max_digits=7, decimal_places=0, null=True, blank=True)

    @property
    def get_total(self):
        if self.price_at_purchase is None:
            self.price_at_purchase = self.product.new_price
        return self.price_at_purchase * self.quantity

    def save(self, *args, **kwargs):
        if not self.price_at_purchase:
            self.price_at_purchase = self.product.new_price
        super().save(*args, **kwargs)


class ShippingAddress(models.Model):
    customer = models.ForeignKey(Customer, on_delete=models.SET_NULL, null=True)
    order = models.ForeignKey(Order, on_delete=models.SET_NULL, null=True, blank=True)
    number = models.CharField(max_length=12, null=False, blank=False)
    whatsapp = models.CharField(max_length=12, null=False, blank=False)
    address = models.CharField(max_length=200, null=False)
    city = models.CharField(max_length=200, null=False)
    state = models.CharField(max_length=200, null=False)
    zipcode = models.CharField(max_length=200, null=False)
    date_added = models.DateTimeField(auto_now_add=True)
    

    def __str__(self):
        return self.address


class PurchaseHistory(models.Model):
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    price_at_purchase = models.DecimalField(max_digits=7, decimal_places=0)
    date_added = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.customer.name} - {self.product.name}"

