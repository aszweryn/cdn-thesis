# Use the OpenResty Nginx module with VTS as the base image
FROM igorbarinov/openresty-nginx-module-vts

# Install build dependencies
RUN apk --no-cache add --virtual .build-deps build-base git

# Clone the lua-resty-balancer repository
RUN git clone https://github.com/openresty/lua-resty-balancer.git

# Build the lua-resty-balancer
WORKDIR lua-resty-balancer
RUN make

# Copy the built files to the appropriate directories
RUN cp -r lib/resty/* /usr/local/openresty/lualib/resty/
RUN cp librestychash.so /usr/local/openresty/lualib/

# Clean up the build dependencies
RUN apk del .build-deps

# Reset the working directory
WORKDIR /