FROM ruby:3.2.2-alpine as build

RUN apk update && apk add --no-cache build-base

WORKDIR /opt/opds-webui
COPY Gemfile Gemfile.lock .

RUN bundle install

FROM ruby:3.2.2-alpine

WORKDIR /opt/opds-webui
COPY lib/ lib/
COPY public/ public/
COPY views/ views/
COPY app.rb app.rb
COPY entrypoint.sh entrypoint.sh
COPY --from=build /usr/local/bundle /usr/local/bundle

EXPOSE 4567

CMD ruby app.rb
ENTRYPOINT ["/opt/opds-webui/entrypoint.sh"]
