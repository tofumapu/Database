/* BUOI 5 */
-- Phần 1: Quản lý bán hàng
-- Cau 11: Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).

CREATE TRIGGER themsua_hdon ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @NGHD SMALLDATETIME, @MAKH CHAR(4)
	SELECT @NGHD = NGHD, @MAKH = MAKH
	FROM inserted
	DECLARE @NGDK SMALLDATETIME
	SELECT @NGDK = NGDK
	FROM KHACHHANG
	WHERE MAKH = @MAKH
	IF(@NGHD < @NGDK)
	BEGIN
		PRINT N'Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK)'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT N'Thêm hoá đơn thành công'
	END
END
GO
CREATE TRIGGER sua_khachhang ON KHACHHANG
FOR INSERT
AS
BEGIN
	DECLARE @NGDK SMALLDATETIME, @MAKH CHAR(4)
	SELECT @NGDK = NGDK, @MAKH = MAKH
	FROM INSERTED
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM HOADON WHERE @MAKH = MAKH AND NGHD < @NGDK
	IF(@COUNT > 0)
	BEGIN
		PRINT N'Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK)'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT N'Thêm thành công'
	END
END
-- Cau 12: Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm
CREATE TRIGGER trg_themsua_12 ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @NGHD SMALLDATETIME, @MANV CHAR(4)
	SELECT @NGHD = NGHD, @MANV = MANV
	FROM inserted
	DECLARE @NGVL SMALLDATETIME
	SELECT @NGVL = NGVL
	FROM NHANVIEN
	WHERE MANV = @MANV
	IF(@NGHD < @NGVL)
	BEGIN
		PRINT N'Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT N'Thêm thành công'
	END
END

CREATE TRIGGER trgsua_nhanvien_12 ON NHANVIEN
FOR INSERT
AS
BEGIN
	DECLARE @MANV CHAR(4), @NGVL SMALLDATETIME
	SELECT @MANV = MANV, @NGVL = NGVL
	FROM INSERTED
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM HOADON
	WHERE @MANV = MANV AND  NGHD < @NGVL
	IF(@COUNT > 0)
	BEGIN
		PRINT N'Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT N'Thêm thành công'
	END
END
-- 13. Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
CREATE TRIGGER hoadon_trigia_13 ON HOADON
FOR UPDATE
AS
BEGIN
	DECLARE @TRIGIA INT
	DECLARE @TONGCTHD_CU INT
	SELECT @TRIGIA = TRIGIA
	FROM INSERTED
	SELECT @TONGCTHD_CU = SUM(SL * GIA) FROM DELETED, SANPHAM, CTHD
	WHERE CTHD.SOHD = DELETED.SOHD AND SANPHAM.MASP = CTHD.MASP
	GROUP BY DELETED.SOHD
	IF (@TONGCTHD_CU != @TRIGIA)
	BEGIN
		PRINT N'Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT N'Chỉnh sửa thành công'
	END
END
-- Câu 14. Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.
GO 
CREATE TRIGGER trg_update_doanhso_khachhang ON KHACHHANG
AFTER UPDATE
AS
BEGIN
	DECLARE @DOANHSO MONEY
	DECLARE @TONGTRIGIA MONEY
	SELECT @DOANHSO = DOANHSO
	FROM INSERTED
	SELECT @TONGTRIGIA = SUM(TRIGIA) 
	FROM HOADON, INSERTED
	WHERE HOADON.MAKH = INSERTED.MAKH

	IF(@DOANHSO != @TONGTRIGIA)
	BEGIN
		PRINT N'Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT N'Cập nhật thành công'
	END
END

-- Phần 2: Quản lý giáo vụ
-- 9.	Lớp trưởng của một lớp phải là học viên của lớp đó.
GO
CREATE TRIGGER themsua_lop_cau9 ON LOP
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @MALOP_INSERTED CHAR(3)
	DECLARE @MAHV CHAR(5)
	SELECT @MALOP_INSERTED = MALOP
	FROM INSERTED
	DECLARE @MALOP_HOCVIEN CHAR(5)
	SELECT @MALOP_HOCVIEN = HOCVIEN.MALOP
	FROM HOCVIEN, INSERTED
	WHERE HOCVIEN.MAHV = INSERTED.TRGLOP
	IF(@MALOP_INSERTED != @MALOP_HOCVIEN)
	BEGIN
		ROLLBACK TRAN
		PRINT N'Lớp trưởng của một lớp phải là học viên của lớp đó.'
	END
