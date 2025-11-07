# 📖 Panduan Setup Detail - DataLearn LMS

Panduan lengkap setup LMS dari nol sampai jalan.

---

## 📋 Daftar Isi

1. [Persiapan](#persiapan)
2. [Install Software](#install-software)
3. [Setup Database](#setup-database)
4. [Setup Backend](#setup-backend)
5. [Setup Frontend](#setup-frontend)
6. [Testing](#testing)
7. [Troubleshooting](#troubleshooting)

---

## 1️⃣ Persiapan

### Cek Requirement

Pastikan komputer Anda punya:
- RAM minimal 4GB
- Storage minimal 5GB free space
- Koneksi internet

### Software yang Dibutuhkan

- ✅ **Node.js 16+** (untuk backend)
- ✅ **PostgreSQL 14+** (untuk database)
- ✅ **Text Editor** (VSCode, Sublime, Notepad++, dll)
- ✅ **Browser** (Chrome, Firefox, Edge)

---

## 2️⃣ Install Software

### Install Node.js

**Windows:**
1. Download dari [nodejs.org](https://nodejs.org)
2. Pilih LTS version (contoh: 18.x atau 20.x)
3. Run installer → Next → Next → Install
4. Buka Command Prompt, test:
   ```cmd
   node -v
   npm -v
   ```

**Mac:**
```bash
# Pakai Homebrew
brew install node@18
```

**Linux (Ubuntu/Debian):**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Install PostgreSQL

**Windows:**
1. Download dari [postgresql.org](https://www.postgresql.org/download/windows/)
2. Run installer
3. Set password untuk user `postgres` (INGAT PASSWORD INI!)
4. Port default: 5432 (jangan diganti)
5. Install semua components termasuk pgAdmin

**Mac:**
```bash
brew install postgresql@14
brew services start postgresql@14
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

---

## 3️⃣ Setup Database

### Option A: Pakai Command Line (psql)

**Windows - Command Prompt:**
```cmd
# Login ke PostgreSQL
psql -U postgres

# Ketik password PostgreSQL yang tadi dibuat
# Setelah masuk, ketik:
CREATE DATABASE datalearn_lms;

# Keluar dari psql
\q

# Import schema
cd path\to\datalearn-lms-fullstack
psql -U postgres -d datalearn_lms -f database\schema.sql
```

**Mac/Linux - Terminal:**
```bash
# Login ke PostgreSQL
sudo -u postgres psql

# Buat database
CREATE DATABASE datalearn_lms;

# Keluar
\q

# Import schema
cd /path/to/datalearn-lms-fullstack
psql -U postgres -d datalearn_lms -f database/schema.sql
```

### Option B: Pakai pgAdmin (GUI)

1. **Buka pgAdmin** (sudah terinstall dengan PostgreSQL)
2. **Connect ke server:**
   - Klik "Servers" → "PostgreSQL"
   - Masukkan password postgres
3. **Buat Database:**
   - Klik kanan "Databases" → "Create" → "Database"
   - Name: `datalearn_lms`
   - Owner: `postgres`
   - Save
4. **Import Schema:**
   - Klik database `datalearn_lms`
   - Klik icon "Query Tool" (ikon petir)
   - Klik "Open File"
   - Pilih file `database/schema.sql`
   - Klik "Execute" (F5)
   - Tunggu sampai selesai (akan muncul "Query returned successfully")

✅ **Database siap!** Ada 15+ tables dan sample data.

---

## 4️⃣ Setup Backend

### Install Dependencies

**Buka terminal/command prompt:**
```bash
cd backend
npm install
```

Tunggu proses install (sekitar 1-3 menit).

### Buat File .env

**Copy template:**
```bash
# Windows
copy .env.example .env

# Mac/Linux
cp .env.example .env
```

**Edit file `.env` dengan text editor:**

```env
# Server Configuration
NODE_ENV=development
PORT=5000
API_URL=http://localhost:5000
FRONTEND_URL=http://localhost:3000

# Database - GANTI SESUAI SETUP ANDA!
DB_HOST=localhost
DB_PORT=5432
DB_NAME=datalearn_lms
DB_USER=postgres
DB_PASSWORD=password_postgres_anda_disini

# JWT Secret - GANTI DENGAN STRING RANDOM!
JWT_SECRET=ini-secret-key-minimal-32-karakter-ganti-dengan-random-string
JWT_EXPIRES_IN=7d

# Email (Optional - bisa diisi nanti)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=

# Payment (Optional - bisa diisi nanti)
MIDTRANS_SERVER_KEY=
MIDTRANS_CLIENT_KEY=
MIDTRANS_IS_PRODUCTION=false

# Security
BCRYPT_ROUNDS=10
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX_REQUESTS=100
```

**PENTING:**
- Ganti `DB_PASSWORD` dengan password PostgreSQL Anda
- Ganti `JWT_SECRET` dengan random string (minimal 32 karakter)

### Generate JWT Secret (Optional)

**Node.js:**
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Copy hasilnya ke `JWT_SECRET` di `.env`

### Jalankan Backend

```bash
npm run dev
```

**Jika berhasil, akan muncul:**
```
╔════════════════════════════════════════╗
║   DataLearn LMS API Server Running    ║
║   Port: 5000                          ║
║   Environment: development            ║
║   Database: Connected                 ║
╚════════════════════════════════════════╝
```

✅ **Backend jalan!** Biarkan terminal ini tetap terbuka.

### Test Backend

Buka browser, akses: `http://localhost:5000/health`

Harus muncul:
```json
{
  "status": "OK",
  "timestamp": "...",
  "uptime": 123
}
```

---

## 5️⃣ Setup Frontend

### Option A: Langsung Buka di Browser

1. Buka Windows Explorer / Finder
2. Navigate ke folder `frontend/`
3. Double-click file `index.html`
4. Website akan terbuka di browser

✅ Done!

### Option B: Pakai HTTP Server (Recommended)

**Buka terminal/command prompt baru:**
```bash
cd frontend
npx http-server -p 3000
```

**Buka browser:** `http://localhost:3000`

---

## 6️⃣ Testing

### Test 1: Login Admin

1. Buka frontend di browser
2. Klik **"Masuk"**
3. Login dengan:
   - Email: `admin@datalearn.com`
   - Password: `admin123`
4. Jika berhasil, akan masuk ke Dashboard

### Test 2: Register User Baru

1. Klik **"Daftar"**
2. Isi form:
   - Nama: Test User
   - Email: test@example.com
   - Password: password123
3. Submit
4. Jika berhasil, akan login otomatis

### Test 3: Browse Courses

1. Klik menu **"Kursus"**
2. Harus muncul 3 courses:
   - SQL untuk Data Analytics
   - Tableau Fundamental
   - Power BI untuk Business Intelligence

### Test 4: Enroll Course

1. Klik salah satu course
2. Klik **"Daftar Sekarang"**
3. Pilih metode pembayaran (simulasi)
4. Klik **"Bayar Sekarang"**
5. Tunggu 2 detik (simulasi payment)
6. Harus muncul alert: "Pembayaran berhasil!"

---

## 7️⃣ Troubleshooting

### ❌ Error: "Cannot connect to database"

**Penyebab:** PostgreSQL tidak jalan atau credentials salah.

**Solusi:**

1. **Check PostgreSQL jalan:**
   
   **Windows:**
   - Tekan `Win + R`
   - Ketik `services.msc`
   - Cari "PostgreSQL" → harus status "Running"
   - Jika tidak, klik kanan → Start

   **Mac:**
   ```bash
   brew services list
   # Jika tidak running:
   brew services start postgresql@14
   ```

   **Linux:**
   ```bash
   sudo systemctl status postgresql
   # Jika tidak running:
   sudo systemctl start postgresql
   ```

2. **Check credentials di `.env`:**
   - Pastikan `DB_PASSWORD` benar
   - Test login manual: `psql -U postgres -d datalearn_lms`

### ❌ Error: "Port 5000 already in use"

**Solusi:**

**Option 1 - Ganti port backend:**
Edit `.env`:
```env
PORT=5001
```

**Option 2 - Matikan aplikasi yang pakai port 5000:**
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID_NUMBER> /F

# Mac/Linux
lsof -ti:5000 | xargs kill -9
```

### ❌ Error: "Module not found"

**Solusi:**
```bash
cd backend
rm -rf node_modules package-lock.json
npm install
```

### ❌ Frontend tidak bisa connect ke backend

**Solusi:**

Edit file `frontend/index.html`, cari baris ini (sekitar line 140):
```javascript
const API_URL = 'http://localhost:5000';
```

Ganti dengan port backend yang benar.

### ❌ Database schema import error

**Solusi:**

1. **Drop database dan buat ulang:**
   ```sql
   DROP DATABASE datalearn_lms;
   CREATE DATABASE datalearn_lms;
   ```

2. **Import ulang:**
   ```bash
   psql -U postgres -d datalearn_lms -f database/schema.sql
   ```

### ❌ Email tidak terkirim

**Normal!** Email service butuh konfigurasi SMTP di `.env`. Untuk development, email bisa di-skip. Aplikasi tetap jalan normal.

---

## 🎉 Selamat!

Jika sudah sampai sini dan semua jalan, congratulations! 🎊

### Next Steps:

1. ✅ Explore semua fitur
2. ✅ Baca dokumentasi API di `docs/README.md`
3. ✅ Customize sesuai kebutuhan
4. ✅ Deploy ke production (`docs/DEPLOYMENT.md`)

---

## 📞 Butuh Bantuan Lebih?

- Cek file `README.md` di root folder
- Baca dokumentasi lengkap di folder `docs/`
- Google error message yang muncul
- Check GitHub issues (jika ada repository)

---

**Happy Learning! 🚀**
