# 🚀 START HERE - DataLearn LMS

## 👋 Selamat Datang!

Terima kasih sudah download **DataLearn LMS** - Platform Learning Management System lengkap berbasis database.

---

## 📖 Baca File Ini Urut dari Atas ke Bawah

### 1. 📥 **DOWNLOAD.md** ← MULAI DARI SINI!
**Cara download, extract, dan cek file sudah lengkap.**

Baca ini dulu jika:
- Baru download project
- File belum di-extract
- Mau pastikan semua file lengkap

### 2. 📋 **README.md** ← BACA INI KEDUA
**Overview project, fitur, dan quick start.**

Baca ini untuk:
- Mengerti apa itu DataLearn LMS
- Lihat fitur-fitur yang ada
- Quick start dalam 3 langkah

### 3. 🛠️ **SETUP.md** ← PANDUAN INSTALL LENGKAP
**Panduan setup detail step-by-step dari nol.**

Baca ini untuk:
- Install Node.js dan PostgreSQL
- Setup database
- Setup backend & frontend
- Troubleshooting error

### 4. 📚 **docs/README.md** ← DOKUMENTASI TEKNIS
**Dokumentasi lengkap API, database, dan arsitektur.**

Baca ini untuk:
- Dokumentasi API endpoints
- Database schema detail
- Konfigurasi advanced

### 5. 🚀 **docs/DEPLOYMENT.md** ← CARA DEPLOY
**Panduan deploy ke production (Railway, Heroku, VPS, Vercel).**

Baca ini untuk:
- Deploy backend ke Railway/Heroku/VPS
- Deploy frontend ke Vercel/Netlify
- Setup domain dan SSL
- Production checklist

---

## ⚡ Quick Start (Jika Sudah Familiar)

Jika Anda sudah paham Node.js dan PostgreSQL:

```bash
# 1. Setup database
psql -U postgres
CREATE DATABASE datalearn_lms;
\q
psql -U postgres -d datalearn_lms -f database/schema.sql

# 2. Setup backend
cd backend
npm install
cp .env.example .env
# Edit .env (isi DB_PASSWORD dan JWT_SECRET)
npm run dev

# 3. Buka frontend
cd ../frontend
# Buka index.html di browser
# atau: npx http-server -p 3000
```

**Login default:**
- Email: `admin@datalearn.com`
- Password: `admin123`

---

## 🎯 Apa yang Ada di Project Ini?

### ✅ Backend (Node.js + Express + PostgreSQL)
- Complete REST API
- Authentication & Authorization (JWT)
- User Management
- Course Management
- Payment Integration (Midtrans ready)
- Certificate Generation
- Email Service
- Private Session Booking

### ✅ Frontend (HTML + Tailwind CSS + JavaScript)
- Responsive web interface
- Student dashboard
- Course catalog & enrollment
- Learning interface
- Admin panel
- Payment checkout

### ✅ Database (PostgreSQL)
- 15+ tables dengan relasi lengkap
- Sample data (3 courses, admin accounts)
- Triggers & functions
- Optimized dengan indexes

### ✅ Documentation
- Setup guide (Bahasa Indonesia)
- API documentation
- Deployment guide
- Troubleshooting tips

---

## 📂 Struktur Folder

```
datalearn-lms-fullstack/
│
├── START_HERE.md        ← File ini (baca dulu!)
├── DOWNLOAD.md          ← Cara download & extract
├── README.md            ← Overview & quick start
├── SETUP.md             ← Panduan install lengkap
│
├── backend/             ← API Server
│   ├── server.js        ← Main server file
│   ├── package.json     ← Dependencies
│   ├── .env.example     ← Environment template
│   ├── config/          ← Database config
│   ├── models/          ← Database models
│   ├── routes/          ← API endpoints
│   ├── middleware/      ← Auth middleware
│   └── utils/           ← Helper functions
│
├── frontend/            ← Web Interface
│   └── index.html       ← Single page app
│
├── database/            ← Database
│   └── schema.sql       ← PostgreSQL schema
│
└── docs/                ← Documentation
    ├── README.md        ← Full documentation
    └── DEPLOYMENT.md    ← Deploy guide
```

