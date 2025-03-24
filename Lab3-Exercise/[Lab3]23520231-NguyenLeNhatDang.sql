-- BUOI 3

-- PHAN 1: QUAN LY BAN HANG
-- BAI TAP 1. Sinh viên hoàn thành Phần III bài tập QuanLyBanHang câu 12 và câu 13. 
-- 12.	Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD 
WHERE SL BETWEEN 10 AND 20 AND MASP = 'BB01'
UNION
SELECT SOHD
FROM CTHD
WHERE SL BETWEEN 10 AND 20 AND MASP = 'BB02' 

-- 13.	Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
SELECT SOHD
FROM CTHD
WHERE SL BETWEEN 10 AND 20 AND MASP = 'BB01'
INTERSECT
SELECT SOHD
FROM CTHD
WHERE SL BETWEEN 10 AND 20 AND MASP = 'BB02'

-- BAI TAP 3
-- 14.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất 
-- hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'
UNION 
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP IN (SELECT MASP
			   FROM CTHD 
			   INNER JOIN HOADON HD
			   ON CTHD.SOHD = HD.SOHD
			   WHERE NGHD = '01/01/2007')

-- 15.	In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT MASP, TENSP 
FROM SANPHAM
EXCEPT
SELECT CTHD.MASP, TENSP 
FROM CTHD 
INNER JOIN SANPHAM SP ON CTHD.MASP = SP.MASP

-- 16.	In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
SELECT MASP, TENSP 
FROM SANPHAM
EXCEPT
SELECT CTHD.MASP, TENSP
FROM CTHD
INNER JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
INNER JOIN HOADON HD ON CTHD.SOHD = HD.SOHD
WHERE YEAR(NGHD) = 2006

-- CÁCH 2
SELECT MASP, TENSP 
FROM SANPHAM
WHERE MASP NOT IN (SELECT MASP
					FROM CTHD 
					INNER JOIN HOADON HD ON CTHD.SOHD = HD.SOHD
					WHERE YEAR(NGHD) = 2006)
-- 17.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' 
AND MASP NOT IN (SELECT CTHD.MASP
					FROM CTHD
					INNER JOIN HOADON HD ON HD.SOHD = CTHD.SOHD
					AND YEAR(NGHD) = 2006)

-- 18.	Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT SOHD
FROM HOADON
WHERE YEAR(NGHD) = 2006
AND NOT EXISTS (SELECT * 
				FROM SANPHAM
				WHERE NUOCSX = 'Singapore'
				AND NOT EXISTS (SELECT * 
								FROM CTHD
								WHERE CTHD.MASP = SANPHAM.MASP
								AND CTHD.SOHD = HOADON.SOHD))


-- PHAN 2: QUAN LY GIAO VU
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
SELECT HOTEN
FROM GIAOVIEN
WHERE MAGV IN (SELECT MAGV
			   FROM GIANGDAY
			   WHERE MAMH = 'CTRR'
			   GROUP BY MAGV, HOCKY, NAM
			   HAVING COUNT(MALOP) >= 2)

-- 17.	Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT A.MAHV, HO + ' ' + TEN AS HOTEN, KETQUATHI.DIEM
FROM HOCVIEN
INNER JOIN (SELECT MAHV, MAX(LANTHI) AS LT_SAUCUNG
			FROM KETQUATHI
			WHERE MAMH = 'CSDL'
			GROUP BY MAHV) A
			ON A.MAHV = HOCVIEN.MAHV
INNER JOIN KETQUATHI ON KETQUATHI.MAHV = A.MAHV
WHERE LANTHI = A.LT_SAUCUNG AND MAMH = 'CSDL'
ORDER BY A.MAHV

-- 18.	Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT A.MAHV, HO + ' ' + TEN AS HOTEN, KETQUATHI.DIEM
FROM HOCVIEN
INNER JOIN (SELECT MAHV, MAX(DIEM) AS DIEM_CAO_NHAT
			FROM KETQUATHI
			WHERE MAMH = 'CSDL'
			GROUP BY MAHV) A
			ON A.MAHV = HOCVIEN.MAHV
INNER JOIN KETQUATHI ON KETQUATHI.MAHV = A.MAHV
WHERE DIEM = A.DIEM_CAO_NHAT AND MAMH = 'CSDL'
ORDER BY A.MAHV

