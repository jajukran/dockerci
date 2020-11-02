FROM jekyll/jekyll:3.8.3 as build-stage

WORKDIR /tmp

COPY Gemfile* ./

RUN bundle install

WORKDIR /usr/src/app

COPY . .

RUN chown -R jekyll .

RUN jekyll build

FROM nginx:alpine

#ENV NGINX_PORT=8000

COPY --from=build-stage /usr/src/app/_site/ /usr/share/nginx/html
COPY default.conf.template /etc/nginx/conf.d/default.conf.template


CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'

