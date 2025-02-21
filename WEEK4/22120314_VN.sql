USE QuanLyDETAI;

 -- Q75 Cho biết họ tên giáo viên và tên bộ môn họ làm trưởng bộ môn nếu có

 SELECT GV.HOTEN, COALESCE( BM.TENBM, '-' ) AS TRUONGBOMON
 FROM GIAOVIEN GV
LEFT JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV

-- Q76 Cho danh sách tên bộ môn và họ tên trưởng bộ môn đó nếu có

 SELECT BM.TENBM, COALESCE( GV.HOTEN, '-' ) AS TENTRUONGBOMON
 FROM BOMON BM
LEFT JOIN GIAOVIEN GV  ON BM.TRUONGBM = GV.MAGV

-- Q77 Cho danh sách tên giáo viên và các đề tài giáo viên đó chủ nhiệm nếu có

SELECT GV.HOTEN , COALESCE(DT.TENDT, '-') AS TENDTCHUNHIEM
FROM GIAOVIEN GV  
LEFT JOIN DETAI DT ON DT.GVCNDT = GV.MAGV

-- Q78 Xuất ra thông tin của giáo viên (MAGV, HOTEN) và mức lương của giáo viên. Mức
-- lương được xếp theo quy tắc: Lương của giáo viên < $1800 : “THẤP” ; Từ $1800 đến
-- $2200: TRUNG BÌNH; Lương > $2200: “CAO”

SELECT GV.MAGV, GV.HOTEN, GV.LUONG,  ( CASE 
							WHEN GV.LUONG < 1800.0 THEN N'THẤP'
							WHEN GV.LUONG BETWEEN 1800.0 AND 2200.0 THEN N'TRUNG BÌNH'
							WHEN GV.LUONG > 2200.0 THEN N'CAO'
							END ) AS LUONG
FROM GIAOVIEN GV

-- Q79 Xuất ra thông tin giáo viên (MAGV, HOTEN) và xếp hạng dựa vào mức lương. Nếu giáo
-- viên có lương cao nhất thì hạng là 1.

SELECT GV.MAGV,  GV.HOTEN, GV.LUONG, DENSE_RANK() OVER (ORDER BY LUONG DESC) AS XEPHANG
FROM GIAOVIEN GV

-- Q80 Xuất ra thông tin thu nhập của giáo viên. Thu nhập của giáo viên được tính bằng
-- LƯƠNG + PHỤ CẤP. Nếu giáo viên là trưởng bộ môn thì PHỤ CẤP là 300, và giáo viên là
-- trưởng khoa thì PHỤ CẤP là 600.

SELECT DISTINCT GV.MAGV, GV.HOTEN, GV.LUONG, GV.LUONG + ( CASE 
				   WHEN GV.MAGV = K.TRUONGKHOA THEN  600.0
				   WHEN GV.MAGV = BM.TRUONGBM THEN  300.0 
				   ELSE 0
				   END) AS THUNHAP
FROM GIAOVIEN GV
LEFT JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
LEFT JOIN KHOA K ON GV.MAGV = K.TRUONGKHOA;

-- Q81 Xuất ra năm mà giáo viên dự kiến sẽ nghĩ hưu với quy định: Tuổi nghỉ hưu của Nam là 60, của Nữ là 55.

SELECT GV.MAGV, GV.HOTEN, (CASE 
						   WHEN GV.PHAI = N'Nam' THEN YEAR(GV.NGSINH) + 60
						   WHEN GV.PHAI = N'Nữ' THEN YEAR(GV.NGSINH) + 55
						   END )AS NAM_NGHI_HUU
FROM GIAOVIEN GV;

-- Q82 Cho biết danh sách tất cả giáo viên (magv, hoten) và họ tên giáo viên là quản lý chuyên môn của họ.

SELECT GV.MAGV, GV.HOTEN, COALESCE( GVQLCM.HOTEN, '-') AS GVQLCM
FROM GIAOVIEN GV 
LEFT JOIN GIAOVIEN GVQLCM ON GV.GVQLCM = GVQLCM.MAGV

-- Q83 Cho biếtdanh sách tất cả bộ môn (mabm, tenbm), tên trưởng bộ môn cùng số lượng giáo viên của mỗi bộ môn.

SELECT BM.MABM, BM.TENBM, COALESCE( BM.TRUONGBM, '-') AS TRUONGBM, COUNT(GV.MAGV) AS SLGV
FROM BOMON BM 
LEFT JOIN GIAOVIEN TBM ON BM.TRUONGBM = TBM.MAGV
LEFT JOIN GIAOVIEN GV ON GV.MABM=BM.MABM 
GROUP BY BM.MABM, BM.TENBM, BM.TRUONGBM


-- Q84 Cho biết danh sách tất cả các giáo viên nam và thông tin các công việc mà họ đã tham gia.

SELECT GV.MAGV, GV.HOTEN, COALESCE( CV.TENCV, '-') AS TENCV, COALESCE( TG.KETQUA, '-') AS KETQUA
FROM GIAOVIEN GV
LEFT JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
LEFT JOIN CONGVIEC CV ON TG.MADT = CV.MADT AND TG.STT = CV.STT
WHERE GV.PHAI = N'Nam'

