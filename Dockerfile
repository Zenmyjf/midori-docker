# Use a lightweight Linux distribution as the base image
FROM debian:bullseye-slim

# Install necessary packages, including Midori
RUN apt-get update && \
    apt-get install -y midori novnc websockify xvfb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose the VNC port
EXPOSE 6080

# Set up noVNC
WORKDIR /root
RUN git clone https://github.com/novnc/noVNC.git && \
    git clone https://github.com/novnc/websockify.git

# Create a script to start Midori with noVNC using Xvfb
RUN echo '#!/bin/bash' > /root/start.sh && \
    echo 'Xvfb :1 -screen 0 1024x768x16 &> xvfb.log &' >> /root/start.sh && \
    echo 'export DISPLAY=:1' >> /root/start.sh && \
    echo 'midori &' >> /root/start.sh && \
    echo 'websockify -D --web=/root/noVNC 6080 localhost:5900' >> /root/start.sh && \
    chmod +x /root/start.sh

# Set the default command to start the script
CMD ["/root/start.sh"]
