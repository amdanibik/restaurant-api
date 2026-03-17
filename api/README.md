# Restaurant API

REST API sederhana untuk mengelola restoran dan menu item menggunakan Ruby on Rails API mode dan MySQL.

## Tech Stack

- Ruby 3.1.2
- Rails 7.0
- MySQL
- RSpec untuk testing
- Pry untuk debugging lokal

## Fitur Utama

- CRUD restoran
- CRUD menu item
- Detail restoran beserta menu items
- Filter menu item berdasarkan kategori
- Pencarian menu item berdasarkan nama
- Pagination pada endpoint list restoran dan menu item
- Autentikasi sederhana menggunakan API key
- Validasi input dengan pesan error yang jelas
- HTTP status code yang sesuai (`200`, `201`, `204`, `400`, `404`, `422`)
- Seed data 3 restoran dengan masing-masing 8 menu item

## Endpoint

| Method | Endpoint | Deskripsi |
| --- | --- | --- |
| POST | `/restaurants` | Membuat restoran |
| GET | `/restaurants` | Menampilkan semua restoran |
| GET | `/restaurants/:id` | Detail restoran beserta menu items |
| PUT | `/restaurants/:id` | Mengubah restoran |
| DELETE | `/restaurants/:id` | Menghapus restoran |
| POST | `/restaurants/:id/menu_items` | Menambah menu item ke restoran |
| GET | `/restaurants/:id/menu_items` | Menampilkan menu item restoran |
| PUT | `/menu_items/:id` | Mengubah menu item |
| DELETE | `/menu_items/:id` | Menghapus menu item |

Contoh filter kategori:

```bash
GET /restaurants/1/menu_items?category=drink
```

## Setup

1. Install dependency Ruby gems.

```bash
bundle install
```

2. Pastikan MySQL berjalan dan konfigurasi database di `config/database.yml` sesuai.

3. Buat database, jalankan migration, dan isi seed.

```bash
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
```

4. Jalankan server.

```bash
bundle exec rails s
```

API akan tersedia di `http://localhost:3000`.

## Authentication

Semua endpoint membutuhkan header berikut:

```bash
X-API-Key: development-api-key
```

Nilai default dipakai untuk local development jika environment variable `API_KEY` belum diisi. Untuk environment lain, disarankan set `API_KEY` secara eksplisit.

Contoh request:

```bash
curl -H "X-API-Key: development-api-key" http://localhost:3000/restaurants
```

## Pagination dan Search

Endpoint list mendukung query parameter:

- `page`: nomor halaman, default `1`
- `per_page`: jumlah data per halaman, default `10`, maksimum `50`

Contoh:

```bash
GET /restaurants?page=1&per_page=2
GET /restaurants/1/menu_items?page=2&per_page=3
```

Format respons endpoint list:

```json
{
	"data": [],
	"pagination": {
		"current_page": 1,
		"per_page": 10,
		"total_pages": 1,
		"total_count": 3
	}
}
```

Filter dan search menu item:

```bash
GET /restaurants/1/menu_items?category=drink
GET /restaurants/1/menu_items?name=tea
GET /restaurants/1/menu_items?category=drink&name=tea
```

## Docker

Project ini sudah disiapkan untuk dijalankan lewat Docker.

Jalankan:

```bash
docker compose up --build
```

Service yang tersedia:

- API Rails di port `3000`
- MySQL di port `3307`
- Redis di port `6380`

## Deployment

Repo sudah disiapkan agar lebih mudah dideploy ke layanan gratis berbasis container seperti Render. File konfigurasi awal tersedia di `render.yaml`.

Deployment aktual ke Railway, Render, atau Fly.io belum saya lakukan dari environment ini karena membutuhkan akun, secret, dan akses ke layanan eksternal.

## Menjalankan Test

```bash
bundle exec rspec
```

## Design Decisions

- Aplikasi menggunakan `config.api_only = true` agar fokus pada JSON API tanpa view layer Rails tradisional.
- Error handling dipusatkan di `ApplicationController` supaya format respons konsisten untuk `400`, `404`, dan `422`.
- API key authentication dipilih karena sederhana dan cukup untuk kebutuhan demo atau internal tool.
- Pagination ditambahkan di endpoint list untuk menjaga respons tetap ringan ketika data bertambah besar.
- Relasi database menggunakan `has_many` dan `belongs_to` dengan foreign key, `dependent: :destroy`, dan constraint `NOT NULL` pada kolom penting.
- Validasi kategori menu dibatasi ke `appetizer`, `main`, `dessert`, dan `drink` agar data tetap konsisten.
- Seed menggunakan data restoran dan menu bertema Thailand agar mudah dipakai untuk demo maupun pengujian manual.
