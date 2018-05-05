FROM debian:wheezy-slim

RUN apt-get update && apt-get install -y \
  sudo \
  curl

# Install node
# nodejs requires special consideration
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
  apt-get install nodejs -u

# These libraries are required for electron (HTML->PDF conversion)
# There's a lot and I'm sure they're not all needed but I'm honestly so
# done with this right now... I just want it to work!
RUN apt-get update && apt-get install -y \
  x11-xkb-utils \
  libx11-xcb-dev \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic \
  x11-apps clang \
  libdbus-1-dev \
  libgtk2.0-dev \
  libnotify-dev \
  libgnome-keyring-dev \
  libgconf2-dev \
  libasound2-dev \
  libcap-dev \
  libcups2-dev \
  libxtst-dev \
  libxss1 \
  libnss3-dev \
  gcc-multilib \
  g++-multilib \
  libxtst6 \
  libxss1 \
  xvfb

# PhantomJS requisites
RUN apt-get update && apt-get install -y bzip2

# GCC is required for hummus to run correctly
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  build-essential \
  gcc \
  mono-mcs

# Copy all of the contents of this current directory into the docker image
RUN mkdir -p /tmp/build
COPY . /tmp/build
WORKDIR /tmp/build

# Install the node modules from package.json
RUN npm install --production

# Install hummus differently because it requires 
# needs to be compiled with C or something like that
RUN npm install hummus --build-from-source --unsafe-perm

# Install nodemon globally for running the back-end
RUN npm install -g nodemon

# Something to do with setting a headless browser. Also needed for HTML->PDF conversion
CMD Xvfb -ac -screen scrn 1280x2000x24 :9.0 & export DISPLAY=:9.0 && NODE_ENV=production nodemon main.js
