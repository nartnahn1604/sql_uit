CREATE DATABASE QLGV

USE QLGV
DROP DATABASE QLGV

CREATE TABLE HOCVIEN
(
	MAHV		char(5) PRIMARY KEY,
	HO			varchar(40),
	TEN			varchar(10),
	NGSINH		smalldatetime,
	GIOITINH	varchar(3),
	NOISINH		varchar(40),
	MALOP		char(3),
);

CREATE TABLE LOP
(
	MALOP		char(3) PRIMARY KEY,
	TENLOP		varchar(40),
	TRGLOP		char(5),
	SISO		tinyint,
	MAGVCN		char(4),
	CONSTRAINT FK_LOP_TRGLOP FOREIGN KEY (TRGLOP) REFERENCES HOCVIEN(MAHV)
);

CREATE TABLE KHOA
(
	MAKHOA	varchar(4) PRIMARY KEY,
	TENKHOA	varchar(40),
	NGTLAP	smalldatetime,
	TRGKHOA	char(4)
);

CREATE TABLE MONHOC
(
	MAMH		varchar(10) PRIMARY KEY,
	TENMH		varchar(40),
	TCLT		tinyint,
	TCTH		tinyint,
	MAKHOA		varchar(4),
	CONSTRAINT FK_MONHOC_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

CREATE TABLE DIEUKIEN
(
	MAMH        varchar(10),
	MAMH_TRUOC	varchar(10),
	CONSTRAINT PK_DIEUKIEN PRIMARY KEY (MAMH,MAMH_TRUOC),
	CONSTRAINT FK_DIEUKIEN_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	CONSTRAINT FK_DIEUKIEN_MAMHTRUOC FOREIGN KEY (MAMH_TRUOC) REFERENCES MONHOC(MAMH)
);

CREATE TABLE GIAOVIEN
(
	MAGV		char(4)PRIMARY KEY,
	HOTEN		varchar(40),
	HOCVI		varchar(10),
	HOCHAM		varchar(10),
	GIOITINH	varchar(3),
	NGSINH		smalldatetime,
	NGVL		smalldatetime,
	HESO		numeric(4,2),
	MUCLUONG	money,
	MAKHOA		varchar(4),
	CONSTRAINT FK_GIAOVIEN_MAKHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA)
);

CREATE TABLE GIANGDAY
(
	MALOP	char(3),
	MAMH	varchar(10),
	MAGV	char(4),
	HOCKY	tinyint,
	NAM		smallint,
	TUNGAY	smalldatetime,
	DENNGAY	smalldatetime,
	CONSTRAINT PK_GIANGDAY PRIMARY KEY (MALOP,MAMH),
	CONSTRAINT FK_GIANGDAY_MALOP FOREIGN KEY (MALOP) REFERENCES LOP(MALOP),
	CONSTRAINT FK_GIANGDAY_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH),
	CONSTRAINT FK_GIANGDAY_MAGV FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)
);

CREATE TABLE KETQUATHI
(
	MAHV	char(5),
	MAMH	varchar(10),
	LANTHI	tinyint,
	NGTHI	smalldatetime,
	DIEM	numeric(4,2),
	KQUA	varchar(10),
	CONSTRAINT PK_KETQUATHI PRIMARY KEY (MAHV,MAMH,LANTHI),
	CONSTRAINT FK_KETQUATHI_MAHV FOREIGN KEY (MAHV) REFERENCES HOCVIEN(MAHV),
	CONSTRAINT FK_KETQUATHI_MAMH FOREIGN KEY (MAMH) REFERENCES MONHOC(MAMH)
);
ALTER TABLE KHOA
    ADD CONSTRAINT FK_KHOA_TRGKHOA FOREIGN KEY(TRGKHOA) REFERENCES GIAOVIEN(MAGV);
ALTER TABLE HOCVIEN
    ADD CONSTRAINT FK_HOCVIEN_MALOP FOREIGN KEY(MALOP) REFERENCES LOP(MALOP);
