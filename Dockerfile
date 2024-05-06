FROM ruby:2.7

RUN apt-get update && apt-get -y install nodejs npm

EXPOSE 4567

CMD ["bundle", "exec", "weaver"]
