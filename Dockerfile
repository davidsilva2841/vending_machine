FROM ruby:alpine3.15

WORKDIR ./vending_machine
COPY . .

RUN bundle install

CMD ["ruby", "script/run.rb"]
