# PENJELASAN SCRIPT

## DOCKERFILE
File ini digunakan untuk membangun image Docker. Berikut adalah command sekaligus penjelasan dari command yang dibuat.


```dockerfile
FROM node:14
# FROM node:14 adalah command untuk menyatakan bahwa kita akan menggunakan image resmi NodeJS dengan versi 14 sebagai image dasar yang akan digunakan sebagai titik awal untuk pembuatan image Docker.


WORKDIR /app
# WORKDIR /app adalah command untuk menetapkan direktori kerja di dalam container ke /app. Semua perintah yang dijalankan setelahnya akan beroperasi di dalam direktori /app. 


COPY . .
# COPY . . adalah command untuk menyalin semua file dan folder dari direktori lokal ke dalam direktori kerja di dalam container. Semua file dan folder dari direktori lokal saat ini akan disalin ke dalam direktori kerja di dalam container (/app). Titik (.) pertama adalah path sumber dari host, dan titik (.) kedua adalah path tujuan di dalam container.


ENV NODE_ENV=production DB_HOST=item-db
# Command ENV pada Dockerfile digunakan untuk menetapkan variabel lingkungan (environment variable) di dalam container. Variabel NODE_ENV diatur ke nilai "production". Sedangkan variabel DB_HOST diatur ke nilai "item-db".


RUN npm install --production --unsafe-perm && npm run build
# Command ini menjalankan dua perintah Node.js di dalam container, npm install --production --unsafe-perm untuk menginstall dependensi Node.js untuk proyek ini. Opsi --production memastikan bahwa hanya dependensi produksi yang diinstal (tidak termasuk dependensi pengembangan), dan --unsafe-perm memungkinkan izin yang lebih longgar untuk menghindari masalah dengan hak akses. Kemudian npm run build untuk menjalankan skrip build aplikasi. 


EXPOSE 8080
# Expose port 8080 yang akan digunakan oleh aplikasi. Instruksi EXPOSE pada Dockerfile digunakan untuk mendokumentasikan port yang akan digunakan oleh aplikasi di dalam container, dan itu tidak memetakan atau membuka port saat menjalankan container. Jika ingin  menjalankan container dari image ini, kita perlu secara eksplisit menyertakan opsi -p atau -P pada perintah docker run untuk memetakan port container ke port host jika ingin mengakses aplikasi melalui port tersebut.


CMD ["npm", "start"]
# Ini adalah perintah default yang akan dijalankan saat container dimulai. Pada command tersebut menyatakan bahwa perintah default yang akan dijalankan saat container dimulai adalah : npm start.
```


## BASH FILE
Skrip ini dapat membantu dalam menjalankan beberapa tugas terkait Docker, termasuk pembuatan image, tagging, login ke Docker Hub, dan mengunggah image.

``` bash
#!/bin/bash
# Baris pertama menentukan bahwa ini adalah skrip Bash dan bahwa skrip ini harus dijalankan menggunakan shell Bash (/bin/bash).


docker build -t item-app:v1 .
# Build Docker image with the tag melakukan pembuatan image Docker dengan menggunakan perintah docker build. Opsi -t digunakan untuk memberikan tag atau nama untuk image yang dibangun, dalam hal ini, item-app:v1. Titik (.) pada akhir perintah menunjukkan bahwa konteks build adalah direktori saat ini (tempat di mana Dockerfile berada).


docker images
# Command ini digunakan untuk menampilkan daftar image Docker yang ada di sistem.


docker tag item-app:v1 mashumjabbar/item-app:v1
# Command ini memberikan tag tambahan untuk image yang telah dibuat. Dalam hal ini, image item-app:v1 diberi tag baru sebagai mashumjabbar/item-app:v1. Tagging diperlukan jika kita ingin mengunggah image ke registry Docker yang berbeda.


echo $PASSWORD_DOCKER_HUB | docker login -u mashumjabbar --password-stdin
# Login to Docker Hub with provided password ini merupakan command untuk melakukan login ke Docker Hub menggunakan perintah docker login. Kata sandi untuk login diambil dari variabel lingkungan $PASSWORD_DOCKER_HUB. Ini adalah cara yang umum digunakan untuk melakukan login secara otomatis dalam skrip tanpa mengekspos kata sandi secara terang-terangan dalam skrip. Pastikan sudah melakukan pembuatan variabel tersebut dengan cara : export PASSWORD_DOCKER_HUB=your_password_here


docker push mashumjabbar/item-app:v1
# Ini merupakan command untuk mengunggah image Docker yang telah dibuat ke Docker Hub menggunakan perintah docker push. Image dengan tag mashumjabbar/item-app:v1 akan diunggah ke registry Docker Hub.
```


## DOCKER COMPOSE