--1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính GHICHU, DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
alter table HOCVIEN
	add GHICHU varchar(100),
		DIEMTB float,
		XEPLOAI varchar(10);

--2. Mã học viên là một chuỗi 5 ký tự, 3 ký tự đầu là mã lớp, 2 ký tự cuối cùng là số thứ tự học viên trong lớp. VD: “K1101”
alter table HOCVIEN
	add ID int identity(1,1);
alter table HOCVIEN
	--drop constraint MAHV_CHECK;
	add constraint MAHV_CHECK check (len(MAHV) = 5 and left(MAHV, 3)=MALOP and (right(MAHV, 2) = cast(ID as varchar(99)) or (ID < 10 and right(MAHV, 1) = cast(ID as varchar(99)))));

--3. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
alter table HOCVIEN
	add constraint GT_CHECK check (GIOITINH = 'Nam' or GIOITINH = 'Nu');

--4. Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
alter table KETQUATHI
	add constraint DIEMTHI_CHECK check (DIEM >= 0 and DIEM <=10); 

--5. Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
alter table KETQUATHI
	add constraint KQ_CHECK check (
		(KQUA = 'Dat' AND DIEM BETWEEN 5 AND 10)
		OR (KQUA = 'Khong dat' AND DIEM < 5)
	); 
--6. Học viên thi một môn tối đa 3 lần.
alter table KETQUATHI
	add constraint LT_CHECK check (LANTHI <= 3);

--7. Học kỳ chỉ có giá trị từ 1 đến 3.
alter table GIANGDAY
	add constraint HK_CHECK check (HOCKY <= 3 and HOCKY >=1);

--8. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
alter table GIAOVIEN
	add constraint HOCVI_CHECK check (HOCVI = 'CN' or HOCVI = 'KS' or HOCVI = 'Ths' or HOCVI = 'TS' or HOCVI = 'PTS');

alter table KHOA nocheck constraint FK_KHOA_TRGKHOA;
alter table HOCVIEN nocheck constraint FK_HOCVIEN_MALOP;
alter table LOP nocheck constraint FK_LOP_TRGLOP;

-- INSERT DATA
set dateformat dmy
-- NHAP DU LIEU LOP --
INSERT INTO LOP VALUES('K11','Lop 1 khoa 1','K1108',11,'GV07')
INSERT INTO LOP VALUES('K12','Lop 2 khoa 1','K1205',12,'GV09')
INSERT INTO LOP VALUES('K13','Lop 3 khoa 1','K1305',12,'GV14')

