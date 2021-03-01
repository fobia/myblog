FROM jekyll/jekyll:3.8

RUN gem install bundler
RUN apk add python3 \
    && pip3 install cyrtranslit

COPY Gemfile /srv/jekyll/Gemfile
COPY Gemfile.lock /srv/jekyll/Gemfile.lock
COPY _config.yml /srv/jekyll/_config.yml

WORKDIR /srv/jekyll

RUN sed -i 's/\r//' /srv/jekyll/Gemfile     \     
    && sed -i 's/\r//' /srv/jekyll/Gemfile.lock  \
    && sed -i 's/\r//' /srv/jekyll/_config.yml  

RUN jekyll build
EXPOSE 4000