END

GO
CREATE TRIGGER sua_hocvien_cau9 ON HOCVIEN
FOR UPDATE
AS
BEGIN
	DECLARE @MAHV_DELETED CHAR(5)
	DECLARE @MALOP_DELETED CHAR(3)
	SELECT @MAHV_DELETED = MAHV, @MALOP_DELETED = MALOP
	FROM DELETED
	DECLARE @CHECK INT
	SELECT @CHECK = COUNT(*)
	FROM LOP
	WHERE MALOP = @MALOP_DELETED AND TRGLOP = @MAHV_DELETED
	IF(@CHECK != 0)
	BEGIN
		ROLLBACK TRAN
		PRINT N'khong the doi ma lop vi hoc vien nay dang la lop truong cua lop ' + CAST(@MALOP_DELETED AS VARCHAR(10))
	END
END

--10.Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”.
GO
CREATE TRIGGER TRG_TRGKHOA_CAU10 ON KHOA
FOR UPDATE
AS
BEGIN
	DECLARE @CHECK INT
	SELECT @CHECK = COUNT(*)
	FROM INSERTED, GIAOVIEN
	WHERE INSERTED.TRGKHOA = GIAOVIEN.MAGV AND INSERTED.MAKHOA = GIAOVIEN.MAKHOA
	AND HOCVI IN ('TS', 'PTS')
	IF(@CHECK = 0)
	BEGIN
		PRINT N'Truong khoa phai la giao vien thuoc khoa va co hoc vi TS hoac PTS' 
		ROLLBACK TRAN
	END
END

--15.Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này.
GO
CREATE TRIGGER trg_kiem_tra_ngay_thi ON KETQUATHI
AFTER UPDATE, INSERT
AS
BEGIN
    DECLARE @mahv CHAR(5)
    DECLARE @malop CHAR(3)
    DECLARE @mamh VARCHAR(10)
    DECLARE @ngaykt DATETIME
    DECLARE @ngaythi DATETIME

    SELECT @mahv = MAHV FROM INSERTED
    SELECT @mamh = MAMH FROM INSERTED
    SELECT @ngaythi =NGTHI FROM INSERTED
    SELECT @malop = MALOP FROM HOCVIEN WHERE @mahv = MAHV
    SELECT @ngaykt = DENNGAY FROM GIANGDAY WHERE @malop = MALOP AND @mamh = MAMH

    IF @ngaykt >= @ngaythi
    BEGIN
        ROLLBACK TRAN
    END
END

go
create trigger TRG_KETQUATHi_NGAYTHI on KETQUATHI for insert,update as
begin 
	declare @MALOP char(3)
	declare @MAMH varchar(10) 
	declare @NGAYTHI smalldatetime 
	select @MALOP = MALOP, @MAMH = MAMH,@NGAYTHI=NGTHI from inserted 
	inner join HOCVIEN on HOCVIEN.MAHV = inserted.MAHV 
	declare @check int 
	select @check= count(*) from GIANGDAY where MALOP = @MALOP and @MAMH = MAMH and DENNGAY>=@NGAYTHI
if(@check!=0)
	begin 
		print'Ngay thi phai sau ngay ket thuc mon' 
		rollback tran 
	end 
end 
go
--16.Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
GO
CREATE TRIGGER trg_test_cau16 ON GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @MALOP CHAR(3)
	DECLARE @HOCKY TINYINT
	DECLARE @NAM SMALLINT
	DECLARE @SL TINYINT

	SELECT @MALOP=MALOP FROM inserted
	SELECT @HOCKY=HOCKY FROM inserted
	SELECT @NAM=NAM FROM inserted
	SELECT @SL=COUNT(MAMH) FROM GIANGDAY
	WHERE @MALOP=MALOP
	AND @HOCKY=HOCKY
	AND @NAM=NAM
	IF(@SL>3)
	BEGIN
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		PRINT 'THEM THANH CONG'
	END
