USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetPerson]    Script Date: 11/17/2015 07:46:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลส่วนตัวของบุคคล>
--  1. id	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetPerson]
(
	@personId	VARCHAR(10) = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT	perps.id,
			perps.idCard,
			perps.perTitlePrefixId,
			pertp.oldId AS perTitlePrefixIdOld,
			pertp.thTitleFullName,
			pertp.thTitleInitials,
			pertp.thDescription,
			pertp.enTitleFullName,
			pertp.enTitleInitials,
			pertp.enDescription,
			pertp.perGenderId AS perGenderIdTitlePrefix,
			pergdtp.thGenderFullName AS thGenderFullNameTitlePrefix,
			pergdtp.thGenderInitials AS thGenderInitialsTitlePrefix,
			pergdtp.enGenderFullName AS enGenderFullNameTitlePrefix,
			pergdtp.enGenderInitials AS enGenderInitialsTitlePrefix,			
			perps.firstName,
			perps.middleName,
			perps.lastName,
			perps.enFirstName,
			perps.enMiddleName,
			perps.enLastName,
			perps.perGenderId,
			pergdps.thGenderFullName,
			pergdps.thGenderInitials,
			pergdps.enGenderFullName,
			pergdps.enGenderInitials,
			perps.alive,
			(
				CASE perps.alive
					WHEN 'Y' THEN 'มีชีวิตอยู่'
					WHEN 'N' THEN 'ถึงแก่กรรม'
					ELSE NULL
				END				
			) AS thAlive,
			(
				CASE perps.alive
					WHEN 'Y' THEN 'Alive'
					WHEN 'N' THEN 'Deceased'
					ELSE NULL
				END				
			) AS enAlive,		
			perps.birthDate,
			(CASE WHEN (perps.birthDate IS NOT NULL) THEN (SUBSTRING(CONVERT(VARCHAR, perps.birthDate, 103),1, 6) + CONVERT(VARCHAR, (YEAR(perps.birthDate) + 543))) ELSE NULL END) AS thBirthDate,
			(CASE WHEN (perps.birthDate IS NOT NULL) THEN CONVERT(VARCHAR, perps.birthDate, 103) ELSE NULL END) AS enBirthDate,
			(CASE WHEN (perps.birthDate IS NOT NULL) THEN (DATEDIFF(YEAR, perps.birthDate, GETDATE())) ELSE NULL END) AS age,
			perps.plcCountryId, 
			plcco.countryNameTH,
			plcco.countryNameEN,
			plcco.isoCountryCodes2Letter,
			plcco.isoCountryCodes3Letter,
			perps.perNationalityId, 
			perna.thNationalityName,
			perna.enNationalityName,
			perna.isoCountryCodes2Letter AS isoNationalityName2Letter,
			perna.isoCountryCodes3Letter AS isoNationalityName3Letter,
			perps.perOriginId,
			perna1.thNationalityName AS thOriginName,
			perna1.enNationalityName AS enOriginName,			
			perna1.isoCountryCodes2Letter AS isoOriginName2Letter,
			perna1.isoCountryCodes3Letter AS isoOriginName3Letter,
			perps.perReligionId,
			perrg.thReligionName,
			perrg.enReligionName,
			perps.perBloodTypeId,
			perbt.thBloodTypeName,
			perbt.enBloodTypeName,
			perps.perMaritalStatusId,
			perms.thMaritalStatusName,
			perms.enMaritalStatusName,
			perps.perEducationalBackgroundId,
			pereb.thEducationalBackgroundName,
			pereb.enEducationalBackgroundName,	
			perps.email,
			perps.brotherhoodNumber, 
			perps.childhoodNumber,
			perps.studyhoodNumber,
			perps.createDate,
			perps.createBy,
			perps.createIp,
			perps.modifyDate,
			perps.modifyBy,
			perps.modifyIp
	FROM	perPerson AS perps LEFT JOIN
			perTitlePrefix AS pertp ON perps.perTitlePrefixId = pertp.id LEFT JOIN
			perGender AS pergdtp ON pertp.perGenderId = pergdtp.id LEFT JOIN			
			perGender AS pergdps ON perps.perGenderId = pergdps.id LEFT JOIN
			plcCountry AS plcco ON perps.plcCountryId = plcco.id LEFT JOIN
			perNationality AS perna ON perps.perNationalityId = perna.id LEFT JOIN
			perNationality AS perna1 ON perps.perOriginId = perna1.id LEFT JOIN
			perReligion AS perrg ON perps.perReligionId = perrg.id LEFT JOIN
			perBloodType AS perbt ON perps.perBloodTypeId = perbt.id LEFT JOIN
			perMaritalStatus AS perms ON perps.perMaritalStatusId = perms.id LEFT JOIN
			perEducationalBackground AS pereb ON perps.perEducationalBackgroundId = pereb.id
	WHERE	(perps.id = @personId)
)	