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

## Menjalankan Test

```bash
bundle exec rspec
```

## Design Decisions

- Aplikasi menggunakan `config.api_only = true` agar fokus pada JSON API tanpa view layer Rails tradisional.
- Error handling dipusatkan di `ApplicationController` supaya format respons konsisten untuk `400`, `404`, dan `422`.
- Relasi database menggunakan `has_many` dan `belongs_to` dengan foreign key, `dependent: :destroy`, dan constraint `NOT NULL` pada kolom penting.
- Validasi kategori menu dibatasi ke `appetizer`, `main`, `dessert`, dan `drink` agar data tetap konsisten.
- Seed menggunakan data restoran dan menu bertema Thailand agar mudah dipakai untuk demo maupun pengujian manual.
