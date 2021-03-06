USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGetPersonStudent]    Script Date: 9/8/2564 20:37:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลของนักศึกษา>
-- Parameter
--  1. personId เป็น varchar	รับค่ารหัสบุคคล
-- =============================================
/*
exec sp_perGetPersonStudent 2564000278
*/

ALTER procedure [dbo].[sp_perGetPersonStudent]
(
	@personId varchar(10) = null
)
as
begin
	set concat_null_yields_null off

	set @personId = ltrim(rtrim(isnull(@personId, '')))

	declare @programContract varchar(8000) = null 
	
	select	@programContract = (coalesce((@programContract + ','), '') + isnull(programId, ''))
	from	ectProgramContract

	select	percst.consentField,
			perstd.id,
			perstd.studentId,
			perstd.studentCode,
			perstd.idCard,
			perstd.thBirthDate as birthDateTH,
			perstd.enBirthDate as birthDateEN,
			perstd.thTitleFullName as titlePrefixFullNameTH,
			perstd.thTitleInitials as titlePrefixInitialsTH,
			perstd.enTitleFullName as titlePrefixFullNameEN,
			perstd.enTitleInitials as titlePrefixInitialsEN,			
			perstd.firstName,
			perstd.middleName,
			perstd.lastName,
			perstd.enFirstName as firstNameEN,
			perstd.enMiddleName as middleNameEN,
			perstd.enLastName as lastNameEN,
			perstd.enGenderInitials as genderInitialsEN,
			perstd.thNationalityName as nationalityNameTH,
			perstd.isoNationalityName2Letter,
			perstd.degree,
			perstd.degreeLevelNameTH,
			perstd.degreeLevelNameEN,
			perstd.facultyId,
			perstd.facultyCode,
			perstd.facultyNameTH,
			perstd.facultyNameEN,
			perstd.programId,
			@programContract as programContract,
			(case when (charindex(perstd.programId, @programContract) > 0) then 'Y' else 'N' end) as isProgramContract,
			perstd.programCode,
			perstd.majorCode,
			perstd.groupNum,
			((left(perstd.programCode, (len(perstd.programCode) - 1)) + '/' + right(perstd.programCode, 1)) + ' ' + perstd.majorCode + ' ' + perstd.groupNum) as programCodeNew,
			perstd.programNameTH,
			perstd.programNameEN,
			perstd.yearEntry,
			perstd.acaYear,
			perstd.courseYear,
			perstd.class,
			perstd.perEntranceTypeId,
			perstd.stdEntranceTypeNameTH,
			perstd.stdEntranceTypeNameEN,
			perstd.stdStatusTypeId,
			perstd.statusTypeNameTH,
			perstd.statusTypeNameEN,
			perstd.statusGroup,
			perstd.admissionDate,
			perstd.graduateDate,
			perstd.updateWhat,
			perstd.updateReason,
			perstd.folderPictureName,
			perstd.profilePictureName,
			(case when (len(isnull(perstd.studentCode, '')) > 0 and len(isnull(perstd.degree, '')) > 0) then dbo.fnc_perGetBarcode(perstd.studentCode, perstd.degree) else null end) as barcode,
			(case when isnull(pervrp.perPerson, 0) = 1 then 'Y' else 'N' end) as studentRecordsPersonalStatus,
			(case when isnull(pervrp.perAddress, 0) = 1 then 'Y' else 'N' end) as studentRecordsAddressStatus,
			(case when isnull(pervrp.perAddressPermanent, 0) = 1 then 'Y' else 'N' end) as studentRecordsAddressPermanentStatus,
			(case when isnull(pervrp.perAddressCurrent, 0) = 1 then 'Y' else 'N' end) as studentRecordsAddressCurrentStatus,
			(case when isnull(pervrp.perEducation, 0) = 1 then 'Y' else 'N' end) as studentRecordsEducationStatus,
			(case when isnull(pervrp.perEducationPrimarySchool, 0) = 1 then 'Y' else 'N' end) as studentRecordsEducationPrimarySchoolStatus,
			(case when isnull(pervrp.perEducationJuniorHighSchool, 0) = 1 then 'Y' else 'N' end) as studentRecordsEducationJuniorHighSchoolStatus,
			(case when isnull(pervrp.perEducationHighSchool, 0) = 1 then 'Y' else 'N' end) as studentRecordsEducationHighSchoolStatus,
			(case when isnull(pervrp.perEducationUniversity, 0) = 1 then 'Y' else 'N' end) as studentRecordsEducationUniversityStatus,
			(case when isnull(pervrp.perEducationAdmissionScores, 0) = 1 then 'Y' else 'N' end) as studentRecordsEducationAdmissionScoresStatus,
			(case when isnull(pervrp.perActivity, 0) = 1 then 'Y' else 'N' end) as studentRecordsTalentStatus,
			(case when isnull(pervrp.perHealthy, 0) = 1 then 'Y' else 'N' end) as studentRecordsHealthyStatus,
			(case when isnull(pervrp.perWork, 0) = 1 then 'Y' else 'N' end) as studentRecordsWorkStatus,
			(case when isnull(pervrp.perFinancial, 0) = 1 then 'Y' else 'N' end) as studentRecordsFinancialStatus,
			(
				case 
					when (case
							when
								(isnull(pervrp.perPersonFather, 0) + isnull(pervrp.perAddressFather, 0) + isnull(pervrp.perWorkFather, 0) +
								 isnull(pervrp.perPersonMother, 0) + isnull(pervrp.perAddressMother, 0) + isnull(pervrp.perWorkMother, 0) +
								 isnull(pervrp.perPersonParent, 0) + isnull(pervrp.perAddressParent, 0) + isnull(pervrp.perWorkParent, 0)) = 9
							then
								1
							else
								0
						  end) = 1
					then 'Y'
					else 'N'
				end
			) as studentRecordsFamilyStatus,
			(case when isnull(pervrp.perPersonFather, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyFatherPersonalStatus,
			(case when isnull(pervrp.perPersonMother, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyMotherPersonalStatus,
			(case when isnull(pervrp.perPersonParent, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyParentPersonalStatus,
			(case when isnull(pervrp.perAddressFather, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyFatherAddressFatherStatus,
			(case when isnull(pervrp.perAddressPermanentFather, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyFatherAddressPermanentStatus,
			(case when isnull(pervrp.perAddressCurrentFather, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyFatherAddressCurrentStatus,
			(case when isnull(pervrp.perAddressMother, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyMotherAddressStatus,
			(case when isnull(pervrp.perAddressPermanentMother, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyMotherAddressPermanentStatus,
			(case when isnull(pervrp.perAddressCurrentMother, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyMotherAddressCurrentStatus,
			(case when isnull(pervrp.perAddressParent, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyParentAddressStatus,
			(case when isnull(pervrp.perAddressPermanentParent, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyParentAddressPermanentStatus,
			(case when isnull(pervrp.perAddressCurrentParent, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyParentAddressCurrentStatus,
			(case when isnull(pervrp.perWorkFather, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyFatherWorkStatus,
			(case when isnull(pervrp.perWorkMother, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyMotherWorkStatus,
			(case when isnull(pervrp.perWorkParent, 0) = 1 then 'Y' else 'N' end) as studentRecordsFamilyParentWorkStatus
	into	#perTemp
	from	fnc_perGetPersonStudent(@personId) as perstd left join
			fnc_perGetValidateRecordPerson(@personId) as pervrp on perstd.id = pervrp.id left join
			perConsent as percst with(nolock) on perstd.id = percst.perPersonId

	declare @studentCode varchar(15) = null
	declare @statusGroup varchar(3) = null
	declare @updateWhat varchar(100) = null
	declare @updateReason varchar(255) = null

	declare rs cursor for
	select	pertmp.studentCode,
			pertmp.statusGroup,
			pertmp.updateWhat,
			pertmp.updateReason
	from	#perTemp as pertmp with (nolock)

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

			update #perTemp set
				updateReason = @updateReason
			where (studentCode = @studentCode)
		end
		
		fetch next from rs into @studentCode, @statusGroup, @updateWhat, @updateReason
	end
	close rs
	deallocate rs		

	select	*
	from	#perTemp
end