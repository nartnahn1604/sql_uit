CREATE DATABASE QLBH

USE QLBH
DROP DATABASE QLBH

create table KHACHHANG
(
    MAKH    char(4) primary key,
    HOTEN   varchar(40),
    DCHI    varchar(50),
    SODT    varchar(20),
    NGSINH  smalldatetime,
    NGDK    smalldatetime,
    DOANHSO money
);

create table NHANVIEN
(
    MANV  char(4) primary key,
    HOTEN varchar(40),
    SODT  varchar(20),
    NGVL smalldatetime
);

create table SANPHAM
(
    MASP   char(4) primary key,
    TENSP  varchar(40),
    DVT    varchar(20),
    NUOCSX varchar(40),
    GIA money
);

create table HOADON
(
    SOHD   int primary key,
    NGHD   smalldatetime,
    MAKH   char(4),
    MANV   char(4),
    TRIGIA money,
    constraint FK_MAKH foreign key (MAKH) references KHACHHANG(MAKH),
    constraint FK_MANV foreign key (MANV) references NHANVIEN(MANV)
);

create table CTHD
(
  SOHD  int,
  MASP  char(4),
  SL    int,
  constraint PK_KEY primary key (SOHD, MASP),
  constraint  FK_SOHD foreign key (SOHD) references HOADON(SOHD),
  constraint  FR_MASP foreign key (MASP) references SANPHAM(MASP)
);

--2. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
alter table SANPHAM
    add GHICHU varchar(20);

--3. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG
alter table KHACHHANG
    add LOAIKH tinyint;

--4. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
alter table SANPHAM
    alter column GHICHU varchar(100);

--5. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
alter table SANPHAM
	drop column GHICHU;

--6. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”, “Thuong xuyen”, “Vip”, …alter table KHACHHANG	alter column LOAIKH varchar(20);--7. Đơn vị tính của sản phẩm chỉ có thể là (“cay”,”hop”,”cai”,”quyen”,”chuc”)alter table SANPHAM	add constraint DVT_SELECT check (DVT = 'cay' or DVT = 'hop' or DVT = 'cai' or DVT = 'quyen' or DVT = 'chuc');--8. Giá bán của sản phẩm từ 500 đồng trở lên.alter table SANPHAM	add constraint GIA_CHECK check (GIA>500);--9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
alter table CTHD	add constraint SL_CHECK check (SL>0);
--10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
alter table KHACHHANG	add constraint DKHV_CHECK check (NGDK - NGSINH >0);
--11. Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).
--12. Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.
--13. Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn.
--14. Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
--15. Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.

--II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):
--1.Nhập dữ liệu cho các quan hệ trên.
set dateformat dmy
-------------------------------
-- KHACHHANG
insert into KHACHHANG values('KH01','Nguyen Van A','731 Tran Hung Dao, Q5, TpHCM','8823451','22/10/1960','22/07/2006',13060000,'')
insert into KHACHHANG values('KH02','Tran Ngoc Han','23/5 Nguyen Trai, Q5, TpHCM','908256478','03/04/1974','30/07/2006',280000,'')
insert into KHACHHANG values('KH03','Tran Ngoc Linh','45 Nguyen Canh Chan, Q1, TpHCM','938776266','12/06/1980','08/05/2006',3860000,'')
insert into KHACHHANG values('KH04','Tran Minh Long','50/34 Le Dai Hanh, Q10, TpHCM','917325476','09/03/1965','10/02/2006',250000,'')
insert into KHACHHANG values('KH05','Le Nhat Minh','34 Truong Dinh, Q3, TpHCM','8246108','10/03/1950','28/10/2006',21000,'')
insert into KHACHHANG values('KH06','Le Hoai Thuong','227 Nguyen Van Cu, Q5, TpHCM','8631738','31/12/1981','24/11/2006',915000,'')
insert into KHACHHANG values('KH07','Nguyen Van Tam','32/3 Tran Binh Trong, Q5, TpHCM','916783565','06/04/1971','12/01/2006',12500,'')
insert into KHACHHANG values('KH08','Phan Thi Thanh','45/2 An Duong Vuong, Q5, TpHCM','938435756','10/01/1971','13/12/2006',365000,'')
insert into KHACHHANG values('KH09','Le Ha Vinh','873 Le Hong Phong, Q5, TpHCM','8654763','03/09/1979','14/01/2007',70000,'')
insert into KHACHHANG values('KH10','Ha Duy Lap','34/34B Nguyen Trai, Q1, TpHCM','8768904','02/05/1983','16/01/2007',67500,'')

