USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetHealthy]    Script Date: 11/17/2015 07:31:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลสุขภาพของบุคคล>
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetHealthy]
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
			perht.bodyMassDetail,
			perht.intolerance,
			(
				CASE perht.intolerance
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END				
			) AS thIntolerance,
			(
				CASE perht.intolerance
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END				
			) AS enIntolerance,		
			perht.intoleranceDetail,
			perht.diseases,
			(
				CASE perht.diseases
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END				
			) AS thDiseases,
			(
				CASE perht.diseases
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END				
			) AS enDiseases,		
			perht.diseasesDetail,
			perht.ailHistoryFamily,
			(
				CASE perht.ailHistoryFamily
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END				
			) AS thAilHistoryFamily,
			(
				CASE perht.ailHistoryFamily
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END				
			) AS enAilHistoryFamily,			
			perht.ailHistoryFamilyDetail,
			perht.travelAbroad,
			(
				CASE perht.travelAbroad
					WHEN 'Y' THEN 'เคย'
					WHEN 'N' THEN 'ไม่เคย'
					ELSE NULL
				END				
			) AS thTravelAbroad,
			(
				CASE perht.travelAbroad
					WHEN 'Y' THEN 'Ever'
					WHEN 'N' THEN 'Never'
					ELSE NULL
				END				
			) AS enTravelAbroad,	
			perht.travelAbroadDetail,
			perht.impairments,
			(
				CASE perht.impairments
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END				
			) AS thImpairments,
			(
				CASE perht.impairments
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END				
			) AS enImpairments,
			perht.perImpairmentsId,
			perip.impairmentsNameTH,
			perip.impairmentsNameEN,
			perht.impairmentsEquipment,
			perht.createDate,
			perht.createBy, 
			perht.createIp,
			perht.modifyDate,
			perht.modifyBy,
			perht.modifyIp
	FROM	fnc_perGetPerson(@personId) AS perps LEFT JOIN
			perHealthy AS perht ON perps.id = perht.perPersonId LEFT JOIN
			perImpairments AS perip ON perht.perImpairmentsId = perip.id
)
