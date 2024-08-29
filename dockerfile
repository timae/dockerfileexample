# Use the official Node.js image as the base image
FROM node:14-alpine AS builder

# Install SQLite3 dependencies
RUN apk add --no-cache sqlite sqlite-dev gcc g++ make python3

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install node modules (including sqlite3)
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Expose the port the app will run on
EXPOSE 3000

# Persist the database file in a volume
VOLUME ["/usr/src/app/database"]

# Start the app
CMD ["npm", "start"]