-- NHAP DU LIEU HOCVIEN -- 
insert into HOCVIEN values('K1101','Nguyen Van','A','27/1/1986','Nam','TpHCM','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1102','Tran Ngoc','Han','14/3/1986','Nu','Kien Giang','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1103','Ha Duy','Lap','18/4/1986','Nam','Nghe An','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1104','Tran Ngoc','Linh','30/3/1986','Nu','Tay Ninh','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1105','Tran Minh','Long','27/2/1986','Nam','TpHCM','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1106','Le Nhat','Minh','24/1/1986','Nam','TpHCM','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1107','Nguyen Nhu','Nhut','27/1/1986','Nam','Ha Noi','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1108','Nguyen Manh','Tam','27/2/1986','Nam','Kien Giang','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1109','Phan Thi Thanh','Tam','27/1/1986','Nu','Vinh Long','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1110','Le Hoai','Thuong','5/2/1986','Nu','Can Tho','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1111','Le Ha','Vinh','25/12/1986','Nam','Vinh Long','K11', NULL, NULL, NULL);
insert into HOCVIEN values('K1201','Nguyen Van','B','11/2/1986','Nam','TpHCM','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1202','Nguyen Thi Kim','Duyen','18/1/1986','Nu','TpHCM','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1203','Tran Thi Kim','Duyen','17/9/1986','Nu','TpHCM','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1204','Truong My','Hanh','19/5/1986','Nu','Dong Nai','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1205','Nguyen Thanh','Nam','17/4/1986','Nam','TpHCM','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1206','Nguyen Thi Truc','Thanh','4/3/1986','Nu','Kien Giang','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1207','Tran Thi Bich','Thuy','8/2/1986','Nu','Nghe An','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1208','Huynh Thi Kim','Trieu','8/4/1986','Nu','Tay Ninh','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1209','Pham Thanh','Trieu','23/2/1986','Nam','TpHCM','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1210','Ngo Thanh','Tuan','14/2/1986','Nam','TpHCM','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1211','Do Thi','Xuan','9/3/1986','Nu','Ha Noi','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1212','Le Thi Phi','Yen','12/3/1986','Nu','TpHCM','K12', NULL, NULL, NULL);
insert into HOCVIEN values('K1301','Nguyen Thi Kim','Cuc','9/6/1986','Nu','Kien Giang','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1302','Truong Thi My','Hien','18/3/1986','Nu','Nghe An','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1303','Le Duc','Hien','21/3/1986','Nam','Tay Ninh','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1304','Le Quang','Hien','18/4/1986','Nam','TpHCM','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1305','Le Thi','Huong','27/3/1986','Nu','TpHCM','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1306','Nguyen Thai','Huu','30/3/1986','Nam','Ha Noi','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1307','Tran Minh','Man','28/5/1986','Nam','TpHCM','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1308','Nguyen Hieu','Nghia','8/4/1986','Nam','Kien Giang','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1309','Nguyen Trung','Nghia','18/1/1987','Nam','Nghe An','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1310','Tran Thi Hong','Tham','22/4/1986','Nu','Tay Ninh','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1311','Tran Minh','Thuc','4/4/1986','Nam','TpHCM','K13', NULL, NULL, NULL);
insert into HOCVIEN values('K1312','Nguyen Thi Kim','Yen','7/9/1986','Nu','TpHCM','K13', NULL, NULL, NULL);


-- NHAP DU LIEU KHOA --
INSERT INTO KHOA VALUES('KHMT','Khoa hoc may tinh','7/6/2005','GV01')
INSERT INTO KHOA VALUES('HTTT','He thong thong tin','7/6/2005','GV02')
INSERT INTO KHOA VALUES('CNPM','Cong nghe phan mem','7/6/2005','GV04')
INSERT INTO KHOA VALUES('MTT','Mang va truyen thong','20/10/2005','GV03')
INSERT INTO KHOA VALUES('KTMT','Ky thuat may tinh','20/12/2005','Null')

