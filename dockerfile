# Use the official Node.js image as the base image
FROM node:14-alpine AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install --production && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Start the App
CMD ["npm", "run", "start"]
