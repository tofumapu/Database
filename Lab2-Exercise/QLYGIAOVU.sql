CREATE DATABASE QLYGIAOVU;
USE MASTER;
USE QLYGIAOVU;

CREATE TABLE KHOA (
	MAKHOA VARCHAR(4),
	TENKHOA VARCHAR(40),
	NGTLAP SMALLDATETIME,
	TRGKHOA CHAR(4),
	CONSTRAINT PK_KHOA PRIMARY KEY(MAKHOA)
)

CREATE TABLE MONHOC (
	MAMH VARCHAR(10),
	TENMH VARCHAR(40),
	TCLT TINYINT,
	TCTH TINYINT,
	MAKHOA VARCHAR(4),
	CONSTRAINT PK_MONHOC PRIMARY KEY(MAMH)
)

CREATE TABLE DIEUKIEN (
	MAMH VARCHAR(10),
	MAMH_TRUOC VARCHAR(10),
	CONSTRAINT PK_DIEUKIEN PRIMARY KEY(MAMH, MAMH_TRUOC)
)

CREATE TABLE GIAOVIEN (
	MAGV CHAR(4),
	HOTEN VARCHAR(40),
	HOCVI VARCHAR(10),
	HOCHAM VARCHAR(10),
	GIOITINH VARCHAR(3),
	NGSINH SMALLDATETIME,
	NGVL SMALLDATETIME,
	HESO NUMERIC(4, 2),
	MUCLUONG MONEY,
	MAKHOA VARCHAR(4),
	CONSTRAINT PK_GIAOVIEN PRIMARY KEY(MAGV)
)

CREATE TABLE LOP (
	MALOP CHAR(3),
	TENLOP VARCHAR(40),
	TRGLOP CHAR(5),
	SISO TINYINT,
	MAGVCN CHAR(4),
	CONSTRAINT PK_LOP PRIMARY KEY(MALOP)
)

CREATE TABLE HOCVIEN (
	MAHV CHAR(5),
	HO VARCHAR(40),
	TEN VARCHAR(10),
	NGSINH SMALLDATETIME,
	GIOITINH VARCHAR(3),
	NOISINH VARCHAR(40),
	MALOP CHAR(3),
	CONSTRAINT PK_HOCVIEN PRIMARY KEY(MAHV)
)

CREATE TABLE GIANGDAY (
	MALOP CHAR(3),
	MAMH VARCHAR(10),
	MAGV CHAR(4),
	HOCKY TINYINT,
	NAM SMALLINT,
	TUNGAY SMALLDATETIME,
	DENNGAY SMALLDATETIME,
	CONSTRAINT PK_GIANGDAY PRIMARY KEY(MALOP, MAMH)
)

CREATE TABLE KETQUATHI (
	MAHV CHAR(5),
	MAMH VARCHAR(10),
	LANTHI TINYINT,
	NGTHI SMALLDATETIME,
	DIEM NUMERIC(4, 2),
	KQUA VARCHAR(10)
	CONSTRAINT PK_KETQUATHI PRIMARY KEY(MAHV, MAMH, LANTHI)
)
ALTER TABLE KETQUATHI
ALTER COLUMN DIEM NUMERIC(3,2)

ALTER TABLE HOCVIEN 
ADD CONSTRAINT FK_HOCVIEN_LOP FOREIGN KEY(MALOP) REFERENCES LOP(MALOP)

ALTER TABLE LOP
ADD CONSTRAINT FK_LOP_GIAOVIEN FOREIGN KEY(MAGVCN) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE KHOA
ADD CONSTRAINT FK_KHOA_GIAOVIEN FOREIGN KEY(TRGKHOA) REFERENCES GIAOVIEN(MAGV)

ALTER TABLE MONHOC
ADD CONSTRAINT FK_MONHOC_KHOA FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE DIEUKIEN
ADD CONSTRAINT FK_DIEUKIEN_MONHOC FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE DIEUKIEN
ADD CONSTRAINT FK_DIEUKIEN_MONHOC_2 FOREIGN KEY(MAMH_TRUOC) REFERENCES MONHOC(MAMH)

ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_GIAOVIEN_KHOA FOREIGN KEY(MAKHOA) REFERENCES KHOA(MAKHOA)

ALTER TABLE GIANGDAY
ADD CONSTRAINT FK_GIANGDAY_LOP FOREIGN KEY(MALOP) REFERENCES LOP(MALOP)