-- NHAP DU LIEU GIAOVIEN --
INSERT INTO GIAOVIEN VALUES('GV01','Ho Thanh Son','PTS','GS','Nam','2/5/1950','11/1/2004',5,2250000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV02','Tran Tam Thanh','TS','PGS','Nam','17/12/1965','20/4/2004',4.5,2025000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV03','Do Nghiem Phung','TS','GS','Nu','1/8/1950','23/9/2004',4,1800000,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV04','Tran Nam Son','TS','PGS','Nam','22/2/1961','12/1/2005',4.5,2025000,'KTMT')
INSERT INTO GIAOVIEN VALUES('GV05','Mai Thanh Danh','ThS','GV','Nam','12/3/1958','12/1/2005',3,1350000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV06','Tran Doan Hung','TS','GV','Nam','11/3/1953','12/1/2005',4.5,2025000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV07','Nguyen Minh Tien','ThS','GV','Nam','23/11/1971','1/3/2005',4,1800000,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV08','Le Thi Tran','KS','Null','Nu','26/3/1974','1/3/2005',1.69,760500,'KHMT')
INSERT INTO GIAOVIEN VALUES('GV09','Nguyen To Lan','ThS','GV','Nu','31/12/1966','1/3/2005',4,1800000,'HTTT')
INSERT INTO GIAOVIEN VALUES('GV10','Le Tran Anh Loan','KS','Null','Nu','17/7/1972','1/3/2005',1.86,837000,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV11','Ho Thanh Tung','CN','GV','Nam','12/1/1980','15/5/2005',2.67,1201500,'MTT')
INSERT INTO GIAOVIEN VALUES('GV12','Tran Van Anh','CN','Null','Nu','29/3/1981','15/5/2005',1.69,760500,'CNPM')
INSERT INTO GIAOVIEN VALUES('GV13','Nguyen Linh Dan','CN','Null','Nu','23/5/1980','15/5/2005',1.69,760500,'KTMT')
INSERT INTO GIAOVIEN VALUES('GV14','Truong Minh Chau','ThS','GV','Nu','30/11/1976','15/5/2005',3,1350000,'MTT')
INSERT INTO GIAOVIEN VALUES('GV15','Le Ha Thanh','ThS','GV','Nam','4/5/1978','15/5/2005',3,1350000,'KHMT')

-- NHAP DU LIEU MONHOC --
INSERT INTO MONHOC VALUES('THDC','Tin hoc dai cuong',4,1,'KHMT')
INSERT INTO MONHOC VALUES('CTRR','Cau truc roi rac',5,0,'KHMT')
INSERT INTO MONHOC VALUES('CSDL','Co so du lieu',3,1,'HTTT')
INSERT INTO MONHOC VALUES('CTDLGT','Cau truc du lieu va giai thuat',3,1,'KHMT')
INSERT INTO MONHOC VALUES('PTTKTT','Phan tich thiet ke thuat toan',3,0,'KHMT')
INSERT INTO MONHOC VALUES('DHMT','Do hoa may tinh',3,1,'KHMT')
INSERT INTO MONHOC VALUES('KTMT','Kien truc may tinh',3,0,'KTMT')
INSERT INTO MONHOC VALUES('TKCSDL','Thiet ke co so du lieu',3,1,'HTTT')
INSERT INTO MONHOC VALUES('PTTKHTTT','Phan tich thiet ke he thong thong tin',4,1,'HTTT')
INSERT INTO MONHOC VALUES('HDH','He dieu hanh',4,0,'KTMT')
INSERT INTO MONHOC VALUES('NMCNPM','Nhap mon cong nghe phan mem',3,0,'CNPM')
INSERT INTO MONHOC VALUES('LTCFW','Lap trinh C for win',3,1,'CNPM')
INSERT INTO MONHOC VALUES('LTHDT','Lap trinh huong doi tuong',3,1,'CNPM')

-- NHAP DU LIEU GIANGDAY --
INSERT INTO GIANGDAY VALUES ('K11','THDC','GV07',1,2006,'2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES ('K12','THDC','GV06',1,2006,'2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES ('K13','THDC','GV15',1,2006,'2/1/2006','12/5/2006')
INSERT INTO GIANGDAY VALUES ('K11','CTRR','GV02',1,2006,'9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES ('K12','CTRR','GV02',1,2006,'9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES ('K13','CTRR','GV08',1,2006,'9/1/2006','17/5/2006')
INSERT INTO GIANGDAY VALUES ('K11','CSDL','GV05',2,2006,'1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES ('K12','CSDL','GV09',2,2006,'1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES ('K13','CTDLGT','GV15',2,2006,'1/6/2006','15/7/2006')
INSERT INTO GIANGDAY VALUES ('K13','CSDL','GV05',3,2006,'1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K13','DHMT','GV07',3,2006,'1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K11','CTDLGT','GV15',3,2006,'1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K12','CTDLGT','GV15',3,2006,'1/8/2006','15/12/2006')
INSERT INTO GIANGDAY VALUES ('K11','HDH','GV04',1,2007,'2/1/2007','18/2/2007')
INSERT INTO GIANGDAY VALUES ('K12','HDH','GV04',1,2007,'2/1/2007','20/3/2007')
INSERT INTO GIANGDAY VALUES ('K11','DHMT','GV07',1,2007,'18/2/2007','20/3/2007')

-- NHAP DU LIEU DIEUKIEN --
INSERT INTO DIEUKIEN VALUES ('CSDL','CTRR')
INSERT INTO DIEUKIEN VALUES ('CSDL','CTDLGT')
INSERT INTO DIEUKIEN VALUES ('CTDLGT','THDC')
INSERT INTO DIEUKIEN VALUES ('PTTKTT','THDC')
INSERT INTO DIEUKIEN VALUES ('PTTKTT','CTDLGT')
INSERT INTO DIEUKIEN VALUES ('DHMT','THDC')
INSERT INTO DIEUKIEN VALUES ('LTHDT','THDC')
INSERT INTO DIEUKIEN VALUES ('PTTKHTTT','CSDL')

-- NHAP DU LIEU KETQUATHI --
INSERT INTO KETQUATHI VALUES ('K1101','CSDL',1,'20/7/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES ('K1101','CTDLGT',1,'28/12/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES ('K1101','THDC',1,'20/5/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES ('K1101','CTRR',1,'13/5/2006',9.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL',1,'20/7/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL',2,'27/7/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CSDL',3,'10/8/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT',1,'28/12/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT',2,'5/1/2007',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTDLGT',3,'15/1/2007',6,'Dat')
INSERT INTO KETQUATHI VALUES ('K1102','THDC',1,'20/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1102','CTRR',1,'13/5/2006',7,'Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CSDL',1,'20/7/2006',3.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CSDL',2,'27/7/2006',8.25,'Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CTDLGT',1,'28/12/2006',7,'Dat')
INSERT INTO KETQUATHI VALUES ('K1103','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1103','CTRR',1,'13/5/2006',6.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CSDL',1,'20/7/2006',3.75,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTDLGT',1,'28/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR',1,'13/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR',2,'20/5/2006',3.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1104','CTRR',3,'30/6/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CSDL',1,'20/7/2006',6,'Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CTDLGT',1,'28/12/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1201','THDC',1,'20/5/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1201','CTRR',1,'13/5/2006',9,'Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CSDL',1,'20/7/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTDLGT',1,'28/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTDLGT',2,'5/1/2007',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1202','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','THDC',2,'27/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR',1,'13/5/2006',3,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR',2,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1202','CTRR',3,'30/6/2006',6.25,'Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CSDL',1,'20/7/2006',9.25,'Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CTDLGT',1,'28/12/2006',9.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1203','THDC',1,'20/5/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES ('K1203','CTRR',1,'13/5/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CSDL',1,'20/7/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CTDLGT',1,'28/12/2006',6.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1204','THDC',1,'20/5/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1204','CTRR',1,'13/5/2006',6,'Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CSDL',1,'20/12/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CTDLGT',1,'25/7/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1301','THDC',1,'20/5/2006',7.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1301','CTRR',1,'13/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CSDL',1,'20/12/2006',6.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CTDLGT',1,'25/7/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1302','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1302','CTRR',1,'13/5/2006',8.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CSDL',1,'20/12/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT',1,'25/7/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT',2,'7/8/2006',4,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTDLGT',3,'15/8/2006',4.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','THDC',1,'20/5/2006',4.5,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTRR',1,'13/5/2006',3.25,'Khong Dat')
INSERT INTO KETQUATHI VALUES ('K1303','CTRR',2,'20/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CSDL',1,'20/12/2006',7.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CTDLGT',1,'25/7/2006',9.75,'Dat')
INSERT INTO KETQUATHI VALUES ('K1304','THDC',1,'20/5/2006',5.5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1304','CTRR',1,'13/5/2006',5,'Dat')
INSERT INTO KETQUATHI VALUES ('K1305','CSDL',1,'20/12/2006',9.25,'Dat')
INSERT INTO KETQUATHI VALUES ('K1305','CTDLGT',1,'25/7/2006',10,'Dat')
INSERT INTO KETQUATHI VALUES ('K1305','THDC',1,'20/5/2006',8,'Dat')
INSERT INTO KETQUATHI VALUES ('K1305','CTRR',1,'13/5/2006',10,'Dat')

--KICH HOAT KHOA NGOAI
alter table KHOA check constraint FK_KHOA_TRGKHOA;
alter table HOCVIEN check constraint FK_HOCVIEN_MALOP;
alter table LOP check constraint FK_LOP_TRGLOP;

--II.Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):
--1. Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
update GIAOVIEN
	set HESO = HESO + HESO*0.2
	where MAGV in (select TRGKHOA from KHOA inner join GIAOVIEN on (GIAOVIEN.MAGV = KHOA.TRGKHOA));
--3. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần thứ 3 dưới 5 điểm.
update HOCVIEN
	set GHICHU = 'Cam thi'
	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV));
/*4. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
o Nếu DIEMTB  9 thì XEPLOAI =”XS”
o Nếu 8  DIEMTB < 9 thì XEPLOAI = “G”
o Nếu 6.5  DIEMTB < 8 thì XEPLOAI = “K”
o Nếu 5  DIEMTB < 6.5 thì XEPLOAI = “TB”
o Nếu DIEMTB < 5 thì XEPLOAI = ”Y”*/update HOCVIEN	set XEPLOAI = 'XS'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM >= 9))update HOCVIEN	set XEPLOAI = 'G'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM < 9 and KETQUATHI.DIEM >= 8))update HOCVIEN	set XEPLOAI = 'K'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM < 8 and KETQUATHI.DIEM >= 6.5))update HOCVIEN	set XEPLOAI = 'TB'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM < 6.5 and KETQUATHI.DIEM >= 5))update HOCVIEN	set XEPLOAI = 'Y'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM < 5))--III. Ngôn ngữ truy vấn dữ liệu:--1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
select hv.MAHV, HO, TEN, hv.MALOP 
from HOCVIEN hv, LOP l
where hv.MALOP = l.MALOP and hv.MAHV = l.TRGLOP;

