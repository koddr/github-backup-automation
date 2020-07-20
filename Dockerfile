FROM python:3.8-slim-buster

LABEL maintainer="Vic Shóstak <truewebartisans@gmail.com>"

# Go to working directory.
WORKDIR /srv

# Update & Install git, tzdata.
RUN apt-get update && apt-get install -y git tzdata

# Cleanup process.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install github-backup by pip.
RUN pip install github-backup

# Copy entrypoint script to /srv directory.
COPY entrypoint.sh .

# Set executable flag to entrypoint.sh script.
RUN chmod +x ./entrypoint.sh

# Run entrypoint.sh script at start container.
ENTRYPOINT ["./entrypoint.sh"]
