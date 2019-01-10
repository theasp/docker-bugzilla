FROM ubuntu:bionic

ENV BUGZILLA_VERSION=5.0.4

RUN set -ex; \
    apt-get update; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get install -y \
      apache2 \
      build-essential \
      graphviz \
      libapache2-mod-perl2 \
      libapache2-mod-perl2-dev \
      libappconfig-perl \
      libauthen-radius-perl \
      libauthen-sasl-perl \
      libcgi-pm-perl \
      libchart-perl \
      libdaemon-generic-perl \
      libdate-calc-perl \
      libdatetime-perl \
      libdatetime-timezone-perl \
      libdbd-mysql-perl \
      libdbi-perl \
      libemail-mime-modifier-perl \
      libemail-mime-perl \
      libemail-sender-perl \
      libencode-detect-perl \
      libfile-mimeinfo-perl \
      libfile-slurp-perl \
      libgd-dev \
      libgd-graph-perl \
      libhtml-formattext-withlinks-perl \
      libhtml-scrubber-perl \
      libjson-rpc-perl \
      libmath-random-isaac-perl \
      libmath-random-isaac-xs-perl \
      libmodule-build-perl \
      libmysqlclient-dev \
      libnet-ldap-perl \
      libsoap-lite-perl \
      libtemplate-perl \
      libtemplate-plugin-gd-perl \
      libtest-taint-perl \
      libtheschwartz-perl \
      libxml-perl \
      libxml-twig-perl \
      lynx \
      perlmagick \
      python-sphinx; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /var/www/html

# Remove DEFAULT apache site

# Make Bugzilla install Directory
# https://ftp.mozilla.org/pub/mozilla.org/webtools/bugzilla-5.0.3.tar.gz

ADD https://ftp.mozilla.org/pub/mozilla.org/webtools/bugzilla-${BUGZILLA_VERSION}.tar.gz /var/www/
RUN set -ex; \
  cd /var/www; \
  tar xvfz /var/www/bugzilla-${BUGZILLA_VERSION}.tar.gz; \
  mv bugzilla-${BUGZILLA_VERSION} html

ADD bugzilla.conf /etc/apache2/sites-available/
WORKDIR /var/www/html

ADD checksetup_answers.txt /var/www/html
ADD params data/params

RUN set -ex; \
  ls -al /var/www; \
  ./checksetup.pl --check-modules ; \
  /usr/bin/perl install-module.pl --all ; \
  /usr/bin/perl install-module.pl Net::SMTP::SSL ; \
  /usr/bin/perl install-module.pl IO::Socket::SSL; \
  ./checksetup.pl ; \
  a2enmod cgi headers expires; \
  a2ensite bugzilla; \
  a2dissite 000-default

# Add the start script
ADD start /opt/

# Run start script
CMD ["/opt/start"]

# Expose web server port
EXPOSE 80
