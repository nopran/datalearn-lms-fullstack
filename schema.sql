-- ============================================
-- LMS DATABASE SCHEMA
-- Database: PostgreSQL 14+
-- ============================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS certificate_verifications CASCADE;
DROP TABLE IF EXISTS certificates CASCADE;
DROP TABLE IF EXISTS quiz_submissions CASCADE;
DROP TABLE IF EXISTS quiz_answers CASCADE;
DROP TABLE IF EXISTS quiz_questions CASCADE;
DROP TABLE IF EXISTS module_progress CASCADE;
DROP TABLE IF EXISTS course_modules CASCADE;
DROP TABLE IF EXISTS private_sessions CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS user_courses CASCADE;
DROP TABLE IF EXISTS course_reviews CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS subscription_plans CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) DEFAULT 'student' CHECK (role IN ('student', 'instructor', 'admin')),
    profile_image VARCHAR(500),
    email_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(100),
    reset_token VARCHAR(100),
    reset_token_expiry TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);

-- ============================================
-- SUBSCRIPTION PLANS
-- ============================================
CREATE TABLE subscription_plans (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    duration_months INTEGER NOT NULL,
    features JSONB,
    is_popular BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- COURSES
-- ============================================
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    instructor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    category VARCHAR(50) NOT NULL,
    level VARCHAR(20) CHECK (level IN ('beginner', 'intermediate', 'advanced')),
    price DECIMAL(10,2) NOT NULL,
    thumbnail VARCHAR(500),
    duration_weeks INTEGER,
    language VARCHAR(20) DEFAULT 'id',
    requirements TEXT,
    what_you_learn JSONB,
    is_published BOOLEAN DEFAULT FALSE,
    total_students INTEGER DEFAULT 0,
    average_rating DECIMAL(3,2) DEFAULT 0.00,
    total_reviews INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_courses_category ON courses(category);
CREATE INDEX idx_courses_slug ON courses(slug);
CREATE INDEX idx_courses_instructor ON courses(instructor_id);

-- ============================================
-- COURSE MODULES
-- ============================================
CREATE TABLE course_modules (
    id SERIAL PRIMARY KEY,
    course_id INTEGER REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    module_order INTEGER NOT NULL,
    module_type VARCHAR(20) CHECK (module_type IN ('video', 'quiz', 'reading', 'assignment', 'interactive')),
    content_url VARCHAR(500),
    duration_minutes INTEGER,
    is_free_preview BOOLEAN DEFAULT FALSE,
    resources JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_modules_course ON course_modules(course_id);

-- ============================================
-- QUIZ QUESTIONS
-- ============================================
CREATE TABLE quiz_questions (
    id SERIAL PRIMARY KEY,
    module_id INTEGER REFERENCES course_modules(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type VARCHAR(20) CHECK (question_type IN ('multiple_choice', 'true_false', 'essay')),
    options JSONB,
    correct_answer TEXT,
    points INTEGER DEFAULT 1,
    explanation TEXT,
    question_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_quiz_module ON quiz_questions(module_id);

-- ============================================
-- USER COURSES (Enrollments)
-- ============================================
CREATE TABLE user_courses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(id) ON DELETE CASCADE,
    enrollment_type VARCHAR(20) CHECK (enrollment_type IN ('purchase', 'subscription', 'free')),
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_date TIMESTAMP,
    progress_percentage DECIMAL(5,2) DEFAULT 0.00,
    is_completed BOOLEAN DEFAULT FALSE,
    last_accessed TIMESTAMP,
    UNIQUE(user_id, course_id)
);

CREATE INDEX idx_user_courses_user ON user_courses(user_id);
CREATE INDEX idx_user_courses_course ON user_courses(course_id);

-- ============================================
-- MODULE PROGRESS
-- ============================================
CREATE TABLE module_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    module_id INTEGER REFERENCES course_modules(id) ON DELETE CASCADE,
    is_completed BOOLEAN DEFAULT FALSE,
    time_spent_minutes INTEGER DEFAULT 0,
    last_position INTEGER DEFAULT 0,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, module_id)
);

CREATE INDEX idx_module_progress_user ON module_progress(user_id);

-- ============================================
-- QUIZ SUBMISSIONS
-- ============================================
CREATE TABLE quiz_submissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    module_id INTEGER REFERENCES course_modules(id) ON DELETE CASCADE,
    score DECIMAL(5,2),
    total_points INTEGER,
    passed BOOLEAN DEFAULT FALSE,
    attempt_number INTEGER DEFAULT 1,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_quiz_submissions_user ON quiz_submissions(user_id);

-- ============================================
-- QUIZ ANSWERS
-- ============================================
CREATE TABLE quiz_answers (
    id SERIAL PRIMARY KEY,
    submission_id INTEGER REFERENCES quiz_submissions(id) ON DELETE CASCADE,
    question_id INTEGER REFERENCES quiz_questions(id) ON DELETE CASCADE,
    user_answer TEXT,
    is_correct BOOLEAN,
    points_earned INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- ORDERS
-- ============================================
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    order_type VARCHAR(20) CHECK (order_type IN ('course', 'subscription')),
    item_id INTEGER,
    amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    final_amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'IDR',
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'failed', 'cancelled', 'refunded')),
    payment_method VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_status ON orders(status);

-- ============================================
-- PAYMENTS
-- ============================================
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    payment_gateway VARCHAR(50),
    transaction_id VARCHAR(255) UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'success', 'failed', 'expired')),
    payment_url VARCHAR(500),
    payment_proof VARCHAR(500),
    metadata JSONB,
    paid_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_payments_transaction ON payments(transaction_id);

-- ============================================
-- PRIVATE SESSIONS
-- ============================================
CREATE TABLE private_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    instructor_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    topic VARCHAR(255) NOT NULL,
    description TEXT,
    scheduled_date DATE NOT NULL,
    scheduled_time TIME NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    zoom_meeting_id VARCHAR(100),
    zoom_join_url VARCHAR(500),
    zoom_password VARCHAR(50),
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'rescheduled')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sessions_user ON private_sessions(user_id);
CREATE INDEX idx_sessions_date ON private_sessions(scheduled_date);

-- ============================================
-- CERTIFICATES
-- ============================================
CREATE TABLE certificates (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(id) ON DELETE CASCADE,
    certificate_number VARCHAR(100) UNIQUE NOT NULL,
    issue_date DATE NOT NULL,
    verification_hash VARCHAR(64) UNIQUE NOT NULL,
    pdf_url VARCHAR(500),
    is_verified BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, course_id)
);

CREATE INDEX idx_certificates_user ON certificates(user_id);
CREATE INDEX idx_certificates_number ON certificates(certificate_number);
CREATE INDEX idx_certificates_hash ON certificates(verification_hash);

-- ============================================
-- CERTIFICATE VERIFICATIONS
-- ============================================
CREATE TABLE certificate_verifications (
    id SERIAL PRIMARY KEY,
    certificate_id INTEGER REFERENCES certificates(id) ON DELETE CASCADE,
    verified_by_ip VARCHAR(45),
    verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- COURSE REVIEWS
-- ============================================
CREATE TABLE course_reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    course_id INTEGER REFERENCES courses(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    is_approved BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, course_id)
);

CREATE INDEX idx_reviews_course ON course_reviews(course_id);
CREATE INDEX idx_reviews_user ON course_reviews(user_id);

-- ============================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SEED DATA
-- ============================================

-- Insert default subscription plans
INSERT INTO subscription_plans (name, description, price, duration_months, features, is_popular) VALUES
('Bulanan', 'Akses semua kursus selama 1 bulan', 199000, 1, '["Akses semua kursus", "1 private session", "Sertifikat", "Support chat"]', false),
('Tahunan', 'Akses semua kursus selama 12 bulan + bonus', 1990000, 12, '["Akses semua kursus", "12 private sessions", "Sertifikat", "Priority support", "Diskon 17%"]', true),
('Lifetime', 'Akses selamanya ke semua kursus', 3999000, 9999, '["Akses semua kursus", "Unlimited private sessions", "Sertifikat", "VIP support", "Early access"]', false);

-- Insert admin user (password: admin123)
INSERT INTO users (email, password_hash, full_name, role, email_verified) VALUES
('admin@datalearn.com', '$2b$10$rqQVH7zt0vBUqEwRnFvs8.X7YOxOgVBj2lCF1qQvXqJ8eqL8LKX8e', 'Admin DataLearn', 'admin', true);

-- Insert sample instructor (password: instructor123)
INSERT INTO users (email, password_hash, full_name, role, email_verified, phone) VALUES
('ahmad.wijaya@datalearn.com', '$2b$10$rqQVH7zt0vBUqEwRnFvs8.X7YOxOgVBj2lCF1qQvXqJ8eqL8LKX8e', 'Dr. Ahmad Wijaya', 'instructor', true, '08123456789'),
('sarah.lestari@datalearn.com', '$2b$10$rqQVH7zt0vBUqEwRnFvs8.X7YOxOgVBj2lCF1qQvXqJ8eqL8LKX8e', 'Sarah Lestari', 'instructor', true, '08123456790'),
('budi.santoso@datalearn.com', '$2b$10$rqQVH7zt0vBUqEwRnFvs8.X7YOxOgVBj2lCF1qQvXqJ8eqL8LKX8e', 'Budi Santoso', 'instructor', true, '08123456791');

-- Insert sample courses
INSERT INTO courses (title, slug, description, instructor_id, category, level, price, duration_weeks, what_you_learn, is_published, total_students, average_rating, total_reviews) VALUES
('SQL untuk Data Analytics', 'sql-untuk-data-analytics', 'Master SQL dari dasar hingga advanced untuk analisis data. Pelajari query optimization, window functions, dan best practices.', 2, 'SQL', 'intermediate', 299000, 8, '["Fundamental SQL queries", "JOIN operations & subqueries", "Window functions & CTEs", "Query optimization", "Real-world projects"]', true, 1234, 4.8, 256),
('Tableau Fundamental', 'tableau-fundamental', 'Buat visualisasi data yang menarik dan interaktif dengan Tableau. Dari basic hingga advanced dashboard.', 3, 'Tableau', 'beginner', 399000, 6, '["Tableau interface & navigation", "Data connections", "Creating visualizations", "Dashboard design", "Interactive features"]', true, 987, 4.9, 198),
('Power BI untuk Business Intelligence', 'power-bi-untuk-business-intelligence', 'Transform data menjadi insight dengan Power BI. Pelajari DAX, Power Query, dan dashboard creation.', 4, 'Power BI', 'intermediate', 449000, 10, '["Power BI Desktop", "Power Query Editor", "DAX fundamentals", "Data modeling", "Advanced visualizations"]', true, 756, 4.7, 145);

-- Insert sample modules for SQL course
INSERT INTO course_modules (course_id, title, description, module_order, module_type, duration_minutes, is_free_preview) VALUES
(1, 'Pengenalan SQL & Database', 'Memahami konsep database relational dan syntax dasar SQL', 1, 'video', 45, true),
(1, 'SELECT Statement & Filtering', 'Belajar query data dengan SELECT, WHERE, ORDER BY', 2, 'video', 60, false),
(1, 'JOIN Operations', 'Menggabungkan data dari multiple tables', 3, 'video', 55, false),
(1, 'Aggregate Functions', 'COUNT, SUM, AVG, GROUP BY, HAVING', 4, 'video', 50, false),
(1, 'Quiz: SQL Fundamentals', 'Test pemahaman SQL dasar', 5, 'quiz', 30, false);

-- Insert sample quiz questions
INSERT INTO quiz_questions (module_id, question_text, question_type, options, correct_answer, points, question_order) VALUES
(5, 'Apa fungsi dari perintah SELECT dalam SQL?', 'multiple_choice', '["Menghapus data", "Mengambil data dari database", "Mengupdate data", "Membuat table baru"]', 'Mengambil data dari database', 1, 1),
(5, 'JOIN digunakan untuk menggabungkan data dari beberapa table', 'true_false', '["True", "False"]', 'True', 1, 2),
(5, 'Apa perbedaan antara WHERE dan HAVING?', 'multiple_choice', '["Tidak ada perbedaan", "WHERE untuk filter sebelum GROUP BY, HAVING untuk filter setelah GROUP BY", "HAVING hanya untuk COUNT", "WHERE lebih cepat"]', 'WHERE untuk filter sebelum GROUP BY, HAVING untuk filter setelah GROUP BY', 2, 3);

-- ============================================
-- VIEWS FOR REPORTING
-- ============================================

-- View: Course Statistics
CREATE OR REPLACE VIEW course_statistics AS
SELECT 
    c.id,
    c.title,
    c.category,
    c.price,
    c.total_students,
    c.average_rating,
    COUNT(DISTINCT uc.user_id) as enrolled_students,
    COUNT(DISTINCT CASE WHEN uc.is_completed = true THEN uc.user_id END) as completed_students,
    SUM(CASE WHEN o.status = 'paid' THEN o.final_amount ELSE 0 END) as total_revenue
FROM courses c
LEFT JOIN user_courses uc ON c.id = uc.course_id
LEFT JOIN orders o ON o.item_id = c.id AND o.order_type = 'course'
GROUP BY c.id, c.title, c.category, c.price, c.total_students, c.average_rating;

-- View: User Progress Summary
CREATE OR REPLACE VIEW user_progress_summary AS
SELECT 
    u.id as user_id,
    u.full_name,
    u.email,
    COUNT(DISTINCT uc.course_id) as total_enrolled,
    COUNT(DISTINCT CASE WHEN uc.is_completed = true THEN uc.course_id END) as courses_completed,
    COUNT(DISTINCT c.id) as certificates_earned,
    AVG(uc.progress_percentage) as average_progress
FROM users u
LEFT JOIN user_courses uc ON u.id = uc.user_id
LEFT JOIN certificates c ON u.id = c.user_id
WHERE u.role = 'student'
GROUP BY u.id, u.full_name, u.email;

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function: Update course rating
CREATE OR REPLACE FUNCTION update_course_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE courses
    SET 
        average_rating = (
            SELECT COALESCE(AVG(rating), 0)
            FROM course_reviews
            WHERE course_id = NEW.course_id AND is_approved = true
        ),
        total_reviews = (
            SELECT COUNT(*)
            FROM course_reviews
            WHERE course_id = NEW.course_id AND is_approved = true
        )
    WHERE id = NEW.course_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_course_rating
AFTER INSERT OR UPDATE ON course_reviews
FOR EACH ROW EXECUTE FUNCTION update_course_rating();

-- Function: Update course progress
CREATE OR REPLACE FUNCTION update_course_progress()
RETURNS TRIGGER AS $$
DECLARE
    total_modules INTEGER;
    completed_modules INTEGER;
    course_id_var INTEGER;
BEGIN
    -- Get course_id from module
    SELECT cm.course_id INTO course_id_var
    FROM course_modules cm
    WHERE cm.id = NEW.module_id;
    
    -- Count total and completed modules
    SELECT COUNT(*) INTO total_modules
    FROM course_modules
    WHERE course_id = course_id_var;
    
    SELECT COUNT(*) INTO completed_modules
    FROM module_progress mp
    JOIN course_modules cm ON mp.module_id = cm.id
    WHERE cm.course_id = course_id_var 
    AND mp.user_id = NEW.user_id 
    AND mp.is_completed = true;
    
    -- Update user course progress
    UPDATE user_courses
    SET 
        progress_percentage = (completed_modules::DECIMAL / total_modules * 100),
        is_completed = (completed_modules = total_modules),
        completion_date = CASE WHEN completed_modules = total_modules THEN CURRENT_TIMESTAMP ELSE NULL END
    WHERE user_id = NEW.user_id AND course_id = course_id_var;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_course_progress
AFTER INSERT OR UPDATE ON module_progress
FOR EACH ROW EXECUTE FUNCTION update_course_progress();

COMMENT ON DATABASE postgres IS 'DataLearn LMS - Learning Management System Database';
