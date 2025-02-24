# Use the latest official Ubuntu with Apache
FROM ubuntu/apache2:latest

# Set working directory to /var/www/html (default for Apache)
WORKDIR /app

# Copy project files to the working directory
COPY . .

# Install necessary dependencies and clean up
RUN apt-get update && \
    apt-get install -y tar curl gcc make libcurl4-openssl-dev libexpat1-dev && \
    rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y libcgi-pm-perl

RUN apt update && apt install -y locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8



# Download and install WFDB from PhysioNet
RUN curl -k https://archive.physionet.org/physiotools/wfdb.tar.gz | tar xvz && \
    cd wfdb-* && \
    ./configure && \
    make install && \
    make check && \
    cd .. && \
    rm -rf wfdb-*  # Clean up WFDB source

# Copy custom Apache configuration
RUN cp server/lw-apache.conf /etc/apache2/sites-available/ && \
    a2ensite lw-apache.conf && \
    a2dissite 000-default.conf 

RUN a2enmod cgid

RUN find / -name "libwfdb.so.10" 2>/dev/null
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/wfdb.conf
RUN ldconfig



RUN make
RUN chmod +x /app
RUN mv database/* /usr/local/database 

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
