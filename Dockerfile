FROM jekyll/jekyll:4.2.2

RUN gem install bundler -v 2.6.9
RUN apk add python3 py3-pip \
    && pip3 install cyrtranslit
RUN gem install webrick 
# && jekyll serve --livereload

COPY Gemfile /srv/jekyll/Gemfile
# COPY Gemfile.lock /srv/jekyll/Gemfile.lock
COPY _config.yml /srv/jekyll/_config.yml

WORKDIR /srv/jekyll

RUN sed -i 's/\r//' /srv/jekyll/Gemfile     \   
    && sed -i 's/\r//' /srv/jekyll/_config.yml  
    # && sed -i 's/\r//' /srv/jekyll/Gemfile.lock  \

RUN jekyll build
EXPOSE 4000
