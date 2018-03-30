if [ -z "$RACK_ENV" ];
then
  RACK_ENV=development
fi

if [ -z "$PORT" ];
then
  PORT=9292
fi

if [ "$RACK_EN" == "production" ];
then
  bundle install --without development test
else
  bundle install
fi

bundle exec thin -R config.ru -p $PORT -e $RACK_ENV start