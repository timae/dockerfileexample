# Use an official Node.js runtime as the base image
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and install dependencies in a single step to optimize layers
COPY package*.json ./
RUN npm install && npm cache clean --force

# Copy the rest of the application code
COPY . .

# Expose the port required by the application
EXPOSE 3000

# Start the application using npm
CMD ["npm", "start"]
