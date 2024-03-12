FROM node:16 as build

# Create app directory
WORKDIR /usr/src/app

# ==================
# Build app
# ==================
COPY package*.json ./
COPY yarn.lock ./

RUN yarn install --immutable --immutable-cache --check-cache

COPY . .

##ARG API_URL="https://sabio.netwerkdigitaalerfgoed.nl/api/v1/"
ARG API_URL="http://localhost:8080/api/v1/"
ENV REACT_APP_API_ROOT=$API_URL

ARG INCLUDE_API_ROOT="true"
ENV REACT_APP_INCLUDE_API_ROOT=$INCLUDE_API_ROOT

RUN yarn run build

# ==================
# Run app
# ==================
FROM nginx:1.21-alpine

COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Configure NGINX
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

# Run
CMD ["nginx", "-g", "daemon off;"]
#EXPOSE 8080
