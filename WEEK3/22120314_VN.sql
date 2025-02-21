	-- Q1 Cho biết họ tên và mức lương của các giáo viên nữ
select HoTen,Luong 
from GIAOVIEN
where PHAI = N'Nữ'

-- Q2 Cho biết họ tên của các giáo viên và lương của họ sau khi tăng 10%
select HoTen, Luong *1.1 as N'Lương sau khi tăng 10%'
from GIAOVIEN

--Q3 Cho biết mã của các giáo viên có họ tên bắt đầu là “Nguyễn” và lương trên $2000 hoặc, giáo viên là trưởng bộ môn nhận chức sau năm 1995.
select GV.MAGV 
from GIAOVIEN GV JOIN BOMON BM ON GV.MABM=BM.MABM
where (GV.HOTEN like N'Nguyễn%' and LUONG > 2000 ) or (GV.MAGV = BM.TRUONGBM and YEAR(BM.NGAYNHANCHUC) > 1995 )

--Q4 Cho biết tên những giáo viên khoa Công nghệ thông tin	
select GV.HoTen
from KHOA ,GIAOVIEN GV, BOMON BM
where KHOA.TENKHOA = N'Công Nghệ Thông Tin' and GV.MABM = BM.MABM and BM.MAKHOA = KHOA.MAKHOA

--Q5 Cho biết thông tin của bộ môn cùng thông tin giảng viên làm trưởng bộ môn đó
select*
from BOMON BM, GIAOVIEN GV
where BM.TRUONGBM = GV.MAGV and GV.MABM = BM.MABM

--Q6 Với mỗi giáo viên, hãy cho biết thông tin của bộ môn mà họ đang làm việc
select GV.HOTEN, BM.*
from BOMON BM, GIAOVIEN GV
where GV.MABM = BM.MABM

--Q7 Cho biết tên đề tài và giáo viên chủ nhiệm đề tài
select DT.TENDT, GV.HOTEN
from DETAI DT,  GIAOVIEN GV
where DT.GVCNDT = GV.MAGV

--Q8 Với mỗi khoa cho biết thông tin trưởng khoa
select KHOA.TENKHOA, GV.*
from KHOA,GIAOVIEN GV
where KHOA.TRUONGKHOA = GV.MAGV

--Q9 Cho biết các giáo viên của bộ môn “Vi sinh” có tham gia đề tài 006
select distinct BM.TENBM, DT.MADT, GV.HOTEN
from GIAOVIEN GV, DETAI DT , BOMON BM, THAMGIADT
where BM.TENBM = N'Vi Sinh' and GV.MABM = BM.MABM and DT.MADT = '006' and THAMGIADT.MAGV = GV.MAGV and THAMGIADT.MADT = DT.MADT

--Q10 Với những đề tài thuộc cấp quản lý “Thành phố”, cho biết mã đề tài, đề tài thuộc về chủ đề nào, họ tên người chủ nghiệm đề tài cùng với ngày sinh và địa chỉ của người ấy.
select DT.MADT, DT.MACD, DT.GVCNDT, GV.HOTEN, GV.NGSINH, GV.DIACHI
from DETAI DT, CHUDE CD,GIAOVIEN GV
where DT.CAPQL = N'Thành phố' and  DT.GVCNDT = GV.MAGV and DT.MACD = CD.MACD

--Q11 Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó
select GV.HOTEN  TENGV, NQL.GVQLCM  GVQLCM
from GIAOVIEN  GV, GIAOVIEN  NQL
where GV.GVQLCM = NQL.MAGV

--Q12 Tìm họ tên của những giáo viên được “Nguyễn Thanh Tùng” phụ trách trực tiếp
select GV.HOTEN  HOTEN
from GIAOVIEN  GV, GIAOVIEN  NPT
where GV.GVQLCM = NPT.MAGV and NPT.HOTEN = N'Nguyễn Thanh Tùng'

--Q13 Cho biết tên giáo viên là trưởng bộ môn “Hệ thống thông tin”
select GV.*
from GIAOVIEN GV, BOMON BM
where GV.MAGV = BM.TRUONGBM and BM.TENBM = N'Hệ Thống Thông Tin'

--Q14 Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục
select distinct GV.HOTEN  HoTen
from GIAOVIEN  GV, DETAI  DT
where DT.MACD = 'QLGD' and DT.GVCNDT = GV.MAGV

--Q15 Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu trong tháng 3/2008.
select	CV.TENCV
from DETAI DT, CONGVIEC CV
where month(CV.NGAYBD) >= 3 and year(CV.NGAYBD) >= 2008 and CV.MADT = DT.MADT and DT.TENDT=N'HTTT quản lý các trường ĐH'

--Q16 Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó
select	GV.HOTEN  HoTen, NPTCM.HOTEN  NPTCM
from GIAOVIEN  GV
left join GIAOVIEN NPTCM on  GV.GVQLCM = NPTCM.MAGV

--Q17 Cho các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007
select CV.*
from CONGVIEC  CV
where CV.NGAYBD between '2007-01-01' and '2007-08-01'

--Q18 Cho biết họ tên các giáo viên cùng bộ môn với giáo viên “Trần Trà Hương”
select GV1.HOTEN
from GIAOVIEN GV1	
where GV1.HOTEN != N'Trần Trà Hương'
AND EXISTS (select * from GIAOVIEN GV2 where GV2.HOTEN=N'Trần Trà Hương' AND GV1.MABM = GV2.MABM)

--Q19 Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài
select distinct GV.*
from GIAOVIEN  GV, BOMON  BM, DETAI  DT
where GV.MAGV = BM.TRUONGBM and GV.MAGV = DT.GVCNDT

--Q20 Cho biết tên những giáo viên vừa là trưởng khoa và vừa là trưởng bộ môn
select GV.HOTEN
from GIAOVIEN GV , KHOA, BOMON BM
where GV.MAGV = KHOA.TRUONGKHOA and GV.MAGV = BM.TRUONGBM

--Q21 Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài
select distinct GV.HOTEN
from GIAOVIEN GV, DETAI DT, BOMON BM
where DT.GVCNDT = GV.MAGV and BM.TRUONGBM = GV.MAGV

--Q22. Cho biết mã số các trưởng khoa có chủ nhiệm đề tài.
select distinct GV.MAGV
from GIAOVIEN GV , DETAI DT, KHOA
where GV.MAGV=DT.GVCNDT AND KHOA.TRUONGKHOA=GV.MAGV

--Q23. Cho biết mã số các giáo viên thuộc bộ môn “HTTT” hoặc có tham gia đề tài mã “001”.
select distinct GV.MAGV , GV.HOTEN
from GIAOVIEN GV, THAMGIADT TG
where (GV.MABM = 'HTTT') OR (GV.MAGV = TG.MAGV AND TG.MADT = '001')

--Q24. Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002.
select GV1.* 
from GIAOVIEN GV1 
where GV1.MABM = (select GV2.MABM 
				  from GIAOVIEN GV2 
				  where GV2.MAGV = '002') AND GV1.MAGV != '002'

--Q25. Tìm những giáo viên là trưởng bộ môn.
select GV.*
from GIAOVIEN GV, BOMON BM
where GV.MAGV = BM.TRUONGBM

--Q26. Cho biết họ tên và mức lương của các giáo viên.
select HOTEN, LUONG
from GIAOVIEN