-- Q85 Cho biết danh sách tất cả các giáo viên và thông tin các công việc thuộc đề tài 001 mà họ tham gia.

SELECT GV.MAGV, GV.HOTEN, CV.TENCV, TG.KETQUA
FROM GIAOVIEN GV
LEFT JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
LEFT JOIN CONGVIEC CV ON TG.MADT = CV.MADT AND TG.STT = CV.STT
WHERE TG.MADT = '001'

-- Q86 Cho biết thông tin các trưởng bộ môn (magv, hoten) sẽ về hưu vào năm 2014. 
-- Biết rằng độ tuổi về hưu của giáo viên nam là 60 còn giáo viên nữ là 55.

SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MAGV = BM.TRUONGBM
WHERE 2014 - YEAR(GV.NGSINH) >= (CASE 
								WHEN GV.PHAI = N'Nam' THEN 60
								WHEN GV.PHAI = N'Nữ' THEN 55
								END) 

-- Q87 Cho biết thông tin các trưởng khoa (magv) và năm họ sẽ về hưu.

SELECT GV.MAGV, GV.HOTEN, (CASE 
						   WHEN GV.PHAI = N'Nam' THEN YEAR(GV.NGSINH) + 60
						   WHEN GV.PHAI = N'Nữ' THEN YEAR(GV.NGSINH) + 55
						   END) AS NAMVEHUU
FROM GIAOVIEN GV
JOIN KHOA K ON GV.MAGV = K.TRUONGKHOA;

-- Q88 Tạo bảng DANHSACHTHIDUA (magv, sodtdat, danhhieu) gồm thông tin mã giáo viên,
-- số đề tài họ tham gia đạt kết quả và danh hiệu thi đua:
-- a. Insert dữ liệu cho bảng này (để trống cột danh hiệu)
--b. Dựa vào cột sldtdat (số lượng đề tài tham gia có kết quả là “đạt”) để cập nhật dữ
-- liệu cho cột danh hiệu theo quy định:
-- i. Sodtdat = 0 thì danh hiệu “chưa hoàn thành nhiệm vụ”
-- ii. 1 <= Sodtdat <= 2 thì danh hiệu “hoàn thành nhiệm vụ”
-- iii. 3 <= Sodtdat <= 5 thì danh hiệu “tiên tiến”
-- iv. Sodtdat >= 6 thì danh hiệu “lao động xuất sắc”

CREATE TABLE DANHSACHTHIDUA
(
	MAGV CHAR(5),
	SODTDAT INT,
	DANHHIEU NVARCHAR(50),
	PRIMARY KEY(MAGV)
)

INSERT INTO DANHSACHTHIDUA (MAGV, SODTDAT) VALUES
    (1, 0),
    (2, 2),
    (3, 4),
    (4, 6),
    (5, 8)

UPDATE DANHSACHTHIDUA
SET DANHHIEU = ( CASE 
				 WHEN SODTDAT = 0 THEN N'Chưa hoàn thành nhiệm vụ'
				 WHEN SODTDAT BETWEEN 1 AND 2 THEN N'Hoàn thành nhiệm vụ'
				 WHEN SODTDAT BETWEEN 3 AND 5 THEN N'Tiên tiến'
				 WHEN SODTDAT >= 6 THEN  N'Lao động xuất sắc'
				 END)

SELECT * FROM DANHSACHTHIDUA

-- Q89 Cho biết magv, họ tên và mức lương các giáo viên nữ của khoa “Công nghệ thông tin”,
-- mức lương trung bình, mức lương lớn nhất và nhỏ nhất của các giáo viên này.

SELECT GV.MAGV, GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.MABM = GV.MABM
JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE GV.PHAI = N'Nữ' AND K.TENKHOA = N'Công nghệ thông tin'

-- Mức lương trung bình, mức lương lớn nhất và nhỏ nhất của các giáo viên nữ khoa "Công nghệ thông tin"
SELECT AVG(GV.LUONG) AS LuongTrungBinh, MAX(GV.LUONG) AS LuongLonNhat,  MIN(GV.LUONG) AS LuongNhoNhat
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.MABM = GV.MABM
JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
WHERE GV.PHAI = N'Nữ' AND K.TENKHOA = N'Công nghệ thông tin'


-- Q90 Cho biết makhoa, tenkhoa, số lượng gv từng khoa, số lượng gv trung bình, lớn nhất và nhỏ nhất của các khoa này.

SELECT K.MAKHOA, K.TENKHOA, COUNT(GV.MAGV) AS SoLuongGV
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.MABM = GV.MABM
JOIN KHOA K ON BM.MAKHOA = K.MAKHOA
GROUP BY K.MAKHOA, K.TENKHOA;

SELECT DISTINCT
    AVG(COUNT(GV.MAGV)) OVER () AS SoLuongGiaoVienTB,
    MAX(COUNT(GV.MAGV)) OVER () AS SoLuongGVLonNhat,
    MIN(COUNT(GV.MAGV)) OVER () AS SoLuongGVNhoNhat
