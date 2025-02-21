USE QuanLyDETAI

-- Q35 Cho biết mức lương cao nhất của các giảng viên

SELECT MAX(GV.LUONG) AS LUONGCAONHAT
FROM GIAOVIEN GV

-- Q36 Cho biết những giáo viên có lương lớn nhất.

SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV
WHERE GV.LUONG >= ALL(SELECT LUONG FROM GIAOVIEN)

-- Q37 Cho biết lương cao nhất trong bộ môn “HTTT”.

SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE GV.LUONG >= ALL(SELECT LUONG FROM GIAOVIEN  ) AND BM.MABM = 'HTTT'

-- Q38 Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin.

SELECT GV.HOTEN, DATEDIFF(YEAR,GV.NGSINH,GETDATE()) AS TUOI
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MABM = BM.MABM
WHERE YEAR(GV.NGSINH) = (SELECT MIN(YEAR(NGSINH)) 
						 FROM GIAOVIEN JOIN BOMON ON GIAOVIEN.MABM = BOMON.MABM 
						 WHERE BOMON.MABM = 'HTTT' ) AND BM.MABM = 'HTTT'

-- Q39 Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin
SELECT GV.HOTEN, DATEDIFF(YEAR,GV.NGSINH,GETDATE()) AS TUOI
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MABM = BM.MABM
JOIN KHOA K ON K.MAKHOA = BM.MAKHOA	
WHERE YEAR(GV.NGSINH) = (SELECT MAX(YEAR(NGSINH)) 
						 FROM GIAOVIEN 
						 JOIN BOMON ON GIAOVIEN.MABM = BOMON.MABM 
						 JOIN KHOA K ON K.MAKHOA = BOMON.MAKHOA
						 WHERE K.TENKHOA = N'Công nghệ thông tin' ) AND K.TENKHOA = N'Công nghệ thông tin'


-- Q40 Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất

SELECT GV.HOTEN, K.TENKHOA, GV.LUONG
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.MABM = GV.MABM
JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
WHERE GV.LUONG >= ALL(SELECT LUONG FROM GIAOVIEN )

-- Q41 Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ.

SELECT GV.HOTEN, GV.MABM, GV.LUONG
FROM GIAOVIEN GV
WHERE GV.LUONG >= ALL (SELECT LUONG
						 FROM GIAOVIEN
						 WHERE GIAOVIEN.MABM = GV.MABM)

-- Q42 Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia

SELECT DT.TENDT 
FROM DETAI DT
WHERE DT.MADT NOT IN ( SELECT TG1.MADT
					   FROM THAMGIADT TG1
					   JOIN GIAOVIEN GV1 ON GV1.MAGV = TG1.MAGV
					   WHERE GV1.HOTEN =  N'Nguyễn Hoài An')

-- Q43 Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài, tên người chủ nhiệm đề tài.

SELECT DT.TENDT, GV.HOTEN AS GVCNDT
FROM DETAI DT
JOIN GIAOVIEN GV ON DT.GVCNDT = GV.MAGV
WHERE DT.MADT NOT IN ( SELECT TG1.MADT
					   FROM THAMGIADT TG1
					   JOIN GIAOVIEN GV1 ON GV1.MAGV = TG1.MAGV
					   WHERE GV1.HOTEN =  N'Nguyễn Hoài An')

-- Q44 Cho biết tên những giáo viên khoa Công nghệ thông tin mà chưa tham gia đề tài nào.

SELECT GV.HOTEN
FROM GIAOVIEN GV
JOIN BOMON BM ON GV.MABM = BM.MABM
JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
WHERE GV.MAGV NOT IN ( SELECT MAGV FROM THAMGIADT) AND K.TENKHOA = N'Công nghệ thông tin'

-- Q45 Tìm những giáo viên không tham gia bất kỳ đề tài nào

SELECT GV.HOTEN, GV.MAGV
FROM GIAOVIEN GV
WHERE GV.MAGV NOT IN ( SELECT MAGV FROM THAMGIADT)

-- Q46 Cho biết giáo viên có lương lớn hơn lương của giáo viên “Nguyễn Hoài An”

SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV
WHERE GV.LUONG > (SELECT LUONG FROM GIAOVIEN WHERE GIAOVIEN.HOTEN = N'Nguyễn Hoài An') 

-- Q47 Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài

SELECT GV.HOTEN
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
WHERE GV.MAGV IN  (SELECT MAGV FROM THAMGIADT)

-- Q48 Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn

SELECT *
FROM GIAOVIEN GV1
WHERE EXISTS (SELECT * 
			  FROM GIAOVIEN GV2 
			  WHERE GV1.HOTEN LIKE GV2.HOTEN
			  AND GV1.PHAI = GV2.PHAI
			  AND GV1.MABM = GV2.MABM
			  AND GV1.MAGV <> GV2.MAGV)

-- Q49 Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn “Công nghệ phần mềm”

SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV
WHERE GV.LUONG > ANY (SELECT LUONG FROM GIAOVIEN
					  JOIN BOMON BM ON BM.MABM = GIAOVIEN.MABM
					  WHERE BM.TENBM = N'Công nghệ phần mềm' ) 

-- Q50 Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn “Hệ thống thông tin”

SELECT GV.HOTEN, GV.LUONG
FROM GIAOVIEN GV
WHERE GV.LUONG > ALL (SELECT LUONG FROM GIAOVIEN
					  JOIN BOMON BM ON BM.MABM = GIAOVIEN.MABM
					  WHERE BM.MABM = 'HTTT' ) 

-- Q51 Cho biết tên khoa có đông giáo viên nhất

SELECT K.TENKHOA, COUNT(*) AS SLGV
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.MABM = GV.MABM
JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
GROUP BY K.TENKHOA, K.MAKHOA
HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
						 FROM GIAOVIEN GV
						 JOIN BOMON BM ON BM.MABM = GV.MABM
						 JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
						 GROUP BY K.MAKHOA)

-- Q52 Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất

SELECT GV.HOTEN, COUNT(*) AS SLDT
FROM GIAOVIEN GV
JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
GROUP BY GV.HOTEN 
HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
						 FROM GIAOVIEN GV
						 JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
						 GROUP BY DT.GVCNDT )

-- Q53 Cho biết mã bộ môn có nhiều giáo viên nhất

SELECT BM.MABM, BM.TENBM , COUNT(*) AS SLGV
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.MABM = GV.MABM
GROUP BY BM.MABM, BM.TENBM 
HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
						 FROM GIAOVIEN GV
						 JOIN BOMON BM ON BM.MABM = GV.MABM
						 GROUP BY BM.MABM )

-- Q54 Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất

SELECT GV.HOTEN, BM.TENBM 
FROM GIAOVIEN GV	
JOIN BOMON BM ON BM.MABM = GV.MABM
WHERE GV.MAGV IN ( SELECT TG.MAGV
				   FROM THAMGIADT TG
				   GROUP BY TG.MAGV
				   HAVING COUNT(TG.MAGV) >= ALL (SELECT COUNT(MAGV) FROM THAMGIADT GROUP BY MAGV)) 

-- Q55 Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT

SELECT GV.HOTEN, COUNT( TG.MAGV ) AS SLDT
FROM GIAOVIEN GV
JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
WHERE GV.MABM = 'HTTT'
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT( TG.MAGV ) >= ALL(SELECT TG.MAGV
							   FROM THAMGIADT TG
							   GROUP BY TG.MAGV
							   HAVING COUNT(TG.MAGV) >= ALL (SELECT COUNT(MAGV) FROM THAMGIADT GROUP BY MAGV))

-- Q56 Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất.

SELECT GV.HOTEN
FROM GIAOVIEN GV
WHERE GV.MAGV IN (SELECT MAGV
			   FROM NGUOITHAN
			   GROUP BY MAGV
			   HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM NGUOITHAN GROUP BY MAGV))

-- Q57 Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất.

SELECT GV.HOTEN
FROM GIAOVIEN GV
JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
WHERE GV.MAGV IN (SELECT DT.GVCNDT
				  FROM DETAI DT
				  GROUP BY DT.GVCNDT
				  HAVING COUNT(*) >= ALL (SELECT COUNT(*) FROM DETAI GROUP BY GVCNDT))