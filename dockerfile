# Use the official Node.js image as the base image
FROM node:14-alpine AS builder

# Install SQLite3
RUN apk add --no-cache sqlite

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --production && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Expose the port the app will run on
EXPOSE 3000

# Persist the database file in a volume
VOLUME ["/usr/src/app/database"]

# Start the App
CMD ["npm", "run", "start"]
