use QuanLyDETAI

-- Câu j
CREATE PROCEDURE sp_GV
AS
	SELECT * FROM GIAOVIEN

-- Test Câu j
Exec sp_GV

-- Câu k
CREATE PROCEDURE sp_SLDT @MaGV varchar(9)
AS
	DECLARE @ret int
	SET @ret = (SELECT COUNT(DISTINCT MADT) FROM THAMGIADT WHERE MAGV = @MaGV GROUP BY MAGV)
	Print N'Số lượng đề tài của GV có MAGV = ' + @MaGV + ' là ' + CAST(@ret AS VARCHAR(12))

-- Câu l
CREATE PROCEDURE sp_TTGV @MaGV varchar(9)
AS
	DECLARE @HoTen nvarchar(30)
	SET @HoTen = (SELECT HOTEN FROM GIAOVIEN WHERE MAGV = @MaGV)
	Print N'Họ tên: ' + @HoTen
	
	DECLARE @Luong decimal(18,1)
	SET @Luong = (SELECT LUONG FROM GIAOVIEN WHERE MAGV = @MaGV)
	Print N'Lương: ' + CAST(@Luong AS VARCHAR(12))
	
	DECLARE @NGSINH date
	SET @NGSINH = (SELECT NGSINH FROM GIAOVIEN WHERE MAGV = @MaGV)
	Print N'Ngày sinh: ' + CAST(@NGSINH AS VARCHAR(12))
	
	DECLARE @DiaChi nvarchar(50)
	Set @DiaChi = (SELECT DIACHI FROM GIAOVIEN WHERE MAGV = @MaGV)
	Print N'Địa chỉ: ' + @DiaChi
	
	DECLARE @SLDT int
	SET @SLDT = (SELECT COUNT(DISTINCT MADT) FROM THAMGIADT WHERE MAGV = @MaGV GROUP BY MAGV)
	Print N'SLDT: ' + CAST(@SLDT AS VARCHAR(12))
	
	DECLARE @SLNT int
	SET @SLNT = (SELECT COUNT(*) FROM NGUOITHAN WHERE MAGV = @MaGV GROUP BY MAGV)
	Print N'SLNT: ' + CAST(@SLNT AS VARCHAR(12))


-- Câu m
CREATE PROCEDURE sp_CheckGVExist @MaGV varchar(9), @check bit out
AS
	IF (EXISTS(SELECT * FROM GIAOVIEN WHERE MAGV = @MaGV))
		BEGIN
			Print N'MAGV = ' + @MaGV + N' -> tồn tại giáo viên.'
			SET @check = 1
		END
	ELSE
		BEGIN
			Print N'MAGV = ' + @MaGV + N' -> không tồn tại giáo viên!'
			SET @check = 0
		END
		

-- Câu n
CREATE PROCEDURE sp_CheckRuleGV @MaGV varchar(9), @MaDT varchar(3), @check bit out
AS
	DECLARE @GVCNDT varchar(3)
	SET @GVCNDT = (SELECT GVCNDT FROM DETAI WHERE MADT = @MaDT)
	
	IF ((SELECT MABM FROM GIAOVIEN WHERE MAGV = @MaGV) = (SELECT MABM FROM GIAOVIEN WHERE MAGV = @GVCNDT))
		BEGIN
			Print 'True'
			Set @check = 1
		END
	ELSE
		BEGIN
			Print 'False'
			Set @check = 0
		END

