# Use the official Node.js image as the base image
FROM node:14-alpine AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --production && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Use the official Caddy image for production
FROM caddy:alpine

# Install supervisord to run multiple services
RUN apk add --no-cache supervisor

# Copy the Node.js app from the builder stage
COPY --from=builder /usr/src/app /srv

# Copy the Caddyfile for reverse proxy configuration
COPY Caddyfile /etc/caddy/Caddyfile

# Copy the supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf

# Expose the default HTTP port
EXPOSE 8080

# Set the working directory to /srv where the app is located
WORKDIR /srv

# Start supervisord, which will manage both Caddy and Node.js
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
