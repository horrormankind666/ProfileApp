USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetWork]    Script Date: 8/4/2559 9:35:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลการทำงานของบุคคล>
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetWork]
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
			perwk.occupation,
			dbo.fnc_perGetOccupationName(perwk.occupation, 'TH') AS thOccupation,
			dbo.fnc_perGetOccupationName(perwk.occupation, 'EN') AS enOccupation,
			perwk.perAgencyId,
			perag.agencyNameTH,
			perag.agencyNameEN,
			perwk.agencyOther,
			perwk.workplace,
			perwk.position,
			perwk.telephone, 
			perwk.salary,
			perwk.createDate,
			perwk.createBy,
			perwk.createIp,
			perwk.modifyDate,
			perwk.modifyBy,
			perwk.modifyIp
	FROM	fnc_perGetPerson(@personId) AS perps LEFT JOIN
			perWork AS perwk ON perps.id = perwk.perPersonId LEFT JOIN
			perAgency AS perag ON perwk.perAgencyId = perag.id
)
