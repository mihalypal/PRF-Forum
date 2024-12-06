# Alap image
FROM node:20.11.1

# Munkakönyvtár beállítása
WORKDIR /app

# Fájlok másolása
COPY . .

# Angular CLI és függőségek telepítése
RUN npm install -g @angular/cli@17.2.1
RUN npm install -g pm2
RUN npm install

# Port megnyitása
EXPOSE 4200

# Angular alkalmazás indítása PM2-vel
CMD ["pm2-runtime", "node_modules/@angular/cli/bin/ng", "serve", "--host", "0.0.0.0"]
