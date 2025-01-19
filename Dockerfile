# Step 1: Build the React app
FROM node:alpine3.18 as build

# Set working directory inside the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json . 
RUN npm install

# Copy the rest of the React app files and build the app
COPY . .
RUN npm run build

# Step 2: Serve with Nginx
FROM nginx:1.23-alpine

# Set working directory for Nginx (this is where Nginx serves static files from)
WORKDIR /usr/share/nginx/html

# Remove default content in the Nginx directory
RUN rm -rf *

# Copy the built React app files from the build stage to the Nginx serving directory
COPY --from=build /app/build .

# Copy the custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for serving the app
EXPOSE 80

# Start Nginx in the foreground (required for Docker containers)
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