END
--17. Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó.
GO
CREATE TRIGGER ins_lop_cau17 ON LOP
AFTER INSERT
AS
BEGIN
    DECLARE @MALOP CHAR(3)
    SELECT @MALOP = MALOP FROM inserted
    UPDATE LOP
    SET SISO = 0
    WHERE MALOP = @MALOP
END

GO
CREATE OR ALTER TRIGGER ins_hv_cau17 ON HOCVIEN
AFTER INSERT
AS
BEGIN
    DECLARE @MALOP CHAR(3)
    SELECT @MALOP = MALOP FROM INSERTED
    UPDATE LOP
    SET SISO = SISO + 1
    WHERE MALOP = @MALOP
END

GO
CREATE OR ALTER TRIGGER upd_hv_cau17 ON HOCVIEN
AFTER UPDATE
AS
BEGIN
    DECLARE @MLM CHAR(3), @MLC CHAR(3)
    SELECT @MLM = MALOP FROM INSERTED
    SELECT @MLC = MALOP FROM DELETED
    UPDATE LOP SET SISO = SISO + 1 WHERE MALOP = @MLM
    UPDATE LOP SET SISO = SISO - 1 WHERE MALOP = @MLC
END

GO
CREATE OR ALTER TRIGGER del_hv_cau17 ON HOCVIEN
AFTER DELETE
AS
BEGIN
    DECLARE @MALOP CHAR(3)
    SELECT @MALOP = MALOP FROM DELETED
    UPDATE LOP
    SET SISO = SISO - 1
    WHERE MALOP = @MALOP
END
--18.Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC trong cùng một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và (“B”,”A”).
GO
CREATE OR ALTER TRIGGER dk_cau18 ON DIEUKIEN
AFTER INSERT ,UPDATE
AS
BEGIN
    DECLARE @MAMH VARCHAR(10), @MAMH_TRUOC VARCHAR(10)
    SELECT @MAMH = MAMH, @MAMH_TRUOC = MAMH_TRUOC FROM INSERTED
    IF (@MAMH = @MAMH_TRUOC)
    BEGIN
        ROLLBACK TRAN
        PRINT 'MAMH VA MAMHTRUOC KHONG DUOC GIONG NHAU'
    END
    ELSE
    BEGIN
        IF (EXISTS(SELECT * FROM DIEUKIEN WHERE MAMH = @MAMH_TRUOC AND MAMH_TRUOC = @MAMH))
        BEGIN
            ROLLBACK TRAN
            PRINT 'DIEU KIEN KHONG THOA MAN'
        END
    END
END
GO
--19.Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau.
GO
CREATE TRIGGER trg_cau19 ON GIAOVIEN
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @MAGV CHAR(4)
	DECLARE @HOCVI VARCHAR(10)
	DECLARE @HOCHAM VARCHAR(10)
	DECLARE @HESO NUMERIC(4,2)
	DECLARE @MUCLUONG MONEY

	SELECT @MUCLUONG=MUCLUONG FROM inserted
	SELECT @MAGV=MAGV FROM inserted
	SELECT @HOCVI=HOCVI FROM inserted
	SELECT @HOCHAM=HOCHAM FROM inserted
	SELECT @HESO=HESO FROM inserted
	SELECT MAGV=@MAGV FROM GIAOVIEN 
	WHERE HOCVI=@HOCVI
	AND @HOCHAM=HOCHAM
	AND @HESO=HESO
	IF(@MUCLUONG <> (SELECT MUCLUONG FROM GIAOVIEN WHERE MAGV<>@MAGV AND HOCVI=@HOCVI AND HOCHAM=@HOCHAM AND HESO=@HESO))
	BEGIN
		ROLLBACK TRAN
	END
