USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_autGetListProgramAccess]    Script Date: 13/5/2564 1:19:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๙/๐๕/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลหลักสูตรตามสิทธิ์ผู้ใช้งาน>
--	1. username		เป็น varchar	รับค่าชื่อผู้ใช้งาน
--	2. systemGroup	เป็น varchar	รับค่าชื่อระบบงาน
--	3. degreeLevel	เป็น varchar	รับค่าระดับปริญญา
--	4. faculty		เป็น varchar	รับค่ารหัสคณะ
--	5. joinProgram	เป็น varchar	รับค่าชื่อโครงการ
-- =============================================
ALTER procedure [dbo].[sp_autGetListProgramAccess]
(
	@username varchar(100) = null,
	@systemGroup varchar(50) = null,
	@degreeLevel varchar(max) = null,
	@faculty varchar(255) = null,
	@program varchar(255) = null,
	@joinProgram varchar(255) = null
)	
as
begin
	set concat_null_yields_null off

	set @username = ltrim(rtrim(isnull(@username, '')))
	set @systemGroup = ltrim(rtrim(isnull(@systemGroup, '')))
	set @degreeLevel = ltrim(rtrim(isnull(@degreeLevel, '')))
	set @faculty = ltrim(rtrim(isnull(@faculty, '')))
	set @program = ltrim(rtrim(isnull(@program, '')))
	set @joinProgram = ltrim(rtrim(isnull(@joinProgram, '')))

	select	 autprg.programId,
			 autprg.programCode,
			 autprg.majorCode,
			 autprg.groupNum,			 
			 autprg.nameTh as programNameTH,
			 autprg.nameEn as programNameEN,
			 acaprg.dLevel as degreeLevel,
			 acaprg.studyYear as programYear	
	from	 fnc_autGetListProgramAccess(@username, @faculty, @systemGroup) as autprg inner join
			 acaProgram as acaprg with(nolock) on autprg.programId = acaprg.id
	where	 (len(@degreeLevel) = 0 or acaprg.dLevel = @degreeLevel) and
			 (len(@program) = 0 or charindex(autprg.programId, @program) > 0) and
			 (len(isnull(@joinProgram, '')) = 0  or 
				(@joinProgram = 'MedicalScholarsProgram' and autprg.programCode in ('BMMDB', 'DTDSB', 'EGEGB', 'MTMTB', 'PIMDB', 'PYBCM', 'RAMDB', 'SCSCB', 'SIMDB'))
			 )
	order by autprg.programId
end