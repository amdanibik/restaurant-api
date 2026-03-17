# Restaurant API

Panduan ini ditujukan untuk siapa pun yang baru clone atau download repository ini, lalu ingin langsung menjalankan aplikasi menggunakan Docker.

## 1. Cara Mendapatkan Kode

### Opsi A: Clone dengan Git

```bash
git clone https://github.com/amdanibik/restaurant-api.git
cd restaurant-api
```

### Opsi B: Download ZIP dari GitHub

1. Download ZIP repository.
2. Extract ZIP.
3. Buka terminal di folder hasil extract (folder yang berisi `docker-compose.yml`).

## 2. Prasyarat

Pastikan sudah terpasang:

- Docker
- Docker Compose (plugin `docker compose`)

Cek versi:

```bash
docker --version
docker compose version
```

## 3. Menjalankan Aplikasi dengan Docker

Jalankan dari folder root repository:

```bash
docker compose up --build -d
```

Service yang berjalan:

- API Rails: http://localhost:3000
- MySQL: localhost:3307
- Redis: localhost:6380

Verifikasi status container:

```bash
docker compose ps
```

Semua service seharusnya `Up`, dan MySQL berstatus `healthy`.

## 4. Inisialisasi dan Cek Seed Data

Jalankan seed:

```bash
docker compose exec -T api bundle exec rails db:seed
```

Verifikasi jumlah data:

```bash
docker compose exec -T api bundle exec rails runner 'puts "Restaurant count: #{Restaurant.count}"; Restaurant.order(:id).each { |r| puts "- #{r.name}: #{r.menu_items.count} menu items" }'
```

Target seed minimum:

- 2+ restoran
- 5+ menu item per restoran

## 5. Akses API

Semua endpoint membutuhkan header:

```text
X-API-Key: development-api-key
```

Contoh request list restoran:

```bash
curl -H "X-API-Key: development-api-key" "http://localhost:3000/restaurants?per_page=10"
```

Contoh request list menu item by restaurant id:

```bash
curl -H "X-API-Key: development-api-key" "http://localhost:3000/restaurants/33/menu_items?per_page=10"
```

Catatan: ID restoran bisa berubah setelah beberapa kali seed (auto increment), jadi tidak selalu mulai dari `1`.

## 6. Menjalankan Test di Docker

Gunakan environment `test` saat menjalankan RSpec di container:

```bash
docker compose exec -T -e RAILS_ENV=test api bundle exec rspec
```

## 7. Stop dan Reset

Stop container:

```bash
docker compose down
```

Stop + hapus volume database (reset data):

```bash
docker compose down -v --remove-orphans
```

## 8. Troubleshooting

### API tidak bisa diakses di port 3000

```bash
docker compose ps
docker compose logs --tail=200 api
```

### MySQL unhealthy atau gagal start

```bash
docker compose logs --tail=200 mysql
docker compose down -v --remove-orphans
docker compose up --build -d
```

### Seed berhasil tapi endpoint menu by id mengembalikan 404

Biasanya karena ID restoran yang dipakai bukan ID aktual. Cek ID terbaru:

```bash
docker compose exec -T api bundle exec rails runner 'Restaurant.order(:id).each { |r| puts "#{r.id} - #{r.name}" }'
```

## 9. Dokumentasi Lanjutan

Detail API, endpoint, dan design decisions ada di [api/README.md](api/README.md).
