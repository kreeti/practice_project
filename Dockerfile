FROM ruby:3.1.0

RUN apt-get clean && apt-get update &&  apt-get install -y imagemagick libxml2-dev libxslt-dev

#Upgrade to Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -   
RUN apt-get install -y nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install --jobs 20 --retry 5 --without development,test

COPY . /app

RUN bundle exec rake assets:precompile

ENTRYPOINT [ "sh", "./bin/docker/startup.sh" ]