``` yaml
version: '2' 
# Menentukan Versi Docker Compose yang digunakan

services:
  item-app:
    image: mashumjabbar/item-app:v1 
    ports:
      - "80:8080"
    depends_on:
      - item-db

  item-db:
    image: mongo:3
    volumes:
      - app-db:/data/db

# Pada skrip Services di atas digunakan untuk memmulai definisi layanan. Dalam hal ini, ada dua layanan yang didefinisikan (item-app dan item-db). 

# item-app adalah layanan yang menggunakan image Docker mashumjabbar/item-app:v1. 
# ports mengatur penerbitan port untuk item-app, sehingga port 80 pada host akan diteruskan ke port 8080 pada kontainer. 
# depends_on menunjukkan bahwa layanan item-db harus berjalan sebelum item-app dimulai.

# item-db adalah layanan yang menggunakan image Docker resmi MongoDB dengan versi 3. 
# volumes mengatur volume untuk menyimpan data basis data MongoDB di /data/db dalam kontainer.

volumes:
  app-db: 

# Mendefinisikan volume bernama app-db yang digunakan oleh layanan item-db.
```



# JALANKAN
Berikut adalah cara menjalankan : 

1. Buka Terminal OS kemudian masuk ke dalam Root dari Repository ini yang sejajar dengan bashfile dan juga dockerfile ataupun docker-compose. 


2. Jalankan perintah berikut untuk memberikan hak eksekusi ke script tersebut : 

``` bash
chmod +x build_push_image.sh
```


3. Jalankan script Bash dengan perintah berikut:

``` bash
./build_push_image.sh
```

Hasilnya seperti ini :

``` bash
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  3.019MB
Step 1/7 : FROM node:14
 ---> 1d12470fa662
Step 2/7 : WORKDIR /app
 ---> Running in e8aa9113511e
Removing intermediate container e8aa9113511e
 ---> 11935a28e43d
Step 3/7 : COPY . .
 ---> fd041c365e85
Step 4/7 : ENV NODE_ENV=production DB_HOST=item-db
 ---> Running in 446e72e9de83
Removing intermediate container 446e72e9de83
 ---> d1978f063b62
Step 5/7 : RUN npm install --production --unsafe-perm && npm run build
 ---> Running in 42c32823c3ca

> docker-software-delivery@1.0.0 preinstall /app
> npx npm-force-resolutions

npx: installed 6 in 4.258s
npm WARN read-shrinkwrap This version of npm is compatible with lockfileVersion@1, but package-lock.json was generated for lockfileVersion@2. I'll try to do my best with it!
added 473 packages from 332 contributors and audited 664 packages in 21.188s

12 packages are looking for funding
  run `npm fund` for details

found 98 vulnerabilities (7 low, 34 moderate, 46 high, 11 critical)
  run `npm audit fix` to fix them, or `npm audit` for details

> docker-software-delivery@1.0.0 build /app
> node ./node_modules/gulp/bin/gulp.js

[10:15:55] Using gulpfile /app/gulpfile.js
[10:15:55] Starting 'scripts'...
[10:15:59] Finished 'scripts' after 3.56 s
[10:15:59] Starting 'default'...
[10:15:59] Finished 'default' after 16 μs
Removing intermediate container 42c32823c3ca
 ---> a00438622cd8
Step 6/7 : EXPOSE 8080
 ---> Running in f4c87fbf94a0
Removing intermediate container f4c87fbf94a0
 ---> 0c476b16c3e6
Step 7/7 : CMD ["npm", "start"]
 ---> Running in 6e99c71b2f42
Removing intermediate container 6e99c71b2f42
 ---> 9bb719340d75
Successfully built 9bb719340d75
Successfully tagged item-app:v1
REPOSITORY    TAG         IMAGE ID       CREATED                  SIZE
item-app      v1          9bb719340d75   Less than a second ago   949MB
hello-world   v1          d0a1cfb8cd6f   4 days ago               1.03GB
hello-world   latest      490ed381b7ef   4 days ago               1.01GB
nginx         latest      c20060033e06   2 weeks ago              187MB
mysql         5.7         bdba757bc933   3 weeks ago              501MB
registry      2           ff1857193a0b   3 weeks ago              25.4MB
python        3.8         795c73a8d985   4 weeks ago              998MB
alpine        latest      8ca4688f4f35   7 weeks ago              7.34MB
node          14          1d12470fa662   7 months ago             912MB
node          12-alpine   bb6d28039b8c   19 months ago            91MB
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
The push refers to repository [docker.io/mashumjabbar/item-app]
84d08876d390: Pushed
a9622713426a: Pushed
141245ce256f: Pushed
0d5f5a015e5d: Pushed
3c777d951de2: Pushed
f8a91dd5fc84: Mounted from library/node
cb81227abde5: Mounted from library/node
e01a454893a9: Mounted from library/node
c45660adde37: Mounted from library/node
fe0fb3ab4a0f: Mounted from library/node
f1186e5061f2: Mounted from library/node
b2dba7477754: Mounted from library/node
v1: digest: sha256:e0b4b9b206077a812d24a4c7a097caa55b7c128fd6379ee3e2f8578c61fd68e7 size: 2844
```

4. Jalankan script Docker Compose sebagai berikut:

``` bash
docker-compose up -d
```

Untuk memberhentikan dapat menggunakan script berikut : 
``` bash
docker-compose down -d
```