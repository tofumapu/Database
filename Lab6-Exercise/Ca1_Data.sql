-- Du Lieu PHONGTRO
INSERT INTO PHONGTRO (MAPT, TENPT, DIENTICH, GIAPT, TINHTRANGPT) VALUES
('P001', 'Phong 101', 24, 5000000, 'Da cho thue'),
('P002', 'Phong 102', 24, 3800000, 'Da cho thue'),
('P003', 'Phong 103', 36, 4800000, 'Da cho thue'),
('P004', 'Phong 104', 24, 3800000, 'Da cho thue'),
('P005', 'Phong 105', 40, 8000000, 'Da cho thue'),
('P006', 'Phong 106', 36, 5800000, 'Trong'),
('P007', 'Phong 107', 28, 3800000, 'Da cho thue'),
('P008', 'Phong 108', 28, 4200000, 'Da cho thue'),
('P009', 'Phong 109', 28, 4200000, 'Trong'),
('P010', 'Phong 110', 40, 8000000, 'Da cho thue');

-- Thêm dữ liệu vào bảng CUDAN
INSERT INTO CUDAN (MACD, HOTEN, CCCD, DIACHI, SODT, NGAYTHUE, TRANGTHAICD) VALUES
('CD001', 'Nguyen Huu Phu', '227635273657', 'Ha Noi', '0367456276', '2024-10-01', 'Da roi di'),
('CD002', 'Le Thi Thanh Thao', '673272832422', 'Hai Phong', '0927482749', '2024-10-01', 'Dang o'),
('CD003', 'Tran Nguyen Huu Phuc', '125266729012', 'Da Nang', '0978123456', '2024-10-15', 'Da roi di'),
('CD004', 'Pham Minh Du', '523483690902', 'Ho Chi Minh', '0888536467', '2024-10-30', 'Dang o'),
('CD005', 'Hoang Thu Hieu', '736862746710', 'Khanh Hoa', '0904897595', '2024-11-01', 'Dang o'),
('CD006', 'Tran Khanh Thi', '237864874844', 'Binh Đinh', '0917363487', '2024-11-15', 'Dang o'),
('CD007', 'Do Van Nam', '980748392617', 'Ho Chi Minh', '0900635473', '2024-11-15', 'Da roi di'),
('CD008', 'Pham Chien Si', '194784625466', 'Vinh Long', '0990237847', '2024-12-01', 'Dang o'),
('CD009', 'Luu Thanh Tu', '998467745644', 'Ca Mau', '0911734784', '2024-12-10', 'Dang o'),
('CD010', 'Bui Thi Mong Uyen', '121234678908', 'Hoa Binh', '0328267480', '2024-12-15', 'Dang o');

-- Thêm dữ liệu vào bảng HOPDONG
INSERT INTO HOPDONG (MAHD, MACD, MAPT, NGAYKY, NGAYHETHAN, TRANGTHAIHD) VALUES
('HD001', 'CD001', 'P002', '2024-10-01', '2024-10-31', 'Da het han'),
('HD002', 'CD002', 'P004', '2024-10-01', '2024-11-30', 'Da het han'),
('HD003', 'CD003', 'P006', '2024-10-15', '2024-11-14', 'Da het han'),
('HD004', 'CD004', 'P001', '2024-10-30', '2025-03-31', 'Dang thue'),
('HD005', 'CD005', 'P003', '2024-11-01', '2025-03-31', 'Dang thue'),
('HD006', 'CD006', 'P005', '2024-11-15', '2025-05-14', 'Dang thue'),
('HD007', 'CD004', 'P006', '2024-11-15', '2024-12-14', 'Da het han'),
('HD008', 'CD002', 'P004', '2024-12-01', '2025-03-31', 'Dang thue'),
('HD009', 'CD007', 'P009', '2024-12-01', '2024-12-31', 'Da het han'),
('HD010', 'CD008', 'P002', '2024-12-01', '2025-05-31', 'Dang thue'),
('HD011', 'CD009', 'P007', '2024-12-10', '2025-06-09', 'Dang thue'),
('HD012', 'CD010', 'P008', '2024-12-15', '2025-09-14', 'Dang thue'),
('HD013', 'CD006', 'P010', '2025-01-01', '2025-12-31', 'Dang thue');


-- Thêm dữ liệu vào bảng DICHVU
INSERT INTO DICHVU (MADV, TENDV, DONGIA) VALUES
('DV001', 'Dien', 3500),
('DV002', 'Nuoc', 10000),
('DV003', 'Internet', 150000),
('DV004', 'Ve sinh', 50000),
('DV005', 'Truyen hinh cap', 160000);