ALTER TABLE GIANGDAY
ADD CONSTRAINT FK_GIANGDAY_MONHOC FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)

ALTER TABLE KETQUATHI
ADD CONSTRAINT FK_KETQUATHI_HOCVIEN FOREIGN KEY(MAHV) REFERENCES HOCVIEN(MAHV)

ALTER TABLE KETQUATHI
ADD CONSTRAINT FK_KETQUATHI_MONHOC FOREIGN KEY(MAMH) REFERENCES MONHOC(MAMH)

-- CÂU 1. Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN
ADD GHICHU VARCHAR(40)

ALTER TABLE HOCVIEN
ADD DIEMTB NUMERIC(4,2)

ALTER TABLE HOCVIEN
ADD XEPLOAI VARCHAR(15)

-- CÂU 2.  Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”

-- CÂU 3.	Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE GIAOVIEN
ADD CHECK (GIOITINH = 'Nam' OR GIOITINH = 'Nu')
 
ALTER TABLE HOCVIEN
ADD CHECK (GIOITINH = 'Nam' OR GIOITINH = 'Nu')

-- CÂU 4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI
ADD CONSTRAINT DIEM_C CHECK (DIEM BETWEEN 0 AND 10)

-- CÂU 5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10  và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI
ADD CHECK (KQUA = IIF(DIEM BETWEEN 5 AND 10, 'Dat', 'Khong dat'))

-- CÂU 6.	Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI
ADD CHECK (LANTHI >= 1 AND LANTHI <= 3)

-- CÂU 7.	Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY
ADD CHECK (HOCKY BETWEEN 1 AND 3)

-- CÂU 8.	Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN
ADD CHECK (HOCVI = 'CN' OR HOCVI = 'KS' OR HOCVI = 'Ths' OR HOCVI = 'TS' OR HOCVI = 'PTS')

USE QLYGIAOVU
-- BAI TAP 2
ALTER TABLE KHOA 
DROP CONSTRAINT FK_KHOA_GIAOVIEN
SET DATEFORMAT YMD
INSERT INTO KHOA (MAKHOA, TENKHOA, NGTLAP, TRGKHOA)
VALUES 
('KHMT', 'Khoa hoc may tinh', '2005-06-07', 'GV01'),
('HTTT', 'He thong thong tin', '2005-06-07', 'GV02'),
('CNPM', 'Cong nghe phan mem', '2005-06-07', 'GV04'),
('MTT', 'Mang va truyen thong', '2005-10-20', 'GV03'),
('KTMT', 'Ky thuat may tinh', '2005-12-20', NULL);
SELECT * FROM KHOA

ALTER TABLE LOP
DROP CONSTRAINT FK_LOP_GIAOVIEN
INSERT INTO LOP (MALOP, TENLOP, TRGLOP, SISO, MAGVCN)
VALUES 
('K11', 'Lop 1 khoa 1', 'K1108', 11, 'GV07'),
('K12', 'Lop 2 khoa 1', 'K1205', 12, 'GV09'),
('K13', 'Lop 3 khoa 1', 'K1305', 12, 'GV14');
SELECT * FROM LOP

