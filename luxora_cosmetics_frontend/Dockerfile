# Step 1: Use the official Ubuntu image
FROM ubuntu:latest

# Step 2: Install necessary packages, including Flutter dependencies and Nginx
RUN apt-get update && \
    apt-get install -y curl git unzip nginx && \
    rm -rf /var/lib/apt/lists/*

# Step 3: Install Flutter SDK and upgrade to the latest stable version
RUN git clone https://github.com/flutter/flutter.git -b stable /usr/local/flutter && \
    /usr/local/flutter/bin/flutter upgrade

# Step 4: Add Flutter to PATH
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Step 5: Enable Flutter web and pre-cache dependencies
RUN flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web && \
    flutter precache

# Step 6: Set the working directory to the Flutter project directory within the container
WORKDIR /app

# Step 7: Copy the Flutter project into the container
COPY . /app

# Step 8: Resolve dependencies
RUN flutter pub get

# Step 9: Run build_runner with conflict resolution
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Step 10: Force rebuild by removing the build folder before rebuilding
RUN rm -rf /app/build && flutter build web
# RUN rm -rf /app/build && flutter build web --wasm

# Step 11: Remove default NGINX content and add the built app
RUN rm -rf /var/www/html/* && cp -r /app/build/web/* /usr/share/nginx/html/

# Step 12: Copy the custom nginx.conf into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Step 13: Expose port 80
EXPOSE 80

# Step 14: Start NGINX
CMD ["nginx", "-g", "daemon off;"]