-------------------------------
-- NHANVIEN
insert into NHANVIEN values('NV01','Nguyen Nhu Nhut','927345678','13/04/2006')
insert into NHANVIEN values('NV02','Le Thi Phi Yen','987567390','21/04/2006')
insert into NHANVIEN values('NV03','Nguyen Van B','997047382','27/04/2006')
insert into NHANVIEN values('NV04','Ngo Thanh Tuan','913758498','24/06/2006')
insert into NHANVIEN values('NV05','Nguyen Thi Truc Thanh','918590387','20/07/2006')

-------------------------------
-- SANPHAM
insert into SANPHAM values('BC01','But chi','cay','Singapore',3000)
insert into SANPHAM values('BC02','But chi','cay','Singapore',5000)
insert into SANPHAM values('BC03','But chi','cay','Viet Nam',3500)
insert into SANPHAM values('BC04','But chi','hop','Viet Nam',30000)
insert into SANPHAM values('BB01','But bi','cay','Viet Nam',5000)
insert into SANPHAM values('BB02','But bi','cay','Trung Quoc',7000)
insert into SANPHAM values('BB03','But bi','hop','Thai Lan',100000)
insert into SANPHAM values('TV01','Tap 100 giay mong','quyen','Trung Quoc',2500)
insert into SANPHAM values('TV02','Tap 200 giay mong','quyen','Trung Quoc',4500)
insert into SANPHAM values('TV03','Tap 100 giay tot','quyen','Viet Nam',3000)
insert into SANPHAM values('TV04','Tap 200 giay tot','quyen','Viet Nam',5500)
insert into SANPHAM values('TV05','Tap 100 trang','chuc','Viet Nam',23000)
insert into SANPHAM values('TV06','Tap 200 trang','chuc','Viet Nam',53000)
insert into SANPHAM values('TV07','Tap 100 trang','chuc','Trung Quoc',34000)
insert into SANPHAM values('ST01','So tay 500 trang','quyen','Trung Quoc',40000)
insert into SANPHAM values('ST02','So tay loai 1','quyen','Viet Nam',55000)
insert into SANPHAM values('ST03','So tay loai 2','quyen','Viet Nam',51000)
insert into SANPHAM values('ST04','So tay','quyen','Thai Lan',55000)
insert into SANPHAM values('ST05','So tay mong','quyen','Thai Lan',20000)
insert into SANPHAM values('ST06','Phan viet bang','hop','Viet Nam',5000)
insert into SANPHAM values('ST07','Phan khong bui','hop','Viet Nam',7000)
insert into SANPHAM values('ST08','Bong bang','cai','Viet Nam',1000)
insert into SANPHAM values('ST09','But long','cay','Viet Nam',5000)
insert into SANPHAM values('ST10','But long','cay','Trung Quoc',7000)

-------------------------------
-- HOADON
insert into HOADON values(1001,'23/07/2006','KH01','NV01',320000)
insert into HOADON values(1002,'12/08/2006','KH01','NV02',840000)
insert into HOADON values(1003,'23/08/2006','KH02','NV01',100000)
insert into HOADON values(1004,'01/09/2006','KH02','NV01',180000)
insert into HOADON values(1005,'20/10/2006','KH01','NV02',3800000)
insert into HOADON values(1006,'16/10/2006','KH01','NV03',2430000)
insert into HOADON values(1007,'28/10/2006','KH03','NV03',510000)
insert into HOADON values(1008,'28/10/2006','KH01','NV03',440000)
insert into HOADON values(1009,'28/10/2006','KH03','NV04',200000)
insert into HOADON values(1010,'01/11/2006','KH01','NV01',5200000)
insert into HOADON values(1011,'04/11/2006','KH04','NV03',250000)
insert into HOADON values(1012,'30/11/2006','KH05','NV03',21000)
insert into HOADON values(1013,'12/12/2006','KH06','NV01',5000)
insert into HOADON values(1014,'31/12/2006','KH03','NV02',3150000)
insert into HOADON values(1015,'01/01/2007','KH06','NV01',910000)
insert into HOADON values(1016,'01/01/2007','KH07','NV02',12500)
insert into HOADON values(1017,'02/01/2007','KH08','NV03',35000)
insert into HOADON values(1018,'13/01/2007','KH08','NV03',330000)
insert into HOADON values(1019,'13/01/2007','KH01','NV03',30000)
insert into HOADON values(1020,'14/01/2007','KH09','NV04',70000)
insert into HOADON values(1021,'16/01/2007','KH10','NV03',67500)
insert into HOADON values(1022,'16/01/2007',Null,'NV03',7000)
insert into HOADON values(1023,'17/01/2007',Null,'NV01',330000)

