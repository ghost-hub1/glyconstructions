# Use official PHP 8.2 Apache image
FROM php:8.2-apache

# Copy all files to Apache web root
COPY . /var/www/html/

# Enable mod_rewrite for .htaccess support
RUN a2enmod rewrite
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Use PORT env variable (Render sets this automatically, defaults to 10000)
RUN sed -i 's/80/${PORT}/g' /etc/apache2/ports.conf /etc/apache2/sites-enabled/000-default.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 10000

# Use shell form so ${PORT} gets expanded at runtime
CMD ["sh", "-c", "sed -i \"s/\\${PORT}/${PORT:-10000}/g\" /etc/apache2/ports.conf /etc/apache2/sites-enabled/000-default.conf && apache2-foreground"]
