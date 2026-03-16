FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  default-mysql-client \
  nodejs

WORKDIR /app

COPY Gemfile* ./

RUN bundle install

COPY . .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]