---

## 🔑 Default Login Credentials

Setelah setup database, login dengan:

**Admin:**
- Email: `admin@datalearn.com`
- Password: `admin123`

**Instructor:**
- Email: `ahmad.wijaya@datalearn.com`
- Password: `instructor123`

⚠️ **Ganti password ini setelah login pertama!**

---

## ❓ FAQ (Pertanyaan Umum)

### Q: Saya tidak familiar dengan Node.js/PostgreSQL, bisa pakai ini?
**A:** Bisa! Baca `SETUP.md` yang sudah dijelaskan step-by-step dengan detail.

### Q: Harus install apa saja?
**A:** Node.js 16+ dan PostgreSQL 14+. Download link ada di `SETUP.md`.

### Q: Apakah gratis?
**A:** Ya, sepenuhnya open source (MIT License). Boleh dipakai untuk project pribadi atau komersial.

### Q: Bisa deploy ke hosting?
**A:** Bisa! Baca `docs/DEPLOYMENT.md` untuk panduan deploy ke Railway (gratis), Heroku, VPS, atau Vercel.

### Q: Database apa yang dipakai?
**A:** PostgreSQL. Sudah include schema lengkap di `database/schema.sql`.

### Q: Ada dokumentasi API?
**A:** Ada! Lengkap di `docs/README.md`.

### Q: Bisa customize?
**A:** Tentu! Semua source code ada dan bisa diubah sesuai kebutuhan.

---

## 🐛 Troubleshooting Umum

### Error: "Cannot connect to database"
→ PostgreSQL belum jalan atau password salah
→ Solusi lengkap di `SETUP.md` bagian Troubleshooting

### Error: "Port already in use"
→ Port 5000 sudah dipakai aplikasi lain
→ Ganti port di `.env`

### Frontend tidak bisa connect ke backend
→ Check API_URL di `frontend/index.html`
→ Pastikan backend sudah running

**Solusi lengkap:** Baca section Troubleshooting di `SETUP.md`

---

## 📞 Butuh Bantuan?

1. ✅ Baca `SETUP.md` dulu (99% masalah terjawab di sini)
2. ✅ Check section Troubleshooting
3. ✅ Baca dokumentasi di folder `docs/`
4. ✅ Google error message yang muncul

---

## 🎓 Fitur Utama

### Untuk Student:
- ✅ Register & Login
- ✅ Browse courses
- ✅ Video learning
- ✅ Interactive quiz
- ✅ Progress tracking
- ✅ Digital certificates
- ✅ Private sessions
- ✅ Multiple payment methods

### Untuk Admin/Instructor:
- ✅ Dashboard analytics
- ✅ Manage courses & users
- ✅ Create quiz & modules
- ✅ View reports
- ✅ Manage payments
- ✅ Issue certificates

---

## 🚀 Langkah Selanjutnya

1. ✅ Baca `DOWNLOAD.md` jika belum extract
2. ✅ Baca `README.md` untuk overview
3. ✅ Ikuti `SETUP.md` untuk install
4. ✅ Jalankan aplikasi
5. ✅ Login dan explore fitur
6. ✅ Customize sesuai kebutuhan
7. ✅ Deploy ke production (baca `docs/DEPLOYMENT.md`)

---

## 📊 Tech Stack

- **Backend:** Node.js, Express.js, PostgreSQL, Sequelize
- **Frontend:** HTML5, CSS3 (Tailwind), JavaScript
- **Auth:** JWT + bcrypt
- **Payment:** Midtrans integration ready
- **Email:** Nodemailer

---

## 📄 License

MIT License - Free untuk personal & commercial use

---

**Dibuat dengan ❤️ untuk pembelajaran**

**Selamat belajar membangun LMS! 🎉**

---

💡 **Tips:** Bookmark file ini untuk referensi cepat!
