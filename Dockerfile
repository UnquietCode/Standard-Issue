FROM ruby:2.6.5

# install dependencies
COPY ./Gemfile .
RUN bundle install
RUN rm Gemfile

# install code
COPY ./run.rb .
COPY environment-conf.rb ./conf.rb

# set code as entrypoint
ENTRYPOINT ["ruby", "/run.rb", "/conf.rb"]