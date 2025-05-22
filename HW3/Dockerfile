FROM nginx:1.21.1

# Удаляем стандартный index.html
RUN rm /usr/share/nginx/html/index.html

# Копируем index.html в контейнер
COPY index.html /usr/share/nginx/html/

# Открываем порт 80
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]