# PRF-Forum
PRF - Fórum beadandó

## Beüzemelés
A projekt működéséhez szükséges Docker, Node (20.11.1), AngularCLI (17.2.1)

Amennyiben az AngularCLI (szükséges verziója) nincs telepítve, akkor a következő paranccsal:
> npm install @angular/cli@17.2.1

### Adatbázis - MongoDB

- Navigálás backend mappába
> cd backend

- Docker image build
> docker build -t my_mongo_image .

- Docker container futtatása
> docker run -p 5000:27017 -it --name my_mongo_container -d my_mongo_image

### Backend beüzemelése

- Jelenlegi mappában backend telepítése
> npm install

- Backend build
> npm run build

- Backend futtatása
> npm run start

### Frontend beüzemelése

- A projekt gyökérmappájából navigáljunk a frontend mappába
> cd frontend

- Frontend fájlok telepítése
> npm install

- Frontend futtatása
> ng serve