INSERT INTO GIAOVIEN (MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH, NGSINH, NGVL, HESO, MUCLUONG, MAKHOA)
VALUES 
('GV01', 'Ho Thanh Son', 'PTS', 'GS', 'Nam', '1950-05-02', '2004-01-11', 5.00, 2250000, 'KHMT'),
('GV02', 'Tran Tam Thanh', 'TS', 'PGS', 'Nam', '1965-12-17', '2004-04-20', 4.50, 2025000, 'HTTT'),
('GV03', 'Do Nghiem Phung', 'TS', 'GS', 'Nu', '1950-08-01', '2004-09-23', 4.00, 1800000, 'CNPM'),
('GV04', 'Tran Nam Son', 'TS', 'PGS', 'Nam', '1961-02-22', '2005-01-12', 4.50, 2025000, 'KTMT'),
('GV05', 'Mai Thanh Danh', 'ThS', 'GV', 'Nam', '1958-03-12', '2005-01-12', 3.00, 1350000, 'HTTT'),
('GV06', 'Tran Doan Hung', 'TS', 'GV', 'Nam', '1953-03-11', '2005-01-12', 4.50, 2025000, 'KHMT'),
('GV07', 'Nguyen Minh Tien', 'ThS', 'GV', 'Nam', '1971-11-23', '2005-03-01', 4.00, 1800000, 'KHMT'),
('GV08', 'Le Thi Tran', 'KS', NULL, 'Nu', '1974-03-26', '2005-03-01', 1.69, 760500, 'KHMT'),
('GV09', 'Nguyen To Lan', 'ThS', 'GV', 'Nu', '1966-12-31', '2005-03-01', 4.00, 1800000, 'HTTT'),
('GV10', 'Le Tran Anh Loan', 'KS', NULL, 'Nu', '1972-07-17', '2005-03-01', 1.86, 837000, 'CNPM'),
('GV11', 'Ho Thanh Tung', 'CN', 'GV', 'Nam', '1980-01-12', '2005-05-15', 2.67, 1201500, 'MTT'),
('GV12', 'Tran Van Anh', 'CN', NULL, 'Nu', '1981-03-29', '2005-05-15', 1.69, 760500, 'CNPM'),
('GV13', 'Nguyen Linh Dan', 'CN', NULL, 'Nu', '1980-05-23', '2005-05-15', 1.69, 760500, 'KTMT'),
('GV14', 'Truong Minh Chau', 'ThS', 'GV', 'Nu', '1976-11-30', '2005-05-15', 3.00, 1350000, 'MTT'),
('GV15', 'Le Ha Thanh', 'ThS', 'GV', 'Nam', '1978-05-04', '2005-05-15', 3.00, 1350000, 'KHMT');
SELECT * FROM GIAOVIEN

INSERT INTO MONHOC (MAMH, TENMH, TCLT, TCTH, MAKHOA)
VALUES 
('THDC', 'Tin hoc dai cuong', 4, 1, 'KHMT'),
('CTRR', 'Cau truc roi rac', 5, 2, 'KHMT'),
('CSDL', 'Co so du lieu', 3, 1, 'HTTT'),
('CTDLGT', 'Cau truc du lieu va giai thuat', 3, 1, 'KHMT'),
('PTTKTT', 'Phan tich thiet ke thuat toan', 3, 0, 'KHMT'),
('DHMT', 'Do hoa may tinh', 3, 1, 'KHMT'),
('KTMT', 'Kien truc may tinh', 3, 0, 'KTMT'),
('TKCSDL', 'Thiet ke co so du lieu', 3, 1, 'HTTT'),
('PTTKHTTT', 'Phan tich thiet ke he thong thong tin', 4, 1, 'HTTT'),
('HDH', 'He dieu hanh', 4, 1, 'KTMT'),
('NMCNPM', 'Nhap mon cong nghe phan mem', 3, 0, 'CNPM'),
('LTCFW', 'Lap trinh C for win', 3, 1, 'CNPM'),
('LTHDT', 'Lap trinh huong doi tuong', 3, 1, 'CNPM');
SELECT * FROM MONHOC

INSERT INTO DIEUKIEN (MAMH, MAMH_TRUOC)
VALUES 
('CSDL', 'CTRR'),
('CSDL', 'CTDLGT'),
('CTDLGT', 'THDC'),
('PTTKTT', 'THDC'),
('PTTKTT', 'CTDLGT'),
('DHMT', 'THDC'),
('LTHDT', 'THDC'),
('PTTKHTTT', 'CSDL');
SELECT * FROM DIEUKIEN

