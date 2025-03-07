USE [QLLopHoc]
GO
/****** Object:  Table [dbo].[GIAOVIEN]    Script Date: 3/11/2024 4:28:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIAOVIEN](
	[magv] [char](10) NOT NULL,
	[hoten] [nvarchar](50) NOT NULL,
	[gioitinh] [nvarchar](3) NOT NULL,
	[ngaysinh] [date] NOT NULL,
	[diachi] [nvarchar](100) NULL,
 CONSTRAINT [PK_GIAOVIEN] PRIMARY KEY CLUSTERED 
(
	[magv] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOCSINH]    Script Date: 3/11/2024 4:28:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOCSINH](
	[mahs] [char](10) NOT NULL,
	[hoten] [nvarchar](50) NOT NULL,
	[gioitinh] [nvarchar](3) NOT NULL,
	[ngaysinh] [date] NOT NULL,
	[diachi] [nvarchar](100) NULL,
	[malop] [char](10) NOT NULL,
 CONSTRAINT [PK_HOCSINH] PRIMARY KEY CLUSTERED 
(
	[mahs] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOPHOC]    Script Date: 3/11/2024 4:28:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOPHOC](
	[malop] [char](10) NOT NULL,
	[tenlop] [nvarchar](100) NOT NULL,
	[nam] [int] NOT NULL,
	[gvcn] [char](10) NOT NULL,
	[loptruong] [char](10) NOT NULL,
 CONSTRAINT [PK_LOPHOC] PRIMARY KEY CLUSTERED 
(
	[malop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV1       ', N'GVA', N'Nam', CAST(N'1993-12-01' AS Date), N'Q4')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV2       ', N'GVB', N'Nu', CAST(N'1985-02-22' AS Date), N'Q5')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV3       ', N'GVC', N'Nam', CAST(N'1994-05-16' AS Date), N'Q6')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV4       ', N'GVD', N'Nam', CAST(N'1985-08-18' AS Date), N'Q7')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV5       ', N'GVE', N'Nu', CAST(N'1979-09-09' AS Date), N'Q8')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV6       ', N'GVF', N'NAM', CAST(N'1998-12-18' AS Date), N'Q9')
GO
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS1       ', N'HSA', N'Nam', CAST(N'2004-01-21' AS Date), N'KTX A', N'1         ')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS2       ', N'HSB', N'Nu', CAST(N'2004-02-22' AS Date), N'KTX B', N'2         ')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS3       ', N'HSC', N'Nam', CAST(N'2003-02-26' AS Date), N'Q9', N'3         ')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS4       ', N'HSD', N'Nam', CAST(N'2004-03-13' AS Date), N'THU DUC', N'4         ')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS5       ', N'HSE', N'Nu', CAST(N'2003-05-08' AS Date), N'KTX A', N'5         ')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS6       ', N'HSF', N'NU', CAST(N'2003-12-13' AS Date), N'KTX B', N'6         ')
GO
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [loptruong]) VALUES (N'1         ', N'NHAP MON LAP TRINH', 2022, N'GV1       ', N'HS1       ')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [loptruong]) VALUES (N'2         ', N'KY THUAT LAP TRINH', 2023, N'GV2       ', N'HS2       ')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [loptruong]) VALUES (N'3         ', N'MANG MAY TINH', 2023, N'GV3       ', N'HS3       ')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [loptruong]) VALUES (N'4         ', N'CAU TRUC DU LIEU VA GIAI THUAT', 2023, N'GV4       ', N'HS4       ')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [loptruong]) VALUES (N'5         ', N'LAP TRINH HUONG DOI TUONG', 2024, N'GV5       ', N'HS5       ')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [loptruong]) VALUES (N'6         ', N'CO SO DU LIEU', 2024, N'GV6       ', N'HS6       ')
GO
ALTER TABLE [dbo].[HOCSINH]  WITH CHECK ADD  CONSTRAINT [FK_HOCSINH_LOPHOC] FOREIGN KEY([malop])
REFERENCES [dbo].[LOPHOC] ([malop])
GO
ALTER TABLE [dbo].[HOCSINH] CHECK CONSTRAINT [FK_HOCSINH_LOPHOC]
GO
ALTER TABLE [dbo].[LOPHOC]  WITH CHECK ADD  CONSTRAINT [FK_LOPHOC_GIAOVIEN] FOREIGN KEY([gvcn])
REFERENCES [dbo].[GIAOVIEN] ([magv])
GO
ALTER TABLE [dbo].[LOPHOC] CHECK CONSTRAINT [FK_LOPHOC_GIAOVIEN]
GO
ALTER TABLE [dbo].[LOPHOC]  WITH CHECK ADD  CONSTRAINT [FK_LOPHOC_HOCSINH] FOREIGN KEY([loptruong])
REFERENCES [dbo].[HOCSINH] ([mahs])
GO
ALTER TABLE [dbo].[LOPHOC] CHECK CONSTRAINT [FK_LOPHOC_HOCSINH]
GO
