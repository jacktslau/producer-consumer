mkdir -p log
bundle exec thin -R config.ru -p 9000 -e development start