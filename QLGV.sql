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
--1. T???o quan h??? v?? khai b??o t???t c??? c??c r??ng bu???c kh??a ch??nh, kh??a ngo???i. Th??m v??o 3 thu???c t??nh GHICHU, DIEMTB, XEPLOAI cho quan h??? HOCVIEN.
alter table HOCVIEN
	add GHICHU varchar(100),
		DIEMTB float,
		XEPLOAI varchar(10);

--2. M?? h???c vi??n l?? m???t chu???i 5 k?? t???, 3 k?? t??? ?????u l?? m?? l???p, 2 k?? t??? cu???i c??ng l?? s??? th??? t??? h???c vi??n trong l???p. VD: ???K1101???
alter table HOCVIEN
	add ID int identity(1,1);
alter table HOCVIEN
	--drop constraint MAHV_CHECK;
	add constraint MAHV_CHECK check (len(MAHV) = 5 and left(MAHV, 3)=MALOP and (right(MAHV, 2) = cast(ID as varchar(99)) or (ID < 10 and right(MAHV, 1) = cast(ID as varchar(99)))));

--3. Thu???c t??nh GIOITINH ch??? c?? gi?? tr??? l?? ???Nam??? ho???c ???Nu???.
alter table HOCVIEN
	add constraint GT_CHECK check (GIOITINH = 'Nam' or GIOITINH = 'Nu');

--4. ??i???m s??? c???a m???t l???n thi c?? gi?? tr??? t??? 0 ?????n 10 v?? c???n l??u ?????n 2 s??? l??? (VD: 6.22).
alter table KETQUATHI
	add constraint DIEMTHI_CHECK check (DIEM >= 0 and DIEM <=10); 

--5. K???t qu??? thi l?? ???Dat??? n???u ??i???m t??? 5 ?????n 10 v?? ???Khong dat??? n???u ??i???m nh??? h??n 5.
alter table KETQUATHI
	add constraint KQ_CHECK check (
		(KQUA = 'Dat' AND DIEM BETWEEN 5 AND 10)
		OR (KQUA = 'Khong dat' AND DIEM < 5)
	); 
--6. H???c vi??n thi m???t m??n t???i ??a 3 l???n.
alter table KETQUATHI
	add constraint LT_CHECK check (LANTHI <= 3);

--7. H???c k??? ch??? c?? gi?? tr??? t??? 1 ?????n 3.
alter table GIANGDAY
	add constraint HK_CHECK check (HOCKY <= 3 and HOCKY >=1);

--8. H???c v??? c???a gi??o vi??n ch??? c?? th??? l?? ???CN???, ???KS???, ???Ths???, ???TS???, ???PTS???.
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

--II.Ng??n ng??? thao t??c d??? li???u (Data Manipulation Language):
--1. T??ng h??? s??? l????ng th??m 0.2 cho nh???ng gi??o vi??n l?? tr?????ng khoa.
update GIAOVIEN
	set HESO = HESO + HESO*0.2
	where MAGV in (select TRGKHOA from KHOA inner join GIAOVIEN on (GIAOVIEN.MAGV = KHOA.TRGKHOA));
--3. C???p nh???t gi?? tr??? cho c???t GHICHU l?? ???Cam thi??? ?????i v???i tr?????ng h???p: h???c vi??n c?? m???t m??n b???t k??? thi l???n th??? 3 d?????i 5 ??i???m.
update HOCVIEN
	set GHICHU = 'Cam thi'
	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV));
/*4. C???p nh???t gi?? tr??? cho c???t XEPLOAI trong quan h??? HOCVIEN nh?? sau:
o N???u DIEMTB ??? 9 th?? XEPLOAI =???XS???
o N???u 8 ??? DIEMTB < 9 th?? XEPLOAI = ???G???
o N???u 6.5 ??? DIEMTB < 8 th?? XEPLOAI = ???K???
o N???u 5 ??? DIEMTB < 6.5 th?? XEPLOAI = ???TB???
o N???u DIEMTB < 5 th?? XEPLOAI = ???Y???*/update HOCVIEN	set XEPLOAI = 'XS'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM >= 9))update HOCVIEN	set XEPLOAI = 'G'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM < 9 and KETQUATHI.DIEM >= 8))update HOCVIEN	set XEPLOAI = 'K'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM < 8 and KETQUATHI.DIEM >= 6.5))update HOCVIEN	set XEPLOAI = 'TB'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM < 6.5 and KETQUATHI.DIEM >= 5))update HOCVIEN	set XEPLOAI = 'Y'	where MAHV in (select KETQUATHI.MAHV from KETQUATHI inner join HOCVIEN on (HOCVIEN.MAHV = KETQUATHI.MAHV and KETQUATHI.DIEM < 5))--III. Ng??n ng??? truy v???n d??? li???u:--1. In ra danh s??ch (m?? h???c vi??n, h??? t??n, ng??y sinh, m?? l???p) l???p tr?????ng c???a c??c l???p.
select hv.MAHV, HO, TEN, hv.MALOP 
from HOCVIEN hv, LOP l
where hv.MALOP = l.MALOP and hv.MAHV = l.TRGLOP;

