USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_autGetListFacultyAccess]    Script Date: 13/5/2564 0:35:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลคณะตามสิทธิ์ผู้ใช้งาน>
--	1. username		เป็น varchar	รับค่าชื่อผู้ใช้งาน
--	2. systemGroup	เป็น varchar	รับค่าชื่อระบบงาน
--	3. faculty		เป็น varchar	รับค่ารหัสคณะ
--	4. joinProgram	เป็น varchar	รับค่าชื่อโครงการ
-- =============================================
-- sp_autGetListFacultyAccess 'thanakrit.tae','Registration','MU-01',''
-- sp_autGetListFacultyAccess 'yutthaphoom.taw','e-Profile','MU-01','MedicalScholarsProgram'

ALTER procedure [dbo].[sp_autGetListFacultyAccess]
(
	@username varchar(100) = null,
	@systemGroup varchar(50) = null,
	@faculty varchar(255) = null,
	@joinProgram varchar(255) = null
)	
as
begin
	set concat_null_yields_null off
	
	set @username = ltrim(rtrim(isnull(@username, '')))
	set @systemGroup = ltrim(rtrim(isnull(@systemGroup, '')))
	set @faculty = ltrim(rtrim(isnull(@faculty, '')))
	set @joinProgram = ltrim(rtrim(isnull(@joinProgram, '')))

	select	 facultyId,
			 facultyCode,
			 nameTh as facultyNameTH,
			 nameEn as facultyNameEN,
			 abbrevTh as facultyAbbrevTH,
			 abbrevEn as facultyAbbrevEN	
	from	 fnc_autGetListFacultyAccess(@username, @systemGroup) as autfac
			 -- แอมขอแก้ไขให้แสดง MU-01 เพื่อแสดงรายชื่อคณะในระบบ Upload Instructor Photo
			 -- 2016-06-01  
	where	 --(autfac.facultyId <> 'MU-01') AND
			 (@faculty = 'MU-01' or charindex(autfac.facultyId, @faculty) > 0) and
			 (len(isnull(@joinProgram, '')) = 0  or 
				(@joinProgram = 'MedicalScholarsProgram' and autfac.facultyCode in ('BM', 'DT', 'EG', 'MT', 'PI', 'PY', 'RA', 'SC', 'SI'))
			 )
	order by autfac.facultyId			
end