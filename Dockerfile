FROM ruby:2.3

RUN apt-get update && \
        apt-get install -y qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x nodejs

COPY . /usr/app
WORKDIR /usr/app

RUN bundle install --jobs 20 --retry 5 --without development test

# Clean APK cache
RUN rm -rf /var/cache/apk/*

EXPOSE 3000
ENV RAILS_ENV production
ENV RACK_ENV production

CMD ["/bin/bash","/usr/app/start.sh"]
