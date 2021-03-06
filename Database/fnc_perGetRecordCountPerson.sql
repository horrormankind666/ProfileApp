USE [Infinity]
GO
/****** Object:  UserDefinedFunction [dbo].[fnc_perGetRecordCountPerson]    Script Date: 11/17/2015 08:22:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๑๘/๐๖/๒๕๕๘>
-- Description	: <สำหรับเรียกดูข้อมูลจำนวนรายการของนักศึกษา>
-- Parameter
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
ALTER FUNCTION [dbo].[fnc_perGetRecordCountPerson]
(
	@personId VARCHAR(10) = NULL
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT   perper.id,
			 COUNT(perper.id) AS perPerson,
			 COUNT(peradd.perPersonId) AS perAddress,
			 COUNT(peredu.perPersonId) AS perEducation,
			 COUNT(peract.perPersonId) AS perActivity,
			 COUNT(perhea.perPersonId) AS perHealthy,
			 COUNT(perwor.perPersonId) AS perWork,
			 COUNT(perfin.perPersonId) AS perFinancial,
			 COUNT(perpar.perPersonId) AS perParent,
			 SUM((CASE WHEN perper.id IS NOT NULL THEN 1 ELSE 0 END) + 
				 (CASE WHEN peradd.perPersonId IS NOT NULL THEN 1 ELSE 0 END) +
				 (CASE WHEN peredu.perPersonId IS NOT NULL THEN 1 ELSE 0 END) +
				 (CASE WHEN peract.perPersonId IS NOT NULL THEN 1 ELSE 0 END) +
				 (CASE WHEN perhea.perPersonId IS NOT NULL THEN 1 ELSE 0 END) +
				 (CASE WHEN perwor.perPersonId IS NOT NULL THEN 1 ELSE 0 END) +
				 (CASE WHEN perfin.perPersonId IS NOT NULL THEN 1 ELSE 0 END) +
				 (CASE WHEN perpar.perPersonId IS NOT NULL THEN 1 ELSE 0 END)) AS total
	FROM	 perPerson AS perper LEFT JOIN
			 perAddress AS peradd ON perper.id = peradd.perPersonId LEFT JOIN
			 perEducation AS peredu ON perper.id = peredu.perPersonId LEFT JOIN
			 perActivity AS peract ON perper.id = peract.perPersonId LEFT JOIN
			 perHealthy AS perhea ON perper.id = perhea.perPersonId LEFT JOIN
			 perWork AS perwor ON perper.id = perwor.perPersonId LEFT JOIN
			 perFinancial AS perfin ON perper.id = perfin.perPersonId LEFT JOIN
			 perParent AS perpar ON perper.id = perpar.perPersonId
	GROUP BY perper.id
	HAVING	 (perper.id = @personId)
)