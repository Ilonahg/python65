from django.contrib import admin
from django.urls import path
from core.views import healthz

urlpatterns = [
    path("admin/", admin.site.urls),
    path("healthz", healthz),  # без слеша на конце
]
