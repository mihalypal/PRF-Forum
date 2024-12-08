# FROM nginx:latest
# COPY nginx.conf /etc/nginx/conf.d/default.conf

FROM nginx:latest
# install nodejs to get npm
# also get git to be able to clone the repository
RUN apt-get update && apt-get install -y nodejs git
# clone the repository, cd into it and npm install, then build the frontend and put the dist folder into the nginx html folder | here is the repo link: https://github.com/mihalypal/PRF-Forum.git | branch name is devops
RUN git clone "https://github.com/mihalypal/PRF-Forum.git" && cd PRF-Forum/frontend && npm install && npm run build && cp -r dist/prf-forum/browser/* /usr/share/nginx/html
# copy the nginx config file to the nginx folder

COPY /nginx/nginx.conf /etc/nginx/conf.d/default.conf
#COPY /frontend/dist/prf-forum/browser /usr/share/nginx/html
