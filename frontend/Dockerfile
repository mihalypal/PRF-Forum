# Alap image
FROM node:20.11.1

# Munkakönyvtár beállítása
WORKDIR /app

# Fájlok másolása
COPY . .

# Angular CLI és függőségek telepítése
RUN npm install -g @angular/cli@17.2.1
RUN npm install -g pm2
RUN npm install -g http-server
RUN npm install
RUN npm run build

# Port megnyitása
EXPOSE 4200

# Angular alkalmazás indítása PM2-vel
CMD ["pm2-runtime", "start", "http-server", "--name", "'angular-app'", "--", "4200", "-d", "false", "./dist/prf-forum/browser"]
