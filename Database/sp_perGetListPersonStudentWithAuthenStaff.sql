USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetListPersonStudentWithAuthenStaff]    Script Date: 13/5/2564 1:40:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๘/๒๕๖๐>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษาตามสิทธิ์ผู้ใช้งาน>
-- Parameter
--	1. username					เป็น varchar	รับค่าชื่อผู้ใช้งาน
--	2. userlevel				เป็น varchar	รับค่าระดับผู้ใช้งาน
--	3. systemGroup				เป็น varchar	รับค่าชื่อระบบงาน
--	4. reportName				เป็น varchar	รับค่าชื่อรายงาน
--	5. keyword					เป็น varchar	รับค่าคำค้น
--	6. degreeLevelId			เป็น varchar	รับค่าระดับปริญญา
--	7. facultyId				เป็น varchar	รับค่ารหัสคณะ
--	8. programId				เป็น varchar	รับค่าหลักสูตร
--  9. yearEntry				เป็น varchar	รับค่าปีที่เข้าศึกษา
-- 10. yearGraduate				เป็น varchar	รับค่าปีที่จบการศึกษา
-- 11. class					เป็น varchar	รับค่าชั้นปี
-- 12. entranceTypeId			เป็น varchar	รับค่าระบบการสอบเข้า
-- 13. studentStatusTypeId		เป็น varchar	รับค่าสถานภาพการเป็นนักศึกษา
-- 14. studentStatusTypeGroup	เป็น varchar	รับค่ากลุ่มสถานภาพการเป็นนักศึกษา
-- 15. studentRecordsStatus		เป็น varchar	รับค่าสถานะการบันทึกระเบียนประวัตินักศึกษา
-- 16. distinctionStatus		เป็น varchar	รับค่าหลักสูตรพิสิฐวิธาน
-- 17. joinProgram				เป็น varchar	รับค่าชื่อโครงการ
-- 18. joinProgramStatus		เป็น varchar	รับค่าสถานะการเข้าโครงการ
-- 19. startAcademicYear		เป็น varchar	รับค่าปีการศึกษาเริ่มต้น
-- 20. endAcademicYear			เป็น varchar	รับค่าปีการศึกษาสิ้นสุด
-- 21. genderId					เป็น varchar	รับค่าเพศ
-- 22. nationalityId			เป็น varchar	รับค่าสัญชาติ
-- 23. sortOrderBy				เป็น varchar	รับค่าคอลัมภ์ที่ต้องการเรียงลำดับ
-- 24. sortExpression			เป็น varchar	รับค่าวิธีการเรียงลำดับ
-- =============================================
ALTER procedure [dbo].[sp_perGetListPersonStudentWithAuthenStaff]
(
	@username varchar(255) = null,
	@userlevel varchar(20) = null,
	@systemGroup varchar(50) = null,
	@reportName varchar(100) = null,
	@keyword varchar(3000) = null,
	@degreeLevelId varchar(1) = null,
	@facultyId varchar(15) = null,
	@programId varchar(15) = null,
	@yearEntry varchar(4) = null,
	@yearGraduate varchar(4) = null,
	@class varchar(3) = null,
	@entranceTypeId varchar(20) = null,
	@studentStatusTypeId varchar(3) = null,
	@studentStatusTypeGroup varchar(2) = null,
	@studentRecordsStatus varchar(1) = null,	
	@distinctionStatus varchar(1) = null,
	@joinProgram varchar(255) = null,
	@joinProgramStatus varchar(1) = null,
	@startAcademicYear varchar(4) = null,
	@endAcademicYear varchar(4) = null,	
	@genderId varchar(2) = null,	
	@nationalityId varchar(3) = null,
	@sortOrderBy varchar(255) = null,
	@sortExpression varchar(25) = null
)
as
begin
	set concat_null_yields_null on

	set @username = ltrim(rtrim(isnull(@username, '')))
	set @userlevel = ltrim(rtrim(isnull(@userlevel, '')))
	set @systemGroup = ltrim(rtrim(isnull(@systemGroup, '')))
	set @reportName = ltrim(rtrim(isnull(@reportName, '')))
	set @keyword = ltrim(rtrim(isnull(@keyword, '')))
	set @degreeLevelId = ltrim(rtrim(isnull(@degreeLevelId, '')))
	set @facultyId = ltrim(rtrim(isnull(@facultyId, '')))
	set @programId = ltrim(rtrim(isnull(@programId, '')))	
	set @yearEntry = ltrim(rtrim(isnull(@yearEntry, '')))
	set @yearGraduate = ltrim(rtrim(isnull(@yearGraduate, '')))
	set @class = ltrim(rtrim(isnull(@class, '')))
	set @entranceTypeId = ltrim(rtrim(isnull(@entranceTypeId, '')))
	set @studentStatusTypeId = ltrim(rtrim(isnull(@studentStatusTypeId, '')))
	set @studentStatusTypeGroup = ltrim(rtrim(isnull(@studentStatusTypeGroup, '')))
	set @studentRecordsStatus = ltrim(rtrim(isnull(@studentRecordsStatus, '')))
	set @distinctionStatus = ltrim(rtrim(isnull(@distinctionStatus, '')))
	set @joinProgram = ltrim(rtrim(isnull(@joinProgram, '')))
	set @joinProgramStatus = ltrim(rtrim(isnull(@joinProgramStatus, '')))
	set @startAcademicYear = ltrim(rtrim(isnull(@startAcademicYear, '')))
	set @endAcademicYear = ltrim(rtrim(isnull(@endAcademicYear, '')))
	set @genderId = ltrim(rtrim(isnull(@genderId, '')))	
	set @nationalityId = ltrim(rtrim(isnull(@nationalityId, '')))
	set @sortOrderBy = ltrim(rtrim(isnull(@sortOrderBy, '')))
	set @sortExpression = ltrim(rtrim(isnull(@sortExpression, '')))	

	declare	@userFaculty varchar(15) = null
	declare @userProgram varchar(255) = null
	declare @sort varchar(255) = ''
	declare @keywordIn varchar(10) = ''
	declare @personId varchar(10) = ''
	declare @xml xml
		
	set @sortOrderBy = dbo.fnc_utilStringCompare(isnull(@sortOrderBy, ''), '', @sortOrderBy, 'Student ID')
	set @sortExpression = dbo.fnc_utilStringCompare(isnull(@sortExpression, ''), '', @sortExpression, 'Ascending')
	set @sort = (@sortOrderBy + ' ' + @sortExpression)

	if (len(isnull(@keyword, '')) > 0)
	begin
		if (substring(@keyword, 1, 2) = 'IN')
		begin
			set @keywordIn = 'IN'
			set @keyword = replace(@keyword, (@keywordIn + ' '), '')
			set @xml = cast(('<A>' + replace(@keyword, '|', '</A><A>') + '</A>') as xml)

			set @keyword = null
		end
	end
		
	select	A.value('.', 'varchar(1000)') as keyword
	into	#keywordTemp
	from	@xml.nodes('A') as fn(A)
	/*
	select	@userFaculty = autusr.facultyId,
			@userProgram = autusr.programId
	from	autUserAccessProgram as autusr with (nolock)
	where	(autusr.username = @username) and
			(autusr.level = @userlevel) and
			(autusr.systemGroup = @systemGroup)
	*/
	select	@userFaculty = a.facultyId,
			@userProgram = b.programId
	from	(
				select	top 1 autusr.facultyId
				from	autUserAccessProgram as autusr with (nolock)
				where	(autusr.username = @username) and
						(autusr.level = @userlevel) and
						(autusr.systemGroup = @systemGroup)
			) as a
			cross apply
			(
				select	(autusr.programId + ',')
				from	autUserAccessProgram as autusr with (nolock)
				where	(autusr.username = @username) and
						(autusr.level = @userlevel) and
						(autusr.systemGroup = @systemGroup)
				for xml path('')
			) as b (programId)

	set @userFaculty = isnull(@userFaculty, '')
	set @userProgram = isnull(@userProgram, '')	
	
	select	stdstd.personId as perPersonId
	into	#perTemp1
	from	stdStudent as stdstd with (nolock) inner join 
			perPerson as perpes with (nolock) on stdstd.personId = perpes.id left join
			#keywordTemp as keytmp with (nolock) on stdstd.studentCode = keytmp.keyword
	where	(@userFaculty = 'MU-01' or stdstd.facultyId = @userFaculty) and
			--(len(isnull(@userProgram, '')) = 0 or stdstd.programId = @userProgram) and
			(len(isnull(@userProgram, '')) = 0 or (charindex(stdstd.programId, @userProgram) > 0)) and
			(len(isnull(stdstd.studentCode, '')) = 0 or left(stdstd.studentCode, 2) not in ('00', '11')) and	
			(len(isnull(@joinProgram, '')) = 0  or 
				(@joinProgram = 'MedicalScholarsProgram' and left(stdstd.programId, 5) in ('BMMDB', 'DTDSB', 'EGEGB', 'MTMTB', 'PIMDB', 'PYBCM', 'RAMDB', 'SCSCB', 'SIMDB'))
			) and
			(@keywordIn <> 'IN' or keytmp.keyword is not null) and
			(len(isnull(@keyword, '')) = 0 or 
				charindex(@keyword, (
					isnull(stdstd.studentCode, '') +
					isnull(perpes.firstName, '') +
					isnull(perpes.middleName, '') +
					isnull(perpes.lastName, '') +
					isnull(perpes.enFirstName, '') +
					isnull(perpes.enMiddleName, '') +
					isnull(perpes.enLastName, '')
				)) > 0
			)

	select	perstd.id,
			perstd.studentId,
			perstd.studentCode,
			perstd.idCard,
			perstd.titlePrefixFullNameTH,
			perstd.titlePrefixInitialsTH,
			perstd.titlePrefixFullNameEN,
			perstd.titlePrefixInitialsEN,
			perstd.firstName,
			perstd.middleName,
			perstd.lastName,
			perstd.firstNameEN,
			perstd.middleNameEN,
			perstd.lastNameEN,
			perstd.perGenderId,
			perstd.genderFullNameTH,
			perstd.genderInitialsTH,
			perstd.genderFullNameEN,
			perstd.genderInitialsEN,
			perstd.perNationalityId,
			perstd.isoNationalityName3Letter,
			perstd.facultyId,
			perstd.facultyCode,
			perstd.facultyNameTH,
			perstd.facultyNameEN,
			perstd.programId,
			perstd.programCode,
			perstd.majorCode,
			perstd.groupNum,
			perstd.programNameTH,
			perstd.programNameEN,
			perstd.yearEntry,
			perstd.class,
			perstd.degree,
			perstd.degreeLevelNameTH, 
			perstd.degreeLevelNameEN,                         
			perstd.perEntranceTypeId,
			perstd.stdEntranceTypeNameTH,
			perstd.stdEntranceTypeNameEN,
			perstd.status,
			perstd.statusTypeNameTH,
			perstd.statusTypeNameEN,
			perstd.statusStudentGroup,
			perstd.statusGroup,
			(
				case perstd.statusGroup
					when '00' then 'กำลังศึกษา'
					when '01' then 'ศึกษาครบหลักสูตร'
					when '02' then 'พ้นสภาพ / ลาออก / สละสิทธิ์'
					else null
				end
			) as statusGroupNameTH,
			(
				case perstd.statusGroup
					when '00' then 'Student'
					when '01' then 'Graduated'
					when '02' then 'Dismissal / Resign / Disclaim'
					else null
				end
			) as statusGroupNameEN,
			perstd.admissionDate,
			perstd.graduateDate,
			perstd.yearGraduate,
			perstd.updateWhat,
			perstd.updateReason,
			pervrp.studentRecordsStatus,
			perstd.distinctionStatus,
			perstd.mspJoin,
			perstd.mspStartSemester,
			perstd.mspStartYear,
			perstd.mspEndSemester,
			perstd.mspEndYear,
			perstd.mspResignDate
	into	#perTemp2
	from	#perTemp1 as pertmp with (nolock) inner join
			fnc_perGetListPersonStudent() as perstd on pertmp.perPersonId = perstd.id inner join
			fnc_perGetListValidateRecordPerson() as pervrp on perstd.id = pervrp.id 
	where	(len(isnull(@degreeLevelId, '')) = 0 or perstd.degree = @degreeLevelId) and
			(len(isnull(@facultyId, '')) = 0 or perstd.facultyId = @facultyId) and
			(len(isnull(@programId, '')) = 0 or perstd.programId = @programId) and
			(len(isnull(@yearEntry, '')) = 0 or perstd.yearEntry = @yearEntry) and
			(len(isnull(@yearGraduate, '')) = 0 or perstd.yearGraduate = @yearGraduate) and
			(len(isnull(@class, '')) = 0 or perstd.class = @class) and
			(len(isnull(@entranceTypeId, '')) = 0 or perstd.perEntranceTypeId = @entranceTypeId) and
			(len(isnull(@studentStatusTypeId, '')) = 0 or perstd.status = @studentStatusTypeId or perstd.statusGroup = (case when (@studentStatusTypeId = '100') then '01' else '' end)) and
			(len(isnull(@studentStatusTypeGroup, '')) = 0 or perstd.statusGroup = @studentStatusTypeGroup) and
			(len(isnull(@studentRecordsStatus, '')) = 0 or pervrp.studentRecordsStatus = @studentRecordsStatus) and
			(len(isnull(@joinProgramStatus, '')) = 0 or 
				(@joinProgram = 'MedicalScholarsProgram' and perstd.mspJoin = @joinProgramStatus)
			) and
			(len(isnull(@startAcademicYear, '')) = 0 or 
				(@joinProgram = 'MedicalScholarsProgram' and perstd.mspStartYear = @startAcademicYear)
			) and
			(len(isnull(@endAcademicYear, '')) = 0 or 
				(@joinProgram = 'MedicalScholarsProgram' and perstd.mspEndYear = @endAcademicYear)
			) and
			(len(isnull(@genderId, '')) = 0 or perstd.perGenderId = @genderId or perstd.genderInitialsEN = @genderId) and
			(len(isnull(@nationalityId, '')) = 0 or perstd.perNationalityId = @nationalityId)

	declare @studentCode varchar(15) = null
	declare @statusGroup varchar(3) = null
	declare @updateWhat varchar(100) = null
	declare @updateReason varchar(255) = null

	declare rs cursor for
	select	pertmp.studentCode,
			pertmp.statusGroup,
			pertmp.updateWhat,
			pertmp.updateReason
	from	#perTemp2 as pertmp with (nolock)

	open rs
	fetch next from rs into @studentCode, @statusGroup, @updateWhat, @updateReason
	while (@@fetch_status = 0)
	begin
		if (@statusGroup = '02' and
			@updateWhat <> 'UpdateStudentStatus')
		begin
			set @updateReason = (
									select	 top 1 
											 updateReason
									from	 InfinityLog..stdStudentLog
									where	 (studentCode = @studentCode) and
											 (updateWhat = 'UpdateStudentStatus')
									order by id desc
								)

			update #perTemp2 set
				updateReason = @updateReason
			where (studentCode = @studentCode)
		end
		
		fetch next from rs into @studentCode, @statusGroup, @updateWhat, @updateReason
	end
	close rs
	deallocate rs		
	
	select	row_number() over(order by 
				case when @sort = 'Student ID Ascending'	then (isnull(pertmp.yearEntry, '') + isnull(pertmp.studentCode, '')) end asc,
				case when @sort = 'Student ID Descending'	then (isnull(pertmp.yearEntry, '') + isnull(pertmp.studentCode, '')) end desc
			) as rowNum,
			pertmp.*
	from	#perTemp2 as pertmp with (nolock)

	------------------------------------------------------------------------------------------------------------------------------------------------------
	
	if (@reportName = 'SummaryNumberOfStudentViewChart' or
		@reportName = 'SummaryNumberOfStudentLevel1ViewTable')
	begin
		--ตามสถานภาพการเป็นนักศึกษา
		if (@reportName = 'SummaryNumberOfStudentLevel1ViewTable')
		begin
			select	 perGenderId,
					 count(id) as countPeople
			from	 #perTemp2 with (nolock)
			where	 (perGenderId is not null)
			group by perGenderId
		end
		
		select	 'จำนวนนักศึกษาตามสถานภาพการเป็นนักศึกษา, ปีที่เข้าศึกษา, คณะ, หลักสูตร' as titleTH,
				 'Number of Student by Student Status, Year Attended, Faculty, Program' as titleEN,
				 a.drilldownId,
				 a.statusGroup,
				 a.statusGroupNameTH,
				 a.statusGroupNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 isnull(convert(varchar(3), statusGroup), 'ZNA') as drilldownId,
							 isnull(convert(varchar(3), statusGroup), 'N/A') as statusGroup,
							 isnull(statusGroupNameTH, 'N/A') as statusGroupNameTH,
							 isnull(statusGroupNameEN, 'N/A') as statusGroupNameEN					
					from	 #perTemp2 with (nolock)
					group by statusGroup, statusGroupNameTH, statusGroupNameEN
				 ) as a left join
				 (
					select	 isnull(convert(varchar(3), statusGroup), 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by statusGroup
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 isnull(convert(varchar(3), statusGroup), 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by statusGroup
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามสถานภาพการเป็นนักศึกษา ปีที่เข้าศึกษา		
		select	 a.drilldownId,
				 a.statusGroup as id,
				 a.yearEntry,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 isnull(convert(varchar(3), statusGroup), 'ZNA') as statusGroup,
							 isnull(yearEntry, 'N/A') as yearEntry
					from	 #perTemp2 with (nolock)
					group by statusGroup, yearEntry
				 ) as a left join
				 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by statusGroup, yearEntry
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by statusGroup, yearEntry
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามสถานภาพการเป็นนักศึกษา ปีที่เข้าศึกษา คณะ
		select	 a.drilldownId,
				 (a.statusGroup + a.yearEntry) as id,
				 a.facultyId,
				 a.faculty,
				 a.facultyNameTH,
				 a.facultyNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA') + ISNULL(facultyId, 'ZNA')) as drilldownId,
							 isnull(convert(varchar(3), statusGroup), 'ZNA') as statusGroup,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'N/A') as facultyId,
							 isnull(facultyCode, 'N/A') as faculty,
							 isnull(facultyNameTH, 'N/A') as facultyNameTH,
							 isnull(facultyNameEN, 'N/A') as facultyNameEN					
					from	 #perTemp2 with (nolock)
					group by statusGroup, yearEntry, facultyId, facultyCode, facultyNameTH, facultyNameEN
				 ) as a left join
				 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by statusGroup, yearEntry, facultyId, facultyCode
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by statusGroup, yearEntry, facultyId, facultyCode
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามสถานภาพการเป็นนักศึกษา ปีที่เข้าศึกษา คณะ หลักสูตร
		select	 a.drilldownId,
				(a.statusGroup + a.yearEntry + a.faculty) as id,
				 a.programId,
				 a.program,
				 a.programNameTH,
				 a.programNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 isnull(convert(varchar(3), statusGroup), 'ZNA') as statusGroup,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'ZNA') as faculty,
							 isnull(programId, 'N/A') as programId,
							 isnull((isnull(programCode, '') + ' ' + isnull(majorCode, '') + ' ' + isnull(groupNum, '')), 'N/A') as program,
							 isnull(programNameTH, 'N/A') as programNameTH,
							 isnull(programNameEN, 'N/A') as programNameEN
					from	 #perTemp2 with (nolock)
					group by statusGroup, yearEntry, facultyId, programId, programCode, majorCode, groupNum, programNameTH, programNameEN
				 ) as a left join
				 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by statusGroup, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(convert(varchar(3), statusGroup), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by statusGroup, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามวุฒิการศึกษา
		select	 'จำนวนนักศึกษาตามวุฒิการศึกษา, ปีที่เข้าศึกษา, คณะ, หลักสูตร' as titleTH,
				 'Number of Student by Degree, Year Attended, Faculty, Program' as titleEN,
				 a.drilldownId,
				 a.degree,
				 a.degreeLevelNameTH,
				 a.degreeLevelNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 isnull(degree, 'ZNA') as drilldownId,
							 isnull(degree, 'N/A') as degree,
							 isnull(degreeLevelNameTH, 'N/A') as degreeLevelNameTH,
							 isnull(degreeLevelNameEN, 'N/A') as degreeLevelNameEN
					from	 #perTemp2 with (nolock)
					group by degree, degreeLevelNameTH, degreeLevelNameEN
				 ) as a left join
				 (
					select	 isnull(degree, 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by degree
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 isnull(degree, 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by degree
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามวุฒิการศึกษา ปีที่เข้าศึกษา
		select	 a.drilldownId,
				 a.degree as id,
				 a.yearEntry,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 isnull(degree, 'ZNA') as degree,
							 isnull(yearEntry, 'N/A') as yearEntry
					from	 #perTemp2 with (nolock)
					group by degree, yearEntry
				 ) as a left join
				 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with(nolock)
					where	 perGenderId = '01'
					group by degree, yearEntry
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by degree, yearEntry
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามวุฒิการศึกษา ปีที่เข้าศึกษา คณะ
		select	 a.drilldownId,
				 (a.degree + a.yearEntry) as id,
				 a.facultyId,
				 a.faculty,
				 a.facultyNameTH,
				 a.facultyNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 isnull(degree, 'ZNA') as degree,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'N/A') as facultyId,
							 isnull(facultyCode, 'N/A') as faculty,
							 isnull(facultyNameTH, 'N/A') as facultyNameTH,
							 isnull(facultyNameEN, 'N/A') as facultyNameEN					
					from	 #perTemp2 with (nolock)
					group by degree, yearEntry, facultyId, facultyCode, facultyNameTH, facultyNameEN
				 ) as a left join
				 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by degree, yearEntry, facultyId, facultyCode
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by degree, yearEntry, facultyId, facultyCode
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามวุฒิการศึกษา ปีที่เข้าศึกษา คณะ หลักสูตร
		select	 a.drilldownId,
				 (a.degree + a.yearEntry + a.faculty) as id,
				 a.programId,
				 a.program,
				 a.programNameTH,
				 a.programNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 isnull(degree, 'ZNA') as degree,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'ZNA') as faculty,
							 isnull(programId, 'N/A') as programId,
							 isnull((isnull(programCode, '') + ' ' + isnull(majorCode, '') + ' ' + isnull(groupNum, '')), 'N/A') as program,
							 isnull(programNameTH, 'N/A') as programNameTH,
							 isnull(programNameEN, 'N/A') as programNameEN
					from	 #perTemp2 with (nolock)
					group by degree, yearEntry, facultyId, programId, programCode, majorCode, groupNum, programNameTH, programNameEN
				 ) as a left join
				 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by degree, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(degree, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by degree, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามปีที่เข้าศึกษา
		select	 'จำนวนนักศึกษาตามปีที่เข้าศึกษา, คณะ, หลักสูตร' as titleTH,
				 'Number of Student by Year Attended, Faculty, Program' as titleEN,
				 a.drilldownId,
				 a.yearEntry,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 isnull(yearEntry, 'ZNA') as drilldownId,
							 isnull(yearEntry, 'N/A') as yearEntry
					from	 #perTemp2 with (nolock)
					group by yearEntry
				 ) as a left join
				 (
					select	 isnull(yearEntry, 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by yearEntry
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 isnull(yearEntry, 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by yearEntry
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามปีที่เข้าศึกษา คณะ
		select	 a.drilldownId,
				 a.yearEntry as id,
				 a.facultyId,
				 a.faculty,
				 a.facultyNameTH,
				 a.facultyNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'N/A') as facultyId,
							 isnull(facultyCode, 'N/A') as faculty,
							 isnull(facultyNameTH, 'N/A') as facultyNameTH,
							 isnull(facultyNameEN, 'N/A') as facultyNameEN					
					from	 #perTemp2 with (nolock)
					group by yearEntry, facultyId, facultyCode, facultyNameTH, facultyNameEN
				 ) as a left join
				 (
					select	 (isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by yearEntry, facultyId, facultyCode
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by yearEntry, facultyId, facultyCode
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามปีที่เข้าศึกษา คณะ หลักสูตร
		select	 a.drilldownId,
				 (a.yearEntry + a.faculty) as id,
				 a.programId,
				 a.program,
				 a.programNameTH,
				 a.programNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'ZNA') as faculty,
							 isnull(programId, 'N/A') as programId,
							 isnull((isnull(programCode, '') + ' ' + isnull(majorCode, '') + ' ' + isnull(groupNum, '')), 'N/A') as program,
							 isnull(programNameTH, 'N/A') as programNameTH,
							 isnull(programNameEN, 'N/A') as programNameEN
					from	 #perTemp2 with (nolock)
					group by yearEntry, facultyId, programId, programCode, majorCode, groupNum, programNameTH, programNameEN
				 ) as a left join
				 (
					select	 (isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId

		--ตามระบบการสอบเข้า
		select	 'จำนวนนักศึกษาตามระบบการสอบเข้า, ปีที่เข้าศึกษา, คณะ, หลักสูตร' as titleTH,
				 'Number of Student by Admission Type, Year Attended, Faculty, Program' as titleEN,
				 a.drilldownId,
				 a.perEntranceTypeId,
				 a.stdEntranceTypeNameTH,
				 a.stdEntranceTypeNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(perEntranceTypeId, 'ZNA')) as drilldownId,
							 isnull(perEntranceTypeId, 'N/A') as perEntranceTypeId,
							 isnull(stdEntranceTypeNameTH, 'N/A') as stdEntranceTypeNameTH,
							 isnull(stdEntranceTypeNameEN, 'N/A') as stdEntranceTypeNameEN
					from	 #perTemp2 with (nolock)
					group by perEntranceTypeId,	stdEntranceTypeNameTH, stdEntranceTypeNameEN
				 ) as a left join
				 (
					select	 isnull(perEntranceTypeId, 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by perEntranceTypeId
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 isnull(perEntranceTypeId, 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by perEntranceTypeId
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามระบบการสอบเข้า ปีที่เข้าศึกษา
		select	 a.drilldownId,
				 a.perEntranceTypeId as id,
				 a.yearEntry,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 isnull(perEntranceTypeId, 'ZNA') as perEntranceTypeId,
							 isnull(yearEntry, 'N/A') AS yearEntry
					from	 #perTemp2 with (nolock)
					group by perEntranceTypeId, yearEntry
				 ) as a left join
				 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by perEntranceTypeId, yearEntry
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 COUNT(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by perEntranceTypeId, yearEntry
				 ) AS c ON a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามระบบการสอบเข้า ปีที่เข้าศึกษา คณะ
		select	 a.drilldownId,
				 (a.perEntranceTypeId + a.yearEntry) as id,
				 a.facultyId,
				 a.faculty,
				 a.facultyNameTH,
				 a.facultyNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 isnull(perEntranceTypeId, 'ZNA') as perEntranceTypeId,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'N/A') as facultyId,
							 isnull(facultyCode, 'N/A') as faculty,
							 isnull(facultyNameTH, 'N/A') as facultyNameTH,
							 isnull(facultyNameEN, 'N/A') as facultyNameEN					
					from	 #perTemp2 with (nolock)
					group by perEntranceTypeId, yearEntry, facultyId, facultyCode, facultyNameTH, facultyNameEN
				 ) as a left join
				 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by perEntranceTypeId, yearEntry, facultyId, facultyCode
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by perEntranceTypeId, yearEntry, facultyId, facultyCode
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามระบบการสอบเข้า ปีที่เข้าศึกษา คณะ หลักสูตร
		select	 a.drilldownId,
				 (a.perEntranceTypeId + a.yearEntry + a.faculty) as id,
				 a.programId,
				 a.program,
				 a.programNameTH,
				 a.programNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 isnull(perEntranceTypeId, 'ZNA') as perEntranceTypeId,
							 isnull(yearEntry, 'ZNA') AS yearEntry,
							 isnull(facultyId, 'ZNA') AS faculty,
							 isnull(programId, 'N/A') AS programId,
							 isnull((isnull(programCode, '') + ' ' + isnull(majorCode, '') + ' ' + isnull(groupNum, '')), 'N/A') as program,
							 isnull(programNameTH, 'N/A') as programNameTH,
							 isnull(programNameEN, 'N/A') as programNameEN
					from	 #perTemp2 with (nolock)
					group by perEntranceTypeId, yearEntry, facultyId, programId, programCode, majorCode, groupNum, programNameTH, programNameEN
				 ) as a left join
				 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by perEntranceTypeId, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(perEntranceTypeId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by perEntranceTypeId, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามชั้นปี
		select	 'จำนวนนักศึกษาตามชั้นปี, ปีที่เข้าศึกษา, คณะ, หลักสูตร' as titleTH,
				 'Number of Student by Class, Year Attended, Faculty, Program' as titleEN,
				 a.drilldownId,
				 a.class,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(convert(varchar(3), class), 'ZNA')) as drilldownId,
							 isnull(convert(varchar(3), class), 'N/A') as class
					from	 #perTemp2 with (nolock)
					group by class
				 ) as a left join
				 (
					select	 isnull(convert(varchar(3), class), 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by class
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 isnull(convert(varchar(3), class), 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by class
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามชั้นปี ปีที่เข้าศึกษา
		select	 a.drilldownId,
				 a.class as id,
				 a.yearEntry,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 isnull(convert(varchar(3), class), 'ZNA') as class,
							 isnull(yearEntry, 'N/A') as yearEntry
					from	 #perTemp2 with (nolock)
					group by class, yearEntry
				 ) as a left join
				 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by class, yearEntry
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by class, yearEntry
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามชั้นปี ปีที่เข้าศึกษา คณะ
		select	 a.drilldownId,
				 (a.class + a.yearEntry) as id,
				 a.facultyId,
				 a.faculty,
				 a.facultyNameTH,
				 a.facultyNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 isnull(convert(varchar(3), class), 'ZNA') as class,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'N/A') as facultyId,
							 isnull(facultyCode, 'N/A') as faculty,
							 isnull(facultyNameTH, 'N/A') as facultyNameTH,
							 isnull(facultyNameEN, 'N/A') as facultyNameEN					
					from	 #perTemp2 with (nolock)
					group by class, yearEntry, facultyId, facultyCode, facultyNameTH, facultyNameEN
				 ) as a left join
				 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by class, yearEntry, facultyId, facultyCode
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by class, yearEntry, facultyId, facultyCode
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามชั้นปี ปีที่เข้าศึกษา คณะ หลักสูตร
		select	 a.drilldownId,
				 (a.class + a.yearEntry + a.faculty) as id,
				 a.programId,
				 a.program,
				 a.programNameTH,
				 a.programNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 isnull(convert(varchar(3), class), 'ZNA') as class,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'ZNA') as faculty,
							 isnull(programId, 'N/A') as programId,
							 isnull((isnull(programCode, '') + ' ' + isnull(majorCode, '') + ' ' + isnull(groupNum, '')), 'N/A') as program,
							 isnull(programNameTH, 'N/A') as programNameTH,
							 isnull(programNameEN, 'N/A') as programNameEN
					from	 #perTemp2 with (nolock)
					group by class, yearEntry, facultyId, programId, programCode, majorCode, groupNum, programNameTH, programNameEN
				 ) as a left join
				 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by class, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(convert(varchar(3), class), 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by class, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามสัญชาติ
		select	 'จำนวนนักศึกษาตามสัญชาติ, ปีที่เข้าศึกษา, คณะ, หลักสูตร' as titleTH,
				 'Number of Student by Nationality, Year Attended, Faculty, Program' as titleEN,
				 a.drilldownId,
				 a.perNationalityId,
				 a.isoNationalityName3Letter,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(perNationalityId, 'ZNA')) as drilldownId,
							 isnull(perNationalityId, 'N/A') as perNationalityId,
							 isnull(isoNationalityName3Letter, 'N/A') as isoNationalityName3Letter
					from	 #perTemp2 with (nolock)
					group by perNationalityId, isoNationalityName3Letter
				 ) as a left join
				 (
					select	 isnull(perNationalityId, 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by perNationalityId
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 isnull(perNationalityId, 'ZNA') as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by perNationalityId
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามสัญชาติ ปีที่เข้าศึกษา
		select	 a.drilldownId,
				 a.perNationalityId AS id,
				 a.yearEntry,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 isnull(perNationalityId, 'ZNA') as perNationalityId,
							 isnull(yearEntry, 'N/A') as yearEntry
					from	 #perTemp2 with (nolock)
					group by perNationalityId, yearEntry
				 ) as a left join
				 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with(nolock)
					where	 perGenderId = '01'
					group by perNationalityId, yearEntry
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by perNationalityId, yearEntry
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามสัญชาติ ปีที่เข้าศึกษา คณะ
		select	 a.drilldownId,
				 (a.perNationalityId + a.yearEntry) as id,
				 a.facultyId,
				 a.faculty,
				 a.facultyNameTH,
				 a.facultyNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 isnull(perNationalityId, 'ZNA') as perNationalityId,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'N/A') as facultyId,
							 isnull(facultyCode, 'N/A') as faculty,
							 isnull(facultyNameTH, 'N/A') as facultyNameTH,
							 isnull(facultyNameEN, 'N/A') as facultyNameEN					
					from	 #perTemp2 with (nolock)
					group by perNationalityId, yearEntry, facultyId, facultyCode, facultyNameTH, facultyNameEN
				 ) as a left join
				 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by perNationalityId, yearEntry, facultyId, facultyCode
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by perNationalityId, yearEntry, facultyId, facultyCode
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
		
		--ตามสัญชาติ ปีที่เข้าศึกษา คณะ หลักสูตร
		select	 a.drilldownId,
				 (a.perNationalityId + a.yearEntry + a.faculty) as id,
				 a.programId,
				 a.program,
				 a.programNameTH,
				 a.programNameEN,
				 isnull(b.countPeople, 0) as countMalePeople,
				 isnull(c.countPeople, 0) as countFemalePeople
		from	 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 isnull(perNationalityId, 'ZNA') as perNationalityId,
							 isnull(yearEntry, 'ZNA') as yearEntry,
							 isnull(facultyId, 'ZNA') as faculty,
							 isnull(programId, 'N/A') as programId,
							 isnull((isnull(programCode, '') + ' ' + isnull(majorCode, '') + ' ' + isnull(groupNum, '')), 'N/A') as program,
							 isnull(programNameTH, 'N/A') as programNameTH,
							 isnull(programNameEN, 'N/A') as programNameEN
					from	 #perTemp2 with (nolock)
					group by perNationalityId, yearEntry, facultyId, programId, programCode, majorCode, groupNum, programNameTH, programNameEN
				 ) as a left join
				 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '01'
					group by perNationalityId, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as b on a.drilldownId = b.drilldownId left join
				 (
					select	 (isnull(perNationalityId, 'ZNA') + isnull(yearEntry, 'ZNA') + isnull(facultyId, 'ZNA') + isnull(programId, 'ZNA')) as drilldownId,
							 count(id) as countPeople
					from	 #perTemp2 with (nolock)
					where	 perGenderId = '02'
					group by perNationalityId, yearEntry, facultyId, programId, programCode, majorCode, groupNum
				 ) as c on a.drilldownId = c.drilldownId
		order by a.drilldownId
	end	
end