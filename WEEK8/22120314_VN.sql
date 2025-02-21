-- Câu a
CREATE PROCEDURE spCHAO
AS
	Print 'Hello World!!!'
	
Exec spCHAO

-- Câu b
CREATE PROCEDURE spTONG_2SO @A int, @B int
AS
	DECLARE @Tong int
	SET @Tong = @A + @B
	PRINT @Tong

Exec spTONG_2SO 13, 12

-- Câu c
CREATE PROCEDURE spTONG_2SO_OUT @So1 int, @So2 int, @Tong int out
AS
	SET @Tong = @So1 + @So2

DECLARE @Tong int
Exec spTONG_2SO_OUT 12, -2, @Tong out
Print @Tong

-- Câu d
CREATE PROCEDURE spTONG_3SO @So1 int, @So2 int,@So3 int
AS
	DECLARE @Tong int
	Exec spTONG_2SO_OUT @So1, @So2, @Tong out
	SET @Tong = @Tong + @So3
	Print @Tong

Exec spTONG_3SO 1, -2, 4

-- Câu e
CREATE PROCEDURE spTONG_M_DEN_N @m int, @n int
AS
	DECLARE @Tong int
	DECLARE @i int
	SET @Tong = 0
	SET @i = @m
	
	WHILE (@i < @n)
	BEGIN
		SET @Tong = @Tong + @i
		SET @i = @i + 1
	END
	
	Print @Tong

Exec spTONG_M_DEN_N 1,6

-- Câu f
CREATE PROCEDURE spCHECK_PRIME @num int, @check bit out
AS
	DECLARE @bound float
	DECLARE @i int
	SET @check = 1
	SET @i = 2
	SET @bound = SQRT(@num)
	
	While (@i <= @bound)
	BEGIN
		IF (@num % @i = 0)
			BEGIN
				SET @check = 0
				break
			END
		SET @i = @i + 1		
	END

DECLARE @check bit
Exec spCHECK_PRIME 5, @check out
IF (@check = 1)
	BEGIN
		Print N'5 là số nguyên tố.'
	END
ELSE
	BEGIN
		Print N'5 không là số nguyên tố.'
	END

DECLARE @check bit
Exec spCHECK_PRIME 4, @check out
IF (@check = 1)
	BEGIN
		Print N'4 là số nguyên tố.'
	END
ELSE
	BEGIN
		Print N'4 không là số nguyên tố.'
	END

-- Câu g		
CREATE PROCEDURE spTONG_NgTo_MN @m int, @n int
AS
	DECLARE @Tong int
	DECLARE @i int
	DECLARE @check bit
	SET @Tong = 0
	SET @i = @m
	
	While (@i <= @n)
	BEGIN
		Exec spCHECK_PRIME @i, @check out
		IF (@check = 1)
			BEGIN
				SET @Tong = @Tong + @i
			END
			
		SET @i = @i + 1
	END
	
	Print N'Tổng các số nguyên tố trong [' + cast(@m as varchar(12)) + N', ' + cast(@n as varchar(12)) + '] = ' + cast(@Tong as varchar(12))

Exec spTONG_NgTo_MN 1, 5


-- Câu h
CREATE PROCEDURE spUCLN @a int, @b int
AS
	SET @a = ABS(@a)
	SET @b = ABS(@b)
	
			While (@a <> @b)
			BEGIN
				IF (@a > @b)
					SET @a = @a - @b
				ELSE
					SET @b = @b - @a
			END
	
	return @a

DECLARE @UCLN int
Exec @UCLN = spUCLN -4, 14
Print @UCLN

-- Câu i
CREATE PROCEDURE spBCNN @a int, @b int	
AS
	DECLARE @ucln int 
	
	Exec @ucln = spUCLN @a, @b
	
	RETURN (ABS(@a*@b)/@ucln)

DECLARE @BCNN int
Exec @BCNN = spBCNN 4, 14
Print @BCNN


-------------------------------------------------------------------------------------------
DROP DATABASE QLDATPHONG	
CREATE DATABASE QLDATPHONG
USE QLDATPHONG

-- Bảng PHÒNG với các thuộc tính
-- MaPhong ứng với MãPhòng - varchar(10)
-- Tinh ứng với Tình - nvarchar(4)
-- LoaiPhong ứng với LoạiPhòng - nvarchar(10)
-- DonGia ứng tới Đơn giá - money
CREATE TABLE PHONG
(	
	MaPhong char(10),
	Tinh nvarchar(4) check(Tinh in (N'Rảnh', N'Bận')) NOT NULL,
	LoaiPhong nvarchar(10) NOT NULL,
	DonGia money NOT NULL,
	PRIMARY KEY (MaPhong)
)

-- Bảng KHÁCH với các thuộc tính
-- MaKH ứng với Mã KH - varchar(10)
-- HoTen ứng với Họ tên - nvarchar(30)
-- DiaChi ứng với Địa chỉ -  nvarchar(50)
-- Dien ứng với Điện - char(10)
CREATE TABLE KHACH
(
	MaKH char(10),
	HoTen nvarchar(30) NOT NULL,
	DiaChi nvarchar(50),
	Dien char(10),
	PRIMARY KEY (MaKH)

)

