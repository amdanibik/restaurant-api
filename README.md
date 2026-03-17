# Restaurant API

Panduan cepat untuk menjalankan project ini secara lokal dengan Docker, melakukan verifikasi API, dan menjalankan test.

## Ringkasannya

Project ini berisi REST API Ruby on Rails untuk mengelola restoran dan menu item.

- API Rails: `http://localhost:3000`
- MySQL: `localhost:3307`
- Redis: `localhost:6380`
- Auth header wajib: `X-API-Key: development-api-key`

## Prasyarat

Pastikan sudah terpasang:

- Docker
- Docker Compose plugin (`docker compose`)

Validasi instalasi:

```bash
docker --version
docker compose version
```

## Quick Start (5 Menit)

1. Clone repository.

```bash
git clone https://github.com/amdanibik/restaurant-api.git
cd restaurant-api
```

2. Jalankan semua service.

```bash
docker compose up --build -d
```

3. Isi seed data.

```bash
docker compose exec -T api bundle exec rails db:seed
```

4. Cek status container.

```bash
docker compose ps
```

MySQL seharusnya berstatus `healthy`, service lain berstatus `Up`.

5. Coba endpoint pertama.

```bash
curl -H "X-API-Key: development-api-key" "http://localhost:3000/restaurants?per_page=10"
```

## Perintah Harian

Menyalakan service:

```bash
docker compose up -d
```

Melihat log API:

```bash
docker compose logs -f api
```

Menjalankan command Rails di container:

```bash
docker compose exec -T api bundle exec rails <command>
```

Menjalankan test RSpec (environment test):

```bash
docker compose exec -T -e RAILS_ENV=test api bundle exec rspec
```

Mematikan service:

```bash
docker compose down
```

Reset penuh (hapus volume database):

```bash
docker compose down -v --remove-orphans
```

## Verifikasi Data Seed

Lihat jumlah restoran dan menu item per restoran:

```bash
docker compose exec -T api bundle exec rails runner 'puts "Restaurant count: #{Restaurant.count}"; Restaurant.order(:id).each { |r| puts "- #{r.id}. #{r.name}: #{r.menu_items.count} menu items" }'
```

Catatan: ID restoran dapat berubah setelah reset/seed ulang karena auto increment.

## Akses API

Semua endpoint mewajibkan header:

```text
X-API-Key: development-api-key
```

Contoh list menu item berdasarkan restoran:

```bash
curl -H "X-API-Key: development-api-key" "http://localhost:3000/restaurants/1/menu_items?per_page=10"
```

Jika ID restoran `1` tidak ada, ambil ID valid terlebih dahulu dari endpoint `/restaurants`.

## Troubleshooting

API tidak bisa diakses:

```bash
docker compose ps
docker compose logs --tail=200 api
```

MySQL gagal start atau `unhealthy`:

```bash
docker compose logs --tail=200 mysql
docker compose down -v --remove-orphans
docker compose up --build -d
```

Menu by restaurant mengembalikan 404:

```bash
docker compose exec -T api bundle exec rails runner 'Restaurant.order(:id).each { |r| puts "#{r.id} - #{r.name}" }'
```

## Dokumentasi Lanjutan

Dokumentasi endpoint lengkap, behavior API, dan design decisions ada di [api/README.md](api/README.md).
