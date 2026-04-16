# **GameDaemonDeck 7 Days to Die Docker Image**

This repository contains everything you need to build and run an automated 7 Days to Die dedicated server using Docker.

## **How to Build and Run**

1. Clone this repository to your server.  
2. Open docker-compose.yml and add your Steam64 ID to ADMIN\_STEAM\_ID if you want admin privileges.  
3. Build the image and start the server by running:  
   docker compose up \-d \--build

## **How to publish this to Docker Hub (Optional)**

If you want to share your image with the world so anyone can just run docker run gamedaemondeck/7dtd, you can build and push it like this:

1. Log into Docker Hub via terminal: docker login  
2. Build the image with your username: docker build \-t yourdockerusername/7dtd-server:latest .  
3. Push it to the cloud: docker push yourdockerusername/7dtd-server:latest
