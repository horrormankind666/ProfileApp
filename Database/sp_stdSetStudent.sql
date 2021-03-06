USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_stdSetStudent]    Script Date: 12/5/2564 23:08:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๔/๑๐/๒๕๕๘>
-- Description	: <สำหรับบันทึกข้อมูลตาราง stdStudent ครั้งละ ๑ เรคคอร์ด>
--  1. action				เป็น varchar	รับค่าการกระทำกับฐานข้อมูล
--  2. personId 			เป็น varchar	รับค่ารหัสบุคคล
--	3. faculty				เป็น varchar	รับค่ารหัสคณะ
--	4. program				เป็น varchar	รับค่าหลักสูตร
--	5. degreeLevel			เป็น varchar	รับค่าระดับปริญญา
--	6. programYear			เป็น varchar	รับค่าจำนวนปีที่ศึกษาตามหลักสูตร
--  7. class				เป็น varchar	รับค่าชั้นปี
--  8. entranceType			เป็น varchar	รับค่าระบบการสอบเข้า
--  9. studentStatus		เป็น varchar	รับค่าสถานภาพการเป็นนักศึกษา
-- 10. graduateDate			เป็น varchar	รับค่าวันที่สำเร็จการศึกษาหรือวันที่ออกจากการศึกษา
-- 11. updateWhat			เป็น varchar	รับค่าปรับปรุงอะไร
-- 12. updateReason			เป็น varchar	รับค่าเหตุผลที่ปรับปรุง
-- 13. pictureName			เป็น varchar	รับค่าชื่อรูปภาพประจำตัว
-- 14. mspJoin				เป็น varchar	รับค่าสถานะการเข้าโครงการผลิตอาจารย์แพทย์
-- 15. startSemester		เป็น varchar	รับค่าภาคเรียนเริ่มต้น
-- 16. startYear			เป็น varchar	รับค่าปีเริ่มต้น
-- 17. endSemester			เป็น varchar	รับค่าภาคเรียนสิ้นสุด
-- 18. endYear				เป็น varchar	รับค่าปีสิ้นสุด
-- 19. resignDate			เป็น varchar	รับค่าวันที่ออกจากโครงการ
-- 20. by					เป็น varchar	รับค่าชื่อของผู้ที่กระทำกับฐานข้อมูล
-- 21. ip					เป็น varchar	รับค่าหมายเลขไอพีของผู้ที่กระทำกับฐานข้อมูล
-- =============================================
ALTER procedure [dbo].[sp_stdSetStudent]
(
	@action varchar(10) = null,
	@personId varchar(10) = null,
	@faculty varchar(15) = null,
	@program varchar(15) = null,
	@class varchar(1) = null,
	@entranceType varchar(20) = null,
	@studentStatus varchar(3) = null,
	@admissionDate varchar(20) = null,
	@yearEntry varchar(4) = null,
	@graduateDate varchar(20) = null,
	@updateWhat varchar(100) = null,
	@updateReason varchar(255) = null,
	@pictureName varchar(100) = null,
	@mspJoin varchar(1) = null,
	@startSemester varchar(1) = null,
	@startYear varchar(4) = null,	
	@endSemester varchar(1) = null,
	@endYear varchar(4) = null,	
	@resignDate varchar(20) = null,
	@by varchar(255) = null,
	@ip varchar(255) = null
)
as
begin
	set concat_null_yields_null off

	set @action = ltrim(rtrim(@action))
	set @personId = ltrim(rtrim(@personId))	
	set @faculty = ltrim(rtrim(@faculty))
	set @program = ltrim(rtrim(@program))
	set @class = ltrim(rtrim(@class))
	set @entranceType = ltrim(rtrim(@entranceType))
	set @studentStatus = ltrim(rtrim(@studentStatus))
	set	@admissionDate = ltrim(rtrim(@admissionDate))
	set @yearEntry = ltrim(rtrim(@yearEntry))
	set @graduateDate = ltrim(rtrim(@graduateDate))
	set @updateWhat = ltrim(rtrim(@updateWhat))
	set @updateReason = ltrim(rtrim(@updateReason))
	set @pictureName = ltrim(rtrim(@pictureName))
	set @mspJoin = ltrim(rtrim(@mspJoin))
	set @startSemester = ltrim(rtrim(@startSemester))
	set @startYear = ltrim(rtrim(@startYear))
	set @endSemester = ltrim(rtrim(@endSemester))
	set @endYear = ltrim(rtrim(@endYear))
	set @resignDate = ltrim(rtrim(@resignDate))
	set @by = ltrim(rtrim(@by))
	set @ip = ltrim(rtrim(@ip))
		
	declare @studentId varchar(7) = null
	declare @major varchar(4) = null
	declare @groupNum varchar(1) = null
	declare @facultyNameTH varchar(200) = null
	declare @programNameTH varchar(200) = null
	declare @programYear varchar(2) = null
	declare @degreeLevel varchar(2) = null
	declare @facultyId varchar(15) = null
	declare @programId varchar(15) = null
	declare @courseYear varchar(4) = null
	declare	@acaYear varchar(4) = null
	declare @table varchar(50) = 'stdStudent'
	declare @rowCount int = 0
	declare @rowCountUpdate int = 0
	declare @value nvarchar(max) = null
	declare	@strBlank varchar(50) = '----------**********.........0.0000000000000000000'

	set @action = upper(@action)
	
	if (@action = 'INSERT' or @action = 'UPDATE' or @action = 'DELETE')
	begin
		set @value = 'personId='			+ (case when (@personId is not null and len(@personId) > 0 and charindex(@personId, @strBlank) = 0) then ('"' + @personId + '"') else 'null' end) + ', ' +
					 'facultyId='			+ (case when (@faculty is not null and len(@faculty) > 0 and charindex(@faculty, @strBlank) = 0) then ('"' + @faculty + '"') else 'null' end) + ', ' +
					 'programId='			+ (case when (@program is not null and len(@program) > 0 and charindex(@program, @strBlank) = 0) then ('"' + @program + '"') else 'null' end) + ', ' +
					 'class='				+ (case when (@class is not null and len(@class) > 0 and charindex(@class, @strBlank) = 0) then ('"' + @class + '"') else 'null' end) + ', ' +
					 'entranceType='		+ (case when (@entranceType is not null and len(@entranceType) > 0) then ('"' + @entranceType + '"') else 'null' end) + ', ' +
					 'status='				+ (case when (@studentStatus is not null and len(@studentStatus) > 0) then ('"' + @studentStatus + '"') else 'null' end) + ', ' +
					 'admissionDate='		+ (case when (@admissionDate is not null and len(@admissionDate) > 0 and charindex(@admissionDate, @strBlank) = 0) then ('"' + @admissionDate + '"') else 'null' end) + ', ' +
					 'acaYear='				+ (case when (@acaYear is not null and len(@acaYear) > 0 and charindex(@acaYear, @strBlank) = 0) then ('"' + @acaYear + '"') else 'null' end) + ', ' +
					 'yearEntry='			+ (case when (@yearEntry is not null and len(@yearEntry) > 0 and charindex(@yearEntry, @strBlank) = 0) then ('"' + @yearEntry + '"') else 'null' end) + ', ' +
					 'graduateDate='		+ (case when (@graduateDate is not null and len(@graduateDate) > 0 and charindex(@graduateDate, @strBlank) = 0) then ('"' + @graduateDate + '"') else 'null' end) + ', ' +
					 'updateWhat='			+ (case when (@updateWhat is not null and len(@updateWhat) > 0 and charindex(@updateWhat, @strBlank) = 0) then ('"' + @updateWhat + '"') else 'null' end) + ', ' +
					 'updateReason='		+ (case when (@updateReason is not null and len(@updateReason) > 0 and charindex(@updateReason, @strBlank) = 0) then ('"' + @updateReason + '"') else 'null' end) + ', ' +
					 'picturename='			+ (case when (@pictureName is not null and len(@pictureName) > 0 and charindex(@pictureName, @strBlank) = 0) then ('"' + @pictureName + '"') else 'null' end) + ', ' +
					 'mspJoin='				+ (case when (@mspJoin is not null and len(@mspJoin) > 0 and charindex(@mspJoin, @strBlank) = 0) then ('"' + @mspJoin + '"') else 'null' end) + ', ' +
					 'mspStartSemester='	+ (case when (@mspJoin = 'Y' and @startSemester is not null and len(@startSemester) > 0 and charindex(@startSemester, @strBlank) = 0) then ('"' + @startSemester + '"') else 'null' end) + ', ' +
					 'mspStartYear='		+ (case when (@mspJoin = 'Y' and @startYear is not null and len(@startYear) > 0 and charindex(@startYear, @strBlank) = 0) then ('"' + @startYear + '"') else 'null' end) + ', ' +
					 'mspEndSemester='		+ (case when (@mspJoin = 'Y' and @endSemester is not null and len(@endSemester) > 0 and charindex(@endSemester, @strBlank) = 0) then ('"' + @endSemester + '"') else 'null' end) + ', ' +
					 'mspEndYear='			+ (case when (@mspJoin = 'Y' and @endYear is not null and len(@endYear) > 0 and charindex(@endYear, @strBlank) = 0) then ('"' + @endYear + '"') else 'null' end) + ', ' +
					 'mspResignDate='		+ (case when (@mspJoin = 'Y' and @resignDate is not null and len(@resignDate) > 0 and charindex(@resignDate, @strBlank) = 0) then ('"' + @resignDate + '"') else 'null' end)
					 					    
  		if (@updateWhat = 'UpdateFacultyProgram')
		begin
			IF (@program is not null and len(@program) > 0)
			begin
				select  @degreeLevel	= dLevel,
						@programYear	= studyYear
				from	Infinity..acaProgram with(nolock)
				where	id = @program
			end
		end

		if (@updateWhat = 'UpdateAdmissionDate')
		begin
			if (@yearEntry is not null and len(@yearEntry) > 0)
			begin
				select	@degreeLevel	= degree,
						@facultyId		= facultyId,
						@programId		= programId,
						@courseYear		= courseYear
				from	dbo.fnc_perGetPersonStudent(@personId)

				set @acaYear = dbo.fnc_acaGetProgramStrucCourseYear('U0001', @courseYear, @degreeLevel, @facultyId, @programId)
			end
		end
		
		begin try
			begin tran
				if (@action = 'INSERT')
				begin
 					insert into stdStudent
 					(
						personId,
						facultyId,
						programId,
						degree,
						programYear,
						status,
						class,
						admissionType,
						admissionDate,
						acaYear,
						yearEntry,
						createdDate,
						createdBy,
						graduateDate,
						updateWhat,
						updateReason,
						pictureName,
						mspJoin,
						mspStartSemester,
						mspStartYear,
						mspEndSemester,
						mspEndYear,
						mspResignDate
					)
					values
					(
						case when (@personId is not null and len(@personId) > 0 and charindex(@personId, @strBlank) = 0) then @personId else null end,
						case when (@faculty is not null and len(@faculty) > 0 and charindex(@faculty, @strBlank) = 0) then @faculty else null end,
						case when (@program is not null and len(@program) > 0 and charindex(@program, @strBlank) = 0) then @program else null end,
						case when (@degreeLevel is not null and len(@degreeLevel) > 0 and charindex(@degreeLevel, @strBlank) = 0) then @degreeLevel else null end,
						case when (@programYear is not null and len(@programYear) > 0 and charindex(@programYear, @strBlank) = 0) then @programYear else null end,
						case when (@studentStatus is not null and len(@studentStatus) > 0) then @studentStatus else null end,
						case when (@class is not null and len(@class) > 0 and charindex(@class, @strBlank) = 0) then @class else null end,
						case when (@entranceType is not null and len(@entranceType) > 0 and charindex(@entranceType, @strBlank) = 0) then @entranceType else null end,
						case when (@admissionDate is not null and len(@admissionDate) > 0 and charindex(@admissionDate, @strBlank) = 0) then convert(datetime, @admissionDate, 103) else null end,
						case when (@acaYear is not null and len(@acaYear) > 0 and charindex(@acaYear, @strBlank) = 0) then @acaYear else null end,
						case when (@yearEntry is not null and len(@yearEntry) > 0 and charindex(@yearEntry, @strBlank) = 0) then @yearEntry else null end,
						getdate(),
						case when (@by is not null and len(@by) > 0 and charindex(@by, @strBlank) = 0) then @by else null end,
						case when (@graduateDate is not null and len(@graduateDate) > 0 and charindex(@graduateDate, @strBlank) = 0) then convert(datetime, @graduateDate, 103) else null end,
						case when (@updateWhat is not null and len(@updateWhat) > 0 and charindex(@updateWhat, @strBlank) = 0) then @updateWhat else null end,
						case when (@updateReason is not null and len(@updateReason) > 0 and charindex(@updateReason, @strBlank) = 0) then @updateReason else null end,
						case when (@pictureName is not null and len(@pictureName) > 0 and charindex(@pictureName, @strBlank) = 0) then @pictureName else null end,						
						case when (@mspJoin is not null and len(@mspJoin) > 0 and charindex(@mspJoin, @strBlank) = 0) then @mspJoin else null end,
						case when (@mspJoin = 'Y' and @startSemester is not null and len(@startSemester) > 0 and charindex(@startSemester, @strBlank) = 0) then @startSemester else null end,
						case when (@mspJoin = 'Y' and @startYear is not null and len(@startYear) > 0 and charindex(@startYear, @strBlank) = 0) then @startYear else null end,
						case when (@mspJoin = 'Y' and @endSemester is not null and len(@endSemester) > 0 and charindex(@endSemester, @strBlank) = 0) then @endSemester else null end,
						case when (@mspJoin = 'Y' and @endYear is not null and len(@endYear) > 0 and charindex(@endYear, @strBlank) = 0) then @endYear else null end,
						case when (@mspJoin = 'Y' and @resignDate is not null and len(@resignDate) > 0 and charindex(@resignDate, @strBlank) = 0) then @resignDate else null end
					)		
					
					set @rowCount = @rowCount + 1
				end
				
				if (@action = 'UPDATE')
				begin
					if (@personId is not null and len(@personId) > 0 and charindex(@personId, @strBlank) = 0)
					begin
						set @rowCountUpdate = (select count(personId) from stdStudent with(nolock) where personId = @personId)
						
						if (@rowCountUpdate > 0)
						begin
							update stdStudent set
								facultyId			= case when (@faculty is not null and len(@faculty) > 0 and charindex(@faculty, @strBlank) = 0) then @faculty else (case when (@faculty is not null and (len(@faculty) = 0 or charindex(@faculty, @strBlank) > 0)) then null else facultyId end) end,
								programId			= case when (@program is not null and len(@program) > 0 and charindex(@program, @strBlank) = 0) then @program else (case when (@program is not null and (len(@program) = 0 or charindex(@program, @strBlank) > 0)) then null else programId end) end,
								degree				= case when (@degreeLevel is not null and len(@degreeLevel) > 0 and charindex(@degreeLevel, @strBlank) = 0) then @degreeLevel else (case when (@degreeLevel is not null and (len(@degreeLevel) = 0 or charindex(@degreeLevel, @strBlank) > 0)) then null else degree end) end,
								programYear			= case when (@programYear is not null and len(@programYear) > 0 and charindex(@programYear, @strBlank) = 0) then @programYear else (case when (@programYear is not null and (len(@programYear) = 0 or charindex(@programYear, @strBlank) > 0)) then null else programYear end) end,
								status				= case when (@studentStatus is not null and len(@studentStatus) > 0) then @studentStatus else (case when (@studentStatus is not null and len(@studentStatus) = 0) then null else status end) end,
								class				= case when (@class is not null and len(@class) > 0 and charindex(@class, @strBlank) = 0) then @class else (case when (@class is not null and (len(@class) = 0 or charindex(@class, @strBlank) > 0)) then null else class end) end,
								admissionType		= case when (@entranceType is not null and len(@entranceType) > 0 and charindex(@entranceType, @strBlank) = 0) then @entranceType else (case when (@entranceType is not null and (len(@entranceType) = 0 or charindex(@entranceType, @strBlank) > 0)) then null else admissionType end) end,
								admissionDate		= case when (@admissionDate is not null and len(@admissionDate) > 0 and charindex(@admissionDate, @strBlank) = 0) then convert(datetime, @admissionDate, 103) else (case when (@admissionDate is not null and (len(@admissionDate) = 0 or charindex(@admissionDate, @strBlank) > 0)) then null else admissionDate end) end,
								acaYear				= case when (@acaYear is not null and len(@acaYear) > 0 and charindex(@acaYear, @strBlank) = 0) then @acaYear else (case when (@acaYear is not null and (len(@acaYear) = 0 or charindex(@acaYear, @strBlank) > 0)) then null else acaYear end) end,
								yearEntry			= case when (@yearEntry is not null and len(@yearEntry) > 0 and charindex(@yearEntry, @strBlank) = 0) then @yearEntry else (case when (@yearEntry is not null and (len(@yearEntry) = 0 or charindex(@yearEntry, @strBlank) > 0)) then null else yearEntry end) end,
								graduateDate		= case when (@graduateDate is not null and len(@graduateDate) > 0 and charindex(@graduateDate, @strBlank) = 0) then convert(datetime, @graduateDate, 103) else (case when (@graduateDate is not null and (len(@graduateDate) = 0 or charindex(@graduateDate, @strBlank) > 0)) then null else graduateDate end) end,
								modifyDate			= getdate(),
								modifyBy			= case when (@by is not null and len(@by) > 0 and charindex(@by, @strBlank) = 0) then @by else (case when (@by is not null and (len(@by) = 0 or charindex(@by, @strBlank) > 0)) then null else modifyBy end) end,
								modifyIp			= case when (@ip is not null and len(@ip) > 0 and charindex(@ip, @strBlank) = 0) then @ip else (case when (@ip is not null and (len(@ip) = 0 or charindex(@ip, @strBlank) > 0)) then null else modifyIp end) end,
								updateWhat			= case when (@updateWhat is not null and len(@updateWhat) > 0 and charindex(@updateWhat, @strBlank) = 0) then @updateWhat else (case when (@updateWhat is not null and (len(@updateWhat) = 0 or charindex(@updateWhat, @strBlank) > 0)) then null else updateWhat end) end,
								updateReason		= case when (@updateReason is not null and len(@updateReason) > 0 and charindex(@updateReason, @strBlank) = 0) then @updateReason else (case when (@updateReason is not null and (len(@updateReason) = 0 or charindex(@updateReason, @strBlank) > 0)) then null else updateReason end) end,
								pictureName			= case when (@pictureName is not null and len(@pictureName) > 0 and charindex(@pictureName, @strBlank) = 0) then @pictureName else (case when (@pictureName is not null and (len(@pictureName) = 0 or charindex(@pictureName, @strBlank) > 0)) then null else pictureName end) end,
								mspJoin				= case when (@mspJoin is not null and len(@mspJoin) > 0 and charindex(@mspJoin, @strBlank) = 0) then @mspJoin else (case when (@mspJoin is not null and (len(@mspJoin) = 0 or charindex(@mspJoin, @strBlank) > 0)) then null else mspJoin end) end,
								mspStartSemester	= case when (@mspJoin = 'Y' and @startSemester is not null and len(@startSemester) > 0 and charindex(@startSemester, @strBlank) = 0) then @startSemester else (case when (@startSemester is not null and (len(@startSemester) = 0 or charindex(@startSemester, @strBlank) > 0)) then null else mspStartSemester end) end,
								mspStartYear		= case when (@mspJoin = 'Y' and @startYear is not null and len(@startYear) > 0 and charindex(@startYear, @strBlank) = 0) then @startYear else (case when (@startYear is not null and (len(@startYear) = 0 or charindex(@startYear, @strBlank) > 0)) then null else mspStartYear end) end,
								mspEndSemester		= case when (@mspJoin = 'Y' and @endSemester is not null and len(@endSemester) > 0 and charindex(@endSemester, @strBlank) = 0) then @endSemester else (case when (@endSemester is not null and (len(@endSemester) = 0 or charindex(@endSemester, @strBlank) > 0)) then null else mspEndSemester end) end,
								mspEndYear			= case when (@mspJoin = 'Y' and @endYear is not null and len(@endYear) > 0 and charindex(@endYear, @strBlank) = 0) then @endYear else (case when (@endYear is not null and (len(@endYear) = 0 or charindex(@endYear, @strBlank) > 0)) then null else mspEndYear end) end,
								mspResignDate		= case when (@mspJoin = 'Y' and @resignDate is not null and len(@resignDate) > 0 and charindex(@resignDate, @strBlank) = 0) then @resignDate else (case when (@resignDate is not null and (len(@resignDate) = 0 or charindex(@resignDate, @strBlank) > 0)) then null else mspResignDate end) end
							where personId = @personId
						end

						set @rowCount = @rowCount + 1							
					end
				end
			commit tran
		end try
		begin catch
			rollback tran
			insert into InfinityLog..stdStudentErrorLog
			(
				errorDatabase,
				errorTable,
				errorAction,
				errorValue,
				errorMessage,
				errorNumber,
				errorSeverity,
				errorState,
				errorLine,
				errorProcedure,
				errorActionDate,
				errorActionBy,
				errorIp
			)
			values
			(
				db_name(),
				@table,
				@action,
				@value,
				error_message(),
				error_number(),
				error_severity(),
				error_state(),
				error_line(),
				error_procedure(),
				getdate(),
				case when (@by is not null and len(@by) > 0 and charindex(@by, @strBlank) = 0) then @by else null end,
				case when (@ip is not null and len(@ip) > 0 and charindex(@ip, @strBlank) = 0) then @ip else null end
			)			
		end catch
	end
	
	select @rowCount
	
	if (@rowCount > 0)
	begin
		select	@studentId = studentCode
		from	stdStudent with(nolock)
		where	personId = @personId
					
		if (@studentId is not null and len(@studentId) > 0 and charindex(@studentId, @strBlank) = 0)
		begin
			if (@updateWhat = 'UpdateFacultyProgram')
			begin
				select	@program		= acaprg.programCode,
						@major			= acaprg.majorCode,
						@groupNum		= acaprg.groupNum,
						@programYear	= acaprg.studyYear,
						@degreeLevel	= acaprg.dLevel,
						@facultyNameTH	= acafac.nameTh,
						@programNameTH	= acaprg.nameTh
				from	Infinity..acaProgram as acaprg with(nolock) left join
						Infinity..acaFaculty as acafac with(nolock) on acaprg.facultyId = acafac.id
				where	acaprg.id = @program
				
				update MUStudent..Student set
					ProgramCode	= @program,
					MajorCode	= @major,
					GroupNum	= @groupNum,
					ProgramYear = @programYear,
					Degree		= @degreeLevel
				where StudentID = @studentId	
				
				update MURegistration..WebStudentInfo set
					ProgramCode	= @program,
					Major		= @major,
					GroupNum	= @groupNum,
					Faculty		= @facultyNameTH,
					ProgramName	= @programNameTH,
					MajorName	= @major
				where StudentID = @studentId	
			end
			
			if (@updateWhat = 'UpdateClassYear')
			begin
				update MUStudent..StudentStatus set
					CurrentYear	= @class
				where StudentID = @studentId					

				update MURegistration..WebStudentInfo set
					CurrentYear	= @class
				where StudentID = @studentId
			end
			
			if (@updateWhat = 'UpdateEntranceType')
			begin
				select	@entranceType = perent.idOld
				from	Infinity..perEntranceType as perent with(nolock)
				where	perent.id = @entranceType

				update MUStudent..Student set
					EntType	= @entranceType
				where StudentID = @studentId	
				
				update MURegistration..WebStudentInfo set
					EntType = @entranceType
				where StudentID = @studentId
			end

			if (@updateWhat = 'UpdateStudentStatus')
			begin
				select	@studentStatus = oldId
				from	Infinity..stdStatusType with(nolock)
				where	id = @studentStatus
				
				update MUStudent..StudentStatus set
					StudentStatus	= @studentStatus,
					GraduateDate	= case when (@graduateDate is not null and len(@graduateDate) > 0 and charindex(@graduateDate, @strBlank) = 0) then convert(datetime, @graduateDate, 103) else null end
				where StudentID = @studentId
				
				update MURegistration..WebStudentInfo set
					CurStatus = @studentStatus
				where StudentID = @studentId							
			end			
		
			if (@updateWhat = 'UpdateAdmissionDate')
			begin
				update MUStudent..Student set
					AdmissionDate = convert(datetime, @admissionDate, 103)
				where StudentID = @studentId	
			end
			/*
			if (@updateWhat = 'UpdateStudentDistinctionProgram')
			begin
				update MUStudent..Student set
					Distinction = @distinctionStatus
				where StudentID = @studentId
			end
			*/			
			set @rowCountUpdate = (select count(Studentid) from MUStudent..SReasonleave with(nolock) where Studentid = @studentId)
			
			if (@rowCountUpdate = 0)
			begin
				insert into MUStudent..SReasonleave
				(
					Studentid,
					Reason
				)
				values
				(
					@studentId,
					case when (@updateReason is not null and len(@updateReason) > 0 and charindex(@updateReason, @strBlank) = 0) then @updateReason else null end
				)									
			end
			
			if (@rowCountUpdate > 0)
			begin
				update MUStudent..SReasonleave set
					Reason = case when (@updateReason is not null and len(@updateReason) > 0 and charindex(@updateReason, @strBlank) = 0) then @updateReason else null end
				where Studentid = @studentId					
			end
		end
	end	
end