FROM KHOA K 
JOIN BOMON BM ON BM.MAKHOA = K.MAKHOA
JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
GROUP BY K.MAKHOA, K.TENKHOA


--Q91. Cho biết danh sách các tên chủ đề, kinh phí cho chủ đề (là kinh phí cấp cho các đề tài
--thuộc chủ đề), tổng kinh phí, kinh phí lớn nhất và nhỏ nhất cho các chủ đề.

SELECT  CD.TENCD, DT.KINHPHI 
FROM CHUDE CD
JOIN DETAI DT ON CD.MACD = DT.MACD
GROUP BY CD.TENCD, DT.KINHPHI;

SELECT
    SUM(DT.KINHPHI) AS TongKinhPhi,
    MAX(DT.KINHPHI) AS KinhPhiLonNhat,
    MIN(DT.KINHPHI) AS KinhPhiNhoNhat
FROM CHUDE CD
JOIN DETAI DT ON CD.MACD = DT.MACD


--Q92. Cho biết madt, tendt, kinh phí đề tài, mức kinh phí tổng và trung bình của các đề tài
--này theo từng giáo viên chủ nhiệm.

SELECT  DT.MADT, DT.TENDT, DT.KINHPHI
FROM DETAI DT

SELECT DT.GVCNDT,  SUM(DT.KINHPHI) AS TongTheoGV, AVG(DT.KINHPHI) AS TrungBinhTheoGV
FROM DETAI DT
GROUP BY DT.GVCNDT

--Q93. Cho biết madt, tendt, kinh phí đề tài, mức kinh phí tổng và trung bình của các đề tài
--này theo từng cấp độ đề tài.
SELECT DT.MADT, DT.TENDT, DT.KINHPHI
FROM DETAI DT

--Mức kinh phí tổng và trung bình của các đề tài này theo từng cấp độ đề tài.
SELECT  DT.CAPQL, SUM( DT.KINHPHI) KinhPhiTong, AVG( DT.KINHPHI) KinhPhiTB
FROM DETAI DT
GROUP BY DT.CAPQL


--Q94. Tổng hợp số lượng các đề tài theo (cấp độ, chủ đề), theo (cấp độ), theo (chủ đề).
SELECT DETAI.CAPQL , CHUDE.TENCD , COUNT(*) AS SoLuong
FROM DETAI
JOIN CHUDE ON DETAI.MACD = CHUDE.MACD
GROUP BY DETAI.CAPQL, CHUDE.TENCD

-- Tổng hợp số lượng các đề tài theo (cấp độ)
SELECT DETAI.CAPQL , COUNT(*) AS SoLuong
FROM DETAI
GROUP BY DETAI.CAPQL

-- Tổng hợp số lượng các đề tài theo (chủ đề)
SELECT CHUDE.TENCD , COUNT(*) AS SoLuong
FROM DETAI
JOIN CHUDE ON DETAI.MACD = CHUDE.MACD
GROUP BY CHUDE.TENCD

-- Q95 Tổng hợp mức lương tổng của các giáo viên theo (bộ môn, phái), theo (bộ môn)

--Theo (bộ môn, phái)
SELECT SUM(GV.LUONG) TongLuongTheoBMPhai
FROM GIAOVIEN GV 
JOIN BOMON BM ON BM.MABM=GV.MABM
GROUP BY BM.MABM, GV.PHAI

--Theo (bộ môn)
SELECT SUM(GV.LUONG) TongLuongTheoBM
FROM GIAOVIEN GV 
JOIN BOMON BM ON BM.MABM=GV.MABM
GROUP BY BM.MABM

-- Q96 Tổng hợp số lượng các giáo viên của khoa CNTT theo (bộ môn, lương), theo (bộ môn), theo (lương)

--Theo (bộ môn, lương)
SELECT BM.MABM, GV.LUONG, COUNT(GV.MAGV) SoLuongGV
FROM KHOA K
JOIN BOMON BM ON BM.MAKHOA=K.MAKHOA
JOIN GIAOVIEN GV ON GV.MABM=BM.MABM
WHERE K.MAKHOA = 'CNTT'
GROUP BY BM.MABM, GV.LUONG

--Theo (bộ môn)
SELECT BM.MABM, COUNT(GV.MAGV) SoLuongGV
FROM KHOA K 
JOIN BOMON BM ON BM.MAKHOA=K.MAKHOA
JOIN GIAOVIEN GV ON GV.MABM=BM.MABM
WHERE K.MAKHOA = 'CNTT'
GROUP BY BM.MABM

--Theo (lương)
SELECT GV.LUONG, COUNT(GV.MAGV) SoLuongGV
FROM KHOA K 
JOIN BOMON BM ON BM.MAKHOA=K.MAKHOA
JOIN GIAOVIEN GV ON GV.MABM=BM.MABM
WHERE K.MAKHOA = 'CNTT'
GROUP BY GV.LUONG