END
--20.	Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5.
GO
CREATE TRIGGER trg_cau20 ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @LANTHI TINYINT, @MAHV CHAR(5), @MAMH VARCHAR(10),@DIEMTHILANTRUOC NUMERIC(4,2)
    SELECT @MAHV = MAHV , @MAMH = MAMH, @LANTHI = LANTHI FROM inserted
    IF(@LANTHI > 1)
    BEGIN
        SELECT @DIEMTHILANTRUOC = DIEM
        FROM KETQUATHI
        WHERE MAHV = @MAHV
        AND MAMH = @MAMH
        AND LANTHI = @LANTHI - 1
        IF(@DIEMTHILANTRUOC > 5)
        BEGIN
            PRINT 'KHONG DUOC THI LAI'
            ROLLBACK TRANSACTION
        END
    END
END
--21. Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên, cùng môn học).
GO
CREATE TRIGGER trg_cau21 ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @MAHV CHAR(5)
	DECLARE @MAMH VARCHAR(10)
	DECLARE @LANTHI TINYINT
	DECLARE @NGTHISAU SMALLDATETIME
	DECLARE @NGTHITRUOC SMALLDATETIME

	SELECT @MAHV=MAHV FROM inserted
	SELECT @MAMH=MAMH FROM inserted
	SELECT @LANTHI=LANTHI FROM inserted
	SELECT @NGTHISAU=NGTHI FROM inserted
	IF(@LANTHI>1)
	BEGIN
		SELECT @NGTHITRUOC=NGTHI
		FROM KETQUATHI
		WHERE MAHV=@MAHV
		AND MAMH=@MAMH
		AND LANTHI=@LANTHI-1
		IF(@NGTHISAU<=@NGTHITRUOC)
		BEGIN
			ROLLBACK TRAN
		END
	END
END
--22. Học viên chỉ được thi những môn mà lớp của học viên đó đã học xong.
GO
CREATE OR ALTER TRIGGER gd_cau22 ON GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @MALOP CHAR(3), @MAMH VARCHAR(10), @MAMH_TRUOC VARCHAR(10)
    SELECT @MALOP = MALOP, @MAMH = MAMH FROM INSERTED
    SELECT @MAMH_TRUOC = MAMH_TRUOC FROM DIEUKIEN WHERE MAMH = @MAMH
    IF NOT EXISTS (SELECT 1 FROM GIANGDAY WHERE MAMH = @MAMH_TRUOC
                                        AND MALOP = @MALOP)
    BEGIN
        PRINT 'MON HOC TRUOC CHUA DUOC HOC'
        ROLLBACK TRANSACTION
    END
END
--23. Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các môn học (sau khi học xong những môn học phải học trước mới được học những môn liền sau).
GO
CREATE TRIGGER trg_cau23 ON GIANGDAY
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @MAGV CHAR(4)
	DECLARE @MAMH VARCHAR(10)
	DECLARE @MAKHOAMH VARCHAR(4)
	DECLARE @MAKHOAGV VARCHAR(4)
	
	SELECT @MAGV=MAGV FROM inserted
	SELECT @MAMH=MAMH FROM inserted
	SELECT @MAKHOAMH=MAKHOA FROM MONHOC WHERE @MAMH=MAMH
	SELECT @MAKHOAGV=MAKHOA FROM GIAOVIEN WHERE @MAGV=MAGV
	IF(@MAKHOAMH<>@MAKHOAGV)
	BEGIN
		ROLLBACK TRAN
	END
END
--24. Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách
GO
create trigger GIANGDAY_PHANCONG on GIANGDAY for insert,update as
begin 
	declare @MAMH varchar(10) 
	declare @MAGV char(4) 
	select @MAMH = MAMH,@MAGV = MAGV from inserted 
	declare @MAKHOA_GV varchar(4)
	declare @MAKHOA_MONHOC varchar(4) 
	select @MAKHOA_GV = MAKHOA from GIAOVIEN where MAGV = @MAGV 
	select @MAKHOA_MONHOC = MAKHOA  from MONHOC where MAMH = @MAMH 
	if(@MAKHOA_GV != @MAKHOA_MONHOC) 
	begin 
		print'Giao vien chi duoc phan cong day nhung mon thuoc giao vien do phu trach' 
		rollback tran 
	end 
end