from django import forms
from django.core.exceptions import ValidationError
from django.contrib.auth.models import User
from store.models import Customer
from django import forms

from django import forms
from django.core.validators import RegexValidator
from django.core.exceptions import ValidationError
from store.models import Customer 

class RegistrationForm(forms.Form):
    username = forms.CharField(
        max_length=150,
        required=True,
        validators=[
            RegexValidator(
                regex=r'^[A-Za-z]+(?: [A-Za-z]+)*$',
                message='Username can contain only letters and spaces.',
                code='invalid_username'
            )
        ]
    )

    contact_number = forms.CharField(
        max_length=12,
        required=True,
        validators=[
            RegexValidator(
                regex=r'^[0-9]{10,12}$',
                message='Contact number must be 10 or 12 digits.',
                code='invalid_contact_number'
            )
        ]
    )

    def clean_username(self):
        username = self.cleaned_data['username'].strip()

        # Count only letters (ignore spaces)
        letter_count = sum(c.isalpha() for c in username)
        if letter_count < 3:
            raise ValidationError(
                'Username must contain at least 3 letters.'
            )

        return username

    def clean_contact_number(self):
        contact_number = self.cleaned_data.get('contact_number')
        if Customer.objects.filter(contact_number=contact_number).exists():
            raise ValidationError(
                f'This contact number {contact_number} is already registered.'
            )
        return contact_number
    

class LoginForm(forms.Form):
    contact_number = forms.CharField(max_length=12)


class SuperuserPasswordForm(forms.Form):
    password = forms.CharField(widget=forms.PasswordInput)