--2. In ra b???ng ??i???m khi thi (m?? h???c vi??n, h??? t??n , l???n thi, ??i???m s???) m??n CTRR c???a l???p ???K12???, s???p x???p theo t??n, h??? h???c vi??n.
select hv.MAHV, HO, TEN, LANTHI, DIEM
from HOCVIEN hv, KETQUATHI kq
where hv.MAHV = kq.MAHV and MALOP = 'K12' and MAMH = 'CTRR';

--3. In ra danh s??ch nh???ng h???c vi??n (m?? h???c vi??n, h??? t??n) v?? nh???ng m??n h???c m?? h???c vi??n ???? thi l???n th??? nh???t ???? ?????t.
select hv.MAHV, HO, TEN, MAMH
from HOCVIEN hv, KETQUATHI kq
where hv.MAHV = kq.MAHV and LANTHI = 1 and KQUA = 'Dat';

--4. In ra danh s??ch h???c vi??n (m?? h???c vi??n, h??? t??n) c???a l???p ???K11??? thi m??n CTRR kh??ng ?????t (??? l???n thi 1).
select hv.MAHV, HO, TEN
from HOCVIEN hv, KETQUATHI kq
where hv.MAHV = kq.MAHV and MALOP = 'K11' and MAMH = 'CTRR' and LANTHI = 1 and KQUA = 'Khong dat';

--5. * Danh s??ch h???c vi??n (m?? h???c vi??n, h??? t??n) c???a l???p ???K??? thi m??n CTRR kh??ng ?????t (??? t???t c??? c??c l???n thi).
select hv.MAHV, HO, TEN, LANTHI, DIEM
from HOCVIEN hv, KETQUATHI kq
where hv.MAHV = kq.MAHV and MALOP like 'K%' and MAMH = 'CTRR' and LANTHI in (select MAX(LANTHI) from KETQUATHI) and KQUA = 'Khong dat';

--6. T??m t??n nh???ng m??n h???c m?? gi??o vi??n c?? t??n ???Tran Tam Thanh??? d???y trong h???c k??? 1 n??m 2006.
select distinct mh.MAMH, TENMH
from MONHOC mh, GIANGDAY gd, GIAOVIEN gv
where mh.MAMH = gd.MAMH and gd.MAGV = gv.MAGV and HOTEN = 'Tran Tam Thanh' and HOCKY = 1 and NAM = 2006;

--7. T??m nh???ng m??n h???c (m?? m??n h???c, t??n m??n h???c) m?? gi??o vi??n ch??? nhi???m l???p ???K11??? d???y trong h???c k??? 1 n??m 2006.


--8. T??m h??? t??n l???p tr?????ng c???a c??c l???p m?? gi??o vi??n c?? t??n ???Nguyen To Lan??? d???y m??n ???Co So Du Lieu???.
--9. In ra danh s??ch nh???ng m??n h???c (m?? m??n h???c, t??n m??n h???c) ph???i h???c li???n tr?????c m??n ???Co So Du Lieu???.
--10. M??n ???Cau Truc Roi Rac??? l?? m??n b???t bu???c ph???i h???c li???n tr?????c nh???ng m??n h???c (m?? m??n h???c, t??n m??n h???c) n??o.
--11. T??m h??? t??n gi??o vi??n d???y m??n CTRR cho c??? hai l???p ???K11??? v?? ???K12??? trong c??ng h???c k??? 1 n??m 2006.
--Khoa H??? Th???ng Th??ng Tin - ?????i h???c C??ng Ngh??? Th??ng Tin
--Phan Nguy???n Th???y An
--C?? S??? D??? Li???u Quan H???
--Trang 13
--12. T??m nh???ng h???c vi??n (m?? h???c vi??n, h??? t??n) thi kh??ng ?????t m??n CSDL ??? l???n thi th??? 1 nh??ng ch??a thi l???i m??n n??y.
--13. T??m gi??o vi??n (m?? gi??o vi??n, h??? t??n) kh??ng ???????c ph??n c??ng gi???ng d???y b???t k??? m??n h???c n??o.
--14. T??m gi??o vi??n (m?? gi??o vi??n, h??? t??n) kh??ng ???????c ph??n c??ng gi???ng d???y b???t k??? m??n h???c n??o thu???c khoa gi??o vi??n ???? ph??? tr??ch.
--15. T??m h??? t??n c??c h???c vi??n thu???c l???p ???K11??? thi m???t m??n b???t k??? qu?? 3 l???n v???n ???Khong dat??? ho???c thi l???n th??? 2 m??n CTRR ???????c 5 ??i???m.
--16. T??m h??? t??n gi??o vi??n d???y m??n CTRR cho ??t nh???t hai l???p trong c??ng m???t h???c k??? c???a m???t n??m h???c.
--17. Danh s??ch h???c vi??n v?? ??i???m thi m??n CSDL (ch??? l???y ??i???m c???a l???n thi sau c??ng).
--18. Danh s??ch h???c vi??n v?? ??i???m thi m??n ???Co So Du Lieu??? (ch??? l???y ??i???m cao nh???t c???a c??c l???n thi)