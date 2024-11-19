FROM ruby

COPY .ruby.prepare /prebuild.bash

RUN chmod +x /prebuild.bash && /prebuild.bash

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
ADD package-lock.json /app/package-lock.json
ADD package.json /app/package.json

WORKDIR /app

RUN bundle install -j4 && npm install

ADD css /app/css
ADD node_modules /app/node_modules
ADD pages /app/pages
ADD source /app/source
ADD bin /app/bin

EXPOSE 4567

CMD ["bundle", "exec", "weaver"]
