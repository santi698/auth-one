FROM ruby:2.4.1-alpine

RUN apk --update add build-base
RUN gem install bundler

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
ENV BUNDLE_WITHOUT test development
RUN bundle install -j 12

COPY . /app

ENV RACK_ENV production

CMD ["bundle", "exec", "puma"]
