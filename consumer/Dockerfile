FROM ruby:2.3.1

ENV RACK_ENV production
ENV PORT 9292

WORKDIR /app

COPY ./common /app/lib/

RUN cd /app/lib ; gem build pc-common.gemspec ; gem install pc-common-0.0.1.gem ; cd - ; rm -r /app/lib

COPY ./consumer /app/

RUN bundle install

EXPOSE $PORT

CMD ["/bin/bash", "start.sh", "10"]