-- Thêm dữ liệu vào bảng THANHTOAN
INSERT INTO PHIEUTINHTIEN (MAPTT, MAHD, SOTIENDICHVU, SOTIENTHUEPT, TONGTIENTT, NGAYTINHTIEN, TINHTRANGTT, PHUONGTHUCTT) VALUES
('TT001', 'HD001', 0, 3800000, 3800000, '2024-10-01', 'Da thanh toan', 'Chuyen khoan'),
('TT002', 'HD002', 0, 3800000, 3000000, '2024-10-01', 'Da thanh toan', 'Chuyen khoan'),
('TT003', 'HD003', 0, 5800000, 5800000, '2024-10-15', 'Da thanh toan', 'Tien mat'),
('TT004', 'HD004', 0, 5000000, 5000000, '2024-10-30', 'Da thanh toan', 'Chuyen khoan'),
('TT005', 'HD005', 0, 4800000, 4800000, '2024-11-01', 'Da thanh toan', 'Chuyen khoan'),
('TT006', 'HD001', 402000, 0, 402000, '2024-11-01', 'Da thanh toan', 'Chuyen khoan'),
('TT007', 'HD002', 289000, 3800000, 4089000, '2024-11-01', 'Da thanh toan', 'Tien mat'),
('TT008', 'HD003', 320000, 0, 320000, '2024-11-15', 'Da thanh toan', 'Chuyen khoan'),
('TT009', 'HD006', 0, 8000000, 8000000, '2024-11-15', 'Da thanh toan', 'Chuyen khoan'),
('TT010', 'HD007', 0, 5800000, 5800000, '2024-11-15', 'Da thanh toan', 'Chuyen khoan'),
('TT011', 'HD002', 296000, 0, 296000, '2024-12-01', 'Da thanh toan', 'Chuyen khoan'),
('TT012', 'HD004', 396000, 5000000, 5396000, '2024-12-01', 'Da thanh toan', 'Tien mat'),
('TT013', 'HD005', 204500, 4800000, 5004500, '2024-12-01', 'Da thanh toan', 'Tien mat'),
('TT014', 'HD008', 0, 3800000, 3800000, '2024-12-01', 'Da thanh toan', 'Chuyen khoan'),
('TT015', 'HD009', 0, 4200000, 4200000, '2024-12-01', 'Da thanh toan', 'Tien mat'),
('TT016', 'HD010', 0, 3800000, 3800000, '2024-12-01', 'Da thanh toan', 'Tien mat'),
('TT017', 'HD011', 0, 3800000, 3800000, '2024-12-10', 'Da thanh toan', 'Chuyen khoan'),
('TT018', 'HD012', 0, 4200000, 4200000, '2024-12-10', 'Da thanh toan', 'Tien mat'),
('TT019', 'HD006', 382000, 8000000, 8382000, '2024-12-15', 'Da thanh toan', 'Tien mat'),
('TT020', 'HD007', 320000, 0, 320000, '2024-12-15', 'Da thanh toan', 'Chuyen khoan');


-- Thêm dữ liệu vào bảng CHITIETTTDV
INSERT INTO CHITIETTTDV (MAPTT, MADV, CHISODV, THANHTIEN) VALUES
('TT006', 'DV001', 32, 112000),
('TT006', 'DV002', 9, 90000),
('TT006', 'DV003', 1, 150000),
('TT006', 'DV004', 1, 50000),
('TT007', 'DV001', 14, 49000),
('TT007', 'DV002', 4, 40000),
('TT007', 'DV003', 1, 150000),
('TT007', 'DV004', 1, 50000),
('TT008', 'DV001', 20, 70000),
('TT008', 'DV002', 5, 50000),
('TT008', 'DV003', 1, 150000),
('TT008', 'DV004', 1, 50000),
('TT011', 'DV001', 16, 56000),
('TT011', 'DV002', 4, 40000),
('TT011', 'DV003', 1, 150000),
('TT011', 'DV004', 1, 50000),
('TT012', 'DV001', 36, 126000),
('TT012', 'DV002', 9, 90000),
('TT012', 'DV003', 1, 150000),
('TT012', 'DV004', 1, 50000),
('TT013', 'DV001', 27, 94500),
('TT013', 'DV002', 6, 60000),
('TT013', 'DV004', 1, 50000),
('TT019', 'DV001', 32, 112000),
('TT019', 'DV002', 7, 70000),
('TT019', 'DV003', 1, 150000),
('TT019', 'DV004', 1, 50000),
('TT020', 'DV001', 20, 70000),
('TT020', 'DV002', 5, 50000),
('TT020', 'DV003', 1, 150000),
('TT020', 'DV004', 1, 50000);
