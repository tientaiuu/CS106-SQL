﻿use QuanLyDETAI;

-- 1 Xuất mã và họ tên giáo viên có tham gia đề tài do trưởng bộ môn của họ là chủ nhiệm
SELECT DISTINCT GV.MAGV, GV.HOTEN 
FROM GIAOVIEN GV 
JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV 
WHERE TG.MADT IN ( SELECT DT.MADT FROM DETAI DT 
				   JOIN BOMON BM ON GV.MABM = BM.MABM AND DT.GVCNDT = BM.TRUONGBM
				   WHERE GV.MAGV != BM.TRUONGBM )

-- 2 Xuất mã, họ tên, và tuổi của các giáo viên đã từng tham gia công việc “thiết kế” hoặc
--   đã từng chủ nhiệm đề tài có công việc liên quan đến “xác định yêu cầu”.
SELECT DISTINCT GV.MAGV, GV.HOTEN, DATEDIFF(YEAR, GV.NGSINH, GETDATE()) AS TUOI
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV=GV.MAGV
JOIN CONGVIEC CV ON TG.MADT= CV.MADT AND TG.STT=CV.STT
WHERE CV.TENCV LIKE N'Thiết kế%'
UNION 
SELECT DISTINCT GV.MAGV, GV.HOTEN, DATEDIFF(YEAR, GV.NGSINH, GETDATE()) AS TUOI
FROM GIAOVIEN GV
JOIN DETAI DT  ON DT.GVCNDT=GV.MAGV
JOIN CONGVIEC CV ON DT.MADT= CV.MADT
WHERE CV.TENCV LIKE N'Xác định yêu cầu'

-- 3 Xuất mã và họ tên các trưởng khoa có tham gia đề tài thuộc chủ đề “nghiên cứu” nhưng
--	 chưa từng tham gia đề tài nào thuộc chủ đề “ứng dụng”.
SELECT DISTINCT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV 
JOIN KHOA K ON GV.MAGV = K.TRUONGKHOA
JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
JOIN DETAI DT ON DT.MADT = TG.MADT
WHERE DT.MACD = 'NCPT' 
AND GV.MAGV NOT IN (
    SELECT GV.MAGV
    FROM GIAOVIEN GV 
    JOIN KHOA K ON GV.MAGV = K.TRUONGKHOA
	JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
    JOIN DETAI DT ON DT.MADT = TG.MADT
    WHERE DT.MACD = N'ƯDCN' 
)	

--4 Xuất mã, tên chủ đề, cấp quản lý (capql) và số lượng đề tài có kinh phí từ 100 triệu trở
-- lên theo từng cấp quản lý của mỗi chủ đề
SELECT CD.MACD, CD.TENCD, DT.CAPQL, COUNT(*) AS SoLuongDeTai
FROM DETAI DT
JOIN CHUDE CD ON DT.MACD = CD.MACD
WHERE DT.KINHPHI >= 100.0  
GROUP BY CD.MACD, CD.TENCD, DT.CAPQL

--5 Xuất mã, họ tên giáo viên, họ tên quản lý chuyên môn của giáo viên (nếu không có
-- quản lý để ký hiệu “-”) của các giáo viên có tham gia đề tài được chủ nhiệm bởi giáo
-- viên khác bộ môn

SELECT GV.MAGV, GV.HOTEN, COALESCE(GVQLCM.HOTEN, '-') AS GVQLCM
FROM GIAOVIEN GV
LEFT JOIN GIAOVIEN GVQLCM ON GV.GVQLCM = GVQLCM.MAGV
WHERE GV.MAGV IN (
    SELECT DISTINCT GV.MAGV
    FROM GIAOVIEN GV
	JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
    JOIN DETAI DT ON TG.MADT = DT.MADT
	JOIN GIAOVIEN GVCNDT ON GVCNDT.MAGV = DT.GVCNDT
    WHERE GVCNDT.MABM != GV.MABM
)