INSERT INTO HOCVIEN (MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP)
VALUES 
('K1101', 'Nguyen Van', 'A', '1986-01-27', 'Nam', 'TpHCM', 'K11'),
('K1102', 'Tran Ngoc', 'Han', '1986-03-14', 'Nu', 'Kien Giang', 'K11'),
('K1103', 'Ha Duy', 'Lap', '1986-04-18', 'Nam', 'Nghe An', 'K11'),
('K1104', 'Tran Ngoc', 'Linh', '1986-03-30', 'Nu', 'Tay Ninh', 'K11'),
('K1105', 'Tran Minh', 'Long', '1986-02-27', 'Nam', 'TpHCM', 'K11'),
('K1106', 'Le Nhat', 'Minh', '1986-01-24', 'Nam', 'TpHCM', 'K11'),
('K1107', 'Nguyen Nhu', 'Nhut', '1986-01-27', 'Nam', 'Ha Noi', 'K11'),
('K1108', 'Nguyen Manh', 'Tam', '1986-02-27', 'Nam', 'Kien Giang', 'K11'),
('K1109', 'Phan Thi', 'Tam', '1986-01-27', 'Nu', 'Vinh Long', 'K11'),
('K1110', 'Le Hoai', 'Thuong', '1986-02-05', 'Nu', 'Can Tho', 'K11'),
('K1111', 'Le Ha', 'Vinh', '1986-12-25', 'Nam', 'Vinh Long', 'K11'),
('K1201', 'Nguyen Van', 'B', '1986-02-11', 'Nam', 'TpHCM', 'K12'),
('K1202', 'Nguyen Thi', 'Duyen', '1986-01-18', 'Nu', 'TpHCM', 'K12'),
('K1203', 'Tran Thi', 'Duyen', '1986-09-17', 'Nu', 'TpHCM', 'K12'),
('K1204', 'Truong My', 'Hanh', '1986-05-19', 'Nu', 'Dong Nai', 'K12'),
('K1205', 'Nguyen Thanh', 'Nam', '1986-04-17', 'Nam', 'TpHCM', 'K12'),
('K1206', 'Nguyen Thi', 'Thanh', '1986-03-04', 'Nu', 'Kien Giang', 'K12'),
('K1207', 'Tran Thi', 'Thuy', '1986-02-08', 'Nu', 'Nghe An', 'K12'),
('K1208', 'Huynh Thi', 'Trieu', '1986-04-08', 'Nu', 'Tay Ninh', 'K12'),
('K1209', 'Pham Thanh', 'Trieu', '1986-02-23', 'Nam', 'TpHCM', 'K12'),
('K1210', 'Ngo Thanh', 'Tuan', '1986-02-14', 'Nam', 'TpHCM', 'K12'),
('K1211', 'Do Thi', 'Xuan', '1986-03-09', 'Nu', 'Ha Noi', 'K12'),
('K1212', 'Le Thi', 'Yen', '1986-03-12', 'Nu', 'TpHCM', 'K12'),
('K1301', 'Nguyen Thi', 'Cuc', '1986-06-09', 'Nu', 'Kien Giang', 'K13'),
('K1302', 'Truong Thi', 'Hien', '1986-03-18', 'Nu', 'Nghe An', 'K13'),
('K1303', 'Le Duc', 'Hien', '1986-03-21', 'Nam', 'Tay Ninh', 'K13'),
('K1304', 'Le Quang', 'Hien', '1986-04-18', 'Nam', 'TpHCM', 'K13'),
('K1305', 'Le Thi', 'Huong', '1986-03-27', 'Nu', 'TpHCM', 'K13'),
('K1306', 'Nguyen Thai', 'Huu', '1986-03-30', 'Nam', 'Ha Noi', 'K13'),
('K1307', 'Tran Minh', 'Man', '1986-05-28', 'Nam', 'TpHCM', 'K13'),
('K1308', 'Nguyen Hieu', 'Nghia', '1986-04-08', 'Nam', 'Kien Giang', 'K13'),
('K1309', 'Nguyen Trung', 'Nghia', '1987-01-18', 'Nam', 'Nghe An', 'K13'),
('K1310', 'Tran Thi', 'Tham', '1986-04-22', 'Nu', 'Tay Ninh', 'K13'),
('K1311', 'Tran Minh', 'Thuc', '1986-04-04', 'Nam', 'TpHCM', 'K13'),
('K1312', 'Nguyen Thi', 'Yen', '1986-09-07', 'Nu', 'TpHCM', 'K13');
SELECT * FROM HOCVIEN

INSERT INTO GIANGDAY (MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY)
VALUES 
('K11', 'THDC', 'GV07', 1, 2006, '2006-01-02', '2006-05-12'),
('K12', 'THDC', 'GV06', 1, 2006, '2006-01-02', '2006-05-12'),
('K13', 'THDC', 'GV15', 1, 2006, '2006-01-02', '2006-05-12'),
('K11', 'CTRR', 'GV02', 1, 2006, '2006-01-09', '2006-05-17'),
('K12', 'CTRR', 'GV02', 1, 2006, '2006-01-09', '2006-05-17'),
('K13', 'CTRR', 'GV08', 1, 2006, '2006-01-09', '2006-05-17'),
('K11', 'CSDL', 'GV05', 2, 2006, '2006-06-01', '2006-07-15'),
('K12', 'CSDL', 'GV09', 2, 2006, '2006-06-01', '2006-07-15'),
('K13', 'CTDLGT', 'GV15', 2, 2006, '2006-06-01', '2006-07-15'),
('K13', 'CSDL', 'GV05', 3, 2006, '2006-08-01', '2006-12-15'),
('K13', 'DHMT', 'GV07', 3, 2006, '2006-08-01', '2006-12-15'),
('K11', 'CTDLGT', 'GV15', 3, 2006, '2006-08-01', '2006-12-15'),
('K12', 'CTDLGT', 'GV15', 3, 2006, '2006-08-01', '2006-12-15'),
('K11', 'HDH', 'GV04', 1, 2007, '2007-01-02', '2007-02-18'),
('K12', 'HDH', 'GV04', 1, 2007, '2007-01-02', '2007-03-20'),
('K11', 'DHMT', 'GV07', 1, 2007, '2007-02-18', '2007-03-20');
SELECT * FROM GIANGDAY