-- Bảng ĐẶT PHÒNG với các thuộc tính
-- Ma ứng với Mã - int
-- NgayDP ứng với Ngày ĐP - date
-- NgayTra ứng với Ngày Trả - date
-- ThanhTien ứng với Thành tiền - money
CREATE TABLE DATPHONG
(
	Ma int,
	MaKH char(10) NOT NULL,
	MaPhong char(10) NOT NULL,
	NgayDP date NOT NULL,
	NgayTra date,
	ThanhTien money,
	PRIMARY KEY (Ma)
)

ALTER TABLE DATPHONG
ADD CONSTRAINT FK_DP_KHACH FOREIGN KEY (MaKH) REFERENCES KHACH
ALTER TABLE DATPHONG
ADD CONSTRAINT FK_DP_PHONG FOREIGN KEY (MaPhong) REFERENCES PHONG

-- Tạo ghi nhận thông tin đặt phòng của khách hàng xuống cơ sở dữ liệu.
CREATE PROCEDURE spDatPhong @makh char(10), @maphong char(10), @ngaydat date
AS 
	DECLARE @check bit
	SET @check = 1	

	-- Kiểm tra mã khách hàng phải hợp lệ (phải xuất hiện trong bảng KHÁCH HÀNG)

	IF (@makh NOT IN (	SELECT MaKH 
						FROM KHACH	))

		BEGIN
			PRINT N'Khách hàng không tồn tại.'
			SET @check = 0
		END

	-- Kiểm tra mã phòng hợp lệ (phải xuất hiện trong bảng PHÒNG)

	IF (@maphong NOT IN (SELECT MaPhong
						 FROM PHONG))
		BEGIN
			PRINT N'Phòng không tồn tại.'
			SET @check = 0
		END

	-- Kiểm tra tình trạng của phòng là “Rảnh” hay không

	IF ( (  SELECT Tinh 
				FROM PHONG 
				WHERE MaPhong = @maphong) = N'Bận')
		BEGIN
			Print N'Phòng đã được đặt.'
			SET @check = 0
		END

	-- Nếu check hợp lệ thì ghi thông tin đặt phòng xuống CSDL

	-- Mã đặt phòng là số nguyên 
	DECLARE @madatphong int

	-- Nếu ĐẶT PHÒNG chưa có dữ liệu nào
	IF (NOT EXISTS(SELECT * FROM DATPHONG))
		BEGIN
			-- Mã trong ĐẶT PHÒNG sẽ bắt đầu từ 1
			SET @madatphong = 1
		END
	-- Nếu ĐẶT PHÒNG đã có dữ liệu
	ELSE
	-- Mã đặt phòng phát sinh tự động theo cách sau: mã đặt phòng phát sinh = mã đặt phòng lớn nhất + 1.
		BEGIN
			SET @madatphong = 1 + ( SELECT MAX(Ma)
									FROM DATPHONG 
									GROUP BY Ma)
		END
		
	-- Nếu các kiểm tra hợp lệ thì ghi nhận thông tin đặt phòng xuống CSDL (Ngày trả và thành tiền của khi đặt phòng là NULL)
	IF (@check = 1)
		BEGIN
			INSERT INTO DATPHONG(Ma, MaKH, MaPhong, NgayDP, NgayTra, ThanhTien)
			VALUES (@madatphong, @makh, @maphong, @ngaydat, NULL, NULL)
			Print N'Đặt phòng thành công.'
			-- Cập nhật lại trạng thái của phòng là "Bận"
			UPDATE PHONG
			SET Tinh = N'Bận.'
			WHERE MaPhong = @maphong
		END

Exec spDatPhong '001', '001', '05/19/2024'
Exec spDatPhong '011', '111', '05/18/2024'

select * from DATPHONG

CREATE PROCEDURE spTraPhong @madp char(10), @makh char(10)
AS
	DECLARE @check bit
	SET @check = 1
	
	-- Kiểm tra tính hợp lệ của mã đặt phòng và mã khách hàng
	IF (NOT EXISTS( SELECT * 
					FROM DATPHONG 
					WHERE Ma = @madp AND MaKH = @makh))
		BEGIN
			Print N'Khách hàng chưa thực hiện việc đặt phòng.'
			SET @check = 0
		END
	
	IF (@check = 1)
		BEGIN
			-- Ngày trả phòng chính là ngày hiện hành
			UPDATE DATPHONG
			SET NgayTra = GetDate()
			WHERE Ma = @madp AND MaKH = @makh
			
			-- Tiền thanh toán = số ngày thuê x đơn giá phòng
			DECLARE @songay int
			SET @songay = 1 + DATEDIFF(DAY, ( SELECT NgayDP 
											  FROM DATPHONG 
											  WHERE Ma = @madp AND MaKH = @makh), GetDate())
			
			DECLARE @maphong char(10)
			SET @maphong = ( SELECT MaPhong
							 FROM DATPHONG
							 WHERE Ma = @madp AND MaKH = @makh)
			
			DECLARE @dongia int
			SET @dongia = ( SELECT DonGia 
							FROM PHONG
							WHERE MaPhong = @maphong)
			
			-- Tính tổng tiền
			UPDATE DATPHONG
			SET ThanhTien = @songay * @dongia
			WHERE Ma = @madp AND MaKH = @makh
			-- Cập nhật lại trạng thái của phòng là "Rảnh"
			UPDATE PHONG
			SET Tinh = N'Rảnh'
			WHERE MaPhong = @maphong
		
			Print N'Trả phòng thành công.'
		END
		
-- Test Câu 2
Exec spTraPhong '001', '001'
Exec spTraPhong '002', '011'

select * from DATPHONG

select * from PHONG
select * from KHACH

