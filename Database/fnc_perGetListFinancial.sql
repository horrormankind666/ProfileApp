USE [MUStudent]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetListFinancial]    Script Date: 03/14/2014 16:57:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๕/๐๑/๒๕๕๗>
-- Description	: <สำหรับแสดงข้อมูลการเงินของบุคคล>
--  1. id		เป็น VARCHAR	รับค่ารหัสบุคคล
--  2. idCard 	เป็น NVARCHAR	รับค่าเลขประจำตัวประชาชนหรือเลขหนังสือเดินทาง
--  3. name		เป็น NVARCHAR	รับค่าชื่อ
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetListFinancial]
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
			perfn.scholarshipFirstBachelor,
			(
				CASE perfn.scholarshipFirstBachelor
					WHEN 'Y' THEN 'เคย'
					WHEN 'N' THEN 'ไม่เคย'
					ELSE NULL				
				END				
			) AS thScholarshipFirstBachelor,
			(
				CASE perfn.scholarshipFirstBachelor
					WHEN 'Y' THEN 'Ever'
					WHEN 'N' THEN 'Never'
					ELSE NULL				
				END				
			) AS enScholarshipFirstBachelor,
			perfn.scholarshipFirstBachelorFrom,
			(		
				CASE perfn.scholarshipFirstBachelorFrom
					WHEN '01' THEN 'กองทุนเงินให้กู้ยืมเพื่อการศึกษา'
					WHEN '02' THEN 'หน่วยงานภาครัฐ'
					WHEN '03' THEN 'หน่วยงานภาคเอกชน'
					ELSE NULL				
				END				
			) AS thScholarshipFirstBachelorFrom,
			(		
				CASE perfn.scholarshipFirstBachelorFrom
					WHEN '01' THEN 'Student Loan'
					WHEN '02' THEN 'Government Agency'
					WHEN '03' THEN 'Private Agency'
					ELSE NULL				
				END				
			) AS enScholarshipFirstBachelorFrom,						
			perfn.scholarshipFirstBachelorName,
			perfn.scholarshipFirstBachelorMoney,
			perfn.scholarshipBachelor, 
			(
				CASE perfn.scholarshipBachelor
					WHEN 'Y' THEN 'เคย'
					WHEN 'N' THEN 'ไม่เคย'
					ELSE NULL				
				END				
			) AS thScholarshipBachelor,
			(
				CASE perfn.scholarshipBachelor
					WHEN 'Y' THEN 'Ever'
					WHEN 'N' THEN 'Never'
					ELSE NULL				
				END				
			) AS enScholarshipBachelor,			
			perfn.scholarshipBachelorFrom,
			(		
				CASE perfn.scholarshipBachelorFrom
					WHEN '01' THEN 'กองทุนเงินให้กู้ยืมเพื่อการศึกษา'
					WHEN '02' THEN 'หน่วยงานภาครัฐ'
					WHEN '03' THEN 'หน่วยงานภาคเอกชน'
					ELSE NULL				
				END				
			) AS thScholarshipBachelorFrom,
			(		
				CASE perfn.scholarshipBachelorFrom
					WHEN '01' THEN 'Student Loan'
					WHEN '02' THEN 'Government Agency'
					WHEN '03' THEN 'Private Agency'
					ELSE NULL				
				END				
			) AS enScholarshipBachelorFrom,		
			perfn.scholarshipBachelorName,
			perfn.scholarshipBachelorMoney,
			perfn.worked,
			(
				CASE perfn.worked
					WHEN 'Y' THEN 'ทำ'
					WHEN 'N' THEN 'ไม่ทำ'
					ELSE NULL
				END				
			) AS thWorked,
			(
				CASE perfn.worked
					WHEN 'Y' THEN 'Work'
					WHEN 'N' THEN 'Not Work'
					ELSE NULL
				END				
			) AS enWorked,		
			perfn.salary,
			perfn.workplace, 
			perfn.gotMoneyFrom,
			(
				CASE perfn.gotMoneyFrom
					WHEN '01' THEN 'บิดา'
					WHEN '02' THEN 'มารดา'
					WHEN '03' THEN 'บิดาและมารดา'
					WHEN '04' THEN 'กู้ยืม'
					WHEN '05' THEN 'ทำงานด้วยตนเอง'
					WHEN '06' THEN 'ผู้ปกครอง / ญาติ'
					WHEN '07' THEN 'ทุนการศึกษา'
					ELSE NULL
				END				
			) AS thGotMoneyFrom,
			(
				CASE perfn.gotMoneyFrom
					WHEN '01' THEN 'Father'
					WHEN '02' THEN 'Mother'
					WHEN '03' THEN 'Father and Mother'
					WHEN '04' THEN 'Loan'
					WHEN '05' THEN 'Self Support'
					WHEN '06' THEN 'Benefactor / Relative'
					WHEN '07' THEN 'Scholarship'
					ELSE NULL
				END				
			) AS enGotMoneyFrom,		
			perfn.gotMoneyFromOther,
			perfn.gotMoneyPerMonth,
			perfn.costPerMonth,
			perfn.createDate, 
			perfn.createBy,
			perfn.createIp,
			perfn.modifyDate,
			perfn.modifyBy,
			perfn.modifyIp
	FROM	fnc_perGetListPerson(@id, @idCard, @name) AS perps LEFT JOIN
			perFinancial AS perfn ON perps.id = perfn.perPersonId
)
