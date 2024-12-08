# Használj Node.js alapú képet a build szakaszhoz
FROM node:20 AS build-stage

# Telepítsd a szükséges csomagokat és klónozd a 'devops' branch-et
RUN apt-get update && apt-get install -y git
RUN git clone --branch devops https://github.com/mihalypal/PRF-Forum.git /app


WORKDIR /app/frontend
RUN npm install -g @angular/cli@17.2.1
RUN npm install
RUN ng build

# Használj Nginx képet a végső szakaszhoz
FROM nginx:latest AS production-stage

# Másold át a build fájlokat az Nginx HTML mappájába
COPY --from=build-stage /app/frontend/dist/prf-forum/browser /usr/share/nginx/html

# Másold át az Nginx konfigurációs fájlt
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80