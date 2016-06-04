FROM ruby:latest

RUN mkdir -p /app
WORKDIR /app

ADD Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development test --deployment

ENV APP_ENV production

ADD . ./

# Run the command on container startup
CMD ruby schedule.rb