--6 Xuất mã, họ tên giáo viên và tổng số lượng giáo viên mà họ quản lý chuyên môn (nếu
-- không quản lý ai, giá trị xuất ra là 0)
SELECT GVQLCM.MAGV, GVQLCM.HOTEN, COALESCE(COUNT(GV.MAGV), 0) AS TongSoLuongQuanLy
FROM GIAOVIEN GVQLCM
LEFT JOIN GIAOVIEN GV ON GVQLCM.MAGV = GV.GVQLCM
GROUP BY GVQLCM.MAGV, GVQLCM.HOTEN

--7 Xuất mã, họ tên giáo viên, tên khoa mà giáo viên thuộc về của các giáo viên từng chủ
-- nhiệm trên 2 đề tài có kinh phí >= 100 triệu

SELECT GV.MAGV, GV.HOTEN, K.TENKHOA
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
JOIN DETAI D ON D.MADT = TG.MADT AND GV.MAGV = D.GVCNDT
JOIN BOMON B ON B.MABM = GV.MABM
JOIN KHOA K ON K.MAKHOA = B.MAKHOA
WHERE D.KINHPHI >= 100.0 
GROUP BY GV.MAGV, GV.HOTEN, K.TENKHOA
HAVING COUNT(D.MADT) >= 2;

-- 8 Xuất mã, tên đề tài, tên và STT công việc có đông giáo viên tham gia nhất.

SELECT DT.MADT, DT.TENDT, CV.TENCV, CV.STT 
FROM DETAI DT
JOIN CONGVIEC CV ON DT.MADT = CV.MADT 
JOIN THAMGIADT TG ON TG.MADT = DT.MADT AND TG.STT = CV.STT
GROUP BY DT.MADT, DT.TENDT, CV.TENCV, CV.STT 
HAVING COUNT(DISTINCT TG.MAGV) >= ALL(
							SELECT COUNT(TG.MAGV)
							FROM THAMGIADT TG 
							JOIN CONGVIEC CV ON CV.MADT=TG.MADT AND CV.STT=TG.STT
							GROUP BY CV.MADT, CV.STT)

-- 9 Xuất mã và họ tên giáo viên có lương lớn nhất ở từng khoa theo các yêu cầu sau:
-- Cách 1: Có dùng lượng từ ALL hoặc hàm kết hợp MAX.

SELECT GV.MAGV, GV.HOTEN, BM.MAKHOA 
FROM GIAOVIEN GV 
JOIN BOMON BM ON GV.MABM = BM.MABM 
WHERE GV.LUONG = (SELECT MAX(GV2.LUONG) 
                  FROM GIAOVIEN GV2 JOIN BOMON BM2 ON GV2.MABM = BM2.MABM
                  WHERE BM2.MAKHOA = BM.MAKHOA)

-- Cách 2:	Không dùng bất cứ lượng từ hay hàm kết hợp nào

SELECT GV.MAGV, GV.HOTEN, BM.MAKHOA 
FROM GIAOVIEN GV 
JOIN BOMON BM ON GV.MABM = BM.MABM 
WHERE NOT EXISTS (SELECT *
                  FROM GIAOVIEN GV2 JOIN BOMON BM2 ON GV2.MABM = BM2.MABM
                  WHERE BM2.MAKHOA = BM.MAKHOA AND GV2.LUONG > GV.LUONG) 

-- 10 Xuất mã và tên khoa có đông giáo viên từng chủ nhiệm đề tài nhất.


SELECT TOP 1 K.MAKHOA, K.TENKHOA 
FROM KHOA K
JOIN BOMON BM ON BM.MAKHOA = K.MAKHOA
JOIN GIAOVIEN GV ON GV.MABM = BM.MABM 
JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
GROUP BY K.MAKHOA, K.TENKHOA
ORDER BY COUNT(*) DESC