-- Câu o
CREATE PROCEDURE sp_PhanCongCongViec @MaGV varchar(3), @MaDT varchar(3), @Stt int, @PhuCap int, @Ketqua nvarchar(3)
AS
	DECLARE @check bit
	SET @check = 1
	
	IF (NOT EXISTS(SELECT * FROM GIAOVIEN WHERE MAGV = @MaGV))
		BEGIN
			Print N'Mã GV không tồn tại'
			SET @check = 0
		END
	
	IF (NOT EXISTS(SELECT * FROM CONGVIEC WHERE MADT = @MaDT AND STT = @Stt))
		BEGIN
			Print N'Công việc không tồn tại'
			SET @check = 0
		END
	
	-- Câu n
	DECLARE @GVCNDT varchar(3)
	SET @GVCNDT = (SELECT GVCNDT FROM DETAI WHERE MADT = @MaDT)
	
	IF (@check = 1 AND (SELECT MABM FROM GIAOVIEN WHERE MAGV = @MaGV) <> (SELECT MABM FROM GIAOVIEN WHERE MAGV = @GVCNDT))
		BEGIN
			Print N'Đề tài không do bộ môn của GV làm chủ nhiệm'
			Set @check = 0
		END
	
	-- Thêm phân công
	IF (@check = 1)
		BEGIN
			INSERT INTO THAMGIADT(MAGV, MADT, STT, PHUCAP, KETQUA)
			VALUES (@MaGV, @MaDT, @Stt, @PhuCap, @Ketqua)
			Print N'Phân công thành công.'
		END



-- Câu p
CREATE PROCEDURE sp_XoaGV @MaGV varchar(9)
AS
	DECLARE @check bit
	SET @check = 1
	
	IF (EXISTS(SELECT * FROM GIAOVIEN WHERE MAGV = @MaGV))
		BEGIN
			IF (EXISTS(SELECT * FROM NGUOITHAN WHERE MAGV = @MaGV))
				BEGIN
					Print N'Giáo viên tồn tại người thân'
					SET @check = 0
				END
				
			IF (EXISTS(SELECT * FROM THAMGIADT WHERE MAGV = @MaGV))
				BEGIN
					Print N'Giáo viên có tham gia đề tài'
					SET @check = 0
				END
				
			IF (EXISTS(SELECT * FROM BOMON WHERE TRUONGBM = @MaGV))
				BEGIN
					Print N'Giáo viên đang là trưởng bộ môn'
					SET @check = 0
				END
				
			IF (EXISTS(SELECT * FROM KHOA WHERE TRUONGKHOA = @MaGV))
				BEGIN
					Print N'Giáo viên đang là trưởng khoa'
					SET @check = 0
				END
				
			IF (EXISTS(SELECT * FROM DETAI WHERE GVCNDT = @MaGV))
				BEGIN
					Print N'Giáo viên đang chủ nhiệm đề tài'
					SET @check = 0
				END
				
			IF (EXISTS(SELECT * FROM GV_DT WHERE MAGV = @MaGV))
				BEGIN
					Print N'Giáo viên có tồn tại số điện thoại'
					SET @check = 0
				END
				
			IF (@check = 1)
				BEGIN
					DELETE FROM GIAOVIEN WHERE MAGV = @MaGV
					Print N'Xóa thành công'
				END
		END
	ELSE
		Print N'Không tồn tại giáo viên có MAGV = ' + @MaGV


-- Câu q
-- using cursor
CREATE PROCEDURE sp_DSGVAll
AS
	DECLARE cs_DSGV CURSOR FOR (SELECT MAGV FROM GIAOVIEN)
	OPEN cs_DSGV
	
	DECLARE @MaGV varchar(3)
	FETCH NEXT FROM cs_DSGV INTO @MaGV
	
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		DECLARE @HoTen nvarchar(30)
		SET @HoTen = (SELECT HOTEN FROM GIAOVIEN WHERE MAGV = @MaGV)
		Print N'Họ tên: ' + @HoTen
		
		DECLARE @Luong decimal(18,1)
		SET @Luong = (SELECT LUONG FROM GIAOVIEN WHERE MAGV = @MaGV)
		Print N'Lương: ' + CAST(@Luong AS VARCHAR(12))
		
		DECLARE @NGSINH date
		SET @NGSINH = (SELECT NGSINH FROM GIAOVIEN WHERE MAGV = @MaGV)
		Print N'Ngày sinh: ' + CAST(@NGSINH AS VARCHAR(12))
		
		DECLARE @DiaChi nvarchar(50)
		Set @DiaChi = (SELECT DIACHI FROM GIAOVIEN WHERE MAGV = @MaGV)
		Print N'Địa chỉ: ' + @DiaChi
		
		DECLARE @SLDT int
		SET @SLDT = (SELECT COUNT(DISTINCT MADT) FROM THAMGIADT WHERE MAGV = @MaGV GROUP BY MAGV)
		Print N'SLDT: ' + CAST(@SLDT AS VARCHAR(12))
		
		DECLARE @SLNT int
		SET @SLNT = (SELECT COUNT(*) FROM NGUOITHAN WHERE MAGV = @MaGV GROUP BY MAGV)
		Print N'SLNT: ' + CAST(@SLNT AS VARCHAR(12))
		
		DECLARE @SoGVQL int
		SET @SoGVQL = (SELECT COUNT(*) FROM GIAOVIEN WHERE GVQLCM = @MaGV)
		Print N'Số GV mà GV quản lý: ' + CAST(@SoGVQL AS VARCHAR(12))
		
		Print '-------------------------------------------------------------'
		FETCH NEXT FROM cs_DSGV INTO @MaGV  
	END
	
	CLOSE cs_DSGV
	DEALLOCATE cs_DSGV

