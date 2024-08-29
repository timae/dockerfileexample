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

# Install Forego (a process manager to run both Caddy and Node.js)
RUN apk add --no-cache forego

# Copy the Node.js app from the builder stage
COPY --from=builder /usr/src/app /srv

# Copy the Caddyfile for reverse proxy configuration
COPY Caddyfile /etc/caddy/Caddyfile

# Create a Procfile to tell Forego which processes to run
RUN echo "web: npm start" > /srv/Procfile
RUN echo "proxy: caddy run --config /etc/caddy/Caddyfile" >> /srv/Procfile

# Set the working directory to /srv where the app is located
WORKDIR /srv

# Expose the default HTTP port
EXPOSE 8080

# Run Forego to start both Node.js and Caddy
CMD ["forego", "start", "-f", "/srv/Procfile"]
