# Use an ARM-compatible Debian base image
FROM arm64v8/debian:latest

WORKDIR /root

# Avoid timezone interactive dialog
ENV DEBIAN_FRONTEND=noninteractive

# Update and upgrade the system
RUN apt-get update && apt-get -y upgrade

# Install necessary packages
RUN apt-get -y install build-essential unzip unrar-free procps mc htop wget zip cron

# Copy cron file to the cron.d directory
COPY mail-cron /etc/cron.d/mail-cron
RUN chmod +x /etc/cron.d/mail-cron
# Apply cron job
RUN crontab /etc/cron.d/mail-cron

# Clean apt cache
RUN apt-get clean

# Download and extract libcl
RUN wget http://www.mysticbbs.com/downloads/cl3441.zip
RUN unzip -a cl3441.zip
RUN make shared

RUN mv /root/libcl.so.3.4.4 /lib/libcl.so

# Remove downloaded files
RUN rm -fr /root/*

# Copy mystic installer and boot scripts
ADD mystic /mystic

# Download and extract Mystic BBS spell checker
RUN wget https://mysticbbs.com/downloads/mystic_spellcheck_v2.zip
RUN unzip mystic_spellcheck_v2.zip -d /mystic

# Go to main directory
WORKDIR /mystic

# Expose necessary ports
EXPOSE 23/tcp
EXPOSE 22/tcp
EXPOSE 24554/tcp

# Set entry point for debugging
ENTRYPOINT ["tail", "-f", "/dev/null"]