-- Câu r
CREATE PROCEDURE sp_CheckRuleGV_AB @MaGVA varchar(9), @MaGVB varchar(9)
AS
	IF ((SELECT MABM FROM GIAOVIEN WHERE MAGV = @MaGVA) = (SELECT MABM FROM GIAOVIEN WHERE MAGV = @MaGVB))
		IF (EXISTS(SELECT * FROM BOMON WHERE TRUONGBM = @MaGVA))
			IF ((SELECT LUONG FROM GIAOVIEN WHERE MAGV = @MaGVA) < (SELECT LUONG FROM GIAOVIEN WHERE MAGV = @MaGVB))
				BEGIN
					Print 'FALSE'
				END
			ELSE
				BEGIN
					Print 'TRUE'
				END
		ELSE 
			IF (EXISTS(SELECT * FROM BOMON WHERE TRUONGBM = @MaGVB))
				IF ((SELECT LUONG FROM GIAOVIEN WHERE MAGV = @MaGVA) > (SELECT LUONG FROM GIAOVIEN WHERE MAGV = @MaGVB))
					Print 'FALSE'
				ELSE
					Print 'TRUE'
			ELSE
				Print 'TRUE'
	ELSE
		Print 'TRUE'

-- Câu s
CREATE PROCEDURE sp_AddGV @MaGV varchar(9), @HoTen nvarchar(30), @Luong int, @Phai nchar(3), @NgSinh date, @DiaChi nvarchar(50), @GVQLCM varchar(3), @MaBM  nchar(4)
AS
	DECLARE @check bit
	SET @check = 1
	
	IF (EXISTS(SELECT * FROM GIAOVIEN WHERE HOTEN = @HoTen))
		BEGIN
			Print N'Trùng họ tên GV khác'
			SET @check = 0
		END
		
	IF (YEAR(GetDate()) - YEAR(@NgSinh) < 18)
		BEGIN
			Print N'Tuổi < 18'
			SET @check = 0
		END
		
	IF (@Luong <= 0)
		BEGIN
			Print N'Lương < 0'
			SET @check = 0
		END
	
	IF (@check = 1)
		BEGIN
			INSERT INTO GIAOVIEN(MAGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI, GVQLCM, MABM)
			VALUES (@MaGV, @HoTen, @Luong, @Phai, @NgSinh, @DiaChi, @GVQLCM, @MaBM)
			Print N'Thêm thành công!'
		END

-- Câu t
CREATE PROCEDURE sp_AutoMaGV @MaGV varchar(3) out
AS
	DECLARE @num int
	DECLARE @temp varchar(3)
	SET @num = 1
	
	WHILE (1=1)
	BEGIN
		IF (@num < 10)
			BEGIN
				SET @temp = '00' + CAST(@num as varchar(1))
			END
		ELSE IF (@num < 100)
			BEGIN
				SET @temp = '0' + CAST(@num as varchar(2))
			END
		ELSE
			BEGIN
				SET @temp = CAST(@num as varchar(3))
			END
		
		IF (NOT EXISTS(SELECT * FROM GIAOVIEN WHERE MAGV = @temp))
			BEGIN
				Set @MaGV = @temp
				break
			END
		
		SET @num = @num + 1
	END

