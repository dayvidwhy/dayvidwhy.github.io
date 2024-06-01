FROM ruby:2.7

WORKDIR /app

COPY . .

RUN bundle install

EXPOSE 4000

# hold the container open
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