SELECT K.MAKHOA, K.TENKHOA 
FROM KHOA K
JOIN BOMON BM ON BM.MAKHOA = K.MAKHOA
JOIN GIAOVIEN GV ON GV.MABM = BM.MABM 
JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
GROUP BY K.MAKHOA, K.TENKHOA
HAVING COUNT(DT.GVCNDT) = ( SELECT MAX(SLGV)
						  FROM (
						  SELECT COUNT(DT.GVCNDT) AS SLGV
						  FROM KHOA K
						  JOIN BOMON BM ON BM.MAKHOA = K.MAKHOA
						  JOIN GIAOVIEN GV ON GV.MABM = BM.MABM 
						  JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
						  GROUP BY K.MAKHOA, K.TENKHOA
						  ) AS MAXSLGV)

-- 11 Xuất mã và tên bộ môn có nhiều giáo viên có quản lý chuyên môn nhất

SELECT TOP 1 BM.MABM, BM.TENBM
FROM BOMON BM
JOIN GIAOVIEN GVQLCM ON BM.MABM = GVQLCM.MABM
JOIN GIAOVIEN GV ON GVQLCM.MAGV = GV.GVQLCM
GROUP BY BM.MABM, BM.TENBM
ORDER BY COUNT(*) DESC;

SELECT BM.MABM, BM.TENBM
FROM BOMON BM
JOIN GIAOVIEN GVQLCM ON BM.MABM = GVQLCM.MABM
JOIN GIAOVIEN GV ON GVQLCM.MAGV = GV.GVQLCM
GROUP BY BM.MABM, BM.TENBM
HAVING COUNT(GV.MAGV) = ( SELECT MAX(SLGV)
						  FROM (
						  SELECT COUNT(GV.MAGV) AS SLGV
						  FROM BOMON BM
						  JOIN GIAOVIEN GVQLCM ON BM.MABM = GVQLCM.MABM
						  JOIN GIAOVIEN GV ON GVQLCM.MAGV = GV.GVQLCM
						  GROUP BY BM.MABM, BM.TENBM
						  ) AS MAXSLGV)

-- 12 Xuất mã, họ tên giáo viên và tổng tiền phụ cấp mà giáo viên nhận được theo từng năm. 
-- Biết rằng tiền phụ cấp được tính từ hệ số phụ cấp cho các công việc mà giáo viên tham gia trong năm đó 
-- (có ngày kết thúc trong năm đang xét) với các quy định như sau: 
-- • Kết quả “Đạt”, Phụ cấp = Hệ số * Lương tháng. 
-- • Còn lại, Phụ cấp = Hệ số * (1/2 Lương tháng).

SELECT 
    GV.MAGV, 
    GV.HOTEN, CV.NGAYBD, CV.NGAYKT,
    SUM(
        CASE 
            WHEN TG.KETQUA = N'Đạt' THEN TG.PHUCAP * GV.LUONG
            ELSE TG.PHUCAP * (GV.LUONG / 2)
        END
    ) AS TONGPHUCAP
FROM GIAOVIEN GV
JOIN  THAMGIADT TG ON TG.MAGV = GV.MAGV
JOIN  CONGVIEC CV ON CV.MADT = TG.MADT AND CV.STT = TG.STT
WHERE YEAR(CV.NGAYKT) = YEAR(CV.NGAYBD)
GROUP BY GV.MAGV, GV.HOTEN, CV.NGAYBD, CV.NGAYKT
ORDER BY MAGV

-- 13 Xuất mã và họ tên giáo viên thuộc khoa “Công nghệ thông tin” có tham gia tất cả đề tài thuộc cấp ĐHQG.
SELECT GV.MAGV, GV.HOTEN 
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MABM = BM.MABM
JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
WHERE K.TENKHOA = N'Công nghệ thông tin'
INTERSECT
SELECT DISTINCT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
JOIN DETAI DT ON TG.MADT = DT.MADT
WHERE DT.CAPQL = N'ĐHQG'
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT( DT.MADT) = ( SELECT COUNT(DT.MADT)
						   FROM DETAI DT
						   WHERE DT.CAPQL = N'ĐHQG')

SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MABM = BM.MABM
JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
WHERE K.TENKHOA = N'Công nghệ thông tin'
AND NOT EXISTS (
    SELECT DISTINCT DT.MADT
    FROM DETAI DT
    WHERE DT.CAPQL = N'ĐHQG'
    EXCEPT
    SELECT TG.MADT
    FROM THAMGIADT TG
    WHERE TG.MAGV = GV.MAGV
)

-- 14 Xuất mã, họ tên giáo viên thuộc bộ môn “Mạng máy tính” tham gia tất cả công việc
-- liên quan đến đề tài thuộc chủ đề “ứng dụng”.

SELECT GV.MAGV, GV.HOTEN 
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE BM.TENBM = N'Mạng máy tính'
INTERSECT
SELECT GV.MAGV, GV.HOTEN 
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
JOIN CONGVIEC CV ON CV.MADT = TG.MADT AND CV.STT = TG.STT
JOIN DETAI DT ON DT.MADT = CV.MADT
JOIN CHUDE CD ON CD.MACD = DT.MACD
WHERE CD.MACD = N'ƯDCN'
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT CV.TENCV) = ( SELECT COUNT(DISTINCT CV.TENCV)
									FROM THAMGIADT TG 
									JOIN CONGVIEC CV ON CV.MADT = TG.MADT AND CV.STT = TG.STT
									JOIN DETAI DT ON DT.MADT=CV.MADT
									JOIN CHUDE CD ON CD.MACD=DT.MACD
									WHERE CD.MACD = N'ƯDCN')

-- 15 Xuất mã, họ tên trưởng khoa có các đề tài từng chủ nhiệm bao phủ tất cả các chủ đề.

SELECT TRGKHOA.MAGV, TRGKHOA.HOTEN, K.TENKHOA
FROM GIAOVIEN TRGKHOA 
JOIN KHOA K ON K.TRUONGKHOA = TRGKHOA.MAGV
JOIN DETAI DT ON DT.GVCNDT = TRGKHOA.MAGV
JOIN CHUDE CD ON CD.MACD = DT.MACD
GROUP BY TRGKHOA.MAGV, TRGKHOA.HOTEN, K.TENKHOA
HAVING COUNT(DISTINCT CD.MACD) = ( SELECT COUNT(DISTINCT CD.MACD) 
								   FROM CHUDE CD)

-- 16 Xuất mã, họ tên trưởng bộ môn có các đề tài từng tham gia liên quan đến tất cả các cấp

SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
JOIN DETAI DT ON DT.MADT = TG.MADT
GROUP BY GV.MAGV, GV.HOTEN 
HAVING COUNT(DISTINCT DT.CAPQL) = (SELECT COUNT(DT.CAPQL) 
                                   FROM DETAI DT )

-- 17 Xuất mã, tên chủ đề có đề tài có tất cả giáo viên có mã tận cùng là số chẵn tham gia

SELECT CD.MACD, CD.TENCD
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
JOIN DETAI DT ON DT.MADT = TG.MADT
JOIN CHUDE CD ON CD.MACD = DT.MACD
GROUP BY CD.MACD, CD.TENCD
HAVING COUNT(DISTINCT TG.MAGV) = (
    SELECT COUNT(*)
    FROM GIAOVIEN GV
    WHERE SUBSTRING(GV.MAGV, 3, 1) IN ('0','2','4','6','8'))

-- 18 Xuất mã, tên đề tài, tên công việc có tất cả giáo viên có lương 2000-3000 tham gia

SELECT DT.MADT, DT.TENDT, CV.TENCV 
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
JOIN DETAI DT ON DT.MADT = TG.MADT
JOIN CONGVIEC CV ON CV.MADT = DT.MADT	
WHERE GV.LUONG BETWEEN 2000 AND 3000
GROUP BY DT.MADT, DT.TENDT, CV.TENCV 
HAVING COUNT(DISTINCT GV.MAGV) = ( SELECT COUNT(DISTINCT GV.MAGV) 
									FROM GIAOVIEN GV
									WHERE GV.LUONG BETWEEN 2000 AND 3000)