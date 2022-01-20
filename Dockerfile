FROM ruby:3.0.0

WORKDIR /usr/src/proseeker

COPY . .

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt update && apt install -y yarn

RUN bundle install

RUN bin/yarn

EXPOSE 3000
