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
