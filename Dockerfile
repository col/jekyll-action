FROM ruby:2.7-alpine

LABEL version="2.0.1.1"
LABEL repository="https://github.com/col/jekyll-action"
LABEL homepage="https://github.com/col/jekyll-action"
LABEL maintainer="Colin Harris <col.w.harris@gmail.com>"

RUN apk add --no-cache git build-base
# Allow for timezone setting in _config.yml
RUN apk add --update tzdata

# debug
RUN bundle version

COPY LICENSE README.md /

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
