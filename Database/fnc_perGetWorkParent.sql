USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetWorkParent]    Script Date: 11/17/2015 08:23:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลการทำงานของครอบครัว>
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetWorkParent]
(	
	@personId VARCHAR(10) = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT	perps.id,
			perps.idCard,
			perps.perTitlePrefixId, 
			perps.thTitleFullName,
			perps.thTitleInitials,
			perps.thDescription,
			perps.enTitleFullName, 
			perps.enTitleInitials,
			perps.enDescription,
			perps.firstName,
			perps.middleName, 
			perps.lastName,
			perps.enFirstName,
			perps.enMiddleName,
			perps.enLastName, 
			perpr.perPersonIdFather,
			perwkfather.occupation AS occupationFather,
			perwkfather.thOccupation AS thOccupationFather,
			perwkfather.enOccupation AS enOccupationFather, 
			perwkfather.perAgencyId AS perAgencyIdFather,
			perwkfather.agencyNameTH AS thAgencyNameFather,
			perwkfather.agencyNameEN AS enAgencyNameFather,
			perwkfather.agencyOther AS agencyOtherFather,
			perwkfather.workplace AS workplaceFather,
			perwkfather.position AS positionFather,
			perwkfather.telephone AS telephoneFather,  
			perwkfather.salary AS salaryFather,							
			perpr.perPersonIdMother,
			perwkmother.occupation AS occupationMother,
			perwkmother.thOccupation AS thOccupationMother,
			perwkmother.enOccupation AS enOccupationMother, 
			perwkmother.perAgencyId AS perAgencyIdMother,
			perwkmother.agencyNameTH AS thAgencyNameMother,
			perwkmother.agencyNameEN AS enAgencyNameMother,
			perwkmother.agencyOther AS agencyOtherMother,
			perwkmother.workplace AS workplaceMother,
			perwkmother.position AS positionMother,
			perwkmother.telephone AS telephoneMother,  
			perwkmother.salary AS salaryMother,					
			perpr.perPersonIdParent,
			perwkparent.occupation AS occupationParent,
			perwkparent.thOccupation AS thOccupationParent,
			perwkparent.enOccupation AS enOccupationParent, 
			perwkparent.perAgencyId AS perAgencyIdParent,
			perwkparent.agencyNameTH AS thAgencyNameParent,
			perwkparent.agencyNameEN AS enAgencyNameParent,
			perwkparent.agencyOther AS agencyOtherParent,
			perwkparent.workplace AS workplaceParent,
			perwkparent.position AS positionParent,
			perwkparent.telephone AS telephoneParent,  
			perwkparent.salary AS salaryParent,			
			perpr.createDate,
			perpr.createBy,
			perpr.createIp, 
			perpr.modifyDate,
			perpr.modifyBy,
			perpr.modifyIp
	FROM	fnc_perGetPerson(@personId) AS perps LEFT JOIN
			perParent AS perpr ON perps.id = perpr.perPersonId LEFT JOIN
			fnc_perGetWork((SELECT perPersonIdFather FROM perParent WHERE perPersonId = @personId)) AS perwkfather ON perpr.perPersonIdFather = perwkfather.id LEFT JOIN			
			fnc_perGetWork((SELECT perPersonIdMother FROM perParent WHERE perPersonId = @personId)) AS perwkmother ON perpr.perPersonIdMother = perwkmother.id LEFT JOIN
			fnc_perGetWork((SELECT perPersonIdParent FROM perParent WHERE perPersonId = @personId)) AS perwkparent ON perpr.perPersonIdParent = perwkparent.id
)