--2. In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
select hv.MAHV, HO, TEN, LANTHI, DIEM
from HOCVIEN hv, KETQUATHI kq
where hv.MAHV = kq.MAHV and MALOP = 'K12' and MAMH = 'CTRR';

--3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
select hv.MAHV, HO, TEN, MAMH
from HOCVIEN hv, KETQUATHI kq
where hv.MAHV = kq.MAHV and LANTHI = 1 and KQUA = 'Dat';

--4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
select hv.MAHV, HO, TEN
from HOCVIEN hv, KETQUATHI kq
where hv.MAHV = kq.MAHV and MALOP = 'K11' and MAMH = 'CTRR' and LANTHI = 1 and KQUA = 'Khong dat';

--5. * Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
select hv.MAHV, HO, TEN, LANTHI, DIEM
from HOCVIEN hv, KETQUATHI kq
where hv.MAHV = kq.MAHV and MALOP like 'K%' and MAMH = 'CTRR' and LANTHI in (select MAX(LANTHI) from KETQUATHI) and KQUA = 'Khong dat';

--6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
select distinct mh.MAMH, TENMH
from MONHOC mh, GIANGDAY gd, GIAOVIEN gv
where mh.MAMH = gd.MAMH and gd.MAGV = gv.MAGV and HOTEN = 'Tran Tam Thanh' and HOCKY = 1 and NAM = 2006;

--7. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1 năm 2006.


--8. Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
--9. In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
--10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn học) nào.
--11. Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
--Khoa Hệ Thống Thông Tin - Đại học Công Nghệ Thông Tin
--Phan Nguyễn Thụy An
--Cơ Sở Dữ Liệu Quan Hệ
--Trang 13
--12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này.
--13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
--14. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa giáo viên đó phụ trách.
--15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ 2 môn CTRR được 5 điểm.
--16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.
--17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
--18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi)