-- DDL

-- Tabel Pengguna (Users)
CREATE TABLE users (
    user_id VARCHAR(15) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    role VARCHAR(10) NOT NULL, 
    contact_info VARCHAR(100),
    password VARCHAR(255) NOT NULL 
);

-- Tabel Proyek (Projects)
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL, 
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    categories VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Anggota Proyek (Project Members)
CREATE TABLE project_members (
    project_member_id SERIAL PRIMARY KEY,
    role_project VARCHAR(10) NOT NULL, 
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOL NOT NULL, 
    users_user_id VARCHAR(15) NOT NULL,
    projects_project_id INT NOT NULL,
    FOREIGN KEY (users_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (projects_project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);

-- Tabel Milestone Proyek
CREATE TABLE milestones (
    milestone_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    due_date TIMESTAMP,
    status VARCHAR(100) NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    projects_project_id INT NOT NULL,
    FOREIGN KEY (projects_project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);

-- Tabel Dokumen
CREATE TABLE documents (
    document_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    file_url VARCHAR(255) NOT NULL,
    document_type VARCHAR(100), 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    projects_project_id INT NOT NULL,
    users_user_id VARCHAR(15) NOT NULL,
    FOREIGN KEY (projects_project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (users_user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- DML

INSERT INTO users (user_id, name, email, password, role, contact_info) VALUES
('6010000000', 'Brandon Russell', '6010000000@student.its.ac.id', '$2a$04$0tjrF!g*$b5t9JNM(AQNmhTx!sZKRkWnQJPWZf&O', 'mahasiswa', '068-855-0225'),
('6010000001', 'Benjamin Bryant', '6010000001@student.its.ac.id', '$2a$04$Zzx(5X1zKh$)26E8KJ(%E&KbR^dHy7MhCDZxrJfc', 'dosen', '001-503-915-0536'),
('6010000002', 'Jasmine Torres', '6010000002@student.its.ac.id', '$2a$04$qgybAk#QqQ_PSFsD*P3BHL^22zr2T&BoRulR0Ngj', 'mahasiswa', '+1-465-285-8129x6602'),
('6010000003', 'Danny Mason', '6010000003@student.its.ac.id', '$2a$04$B4Vm2zGl*F7upF^9tPW%GVAMie5KoTnwLU5C$)JO', 'dosen', '(909)975-9105'),
('6010000004', 'Joshua Nguyen', '6010000004@student.its.ac.id', '$2a$04$E$!b270gR2O%4R*nTl4uZHlL%KaF+)uyx63H@IB#', 'dosen', '(390)789-4905x631'),
('6010000005', 'Douglas Day', '6010000005@student.its.ac.id', '$2a$04$_gt)MpS@Q@3v*nhjC&bw1BNp!k&7_Lva%+M&bEwm', 'mahasiswa', '380-527-3638x66836'),
('6010000006', 'Adam Murphy', '6010000006@student.its.ac.id', '$2a$04$yTF_8#9nolP!9G1CpgwRHc2IJNaSSG7#tY+21_e*', 'mahasiswa', '(530)081-1343x2809'),
('6010000007', 'Heather King', '6010000007@student.its.ac.id', '$2a$04$oXuAcusv1*3I5!Il&RJjGAq)U7$beqBSazbAr23$', 'dosen', '948-818-1544'),
('6010000008', 'Stephanie Brown', '6010000008@student.its.ac.id', '$2a$04$#!+Z*enkrXC1aya*$+l_eVEw7I1RaSJurW_8vWLa', 'admin', '001-369-685-1317'),
('6010000009', 'Paul Brooks', '6010000009@student.its.ac.id', '$2a$04$X5G_c*vvh&kOBWoksv7c1*2$QjF#_aDHljrPajNb', 'admin', '001-489-953-2050x9175'),
('6010000010', 'Ms. Jessica Jones', '6010000010@student.its.ac.id', '$2a$04$xSbTfYdh#)LmnJoD^)wEA^35Ty!NJe%1DCIOHEv*', 'dosen', '001-765-066-1577x0105'),
('6010000011', 'Bradley Jones', '6010000011@student.its.ac.id', '$2a$04$(KP#39e+WERqXo35N5Bj2NCYMtKtTHM*@oGTR5%f', 'dosen', '+1-767-060-1486x6555'),
('6010000012', 'Paula Thompson', '6010000012@student.its.ac.id', '$2a$04$LXX22VhAu2L16YfC*$3%M0yQW5*rEAL)FH@OKf+U', 'mahasiswa', '361.968.1572x25922'),
('6010000013', 'Virginia Matthews', '6010000013@student.its.ac.id', '$2a$04$*5Xuz^7T7xXy!e&Py^MPKAHr_CKh6AdNDo5Eu6U&', 'mahasiswa', '282.371.1420'),
('6010000014', 'Chris Allen', '6010000014@student.its.ac.id', '$2a$04$!uy4W+WKeBeaCy%@)(Oba+R08HNGJVuC)56zA&Fx', 'mahasiswa', '+1-537-283-6562x4956'),
('6010000015', 'Amy Hernandez', '6010000015@student.its.ac.id', '$2a$04$ROZ2llaQ32bQ2p8p_mB6^F5EXp(@8o$YwjD*ZQxm', 'dosen', '001-631-870-9952x33011'),
('6010000016', 'Christina Rivera', '6010000016@student.its.ac.id', '$2a$04$bH63C34q)6_XGhu%xVeswb6pD3G_tRBjydoJCEfV', 'admin', '947.589.5277x8122'),
('6010000017', 'Victoria Baldwin', '6010000017@student.its.ac.id', '$2a$04$26@^43_0wgUb5JMaD_q_LRm_4Iq7Y*5cFhr5t@%g', 'dosen', '7090612125'),
('6010000018', 'Samuel Rocha', '6010000018@student.its.ac.id', '$2a$04$!Sbx+8wpTYUdp%vLq8P7WlM)M_zXRxAgsrYqU924', 'admin', '+1-386-701-0117x638'),
('6010000019', 'Sean Griffin', '6010000019@student.its.ac.id', '$2a$04$c_r_bMwp8l8XovDoc96yT$QFjY+oDb3^4cPc)1^E', 'mahasiswa', '645.884.8980');

INSERT INTO projects (title, description, status, start_date, end_date, categories, created_at) VALUES
('Senolacrity', 'Lightweight AI Agent on the terminal', 'ONGOING', '2024-01-15', NULL, 'LLM', '2024-01-15 09:00:00'),
    ('iBus', 'Outdoor navigation system for the upcoming iBus', 'PLANNING', '2024-03-01', NULL, 'IoT', '2024-02-15 14:30:00'),
    ('ITS Research & Collaboration', 'System for managing, organizing, and collabarate in research', 'COMPLETED', '2024-06-13', '2024-06-18', 'Event Management', '2024-06-13 23:56:59');
('Pengembangan Sistem Pembayaran Wajah', 'Inovasi pembayaran menggunakan teknologi pengenalan wajah.', 'PLANNING', '2024-09-15 18:46:52', NULL, 'AI', '2024-09-15 18:46:52'),
('Aplikasi Manajemen Acara Kampus', 'Mempermudah pengelolaan dan pendaftaran acara di kampus.', 'ONGOING', '2024-08-20 11:26:18', NULL, 'Event Management', '2024-08-20 11:26:18'),
('Platform Kolaborasi Tim Mahasiswa', 'Memfasilitasi kolaborasi dan komunikasi antar mahasiswa.', 'PLANNING', '2025-01-03 08:21:09', NULL, 'Mobile', '2025-01-03 08:21:09'),
('Solusi Cerdas untuk Pertanian Modern', 'Penggunaan AI untuk optimasi hasil pertanian.', 'ONGOING', '2025-05-28 11:14:32', NULL, 'AI', '2025-05-28 11:14:32'),
('Sistem Keamanan Data Berbasis Blockchain', 'Peningkatan keamanan data dengan teknologi blockchain.', 'PLANNING', '2025-05-11 11:29:17', NULL, 'Blockchain', '2025-05-11 11:29:17'),
('Edukasi Interaktif untuk Anak Sekolah Dasar', 'Konten edukasi berbasis AI yang menarik.', 'COMPLETED', '2024-12-27 06:10:24', '2025-05-20 06:10:24', 'AI', '2024-12-27 06:10:24'),
('Peningkatan Kualitas Layanan Publik', 'Pengembangan sistem untuk meningkatkan efisiensi layanan.', 'PLANNING', '2025-04-26 07:45:01', NULL, 'AI', '2025-04-26 07:45:01'),
('Monitoring Kesehatan IoT untuk Lansia', 'Perangkat IoT untuk memantau kesehatan lansia dari jarak jauh.', 'COMPLETED', '2025-02-23 12:02:40', '2025-04-30 12:02:40', 'IoT', '2025-02-23 12:02:40'),
('Dompet Digital Aman Berbasis Blockchain', 'Aplikasi dompet digital dengan keamanan terjamin.', 'PLANNING', '2024-06-18 03:47:29', NULL, 'Blockchain', '2024-06-18 03:47:29'),
('Aplikasi Belanja Online Ramah Pengguna', 'Peningkatan fitur dan antarmuka aplikasi belanja.', 'ONGOING', '2025-01-15 08:31:21', NULL, 'Mobile', '2025-01-15 08:31:21'),
('Sistem Verifikasi Data Menggunakan Blockchain', 'Memastikan keaslian data dengan teknologi blockchain.', 'ONGOING', '2024-07-14 03:51:18', NULL, 'Blockchain', '2024-07-14 03:51:18'),
('Kampanye Lingkungan Hidup Berbasis Digital', 'Mengelola acara kampanye lingkungan secara daring.', 'ONGOING', '2024-11-24 10:43:58', NULL, 'Event Management', '2024-11-24 10:43:58'),
('Penjadwalan Acara Otomatis', 'Alat bantu untuk mengatur jadwal berbagai acara.', 'PLANNING', '2025-03-04 11:11:49', NULL, 'Event Management', '2025-03-04 11:11:49'),
('Analisis Tren Pasar Kripto', 'Analisis data untuk memprediksi pergerakan pasar kripto.', 'ONGOING', '2024-12-22 20:46:27', NULL, 'Blockchain', '2024-12-22 20:46:27'),
('Sistem Smart Home Berbasis IoT', 'Otomatisasi rumah tangga dengan perangkat IoT.', 'COMPLETED', '2024-07-16 02:32:12', '2024-12-16 02:32:12', 'IoT', '2024-07-16 02:32:12'),
('Aplikasi Mobile Pelacak Kebugaran', 'Aplikasi untuk memantau aktivitas fisik dan kesehatan.', 'COMPLETED', '2024-08-16 07:25:40', '2025-01-27 07:25:40', 'Mobile', '2024-08-16 07:25:40'),
('Sistem Rekomendasi Film Berbasis AI', 'Rekomendasi film personalisasi menggunakan AI.', 'ONGOING', '2024-09-29 23:42:22', NULL, 'AI', '2024-09-29 23:42:22'),
('Manajemen Tiket Konser Digital', 'Platform untuk penjualan dan pengelolaan tiket konser.', 'ONGOING', '2024-08-28 15:21:09', NULL, 'Event Management', '2024-08-28 15:21:09'),
('Pengembangan Website E-Commerce Fashion', 'Pembuatan situs web e-commerce untuk produk fashion.', 'COMPLETED', '2024-09-15 04:05:19', '2025-02-23 04:05:19', 'Web', '2024-09-15 04:05:19'),
('Riset Daur Ulang Limbah Plastik', 'Studi dan pengembangan metode daur ulang yang efektif.', 'COMPLETED', '2025-06-12 04:58:46', '2025-11-26 04:58:46', 'Sustainability', '2025-06-12 04:58:46');

INSERT INTO project_members (role_project, joined_at, is_active, users_user_id, projects_project_id) VALUES
('member', '2024-07-15 16:09:25', false, '6010000011', 20),
('manager', '2025-01-17 09:55:07', true, '6010000002', 19),
('member', '2024-10-27 13:55:36', true, '6010000010', 14),
('member', '2025-05-31 02:16:46', true, '6010000014', 16),
('member', '2024-06-27 23:12:10', true, '6010000006', 22),
('manager', '2024-08-26 15:39:53', false, '6010000000', 15),
('manager', '2024-11-24 10:37:00', false, '6010000017', 20),
('manager', '2024-11-20 20:59:45', false, '6010000015', 11),
('member', '2025-03-29 21:23:03', true, '6010000004', 21),
('member', '2025-03-23 06:29:45', false, '6010000014', 5),
('manager', '2024-11-09 00:33:31', true, '6010000014', 10),
('manager', '2025-03-27 09:10:47', false, '6010000011', 12),
('member', '2024-12-08 02:35:26', false, '6010000000', 7),
('manager', '2025-01-05 06:34:01', false, '6010000002', 6),
('member', '2024-10-03 18:53:31', true, '6010000017', 16),
('manager', '2024-10-13 21:49:39', false, '6010000000', 14),
('member', '2025-04-09 07:54:48', false, '6010000001', 21),
('member', '2025-04-11 12:05:10', false, '6010000011', 4),
('manager', '2024-11-07 09:49:27', false, '6010000002', 8),
('member', '2025-06-06 10:49:51', true, '6010000002', 5),
('member', '2025-04-29 03:07:48', false, '6010000004', 13),
('member', '2024-12-30 21:28:24', false, '6010000004', 21),
('member', '2024-12-21 00:23:51', true, '6010000005', 22),
('member', '2025-05-27 16:06:31', false, '6010000001', 8),
('member', '2024-09-11 17:39:17', true, '6010000011', 18),
('member', '2025-01-26 14:45:23', false, '6010000013', 4),
('manager', '2024-12-15 08:37:21', false, '6010000016', 20),
('manager', '2024-10-24 14:44:15', false, '6010000016', 7),
('member', '2025-02-27 06:35:42', true, '6010000018', 14),
('manager', '2024-11-09 14:16:37', false, '6010000016', 11),
('manager', '2024-07-17 10:07:25', false, '6010000008', 16),
('manager', '2024-10-01 07:36:21', true, '6010000006', 20),
('manager', '2024-10-16 09:41:37', true, '6010000006', 12),
('manager', '2024-09-16 09:46:20', true, '6010000019', 14),
('manager', '2024-09-02 17:56:44', false, '6010000017', 21),
('manager', '2025-04-10 21:53:32', true, '6010000015', 19),
('member', '2024-07-15 14:40:03', true, '6010000008', 22),
('member', '2025-06-10 18:43:41', false, '6010000012', 11),
('manager', '2024-09-06 08:46:50', true, '6010000019', 23),
('member', '2025-03-17 20:46:51', false, '6010000018', 7),
('manager', '2025-01-16 11:49:37', false, '6010000014', 15),
('member', '2024-10-26 15:52:56', false, '6010000011', 10),
('member', '2025-01-25 09:10:12', false, '6010000006', 9),
('member', '2025-06-12 12:55:01', true, '6010000013', 16),
('member', '2025-05-21 13:28:30', true, '6010000017', 16),
('member', '2025-03-15 14:53:10', true, '6010000009', 7),
('member', '2025-06-11 17:48:10', false, '6010000001', 16),
('manager', '2025-05-20 16:54:10', false, '6010000009', 7),
('member', '2024-11-28 23:04:15', false, '6010000007', 18),
('member', '2025-03-24 07:35:37', false, '6010000018', 22),
('member', '2024-06-30 17:19:30', true, '6010000014', 20),
('member', '2024-12-18 13:27:38', false, '6010000001', 9),
('manager', '2025-04-06 01:35:37', true, '6010000013', 19),
('manager', '2024-08-26 17:54:55', false, '6010000017', 5),
('member', '2024-12-07 04:06:19', true, '6010000010', 15),
('manager', '2025-06-10 20:42:14', true, '6010000014', 20),
('member', '2024-10-23 05:15:33', true, '6010000010', 16),
('manager', '2024-07-10 04:22:23', true, '6010000008', 13),
('manager', '2024-06-17 05:44:02', false, '6010000011', 17),
('manager', '2024-12-09 00:32:11', true, '6010000015', 9);

INSERT INTO documents (title, file_url, document_type, users_user_id, projects_project_id, created_at) VALUES
('Proposal Proyek Pembayaran Wajah', 'https://example.com/docs/22d31f05-843d-4b0c-a5dd-301717e5374f.pdf', 'application/pdf', '6010000006', 5, '2024-10-20 19:03:48'),
('Laporan Akhir Riset Daur Ulang', 'https://example.com/docs/1aa6f29b-dba9-41da-a8a0-a415227e377c.pdf', 'application/pdf', '6010000008', 20, '2025-04-02 08:33:49'),
('Materi Presentasi Keberlanjutan', 'https://example.com/docs/8401c090-54ad-4703-a35d-c5a2f8362752.pdf', 'application/pdf', '6010000005', 20, '2025-06-12 10:19:42'),
('Anggaran Proyek Penjadwalan Acara', 'https://example.com/docs/e8cd10c2-4f1d-408f-be47-03f4fb4fb54f.pdf', 'application/pdf', '6010000006', 13, '2024-09-06 15:43:28'),
('Desain Antarmuka Tiket Konser', 'https://example.com/docs/9404105b-459e-46c4-a018-5d1bc7406def.pdf', 'application/pdf', '6010000015', 18, '2025-05-03 05:27:53'),
('Laporan Progres Manajemen Acara', 'https://example.com/docs/76c4f795-9ed2-4a16-b925-303d1f62c507.pdf', 'application/pdf', '6010000007', 13, '2025-04-25 23:49:01'),
('Modul Pelatihan Edukasi Interaktif', 'https://example.com/docs/6122f1f0-20ea-4600-bb0d-18fdc5672781.pdf', 'application/pdf', '6010000016', 6, '2025-02-24 01:06:37'),
('Spesifikasi Sistem Tiket Digital', 'https://example.com/docs/8c27d5e6-af26-4420-acaf-37de02fcd2cc.pdf', 'application/pdf', '6010000003', 18, '2024-08-30 11:30:57'),
('Rencana Pengembangan Website', 'https://example.com/docs/5b297c47-5f84-4a93-b907-768045971d56.pdf', 'application/pdf', '6010000019', 21, '2025-01-26 15:18:54'),
('Panduan Penggunaan Kampanye Digital', 'https://example.com/docs/4be37e32-6c65-41ba-8801-a33d048b7bac.pdf', 'application/pdf', '6010000017', 12, '2024-07-05 10:17:25'),
('Prosedur Keamanan Data', 'https://example.com/docs/6080a371-57b1-4866-96f3-1df628d2f493.pdf', 'application/pdf', '6010000006', 20, '2024-08-06 08:09:16'),
('Desain Aplikasi Mobile Kebugaran', 'https://example.com/docs/69d540b7-d5db-471e-bb41-b9d130a3d4d9.pdf', 'application/pdf', '6010000002', 16, '2024-12-07 17:54:57'),
('Laporan Studi Kasus Pelacakan Kesehatan', 'https://example.com/docs/5b709af8-ea64-4a7b-8421-5175a1089f18.pdf', 'application/pdf', '6010000013', 18, '2024-09-22 21:55:44'),
('Analisis Kinerja Pembayaran Wajah', 'https://example.com/docs/5fcc1060-f641-4061-8733-a152bdcfce8d.pdf', 'application/pdf', '6010000003', 5, '2025-03-05 14:55:10'),
('Rencana Implementasi Smart Home', 'https://example.com/docs/0b38e5d4-74c4-4b33-8fd4-10afccf8691d.pdf', 'application/pdf', '6010000018', 17, '2024-08-13 00:05:14'),
('Dokumentasi Teknis Daur Ulang', 'https://example.com/docs/393177b3-34b0-4e37-a00d-4a57d35d468c.pdf', 'application/pdf', '6010000013', 20, '2025-03-21 01:22:09'),
('Diagram Alir Sistem Monitoring Kesehatan', 'https://example.com/docs/0a71ed81-813b-4480-a331-da208929bdcc.pdf', 'application/pdf', '6010000011', 8, '2024-06-21 23:45:32'),
('Hasil Uji Coba Smart Home', 'https://example.com/docs/9cce96d9-38d6-42b9-9782-e222aedf84d6.pdf', 'application/pdf', '6010000015', 8, '2024-08-31 21:03:28'),
('Protokol Komunikasi Blockchain', 'https://example.com/docs/cb549db3-d7d3-40d8-9eaf-45d5a3342401.pdf', 'application/pdf', '6010000006', 10, '2024-09-17 16:41:10'),
('Studi Kelayakan Aplikasi Belanja', 'https://example.com/docs/56074df6-5ddb-45de-aaa2-788dd43a0e65.pdf', 'application/pdf', '6010000007', 5, '2025-02-08 20:59:25'),
('Laporan Proyek Akhir E-Commerce', 'https://example.com/docs/e17dcc19-a3c3-43e0-8487-e02fb3d194c9.pdf', 'application/pdf', '6010000007', 10, '2024-12-30 07:00:14'),
('Pedoman Desain Aplikasi Kebugaran', 'https://example.com/docs/e37812c4-08ee-4fd0-8459-06437b65ed91.pdf', 'application/pdf', '6010000002', 16, '2024-12-18 10:02:34'),
('Riset Pasar untuk Sistem AI Pertanian', 'https://example.com/docs/42a44142-73a3-4309-bd93-f6a05d0fe63a.pdf', 'application/pdf', '6010000000', 4, '2025-01-16 05:49:59'),
('Draft Proposal Proyek Blockchain', 'https://example.com/docs/de3c793d-f878-4895-ac9a-ef1ffa9f7d05.pdf', 'application/pdf', '6010000013', 14, '2024-12-05 12:37:20'),
('Presentasi Awal Proyek AI', 'https://example.com/docs/a25387ac-74bc-4a5b-a69c-70b2bec8db98.pdf', 'application/pdf', '6010000017', 4, '2025-01-01 06:38:57'),
('Laporan Kemajuan Proyek Blockchain', 'https://example.com/docs/5db74646-a873-40f3-a28f-4a7796d316e7.pdf', 'application/pdf', '6010000001', 11, '2025-03-17 19:23:56'),
('Rencana Komunikasi Event', 'https://example.com/docs/4b4897f1-9cf5-472e-b733-8e6f5f6c14c9.pdf', 'application/pdf', '6010000013', 13, '2025-05-25 12:55:35'),
('Dokumentasi Teknis Penjadwalan', 'https://example.com/docs/619bcfcd-a89c-4b52-827f-d971de49554c.pdf', 'application/pdf', '6010000005', 13, '2025-04-03 10:23:05'),
('Rancangan Sistem E-Commerce', 'https://example.com/docs/fbbd5555-bc59-4179-878c-8c679f67964d.pdf', 'application/pdf', '6010000003', 13, '2024-08-27 00:23:58'),
('Materi Promosi Aplikasi Belanja', 'https://example.com/docs/d8ac4c27-ff76-4d98-8609-6dacb58a643d.pdf', 'application/pdf', '6010000010', 10, '2024-07-17 20:18:19');

INSERT INTO milestones (title, description, due_date, status, projects_project_id, created_at) VALUES
('Desain Antarmuka Selesai', 'Tahap awal pengembangan UI/UX sistem pembayaran wajah.', '2025-07-26 01:14:47', 'COMPLETED', 4, '2025-03-28 18:13:52'),
('Pengujian Sistem Smart Home Tahap 1', 'Verifikasi fungsi dasar perangkat IoT di rumah pintar.', '2025-07-17 20:21:01', 'COMPLETED', 15, '2024-12-23 07:19:58'),
('Perencanaan Fitur Aplikasi Tiket', 'Penentuan fitur-fitur utama untuk aplikasi tiket konser.', '2025-06-26 04:44:15', 'PLANNED', 18, '2024-11-07 18:15:16'),
('Pengembangan Algoritma Rekomendasi', 'Pembuatan algoritma AI untuk rekomendasi film.', '2025-06-24 00:04:52', 'PLANNED', 17, '2024-12-23 06:34:06'),
('Analisis Dampak Lingkungan Daur Ulang', 'Penilaian potensi dampak positif daur ulang limbah.', '2025-07-31 01:19:07', 'PLANNED', 20, '2024-12-21 20:46:07'),
('Integrasi AI ke Sistem Rekomendasi', 'Penggabungan model AI ke dalam platform rekomendasi film.', '2025-06-27 00:12:12', 'COMPLETED', 17, '2024-10-23 15:05:18'),
('Pengumpulan Data Kesehatan IoT', 'Tahap awal pengumpulan data dari perangkat IoT lansia.', '2025-08-24 06:11:39', 'IN_PROGRESS', 21, '2025-04-14 19:01:38'),
('Persiapan Peluncuran Aplikasi Kebugaran', 'Finalisasi sebelum aplikasi mobile kebugaran dirilis.', '2025-09-11 16:33:00', 'PLANNED', 16, '2025-03-22 14:04:28'),
('Audit Keamanan Dompet Digital', 'Pemeriksaan keamanan menyeluruh untuk dompet digital.', '2025-06-25 09:13:33', 'PLANNED', 19, '2024-07-27 21:20:33'),
('Desain Sistem Penjadwalan Acara', 'Merancang arsitektur untuk sistem penjadwalan otomatis.', '2025-09-14 08:55:02', 'PLANNED', 13, '2025-05-23 17:21:34'),
('Prototyping Dompet Blockchain', 'Pembuatan prototipe awal dompet digital berbasis blockchain.', '2025-08-04 19:42:20', 'PLANNED', 19, '2025-06-06 18:14:52'),
('Pelatihan Pengguna Layanan Publik', 'Sesi pelatihan untuk pengguna sistem layanan publik baru.', '2025-07-29 21:42:23', 'COMPLETED', 7, '2025-05-20 08:15:58'),
('Evaluasi Kualitas Layanan Publik', 'Penilaian efektivitas sistem layanan publik yang baru.', '2025-08-07 13:57:27', 'PLANNED', 7, '2024-12-07 23:59:21'),
('Analisis Data Pasar Kripto Lanjutan', 'Analisis mendalam untuk memprediksi pergerakan pasar kripto.', '2025-09-07 17:43:12', 'IN_PROGRESS', 15, '2025-01-08 03:02:03'),
('Uji Coba Pengguna Website E-Commerce', 'Pengujian situs web e-commerce oleh pengguna beta.', '2025-08-28 14:17:07', 'COMPLETED', 23, '2024-10-20 01:23:58'),
('Pengembangan Modul Tiket Event', 'Pembuatan modul khusus untuk pengelolaan tiket acara.', '2025-06-22 21:48:43', 'PLANNED', 18, '2024-07-09 17:00:34'),
('Integrasi Perangkat IoT ke Smart Home', 'Menghubungkan berbagai perangkat IoT dalam sistem rumah pintar.', '2025-07-17 13:58:20', 'COMPLETED', 15, '2025-03-21 07:56:53'),
('Pengembangan Fitur Aplikasi Belanja', 'Penambahan fitur baru pada aplikasi belanja online.', '2025-08-12 23:30:16', 'IN_PROGRESS', 15, '2024-08-08 16:44:14'),
('Verifikasi Data Keamanan Blockchain', 'Memastikan integritas data pada sistem berbasis blockchain.', '2025-06-17 06:40:23', 'PLANNED', 16, '2024-09-09 22:56:25'),
('Uji Coba Pengenalan Wajah', 'Menguji akurasi sistem pembayaran menggunakan wajah.', '2025-07-02 01:32:17', 'PLANNED', 7, '2025-04-18 15:42:54'),
('Peluncuran Sistem Pembayaran Wajah', 'Peresmian penggunaan sistem pembayaran wajah.', '2025-06-20 18:46:11', 'COMPLETED', 7, '2025-02-19 03:05:04'),
('Finalisasi Kampanye Digital Lingkungan', 'Penyelesaian semua materi dan strategi kampanye.', '2025-06-23 17:37:07', 'COMPLETED', 14, '2025-05-23 07:38:10'),
('Evaluasi Hasil Edukasi Interaktif', 'Penilaian efektivitas materi edukasi berbasis AI.', '2025-08-21 21:22:26', 'COMPLETED', 6, '2024-07-23 20:29:47'),
('Pembaruan Aplikasi Belanja Online', 'Perbaikan dan penambahan fitur pada aplikasi belanja.', '2025-07-09 01:12:00', 'COMPLETED', 10, '2024-09-19 01:13:13'),
('Perencanaan Strategi Pemasaran Dompet Digital', 'Perumusan strategi untuk mempromosikan dompet digital.', '2025-07-14 00:08:30', 'IN_PROGRESS', 9, '2025-06-12 18:20:27'),
('Desain Database Kesehatan IoT', 'Perancangan struktur database untuk data kesehatan lansia.', '2025-07-25 13:11:34', 'IN_PROGRESS', 8, '2024-07-08 11:37:50'),
('Pengembangan Backend Monitoring IoT', 'Pembuatan sistem backend untuk pemantauan IoT.', '2025-08-26 04:09:12', 'IN_PROGRESS', 8, '2024-08-08 13:42:14'),
('Uji Coba Dompet Digital Blockchain', 'Pengujian fungsionalitas dan keamanan dompet digital.', '2025-07-26 00:46:04', 'PLANNED', 9, '2024-09-08 11:32:03'),
('Pelaporan Hasil Analisis Kripto', 'Presentasi temuan dari analisis tren pasar kripto.', '2025-08-03 16:12:18', 'PLANNED', 14, '2024-08-08 12:12:28'),
('Pembuatan Materi Pemasaran Layanan Publik', 'Pengembangan brosur dan iklan untuk layanan publik.', '2025-07-22 17:32:07', 'PLANNED', 7, '2025-03-30 19:52:22'),
('Perencanaan Fitur Sistem Verifikasi Blockchain', 'Penentuan fitur untuk sistem verifikasi data.', '2025-07-06 20:50:33', 'PLANNED', 11, '2024-10-15 07:41:05'),
('Integrasi Modul Rekomendasi ke Aplikasi', 'Menggabungkan fitur rekomendasi film ke dalam aplikasi.', '2025-08-18 09:25:38', 'IN_PROGRESS', 17, '2024-07-28 09:25:10'),
('Uji Coba Kualitas Aplikasi Kebugaran', 'Menguji kinerja dan stabilitas aplikasi mobile kebugaran.', '2025-07-07 23:52:43', 'PLANNED', 16, '2025-01-27 16:28:20'),
('Pengembangan Modul Pembayaran Wajah', 'Pembuatan modul khusus untuk sistem pembayaran wajah.', '2025-07-27 02:33:08', 'PLANNED', 5, '2024-08-02 14:13:34'),
('Pelatihan Staf Layanan Publik', 'Mengadakan pelatihan untuk staf yang menggunakan sistem baru.', '2025-07-17 08:15:00', 'PLANNED', 7, '2024-09-01 20:56:30'),
('Pengembangan Modul Edukasi Interaktif', 'Pembuatan konten dan fitur untuk modul edukasi berbasis AI.', '2025-09-07 00:58:05', 'IN_PROGRESS', 6, '2024-06-17 23:20:57'),
('Desain Antarmuka Aplikasi Pembayaran Wajah', 'Merancang tampilan dan interaksi untuk aplikasi pembayaran.', '2025-08-16 04:01:04', 'PLANNED', 5, '2025-01-02 08:46:33'),
('Implementasi Fitur Penjadwalan Acara', 'Mengimplementasikan fitur penjadwalan dalam sistem.', '2025-07-19 09:05:36', 'IN_PROGRESS', 18, '2024-07-26 08:14:57'),
('Perencanaan Pengujian Verifikasi Blockchain', 'Merumuskan rencana pengujian untuk sistem verifikasi data.', '2025-07-02 17:58:04', 'PLANNED', 11, '2025-03-01 17:23:03'),
('Pengembangan Fitur Utama Rekomendasi Film', 'Membuat fitur inti untuk sistem rekomendasi film.', '2025-07-02 06:48:15', 'PLANNED', 17, '2025-05-20 09:50:18');

SELECT * FROM users
SELECT * FROM projects
SELECT * FROM project_members
SELECT * FROM milestones
SELECT * FROM documents

DROP TABLE users
DROP TABLE projects
DROP TABLE project_members
DROP TABLE milestones
DROP TABLE documents

SELECT DISTINCT user_id AS NRP, name AS nama
FROM users u NATURAL JOIN 
projects pr 
WHERE pr.title='Dompet Digital Aman Berbasis Blockchain'
GROUP BY user_id

SELECT pr.title AS judul, u.name AS nama_dosen
FROM users u NATURAL JOIN project_members pm 
NATURAL JOIN projects pr
WHERE pr.status='ONGOING' and u.role = 'dosen'
GROUP BY pr.title, u.name
ORDER BY pr.title 

SELECT DISTINCT ON(pr.title) pr.title AS judul_proyek, u.name AS nama_dosen, u.email AS email_dosen
FROM projects pr JOIN project_members pm ON pr.project_id = pm.projects_project_id
JOIN users u ON pm.users_user_id = u.user_id
WHERE pr.status = 'ONGOING' AND u.role = 'dosen'
GROUP BY pr.title, u.name, u.email
ORDER BY pr.title;


CREATE OR REPLACE VIEW rencana_proyek AS
SELECT DISTINCT ON(p.project_id) pr.project_id, pr.title AS judul_proyek, pr.status AS status_proyek, u.name AS nama_dosen_manajer, u.email AS email_dosen_manajer
FROM projects pr
NATURAL JOIN project_members pm
NATURAL JOIN users u
WHERE  pr.status = 'PLANNING' AND u.role = 'dosen' AND pm.role_project = 'manager'
ORDER BY pr.project_id, u.user_id;

SELECT * FROM rencana_proyek

UPDATE users
SET email = REPLACE(email, '@student.its.ac.id', '@if.ac.id')
WHERE role IN ('dosen', 'admin');

CREATE OR REPLACE VIEW dokumen_terbaru_per_proyek AS
SELECT d.projects_project_id, pr.title AS judul_proyek, d.title AS judul_dokumen, d.file_url, d.created_at AS tanggal_upload_dokumen
FROM documents d JOIN projects pr ON d.projects_project_id = pr.project_id
WHERE (d.projects_project_id, d.created_at) 
IN (
        SELECT projects_project_id, MAX(created_at)
        FROM documents
        GROUP BY projects_project_id
    );
	
SELECT * FROM dokumen_terbaru_per_proyek

CREATE OR REPLACE FUNCTION check_project_completion()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM milestones
        WHERE projects_project_id = OLD.projects_project_id
        AND status != 'COMPLETED'
    ) THEN
        UPDATE projects
        SET status = 'COMPLETED', end_date = CURRENT_TIMESTAMP
        WHERE project_id = OLD.projects_project_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_status_proyek_milestone_selesai
AFTER UPDATE ON milestones
FOR EACH ROW
WHEN (OLD.status IS DISTINCT FROM NEW.status AND NEW.status = 'COMPLETED')
EXECUTE FUNCTION check_project_completion();

SELECT milestone_id, title, status FROM milestones WHERE projects_project_id = 17;

UPDATE milestones
SET status = 'COMPLETED'
WHERE milestone_id = 4;

UPDATE milestones
SET status = 'COMPLETED'
WHERE milestone_id = 32;

UPDATE milestones
SET status = 'COMPLETED'
WHERE milestone_id = 40;

SELECT project_id, title, status FROM projects WHERE project_id = 17;

CREATE TABLE project_member_logs (
    log_id SERIAL PRIMARY KEY,
    project_id INT NOT NULL,
    user_id VARCHAR(15) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT
);
drop table project_member_logs
CREATE OR REPLACE FUNCTION log_new_project_member()
RETURNS TRIGGER AS $$
DECLARE
    project_title VARCHAR(100);
    user_name VARCHAR(50);
BEGIN
    SELECT title INTO project_title FROM projects WHERE project_id = NEW.projects_project_id;
    SELECT name INTO user_name FROM users WHERE user_id = NEW.users_user_id;

    INSERT INTO project_member_logs (project_id, user_id, action_type, description)
    VALUES (NEW.projects_project_id, NEW.users_user_id, 'Tambah_Anggota', 
            'Pengguna ' || user_name || ' (' || NEW.users_user_id || ') bergabung dengan proyek "' || project_title || '" sebagai ' || NEW.role_project || '.');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_penambahan_anggota_proyek
AFTER INSERT ON project_members
FOR EACH ROW
EXECUTE FUNCTION log_new_project_member();

INSERT INTO project_members (role_project, joined_at, is_active, users_user_id, projects_project_id) VALUES
('member', CURRENT_TIMESTAMP, TRUE, '6010000010', 2); 

SELECT * FROM project_member_logs

CREATE OR REPLACE FUNCTION anggota_per_kategori(category_name VARCHAR(100))
RETURNS INT AS $$
DECLARE
    total_members INT;
BEGIN
    SELECT COUNT(DISTINCT pm.users_user_id)
    INTO total_members
    FROM project_members pm
    JOIN projects p ON pm.projects_project_id = p.project_id
    WHERE p.categories = category_name;

    RETURN total_members;
END;
$$ LANGUAGE plpgsql;

SELECT anggota_per_kategori('AI');



CREATE OR REPLACE FUNCTION project_milestone_summary(project_id_param INT)
RETURNS TABLE (
    milestone_status VARCHAR(100),
    total_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.status,
        COUNT(*) AS total_milestones
    FROM
        milestones m
    WHERE
        m.projects_project_id = project_id_param
    GROUP BY
        m.status;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM project_milestone_summary(7);
