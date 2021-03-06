USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetActivity]    Script Date: 11/16/2015 16:59:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับแสดงข้อมูลความสามารถพิเศษของบุคคล>
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetActivity]
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
			perac.sportsman,
			(
				CASE perac.sportsman
					WHEN 'Y' THEN 'เคย'
					WHEN 'N' THEN 'ไม่เคย'
					ELSE NULL				
				END				
			) AS thSportsman,
			(
				CASE perac.sportsman
					WHEN 'Y' THEN 'Ever'
					WHEN 'N' THEN 'Never'
					ELSE NULL				
				END				
			) AS enSportsman,			
			perac.sportsmanDetail,
			perac.specialist,
			(
				CASE perac.specialist
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END						
			) AS thSpecialist,
			(
				CASE perac.specialist
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END						
			) AS enSpecialist,		
			perac.specialistSport,
			(
				CASE perac.specialistSport
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END				
			) AS thSpecialistSport,
			(
				CASE perac.specialistSport
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END				
			) AS enSpecialistSport,		
			perac.specialistSportDetail,				
			perac.specialistArt,
			(
				CASE perac.specialistArt
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END		
			) AS thSpecialistArt,
			(
				CASE perac.specialistArt
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END		
			) AS enSpecialistArt,
			perac.specialistArtDetail,
			perac.specialistTechnical,
			(
				CASE perac.specialistTechnical
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END		
			) AS thSpecialistTechnical,		
			(
				CASE perac.specialistTechnical
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END		
			) AS enSpecialistTechnical,			
			perac.specialistTechnicalDetail,
			perac.specialistOther,
			(
				CASE perac.specialistOther
					WHEN 'Y' THEN 'มี'
					WHEN 'N' THEN 'ไม่มี'
					ELSE NULL
				END		
			) AS thSpecialistOther,		
			(
				CASE perac.specialistOther
					WHEN 'Y' THEN 'Have'
					WHEN 'N' THEN 'Without'
					ELSE NULL
				END		
			) AS enSpecialistOther,		
			perac.specialistOtherDetail, 
			perac.activity,
			(
				CASE perac.activity
					WHEN 'Y' THEN 'เคย'
					WHEN 'N' THEN 'ไม่เคย'
					ELSE NULL				
				END				
			) AS thActivity,
			(
				CASE perac.activity
					WHEN 'Y' THEN 'Ever'
					WHEN 'N' THEN 'Never'
					ELSE NULL				
				END				
			) AS enActivity,	        
			perac.activityDetail,
			perac.reward,
			(
				CASE perac.reward
					WHEN 'Y' THEN 'เคย'
					WHEN 'N' THEN 'ไม่เคย'
					ELSE NULL				
				END				
			) AS thReward,
			(
				CASE perac.reward
					WHEN 'Y' THEN 'Ever'
					WHEN 'N' THEN 'Never'
					ELSE NULL				
				END				
			) AS enReward,                        
			perac.rewardDetail,
			perac.createDate,
			perac.createBy,
			perac.createIp, 
			perac.modifyDate,
			perac.modifyBy,
			perac.modifyIp
	FROM	fnc_perGetPerson(@personId) AS perps LEFT JOIN
			perActivity AS perac ON perps.id = perac.perPersonId
)