-------------------------------
-- CTHD
delete from CTHD
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'TV02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'ST01', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'BC01', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'BC02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1001, 'ST08', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1002, 'BC04', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1002, 'BB01', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1002, 'BB02', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1003, 'BB03', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1004, 'TV01', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1004, 'TV02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1004, 'TV03', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1004, 'TV04', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1005, 'TV05', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1005, 'TV06', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1006, 'TV07', 20)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1006, 'ST01', 30)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1006, 'ST02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1007, 'ST03', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1008, 'ST04', 8)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1009, 'ST05', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'TV07', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'ST07', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'ST08', 100)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'ST04', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1010, 'TV03', 100)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1011, 'ST06', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1012, 'ST07', 3)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1013, 'ST08', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1014, 'BC02', 80)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1014, 'BB02', 100)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1014, 'BC04', 60)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1014, 'BB01', 50)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1015, 'BB02', 30)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1015, 'BB03', 7)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1016, 'TV01', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1017, 'TV02', 1)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1017, 'TV03', 1)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1017, 'TV04', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1018, 'ST04', 6)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1019, 'ST05', 1)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1019, 'ST06', 2)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1020, 'ST07', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1021, 'ST08', 5)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1021, 'TV01', 7)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1021, 'TV02', 10)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1022, 'ST07', 1)
INSERT INTO CTHD (SOHD, MASP, SL) VALUES (1023, 'ST04', 6)

--2. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
select * 
into SANPHAM1
from SANPHAM;

select * 
into KHACHHANG1
from KHACHHANG;

--3. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
update SANPHAM1	
	set GIA = GIA*1.05
	where NUOCSX like '%Thai Lan%';

--4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
update SANPHAM1	
	set GIA = GIA*0.95
	where NUOCSX like '%Trung Quoc%' and GIA <= 10000;

--5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
update KHACHHANG1	
	set LOAIKH = 'VIP'
	where (YEAR(NGDK) < 2007 and DOANHSO >= 10000000) or (YEAR(NGDK) >= 2007 and DOANHSO >= 2000000);

select * from KHACHHANG1

--III. Ngôn ngữ truy vấn dữ liệu có cấu trúc:
--1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
select MASP, TENSP
from SANPHAM
where NUOCSX = 'Trung Quoc';

--2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
select MASP, TENSP
from SANPHAM
where DVT = 'cay' or DVT = 'quyen';

--3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
select MASP, TENSP
from SANPHAM
where MASP like 'B%01';

--4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
select MASP, TENSP
from SANPHAM
where NUOCSX = 'Trung Quoc' and GIA between 30000 and 40000;

--5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
select MASP, TENSP
from SANPHAM
where (NUOCSX = 'Trung Quoc' or NUOCSX = 'Thai Lan') and GIA between 30000 and 40000;

--6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
select SOHD, TRIGIA
from HOADON
where NGHD = '01/01/2007' or NGHD = '02/01/2007';

--7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
select SOHD, TRIGIA
from HOADON
where month(NGHD) = 1 and  year(NGHD) = 2007
order by NGHD ASC, TRIGIA DESC;

--8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
select KHACHHANG.MAKH, HOTEN, NGHD
from KHACHHANG, HOADON
where KHACHHANG.MAKH = HOADON.MAKH and NGHD='01/01/2007';

--9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
select SOHD, TRIGIA
from NHANVIEN inner join HOADON 
on NHANVIEN.MANV = HOADON.MANV
where HOTEN = 'Nguyen Van B' and NGHD = '28/10/2006';

--10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
select SANPHAM.MASP, TENSP
from SANPHAM, CTHD, HOADON, KHACHHANG
where SANPHAM.MASP = CTHD.MASP and CTHD.SOHD = HOADON.SOHD and KHACHHANG.MAKH = HOADON.MAKH and HOTEN = 'Nguyen Van A' and month(NGHD) = '10' and year(NGHD) = '2006';

--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
select SOHD 
from CTHD
where MASP = 'BB01' or MASP = 'BB02';

--12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select SOHD
from CTHD
where SL between 10 and 20 and (MASP = 'BB01' or MASP = 'BB02');

--13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select SOHD
from CTHD
where SL between 10 and 20 and MASP = 'BB01' and SOHD in (select SOHD from CTHD where MASP = 'BB02');

--14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra trong ngày 1/1/2007.
select sp.MASP,TENSP
from SANPHAM sp, CTHD ct, HOADON hd
where sp.MASP = ct.MASP and hd.SOHD = ct.SOHD and NUOCSX = 'Trung Quoc' and NGHD = '01/01/2007';

--15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
select MASP,TENSP
from SANPHAM sp
where MASP not in (select distinct ct.MASP from CTHD ct);

--16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
select MASP,TENSP
from SANPHAM sp
where MASP not in (select distinct ct.MASP from CTHD ct, HOADON hd where ct.SOHD = hd.SOHD and year(NGHD) = '2006');

--17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
select MASP,TENSP
from SANPHAM sp
where  NUOCSX = 'Trung Quoc' and MASP not in (select distinct ct.MASP from CTHD ct, HOADON hd where ct.SOHD = hd.SOHD and year(NGHD) = '2006');