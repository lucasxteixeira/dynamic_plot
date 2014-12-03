FROM phusion/baseimage:0.9.15

# Set correct environment variables.
ENV HOME /root

# Add ubuntu updated repository
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe" >> /etc/apt/sources.list
RUN echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys E084DAB9

# Update
RUN apt-get update

# Install R and some dependencies
RUN apt-get install -y -q r-base r-base-dev
RUN apt-get install -y -q gdebi-core libapparmor1 supervisor sudo libssl0.9.8 libcurl4-openssl-dev wget

# Clean up APT when done.
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install R packages
RUN R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rmarkdown', repos='http://cran.rstudio.com/')" 
RUN R -e "install.packages('plyr', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rjson', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('ggvis', repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
RUN R -e "require(devtools); install_github('curl', 'jeroenooms')"
RUN R -e "require(devtools); install_github('rCharts', 'ramnathv')"

# Install shiny server
RUN update-locale
RUN wget http://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.2.3.368-amd64.deb
RUN gdebi --n shiny-server-1.2.3.368-amd64.deb
RUN rm shiny-server-1.2.3.368-amd64.deb
RUN mkdir -p /srv/shiny-server

# Copy the rmarkdown document to the shiny server folder
COPY index.Rmd /srv/shiny-server/index.Rmd

# Startup scripts 
#  Usually for configuring databases and bug fixing
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

##Adding Deamons to containers
RUN mkdir /etc/service/shiny-server
COPY shiny-server.sh /etc/service/shiny-server/run
RUN chmod +x /etc/service/shiny-server/run

# Expose port to outerworld
EXPOSE 3838

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]