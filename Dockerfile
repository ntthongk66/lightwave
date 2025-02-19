FROM ubuntu/apache2:latest

# Copy website files (if any)
# COPY ./public-html/ /var/www/html/
COPY . /root

RUN apt-get update && \
  apt-get install -y tar curl gcc make libcurl4-openssl-dev libexpat1-dev && \
  rm -rf /var/lib/apt/lists/*

RUN curl -k https://archive.physionet.org/physiotools/wfdb.tar.gz | tar xvz && \
  cd wfdb-* && \
  ./configure && \
  make install && \
  make check

RUN cp /root/server/lw-apache.conf /etc/apache2/sites-available/
# RUN apachectl -D FOREGROUND

# RUN a2ensite lw-apache.conf
# RUN service apache2 reload


# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]