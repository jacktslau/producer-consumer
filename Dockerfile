FROM ruby:2.3.1

ENV RACK_ENV production
ENV PORT 9292

WORKDIR /app

COPY . /app/

EXPOSE $PORT

CMD ["/bin/bash", "start.sh"]