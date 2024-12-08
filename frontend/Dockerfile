# Alap image
FROM node:20-alpine

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
# CMD ["pm2-runtime", "start", "http-server", "--name", "angular-app", "--", "dist/prf-forum/browser", "-p", "4200"]
# CMD ["pm2-runtime", "http-server", "--", "-p", "4200"]
# CMD ["pm2-runtime", "http-server", "./dist/prf-forum/browser", "--", "-p", "4200"]
CMD ["pm2-runtime", "start", "http-server", "--name", "angular-app", "--", "./dist/prf-forum/browser", "-p", "4200"]