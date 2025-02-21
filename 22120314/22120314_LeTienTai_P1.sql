Drop database QLKhoaHoc

use master
go
create database QLKhoaHoc
go
use QLKhoaHoc
go

create table BaiBao
(
	IDBaiBao char(10) not null,
	TenBaiBao nvarchar(50),
	IDTruong char(10) not null,
	IDPhanBien char(10)
	primary key (IDBaiBao,IDTruong)
)

create table NhaKhoaHoc
(
	IDNhaKhoaHoc char(10) not null,
	IDTruong char(10) not null ,
	HoTen nvarchar(50),
	NgaySinh date,
	primary key (IDTruong,IDNhaKhoaHoc)
)

create table THAMGIA
(
	IDBaiBao char(10) not null,
	IDNhaKhoaHoc char(10) not null,
	IDTruong char(10) not null,
	ThanhTich nvarchar(50),
	primary key(IDBaiBao,IDTruong,IDNhaKhoaHoc)
)

alter table THAMGIA
add constraint FK_ThamGia_NhaKhoaHoc foreign key (IDTruong,IDNhaKhoaHoc) references NhaKhoaHoc(IDTruong,IDNhaKhoaHoc)

alter table THAMGIA
add constraint FK_ThamGia_BaiBao foreign key (IDBaiBao,IDTruong) references BaiBao(IDBaiBao,IDTruong)

insert into BaiBao(IDBaiBao,IDTruong,TenBaiBao,IDPhanBien) values ('B1','TN',N'Phát triển TPTM','N2')
insert into BaiBao(IDBaiBao,IDTruong,TenBaiBao,IDPhanBien) values ('B1','BK',N'Nghiên cứu B1','N2')
insert into BaiBao(IDBaiBao,IDTruong,TenBaiBao,IDPhanBien) values ('B2','BK',N'Xử lý ngôn ngữ','N2')

insert into NhaKhoaHoc(IDNhaKhoaHoc,IDTruong,HoTen,NgaySinh) values ('N2','TN',N'Nguyễn','1984-07-15')
insert into NhaKhoaHoc(IDNhaKhoaHoc,IDTruong,HoTen,NgaySinh) values ('N2','BK',N'Tín','1983-09-26')
insert into NhaKhoaHoc(IDNhaKhoaHoc,IDTruong,HoTen,NgaySinh) values ('N1','BK',N'Hà','1984-10-18')
insert into NhaKhoaHoc(IDNhaKhoaHoc,IDTruong,HoTen,NgaySinh) values ('N1','TN',N'Hữu','1984-12-09')
insert into NhaKhoaHoc(IDNhaKhoaHoc,IDTruong,HoTen,NgaySinh) values ('N3','BK',N'Nhân','1982-12-1')

insert into THAMGIA(IDBaiBao, IDTruong, IDNhaKhoaHoc, ThanhTich) values ('B1', 'TN', 'N1', N'Giỏi')
insert into THAMGIA(IDBaiBao, IDTruong, IDNhaKhoaHoc, ThanhTich) values ('B1', 'BK', 'N1', N'Xuất sắc')
insert into THAMGIA(IDBaiBao, IDTruong, IDNhaKhoaHoc, ThanhTich) values ('B1', 'BK', 'N3', N'Khá')
insert into THAMGIA(IDBaiBao, IDTruong, IDNhaKhoaHoc, ThanhTich) values ('B2', 'BK', 'N1', N'Trung bình')
insert into THAMGIA(IDBaiBao, IDTruong, IDNhaKhoaHoc, ThanhTich) values ('B2', 'BK', 'N3', N'Khá')

select BaiBao.IDTruong, BaiBao.TenBaiBao
from BaiBao
join THAMGIA on BaiBao.IDBaiBao = THAMGIA.IDBaiBao and BaiBao.IDTruong = THAMGIA.IDTruong
join NhaKhoaHoc on THAMGIA.IDNhaKhoaHoc = NhaKhoaHoc.IDNhaKhoaHoc and THAMGIA.IDTruong = NhaKhoaHoc.IDTruong
where YEAR(NhaKhoaHoc.NgaySinh) = 1984

select NhaKhoaHoc1.IDTruong, NhaKhoaHoc1.HoTen
from NhaKhoaHoc as NhaKhoaHoc1
join THAMGIA on NhaKhoaHoc1.IDTruong = THAMGIA.IDTruong and NhaKhoaHoc1.IDNhaKhoaHoc = THAMGIA.IDNhaKhoaHoc
join BaiBao on THAMGIA.IDBaiBao = BaiBao.IDBaiBao and THAMGIA.IDTruong = BaiBao.IDTruong
join NhaKhoaHoc as NhaKhoaHoc2 on BaiBao.IDPhanBien = NhaKhoaHoc2.IDNhaKhoaHoc and BaiBao.IDTruong = NhaKhoaHoc2.IDTruong
where YEAR(NhaKhoaHoc1.NgaySinh) = YEAR(NhaKhoaHoc2.NgaySinh)