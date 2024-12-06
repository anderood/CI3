# Usar a imagem oficial do PHP 8.1 com Apache
FROM php:8.1-apache

# Atualizar os pacotes do sistema e instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    nano \
    && docker-php-ext-install zip mysqli \
    && docker-php-ext-enable zip mysqli

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar o diretório de trabalho dentro do contêiner
WORKDIR /var/www/html

# Copiar os arquivos do projeto para o contêiner
COPY . /var/www/html

# Garantir que o usuário do Apache tenha permissões corretas
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Ativar o módulo rewrite do Apache (necessário para CodeIgniter)
RUN a2enmod rewrite

# Reiniciar o serviço Apache para carregar as configurações
CMD ["apache2-foreground"]