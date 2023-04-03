# Khai báo image node
FROM node:16-alpine3.16 AS builder
WORKDIR /app
# Copy package.json và package-lock.json dự án vào trong container
COPY package*.json ./
RUN npm install
COPY . .

RUN npm run build

# Khai báo image nginx
FROM nginx:stable-alpine

# Copy mục đã build vào trong container
COPY --from=builder /app/build /usr/share/nginx/html

# Copy file nginx config đã chuẩn bị sẵn vào container
COPY --from=builder app/docker/nginx.conf /etc/nginx/conf.d/default.conf

# Khởi chạy nginx ở chế độ không phải demon
# -g ở đây là truyền cấu hình tùy chọn cho Nginx, ở đây là deamon off
CMD ["nginx","-g","daemon off;"]