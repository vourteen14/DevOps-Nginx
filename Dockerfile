FROM nginx:latest

RUN mkdir -p /var/www

COPY hello.txt /var/www/hello.txt

RUN chown -R www-data:www-data /var/www

COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
