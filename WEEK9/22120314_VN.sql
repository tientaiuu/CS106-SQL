use QuanLyDETAI

-- T1: Tên đề tài phải duy nhất
CREATE TRIGGER trg_unique_tendetai
ON DETAI
FOR INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT *
    FROM DETAI DT
    JOIN INSERTED I ON DT.TENDT = I.TENDT
    WHERE DT.MADT <> I.MADT
  )
  BEGIN
    RAISERROR (N'Lỗi: Tên đề tài phải duy nhất', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T2: Trưởng bộ môn phải sinh sau trước 1975
CREATE TRIGGER trg_truongbomon_sinh_sau_1975
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT 1
    FROM BOMON BM
    JOIN GIAOVIEN GV ON BM.TRUONGBM = GV.MAGV
    WHERE YEAR(GV.NGSINH) >= 1975
  )
  BEGIN
    RAISERROR (N'Lỗi: Trưởng bộ môn phải sinh trước 1975', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T3: Một bộ môn có tối thiểu 1 giáo viên nữ
CREATE TRIGGER trg_bomon_toithieu_1gvnu
ON GIAOVIEN
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  IF NOT EXISTS (
    SELECT *
    FROM GIAOVIEN G
    WHERE G.MABM IN (SELECT MABM 
					 FROM INSERTED 
					 UNION 
					 SELECT MABM 
					 FROM DELETED)
      AND G.PHAI = 'Nữ'
  )
  BEGIN
    RAISERROR (N'Lỗi: Một bộ môn phải có tối thiểu 1 giáo viên nữ', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T4: Một giáo viên phải có ít nhất 1 số điện thoại
CREATE TRIGGER trg_gv_toithieu_1sdt
ON GV_DT
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  IF EXISTS (
    SELECT MAGV
    FROM GIAOVIEN G
    WHERE NOT EXISTS (
      SELECT 1
      FROM GV_DT D
      WHERE G.MAGV = D.MAGV
    )
  )
  BEGIN
    RAISERROR (N'Lỗi: Một giáo viên phải có ít nhất 1 số điện thoại', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T5: Một giáo viên có tối đa 3 số điện thoại
CREATE TRIGGER trg_gv_toida_3sdt
ON GV_DT
FOR INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT MAGV
    FROM GV_DT
    GROUP BY MAGV
    HAVING COUNT(*) > 3
  )
  BEGIN
    RAISERROR (N'Lỗi: Một giáo viên có tối đa 3 số điện thoại', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T6: Một bộ môn phải có tối thiểu 4 giáo viên
CREATE TRIGGER trg_bomon_toithieu_4gv
ON GIAOVIEN
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  IF EXISTS (
    SELECT MABM
    FROM GIAOVIEN
    GROUP BY MABM
    HAVING COUNT(MAGV) < 4
  )
  BEGIN
    RAISERROR (N'Lỗi: Một bộ môn phải có tối thiểu 4 giáo viên', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T7: Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn
CREATE TRIGGER trg_trgbomon_lon_tuoi_nhat
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT *
    FROM BOMON B
    JOIN GIAOVIEN G ON B.TRUONGBM = G.MAGV
    WHERE G.NGSINH > (
      SELECT MIN(NGSINH)
      FROM GIAOVIEN
      WHERE MABM = B.MABM
    )
  )
  BEGIN
    RAISERROR (N'Lỗi: Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T8: Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên môn
CREATE TRIGGER trg_khong_lam_2_vai_tro
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT *
    FROM GIAOVIEN G
    JOIN BOMON B ON G.MAGV = B.TRUONGBM
    WHERE G.GVQLCM IS NOT NULL
  )
  BEGIN
    RAISERROR (N'Lỗi: Giáo viên đã là trưởng bộ môn thì không thể làm người quản lý chuyên môn', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T9: Giáo viên và giáo viên quản lý chuyên môn của giáo viên đó phải thuộc về 1 bộ môn.
CREATE TRIGGER trg_cung_bomon
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT *
    FROM GIAOVIEN G1
    JOIN GIAOVIEN G2 ON G1.GVQLCM = G2.MAGV
    WHERE G1.MABM <> G2.MABM
  )
  BEGIN
    RAISERROR (N'Lỗi: Giáo viên và giáo viên quản lý chuyên môn phải thuộc cùng một bộ môn', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T10: Mỗi giáo viên chỉ có tối đa 1 vợ chồng
CREATE TRIGGER trg_1_vochong
ON NGUOITHAN
FOR INSERT, UPDATE
AS
BEGIN
  IF EXISTS (
    SELECT MAGV
    FROM NGUOITHAN
    GROUP BY MAGV
    HAVING COUNT(*) > 1
  )
  BEGIN
    RAISERROR (N'Lỗi: Mỗi giáo viên chỉ có tối đa 1 vợ/chồng', 16, 1);
    ROLLBACK TRANSACTION;
  END
END;

-- T11.Giáo viên là Nam thì chỉ có vợ là Nữ hoặc ngược lại.
CREATE TRIGGER trg_T11_CheckSpouseGender
ON NGUOITHAN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        JOIN GIAOVIEN G ON I.MAGV = G.MAGV
        WHERE (G.PHAI = 'Nam'  AND I.PHAI <> 'Nữ')
           OR (G.PHAI = 'Nữ' AND I.PHAI <> 'Nam')
    )
    BEGIN
        RAISERROR (N'Lỗi: Vợ/chồng trùng giới tính với giáo viên', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
-- T12.Nếu thân nhân có quan hệ là “con gái” hoặc “con trai” với giáo viên thì năm sinh của giáo viên phải nhỏ hơn năm sinh của thân nhân.
CREATE TRIGGER trg_T12_CheckChildBirthYear
ON NGUOITHAN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN GIAOVIEN G ON I.MAGV = G.MAGV
        WHERE ( YEAR(G.NGSINH) >= YEAR(I.NGSINH))
    )
    BEGIN
        RAISERROR (N'Lỗi: Năm sinh của giáo viên phải nhỏ hơn năm sinh của con gái/con trai.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- T13.Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài.
CREATE TRIGGER trg_T13_MaxTopics
ON DETAI
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT GVCNDT
        FROM (
            SELECT GVCNDT
            FROM DETAI
            UNION ALL
            SELECT GVCNDT
            FROM INSERTED
        ) AS Combined
        GROUP BY GVCNDT
        HAVING COUNT(GVCNDT) > 3
    )
    BEGIN
        RAISERROR ('Lỗi: Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
-- T14.Một đề tài phải có ít nhất một công việc
CREATE TRIGGER trg_T14_CheckTasks
ON DETAI
FOR DELETE
AS
BEGIN
    IF EXISTS (
        SELECT *	
        FROM DELETED D
        LEFT JOIN CONGVIEC C ON D.MADT = C.MADT
        WHERE C.MADT IS NULL
    )
    BEGIN
        RAISERROR ('Lỗi: Một đề tài phải có ít nhất một công việc.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
-- T15.Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó.
CREATE TRIGGER trg_T15_CheckSalary
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM INSERTED I
        JOIN GIAOVIEN G ON I.GVQLCM = G.MAGV
        WHERE I.LUONG >= G.LUONG
    )
    BEGIN
        RAISERROR ('Lỗi: Lương của giáo viên phải nhỏ hơn lương người quản lý.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- T16.Lương của trưởng bộ môn phải lớn hơn lương của các giáo viên trong bộ môn.
CREATE TRIGGER trg_T16_CheckHeadSalary
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM BOMON B
        JOIN GIAOVIEN G ON B.MABM = G.MABM
        WHERE G.LUONG >= (SELECT MAX(GV.LUONG)
                           FROM GIAOVIEN GV
                           WHERE GV.MAGV = B.TRUONGBM)
    )
    BEGIN
        RAISERROR ('Lỗi: Lương của trưởng bộ môn phải lớn hơn lương của các giáo viên trong bộ môn.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- T17.Bộ môn ban nào cũng phải có trưởng bộ môn và trưởng bộ môn phải là một giáo viên trong trường.
CREATE TRIGGER trg_T17
ON BOMON
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM BOMON B
        LEFT JOIN GIAOVIEN G ON B.TRUONGBM = G.MAGV
        WHERE B.TRUONGBM IS NULL OR G.MAGV IS NULL
    )
    BEGIN
        RAISERROR ('Lỗi: Bộ môn phải có trưởng bộ môn và trưởng bộ môn phải là giáo viên trong trường.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- T18.Một giáo viên chỉ quản lý tối đa 3 giáo viên khác.
CREATE TRIGGER trg_T18_QuanLyToiDa
ON GIAOVIEN
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM GIAOVIEN G
        GROUP BY G.GVQLCM
        HAVING COUNT(*) > 3
    )
    BEGIN
        RAISERROR ('Lỗi: Một giáo viên chỉ quản lý tối đa 3 giáo viên khác.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- T19.Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó.
CREATE TRIGGER trg_T19_SameDepartment
ON THAMGIADT
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED I
        JOIN DETAI D ON I.MADT = D.MADT
        JOIN GIAOVIEN G ON I.MAGV = G.MAGV
        JOIN GIAOVIEN GCN ON D.GVCNDT = GCN.MAGV
        WHERE G.MABM <> GCN.MABM
    )
    BEGIN
        RAISERROR (N'Lỗi: Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với giáo viên đó.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
