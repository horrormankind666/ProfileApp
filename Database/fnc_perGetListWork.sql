USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetListWork]    Script Date: 09/21/2015 07:26:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๑/๒๕๕๗>
-- Description	: <สำหรับแสดงข้อมูลการทำงานของบุคคล>
--  1. id		เป็น VARCHAR	รับค่ารหัสบุคคล
--  2. idCard 	เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  3. name		เป็น NVARCHAR	รับค่าชื่อ
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetListWork]
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
			perwk.occupation,
			(
				CASE perwk.occupation
					WHEN '01' THEN 'รับราชการ'
					WHEN '02' THEN 'พนักงาน / ลูกจ้าง ส่วนราชการ'
					WHEN '03' THEN 'พนักงาน / ลูกจ้างเอกชน'
					WHEN '04' THEN 'พนักงานรัฐวิสาหกิจ'
					WHEN '05' THEN 'ธุรกิจส่วนตัว / ค้าขาย / อาชีพอิสระ'
					WHEN '06' THEN 'เกษตรกร / ชาวประมง'				
					WHEN '07' THEN 'องค์การมหาชน'
					WHEN '08' THEN 'รับจ้าง'
					ELSE NULL
				END				
			) AS thOccupation,
			(
				CASE perwk.occupation
					WHEN '01' THEN 'Public Servant'
					WHEN '02' THEN 'Staff / Employee Government'
					WHEN '03' THEN 'Staff / Employee in Private Company'
					WHEN '04' THEN 'State Enterprise Employees'
					WHEN '05' THEN 'Independent Business / Family Business / Freelance'
					WHEN '06' THEN 'Farmer / Fisherman'				
					WHEN '07' THEN 'Public Organization'
					WHEN '08' THEN 'Hired Hands'
					ELSE NULL
				END				
			) AS enOccupation,					
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
	FROM	fnc_perGetListPerson(@id, @idCard, @name) AS perps LEFT JOIN
			perWork AS perwk ON perps.id = perwk.perPersonId LEFT JOIN
			perAgency AS perag ON perwk.perAgencyId = perag.id
)
