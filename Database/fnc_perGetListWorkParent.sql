USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetListWorkParent]    Script Date: 09/21/2015 07:27:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๐๔/๐๓/๒๕๕๗>
-- Description	: <สำหรับแสดงข้อมูลการทำงานของครอบครัว>
--  1. id		เป็น VARCHAR	รับค่ารหัสบุคคล
--  2. idCard 	เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  3. name		เป็น NVARCHAR	รับค่าชื่อ
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetListWorkParent]
(	
	@id	VARCHAR(MAX) = NULL,
	@idCard NVARCHAR(MAX) = NULL,
	@name NVARCHAR(MAX) = NULL
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
	FROM	fnc_perGetListPerson(@id, @idCard, @name) AS perps LEFT JOIN
			perParent AS perpr ON perps.id = perpr.perPersonId LEFT JOIN
			fnc_perGetListWork('', '', '') AS perwkfather ON perpr.perPersonIdFather = perwkfather.id LEFT JOIN
			fnc_perGetListWork('', '', '') AS perwkmother ON perpr.perPersonIdMother = perwkmother.id LEFT JOIN
			fnc_perGetListWork('', '', '') AS perwkparent ON perpr.perPersonIdParent = perwkparent.id
)