INSERT INTO KETQUATHI (MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA)
VALUES 
('K1101', 'CSDL', 1, '2006-07-20', 10.00, 'Dat'),
('K1101', 'CTDLGT', 1, '2006-12-28', 9.00, 'Dat'),
('K1101', 'THDC', 1, '2006-05-20', 9.00, 'Dat'),
('K1101', 'CTRR', 1, '2006-05-13', 9.50, 'Dat'),
('K1102', 'CSDL', 1, '2006-07-20', 4.00, 'Khong Dat'),
('K1102', 'CSDL', 2, '2006-07-27', 4.25, 'Khong Dat'),
('K1102', 'CSDL', 3, '2006-08-10', 4.50, 'Khong Dat'),
('K1102', 'CTDLGT', 1, '2006-12-28', 4.50, 'Khong Dat'),
('K1102', 'CTDLGT', 2, '2007-01-05', 4.00, 'Khong Dat'),
('K1102', 'CTDLGT', 3, '2007-01-15', 6.00, 'Dat'),
('K1102', 'THDC', 1, '2006-05-20', 5.00, 'Dat'),
('K1102', 'CTRR', 1, '2006-05-13', 7.00, 'Dat'),
('K1103', 'CSDL', 1, '2006-07-20', 3.50, 'Khong Dat'),
('K1103', 'CSDL', 2, '2006-07-27', 8.25, 'Dat'),
('K1103', 'CTDLGT', 1, '2006-12-28', 7.00, 'Dat'),
('K1103', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1103', 'CTRR', 1, '2006-05-13', 6.50, 'Dat'),
('K1104', 'CSDL', 1, '2006-07-20', 3.75, 'Khong Dat'),
('K1104', 'CTDLGT', 1, '2006-12-28', 4.00, 'Khong Dat'),
('K1104', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1104', 'CTRR', 1, '2006-05-13', 4.00, 'Khong Dat'),
('K1104', 'CTRR', 2, '2006-05-20', 3.50, 'Khong Dat'),
('K1104', 'CTRR', 3, '2006-06-30', 4.00, 'Khong Dat'),
('K1201', 'CSDL', 1, '2006-07-20', 6.00, 'Dat'),
('K1201', 'CTDLGT', 1, '2006-12-28', 5.00, 'Dat'),
('K1201', 'THDC', 1, '2006-05-20', 8.50, 'Dat'),
('K1201', 'CTRR', 1, '2006-05-13', 9.00, 'Dat'),
('K1202', 'CSDL', 1, '2006-07-20', 8.00, 'Dat'),
('K1202', 'CTDLGT', 1, '2006-12-28', 4.00, 'Khong Dat'),
('K1202', 'CTDLGT', 2, '2007-01-05', 5.00, 'Dat'),
('K1202', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1202', 'THDC', 2, '2006-05-27', 4.00, 'Khong Dat'),
('K1202', 'CTRR', 1, '2006-05-13', 3.00, 'Khong Dat'),
('K1202', 'CTRR', 2, '2006-05-20', 4.00, 'Khong Dat'),
('K1202', 'CTRR', 3, '2006-06-30', 6.25, 'Dat'),
('K1203', 'CSDL', 1, '2006-07-20', 9.25, 'Dat'),
('K1203', 'CTDLGT', 1, '2006-12-28', 9.50, 'Dat'),
('K1203', 'THDC', 1, '2006-05-20', 10.00, 'Dat'),
('K1203', 'CTRR', 1, '2006-05-13', 10.00, 'Dat'),
('K1204', 'CSDL', 1, '2006-07-20', 8.50, 'Dat'),
('K1204', 'CTDLGT', 1, '2006-12-28', 6.75, 'Dat'),
('K1204', 'THDC', 1, '2006-05-20', 4.00, 'Khong Dat'),
('K1204', 'CTRR', 1, '2006-05-13', 6.00, 'Dat'),
('K1301', 'CSDL', 1, '2006-12-20', 4.25, 'Khong Dat'),
('K1301', 'CTDLGT', 1, '2006-07-25', 8.00, 'Dat'),
('K1301', 'THDC', 1, '2006-05-20', 7.75, 'Dat'),
('K1301', 'CTRR', 1, '2006-05-13', 8.00, 'Dat'),
('K1302', 'CSDL', 1, '2006-12-20', 6.75, 'Dat'),
('K1302', 'CTDLGT', 1, '2006-07-25', 5.00, 'Dat'),
('K1302', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1302', 'CTRR', 1, '2006-05-13', 8.50, 'Dat'),
('K1303', 'CSDL', 1, '2006-12-20', 4.00, 'Khong Dat'),
('K1303', 'CTDLGT', 1, '2006-07-25', 4.50, 'Khong Dat'),
('K1303', 'CTDLGT', 2, '2006-08-07', 4.00, 'Khong Dat'),
('K1303', 'CTDLGT', 3, '2006-08-15', 4.25, 'Khong Dat'),
('K1303', 'THDC', 1, '2006-05-20', 4.50, 'Khong Dat'),
('K1303', 'CTRR', 1, '2006-05-13', 3.25, 'Khong Dat'),
('K1303', 'CTRR', 2, '2006-05-20', 5.00, 'Dat'),
('K1304', 'CSDL', 1, '2006-12-20', 7.75, 'Dat'),
('K1304', 'CTDLGT', 1, '2006-07-25', 9.75, 'Dat'),
('K1304', 'THDC', 1, '2006-05-20', 5.50, 'Dat'),
('K1304', 'CTRR', 1, '2006-05-13', 5.00, 'Dat'),
('K1305', 'CSDL', 1, '2006-12-20', 9.25, 'Dat'),
('K1305', 'CTDLGT', 1, '2006-07-25', 10.00, 'Dat'),
('K1305', 'THDC', 1, '2006-05-20', 8.00, 'Dat'),
('K1305', 'CTRR', 1, '2006-05-13', 10.00, 'Dat');
SELECT * FROM KETQUATHI
-- BAI TAP 4

-- CÂU 11.	Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN ADD
CONSTRAINT CK_TUOI CHECK(DATEDIFF(YEAR, NGSINH, GETDATE()) >= 18)
-- CÂU 12.	Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD
CONSTRAINT CK_NGGD CHECK(TUNGAY < DENNGAY)
-- CÂU 13.	Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN ADD
CONSTRAINT CK_TUOI_GV CHECK(DATEDIFF(YEAR, NGSINH, GETDATE()) >= 22)
-- CÂU 14.	Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC
ADD CONSTRAINT CHECK_TC CHECK(ABS(TCLT - TCTH) <= 3)

-- BAI TAP 6
/*1. In ra danh sach (ma hoc vien, ho ten, ngay sinh, ma lop) lop truong cua cac lop.*/
SELECT MAHV, HO, TEN, NGSINH, HOCVIEN.MALOP
FROM HOCVIEN INNER JOIN LOP ON HOCVIEN.MAHV = LOP.TRGLOP

/*2. In ra bang diem khi thi (ma hoc vien, ho ten, lan thi, diem so) mon CTRR cua lop "K12", sap xep theo ten, ho hoc vien.*/
SELECT KETQUATHI.MAHV, HO, TEN, LANTHI, DIEM
FROM KETQUATHI
	INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE MAMH = 'CTRR' AND MALOP = 'K12'
ORDER BY TEN, HO

/*3. In ra danh sach nhung hoc vien (ma hoc vien, ho ten) va nhung mon hoc ma hoc vien do thi lan thu nhat da dat.*/
SELECT KETQUATHI.MAHV, HO, TEN, MAMH
FROM KETQUATHI
	INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE LANTHI = 1 AND KQUA = 'Dat'

/*4. In ra danh sach hoc vien (ma hoc vien, ho ten) cua lop "K11" thi mon CTRR khong dat (o lan thi 1).*/
SELECT KETQUATHI.MAHV, HO, TEN
FROM KETQUATHI 
	INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE MALOP ='K11' AND MAMH = 'CTRR' AND LANTHI = 1 AND KQUA = 'Khong Dat'

/*5. *Danh sach hoc vien (ma hoc vien, ho ten) cua lop "K" thi mon CTRR khong dat (o tat ca cac lan thi).*/
SELECT DISTINCT KETQUATHI.MAHV, HO, TEN
FROM KETQUATHI
	INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE MALOP LIKE 'K%' AND MAMH = 'CTRR' AND KQUA = 'Khong Dat'
EXCEPT
SELECT DISTINCT KETQUATHI.MAHV, HO, TEN
FROM KETQUATHI
	INNER JOIN HOCVIEN ON KETQUATHI.MAHV = HOCVIEN.MAHV
WHERE MALOP LIKE 'K%' AND MAMH = 'CTRR' AND KQUA = 'Dat'


-- BUOI 3
-- BAI TAP 2. Sinh viên hoàn thành Phần II bài tập QuanLyGiaoVu từ câu 1 đến câu 4. 
-- 1.	Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN
SET HESO = HESO + 0.2
WHERE MAGV IN (SELECT TRGKHOA
				FROM KHOA)

-- 2.	Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
ALTER TABLE KETQUATHI
ADD DIEMTB NUMERIC(4,2)
UPDATE HOCVIEN 
SET DIEMTB = DTB_HOCVIEN.DTB
FROM HOCVIEN HV LEFT JOIN (SELECT A.MAHV, AVG(A.DIEM) DTB
							FROM KETQUATHI A INNER JOIN (SELECT MAHV, MAMH, MAX(LANTHI) AS LANTHIMAX
															FROM KETQUATHI
															GROUP BY MAHV, MAMH) B
							ON A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI = B.LANTHIMAX
							GROUP BY A.MAHV) DTB_HOCVIEN
ON HV.MAHV = DTB_HOCVIEN.MAHV
-- 3.	Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN(SELECT MAHV 
			  FROM KETQUATHI
			  WHERE LANTHI = 3 AND DIEM < 5)
-- 4.	Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
--o	Nếu DIEMTB >= 9 thì XEPLOAI =”XS”
--o	Nếu  8 <= DIEMTB < 9 thì XEPLOAI = “G”
--o	Nếu  6.5 <= DIEMTB < 8 thì XEPLOAI = “K”
--o	Nếu  5  <= DIEMTB < 6.5 thì XEPLOAI = “TB”
--o	Nếu  DIEMTB < 5 thì XEPLOAI = ”Y”
UPDATE HOCVIEN
SET XEPLOAI = CASE
	WHEN DIEMTB >= 9 THEN 'XS'
	WHEN DIEMTB >= 8 AND DIEMTB < 9 THEN 'G'
	WHEN DIEMTB >= 6.5 AND DIEMTB < 8 THEN 'K'
	WHEN DIEMTB >= 5 AND DIEMTB < 6.5 THEN 'TB'
	WHEN DIEMTB < 5 THEN 'Y'
	WHEN DIEMTB IS NULL THEN NULL
	ELSE 'Y'
END
-- BAI TAP 3 Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 6 đến câu 10. 
-- 6.	Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
SELECT MH.MAMH, TENMH
FROM GIANGDAY GD
INNER JOIN
	MONHOC MH ON GD.MAMH = MH.MAMH
INNER JOIN
	GIAOVIEN GV ON GV.MAGV = GD.MAGV
WHERE HOTEN = 'Tran Tam Thanh' AND HOCKY = 1 AND NAM = 2006
-- 7.	Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.
SELECT MH.MAMH, TENMH
FROM MONHOC MH
	INNER JOIN 
	GIANGDAY GD ON MH.MAMH = GD.MAMH
WHERE MALOP = 'K11' AND HOCKY = 1 AND NAM = 2006
-- 8.	Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
-- Cách 1
SELECT HO + ' ' + TEN AS HOTEN
FROM HOCVIEN HV
WHERE MAHV IN(SELECT DISTINCT TRGLOP
				FROM LOP
				INNER JOIN
				GIANGDAY GD ON LOP.MALOP = GD.MALOP
				INNER JOIN
				GIAOVIEN GV ON GV.MAGV = GD.MAGV
				INNER JOIN
				MONHOC MH ON GD.MAMH = MH.MAMH
				WHERE GV.HOTEN = 'Nguyen To Lan' AND TENMH = 'Co so du lieu')
-- Cách 2
SELECT HO + ' ' + TEN AS HOTEN
FROM HOCVIEN
WHERE MAHV IN (SELECT TRGLOP
			   FROM LOP
			   WHERE MALOP IN (SELECT MALOP
							   FROM GIANGDAY
							   WHERE MAMH IN (SELECT MAMH
							                  FROM MONHOC
											  WHERE TENMH = 'Co So Du Lieu') AND MAGV IN (SELECT MAGV
																		FROM GIAOVIEN
																		WHERE HOTEN = 'Nguyen To Lan')))
-- 9.	In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
-- Cách 1
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN(SELECT MAMH_TRUOC
				FROM DIEUKIEN
				INNER JOIN
				MONHOC ON DIEUKIEN.MAMH = MONHOC.MAMH
				WHERE TENMH = 'Co So Du Lieu')
-- Cách 2
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN (SELECT MAMH_TRUOC
			   FROM DIEUKIEN
			   WHERE MAMH = 'CSDL')
-- 10.	Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
SELECT MAMH, TENMH
FROM MONHOC
WHERE MAMH IN(SELECT MAMH
				FROM DIEUKIEN
				WHERE MAMH_TRUOC = 'CTRR')

-- BAI TAP 5: Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 11 đến câu 18.
-- 11.	Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT GV.MAGV, HOTEN
FROM GIAOVIEN GV
	INNER JOIN
	GIANGDAY GD ON GV.MAGV = GD.MAGV
WHERE MAMH = 'CTRR' AND MALOP LIKE 'K11' AND HOCKY = 1 AND NAM = 2006
INTERSECT
SELECT GV.MAGV, HOTEN
FROM GIAOVIEN GV
	INNER JOIN
	GIANGDAY GD ON GV.MAGV = GD.MAGV
WHERE MAMH = 'CTRR' AND MALOP LIKE 'K12' AND HOCKY = 1 AND NAM = 2006

--CACH 2
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV IN (SELECT MAGV
			   FROM GIANGDAY
			   WHERE MALOP = 'K11' AND HOCKY = 1 AND NAM = 2006
			   INTERSECT
			   SELECT MAGV
			   FROM GIANGDAY
			   WHERE MALOP = 'K12' AND HOCKY = 1 AND NAM = 2006)


-- 12.	Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN HV
	INNER JOIN
	KETQUATHI KQT ON HV.MAHV = KQT.MAHV
WHERE KQUA = 'Khong Dat' AND LANTHI = 1

SELECT MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN
WHERE MAHV IN (SELECT B.MAHV
			   FROM (SELECT MAHV, COUNT(*) SL_THIROT
					 FROM (SELECT MAHV  
						   FROM KETQUATHI
					       WHERE MAMH = 'CSDL' AND KQUA = 'Khong Dat'
						   EXCEPT
						   SELECT MAHV  
						   FROM KETQUATHI
					       WHERE MAMH = 'CSDL' AND KQUA = 'Dat') AS A
					 GROUP BY A.MAHV) AS B
			   WHERE B.SL_THIROT = 1)

-- 13.	Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN (SELECT DISTINCT MAGV
					FROM GIANGDAY)
-- 14.	Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
SELECT MAGV, HOTEN
FROM GIAOVIEN
WHERE MAGV NOT IN(SELECT DISTINCT GD.MAGV
					FROM GIANGDAY GD
					INNER JOIN MONHOC MH ON GD.MAMH = MH.MAMH
					INNER JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV
					WHERE MH.MAKHOA = GIAOVIEN.MAKHOA)
-- 15.	Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN HV
INNER JOIN LOP ON HV.MALOP = LOP.MALOP
INNER JOIN KETQUATHI ON HV.MAHV = KETQUATHI.MAHV
WHERE HV.MALOP = 'K11' AND LANTHI > 3 AND KQUA = 'Khong Dat' 
UNION
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN
FROM HOCVIEN HV
INNER JOIN LOP ON HV.MALOP = LOP.MALOP
INNER JOIN KETQUATHI ON HV.MAHV = KETQUATHI.MAHV
WHERE MAMH = 'CTRR' AND LANTHI = 2 AND DIEM = 5

SELECT HO + ' ' + TEN AS HOTEN FROM HOCVIEN
WHERE MAHV IN (
	SELECT MAHV FROM KETQUATHI A
	WHERE LEFT(MAHV, 3) = 'K11' AND ((
		NOT EXISTS (
			SELECT 1 FROM KETQUATHI B 
			WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
		)  AND LANTHI = 3 AND KQUA = 'Khong Dat'
	) OR MAMH = 'CTRR' AND LANTHI = 2 AND DIEM = 5))

-- 16.	Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
-- 17.	Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
-- 18.	Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).

