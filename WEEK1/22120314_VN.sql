USE [QLBanHang]
GO
/****** Object:  Table [dbo].[CT_HOA_DON]    Script Date: 3/16/2024 4:09:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_HOA_DON](
	[mahd] [char](10) NOT NULL,
	[masp] [nchar](10) NOT NULL,
	[soluong] [int] NOT NULL,
	[dongia] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CT_HOA_DON] PRIMARY KEY CLUSTERED 
(
	[mahd] ASC,
	[masp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOA_DON]    Script Date: 3/16/2024 4:09:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOA_DON](
	[mahd] [char](10) NOT NULL,
	[ngaylap] [date] NOT NULL,
	[makh] [char](10) NOT NULL,
 CONSTRAINT [PK_HOA_DON] PRIMARY KEY CLUSTERED 
(
	[mahd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHACH_HANG]    Script Date: 3/16/2024 4:09:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHACH_HANG](
	[makh] [char](10) NOT NULL,
	[hoten] [nvarchar](50) NOT NULL,
	[gioitinh] [nchar](10) NOT NULL,
	[dthoai] [char](10) NULL,
	[diachi] [nvarchar](50) NULL,
 CONSTRAINT [PK_KHACH_HANG] PRIMARY KEY CLUSTERED 
(
	[makh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SAN_PHAM]    Script Date: 3/16/2024 4:09:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SAN_PHAM](
	[masp] [nchar](10) NOT NULL,
	[tensp] [nvarchar](50) NOT NULL,
	[ngaysx] [date] NOT NULL,
	[dongia] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SAN_PHAM] PRIMARY KEY CLUSTERED 
(
	[masp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'A1        ', N'B1        ', 5000, N'10.000')
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'A2        ', N'B2        ', 2000, N'15.000')
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'A3        ', N'B3        ', 1500, N'5.000')
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'A4        ', N'B4        ', 1000, N'30.000')
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'A5        ', N'B5        ', 750, N'50.000')
INSERT [dbo].[CT_HOA_DON] ([mahd], [masp], [soluong], [dongia]) VALUES (N'A6        ', N'B6        ', 1250, N'25.000')
GO
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'A1        ', CAST(N'2024-03-10' AS Date), N'KH1       ')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'A2        ', CAST(N'2024-03-09' AS Date), N'KH2       ')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'A3        ', CAST(N'2024-03-10' AS Date), N'KH3       ')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'A4        ', CAST(N'2024-03-11' AS Date), N'KH4       ')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'A5        ', CAST(N'2024-03-12' AS Date), N'KH5       ')
INSERT [dbo].[HOA_DON] ([mahd], [ngaylap], [makh]) VALUES (N'A6        ', CAST(N'2024-03-12' AS Date), N'KH6       ')
GO
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH1       ', N'A', N'NAM       ', N'01        ', N'Q3')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH2       ', N'B', N'NU        ', N'02        ', N'Q4')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH3       ', N'C', N'NAM       ', N'03        ', N'Q5')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH4       ', N'D', N'NAM       ', N'04        ', N'Q7')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH5       ', N'E', N'NU        ', N'05        ', N'THU DUC')
INSERT [dbo].[KHACH_HANG] ([makh], [hoten], [gioitinh], [dthoai], [diachi]) VALUES (N'KH6       ', N'F', N'NU        ', N'06        ', N'BINH THANH')
GO
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'B1        ', N'BANH', CAST(N'2024-03-01' AS Date), N'10.000')
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'B2        ', N'BANH GAU', CAST(N'2024-02-28' AS Date), N'15.000')
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'B3        ', N'BANH QUY', CAST(N'2024-02-14' AS Date), N'5.000')
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'B4        ', N'SOCOLA', CAST(N'2024-03-03' AS Date), N'30.000')
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'B5        ', N'BANH SOCOLA', CAST(N'2024-03-02' AS Date), N'50.000')
INSERT [dbo].[SAN_PHAM] ([masp], [tensp], [ngaysx], [dongia]) VALUES (N'B6        ', N'KEO DUA', CAST(N'2024-03-07' AS Date), N'25.000')
GO
ALTER TABLE [dbo].[CT_HOA_DON]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOA_DON_HOA_DON] FOREIGN KEY([mahd])
REFERENCES [dbo].[HOA_DON] ([mahd])
GO
ALTER TABLE [dbo].[CT_HOA_DON] CHECK CONSTRAINT [FK_CT_HOA_DON_HOA_DON]
GO
ALTER TABLE [dbo].[CT_HOA_DON]  WITH CHECK ADD  CONSTRAINT [FK_CT_HOA_DON_SAN_PHAM] FOREIGN KEY([masp])
REFERENCES [dbo].[SAN_PHAM] ([masp])
GO
ALTER TABLE [dbo].[CT_HOA_DON] CHECK CONSTRAINT [FK_CT_HOA_DON_SAN_PHAM]
GO
ALTER TABLE [dbo].[HOA_DON]  WITH CHECK ADD  CONSTRAINT [FK_HOA_DON_KHACH_HANG] FOREIGN KEY([makh])
REFERENCES [dbo].[KHACH_HANG] ([makh])
GO
ALTER TABLE [dbo].[HOA_DON] CHECK CONSTRAINT [FK_HOA_DON_KHACH_HANG]
GO
