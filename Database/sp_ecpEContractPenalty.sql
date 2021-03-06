USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpEContractPenalty]    Script Date: 1/2/2559 8:26:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <20-03-2015>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpEContractPenalty]
(
	@ordertable INT = NULL,	
	@startrow INT = NULL,
	@endrow INT = NULL,
	@section CHAR(1)= NULL,
	@username VARCHAR(50) = NULL,
	@password VARCHAR(50) = NULL,
	@userlevel VARCHAR(50) = NULL,
	@usernameold VARCHAR(50) = NULL,
	@passwordold VARCHAR(50) = NULL,	
	@name VARCHAR(100) = NULL,
	@studentid VARCHAR(100) = NULL,
	@cp1id VARCHAR(10) = NULL,
	@cp2id VARCHAR(10) = NULL,
	@cmd VARCHAR(6000) = NULL,
	@usecontractinterest VARCHAR(1) = NULL,
	@casegraduate VARCHAR(1) = NULL,
	@dlevel VARCHAR(1) = NULL,
	@faculty VARCHAR(2) = NULL,
	@program VARCHAR(5) = NULL,
	@major VARCHAR(4) = NULL,
	@groupnum VARCHAR(1) = NULL,
	@statussend VARCHAR(1) = NULL,
	@statusreceiver VARCHAR(1) = NULL,
	@statusedit VARCHAR(1) = NULL,
	@statuscancel VARCHAR(1) = NULL,
	@statusrepay VARCHAR(1) = NULL,
	@statusreply VARCHAR(1) = NULL,
	@replyresult VARCHAR(1) = NULL,
	@formatpayment VARCHAR(1) = NULL,
	@statuspayment VARCHAR(1) = NULL,
	@datestart VARCHAR(10) = NULL,
	@dateend VARCHAR(10) = NULL,
	@actioncomment VARCHAR(1) = NULL,
	@capital	VARCHAR(20) = NULL,
	@interest	VARCHAR(20) = NULL,
	@pay		VARCHAR(20) = NULL,
	@paiddate	VARCHAR(10) = NULL,
	@statusstepofwork VARCHAR(2) = NULL,
	@acadamicyear VARCHAR(4) = NULL
)
	
AS

BEGIN
	DECLARE @sql VARCHAR(8000) = NULL
	DECLARE @where VARCHAR (1000) = NULL
	DECLARE @where1 VARCHAR (1000) = NULL
	DECLARE @order VARCHAR (100) = NULL
	DECLARE @nostudentid VARCHAR (400) = NULL
	DECLARE @nostudentstatus VARCHAR (400) = NULL
	DECLARE @dlevelfix VARCHAR(400) = NULL
	DECLARE @trackingstatusoraa VARCHAR(400) = NULL
	DECLARE @trackingstatusorla VARCHAR(400) = NULL
	DECLARE @trackingstatusorfa VARCHAR(400) = NULL
	DECLARE @repaystatus1 VARCHAR(400) = NULL
	DECLARE @repaystatus2 VARCHAR(400) = NULL
	
	SET @nostudentid = '(LEFT(std.studentCode, 2) NOT IN ("00", "11", "22", "97", "98", "99"))'
	SET @nostudentstatus =  '(std.status NOT BETWEEN 103 AND 108)'
	SET @dlevelfix = '(cp.dLevel IN ("U", "B"))'
	SET @trackingstatusoraa = '(CONVERT(VARCHAR, cptbc.StatusSend) + CONVERT(VARCHAR, cptbc.StatusReceiver) + CONVERT(VARCHAR, cptbc.StatusEdit) + CONVERT(VARCHAR, cptbc.StatusCancel)) IN ("1111", "1112", "2111", "2121", "2122", "2211", "2212")'
	SET @trackingstatusorla = '(CONVERT(VARCHAR, cptbc.StatusSend) + CONVERT(VARCHAR, cptbc.StatusReceiver) + CONVERT(VARCHAR, cptbc.StatusEdit) + CONVERT(VARCHAR, cptbc.StatusCancel)) IN ("2111", "2121", "2122", "2211", "2212")'
	SET @trackingstatusorfa = '(CONVERT(VARCHAR, cptbc.StatusSend) + CONVERT(VARCHAR, cptbc.StatusReceiver) + CONVERT(VARCHAR, cptbc.StatusEdit) + CONVERT(VARCHAR, cptbc.StatusCancel)) IN ("2211")'
	SET @repaystatus1 = '(CONVERT(VARCHAR, cptbc.StatusSend) + CONVERT(VARCHAR, cptbc.StatusReceiver) + CONVERT(VARCHAR, cptbc.StatusEdit) + CONVERT(VARCHAR, cptbc.StatusCancel)) IN ("2211", "2212")'
	SET @repaystatus2 = '(CONVERT(VARCHAR, cptbc.StatusSend) + CONVERT(VARCHAR, cptbc.StatusReceiver) + CONVERT(VARCHAR, cptbc.StatusEdit) + CONVERT(VARCHAR, cptbc.StatusCancel)) IN ("2211")'
	
	/*ตรวจสอบสิทธิ์ผู้ใช้งานว่าเป็นเจ้าหน้าที่กองทะเบียนหรือเจ้าหน้าที่กองกฏหมาย*/
	IF (@ordertable = 1)
	BEGIN
		SET @sql = 'SELECT * FROM ecpTabUser WHERE (Username = "' + @username + '") AND (Password = "' + @password + '")'
		EXEC (@sql)
	END
	
	/*SELECT ecpTabUser*/
	IF (@ordertable = 36)
	BEGIN
		SET @where = ''
				
		IF (@userlevel <> NULL)
			SET @where = '(cptu.UserLevel = "' + @userlevel + '")'
		
		IF ((@username <> NULL) AND (@password <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '(cptu.Username = "' + @username + '") AND (cptu.Password = "' + @password + '")'
		END			
				
		IF (@name <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptu.Name LIKE "%' + @name + '%")'
		END
				
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'
				
		SET @sql = 'SELECT	COUNT(cptu.Username) AS CountCPTabUser
					FROM	ecpTabUser AS cptu
					WHERE	(cptu.UserSection = "' + @section + '")' + @where
		EXEC (@sql)

		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptu.Username) AS RowNum,
									cptu.Username, cptu.Password, cptu.Name, cptu.UserSection, cptu.UserLevel
							 FROM	ecpTabUser AS cptu
							 WHERE	(cptu.UserSection = "' + @section + '")' + @where + ') AS cptu1'		

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptu1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
	
	/*SELECT ecpTabUser ON REPEAT*/
	IF (@ordertable = 37)
	BEGIN
		SET @where = ''	
			
		IF ((@username <> NULL) AND (@password = NULL))
		BEGIN
			SET @where = ' WHERE (cptu.Username = "' + @username + '")'
			IF (@usernameold <> NULL) SET @where = @where + ' AND (cptu.Username <> "' + @usernameold + '")'
		END			
			
		IF ((@username = NULL) AND (@password <> NULL))
		BEGIN
			SET @where = ' WHERE (cptu.Password = "' + @Password + '")'
			IF (@passwordold <> NULL) SET @where = @where + ' AND (cptu.Password <> "' + @passwordold + '")'
		END			

		SET @sql = 'SELECT	cptu.Username, cptu.Password 
				    FROM	ecpTabUser AS cptu'
		SET @sql = @sql + @where					   
		EXEC (@sql)
	END		
	
	/*SELECT ecpTabCalDate*/
	IF (@ordertable = 2)
	BEGIN
		SET @where = ''	
			
		IF (@cp1id <> NULL) SET @where = ' WHERE (ecptcd.ID = ' + @cp1id + ')'
					
		SET @sql = 'SELECT	ecptcd.ID, ecptcd.CalDateCondition, ecptcd.PenaltyFormula 
				    FROM	ecpTabCalDate AS ecptcd'
		SET @sql = @sql + @where					   
		SET @sql = @sql + ' ORDER BY ecptcd.ID'
		EXEC (@sql)
	END	
	
	/*SELECT ecpTabInterest*/
	IF (@ordertable = 3)
	BEGIN
		SET @where = ''		
		
		IF (@cp1id <> NULL) SET @where = ' WHERE (cpti.ID = ' + @cp1id + ')'
		IF (@usecontractinterest <> NULL) SET @where = ' WHERE (cpti.UseContractInterest = ' + @usecontractinterest + ')'
			
		SET @sql = 'SELECT	cpti.ID, cpti.InContractInterest, cpti.OutContractInterest, cpti.UseContractInterest
				    FROM	ecpTabInterest AS cpti'
		SET @sql = @sql + @where					   
		SET @sql = @sql + ' ORDER BY cpti.ID'
		EXEC (@sql)
	END		

	/*SELECT ecpTabPayBreakContract*/ 
	IF (@ordertable = 4)
	BEGIN
		SET @where = ''	
			
		IF (@cp1id <> NULL) SET @where = ' WHERE (cptpbc.ID = ' + @cp1id + ')'

		SET @sql = 'SELECT	cptpbc.ID, cptpbc.FacultyCode, bf.nameTh As FactTName, cptpbc.ProgramCode,
							cp.nameTh As ProgTName, cptpbc.MajorCode, cptpbc.GroupNum, cptpbc.AmountCash,
							cptpbc.Dlevel, 
							(
								CASE cptpbc.Dlevel
									WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
									WHEN "B" THEN "ปริญญาตรี"
									ELSE NULL
								END					
							) AS DlevelName,														
							cptpbc.CaseGraduate, 
							(
								CASE cptpbc.CaseGraduate
									WHEN "1" THEN "ก่อนสำเร็จการศึกษา"
									WHEN "2" THEN "หลังสำเร็จการศึกษา"
									ELSE NULL
								END					
							) AS CaseGraduateName,																					
							cptpbc.CalDateCondition AS IDCalDate,
							cptcd.CalDateCondition, cptcd.PenaltyFormula, cptpbc.AmtIndemnitorYear
				    FROM	ecpTabPayBreakContract AS cptpbc INNER JOIN
							acaFaculty AS bf ON cptpbc.FacultyCode = bf.facultyCode INNER JOIN
							ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cptpbc.ProgramCode = cptpg.ProgramCode AND cptpbc.MajorCode = cptpg.MajorCode AND cptpbc.GroupNum = cptpg.GroupNum AND cptpbc.Dlevel = cptpg.Dlevel INNER JOIN
							acaProgram AS cp ON bf.id = cp.facultyId AND cptpg.ProgramCode = cp.programCode AND cptpg.MajorCode = cp.majorCode AND cptpg.GroupNum = cp.groupNum AND cptpg.Dlevel = cp.dLevel INNER JOIN
							ecpTabCalDate AS cptcd ON cptpbc.CalDateCondition = cptcd.ID'
		SET @sql = @sql + @where					   
		SET @sql = @sql + ' ORDER BY cptpbc.CaseGraduate, DlevelName, cptpbc.ProgramCode'
		EXEC (@sql)
	END		

	/*SELECT FACULTY*/
	IF (@ordertable = 5)
	BEGIN
		SET @sql = 'SELECT	bf.id,bf.FacultyCode, bf.nameTh As FactTName
				    FROM	acaFaculty AS bf'
		SET @sql = @sql + ' ORDER BY bf.FacultyCode'					   
		EXEC (@sql)
	END		

	/*SELECT PROGRAM ON FACULTY*/
	IF (@ordertable = 6)
	BEGIN
		SET @where = ''		
		
		IF ((@dlevel = NULL) AND (@faculty <> NULL))
			SET @where = ' WHERE (' + @dlevelfix + ') AND (bf.facultyCode = "' + @faculty + '")'

		IF ((@dlevel <> NULL) AND (@faculty <> NULL))
			SET @where = ' WHERE (' + @dlevelfix + ') AND (bf.facultyCode = "' + @faculty + '") AND (cp.dLevel = "' + @dlevel + '")'

		SET @sql = 'SELECT	cp.id,cp.ProgramCode, cp.MajorCode, cp.GroupNum, cp.nameTh As ProgTName, cp.dLevel,
							(
								CASE cp.dLevel
									WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
									WHEN "B" THEN "ปริญญาตรี"
									ELSE NULL
								END					
							) AS DLevelName		
				    FROM	acaProgram AS cp 
						    INNER JOIN acaFaculty AS bf ON cp.facultyId = bf.id'
		SET @sql = @sql + @where				    
		SET @sql = @sql + ' ORDER BY cp.ProgramCode'
		EXEC (@sql)
	END		

	/*SELECT ecpTabPayBreakContract ON REPEAT*/
	IF (@ordertable = 7)
	BEGIN
		SET @where = ''	
			
		IF ((@casegraduate <> NULL) AND
			(@dlevel <> NULL) AND
			(@faculty <> NULL) AND
			(@program <> NULL) AND
			(@major <> NULL) AND
			(@groupnum <> NULL))
		BEGIN			
			SET @where = ' WHERE ((cptpbc.CaseGraduate = ' + @casegraduate + ') AND
								  (cptpbc.Dlevel = "' + @dlevel + '") AND
								  (cptpbc.FacultyCode = "' + @faculty + '") AND
								  (cptpbc.ProgramCode = "' + @program + '") AND
								  (cptpbc.MajorCode = "' + @major + '") AND
								  (cptpbc.GroupNum = "' + @groupnum + '"))'							  
			IF (@cp1id <> NULL) SET @where = @where + ' AND (cptpbc.ID <> ' + @cp1id + ')'
		END
		
		SET @sql = 'SELECT	cptpbc.ID, cptpbc.CalDateCondition, cptpbc.AmtIndemnitorYear, cptpbc.AmountCash
				    FROM	ecpTabPayBreakContract AS cptpbc INNER JOIN
							acaFaculty AS bf ON cptpbc.FacultyCode = bf.facultyCode INNER JOIN
							ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cptpbc.ProgramCode = cptpg.ProgramCode AND cptpbc.MajorCode = cptpg.MajorCode AND cptpbc.GroupNum = cptpg.GroupNum AND cptpbc.Dlevel = cptpg.Dlevel INNER JOIN
							acaProgram AS cp ON bf.id = cp.facultyId AND cptpg.ProgramCode = cp.programCode AND cptpg.MajorCode = cp.majorCode AND cptpg.GroupNum = cp.groupNum AND cptpg.Dlevel = cp.dLevel INNER JOIN
							ecpTabCalDate AS cptcd ON cptpbc.CalDateCondition = cptcd.ID'
		SET @sql = @sql + @where					   
		SET @sql = @sql + ' ORDER BY cptpbc.ID'
		EXEC (@sql)
	END		

	/*SELECT STDSTUDENT*/
	IF (@ordertable = 8)
	BEGIN
		SET @where = ''

		IF (@studentid <> NULL)
			SET @where = ' AND ((std.studentCode LIKE "' + @studentid + '%") OR (perpes.firstName LIKE "%' + @studentid + '%") OR (perpes.lastName LIKE "%' + @studentid + '%"))'
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where		
			SET @where = @where + ' AND (cptpg.FacultyCode = "' + @faculty + '")'
		END

		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where
			SET @where = @where + ' AND ((cptpg.ProgramCode = "' + @program + '") AND (cptpg.MajorCode = "' + @major + '") AND (cptpg.GroupNum = "' + @groupnum + '"))'
		END

		IF (@where <> '') 
			SET @where = @where

		SET @where = ' WHERE ' + @nostudentid + @where

		SET @sql = 'SELECT	COUNT(std.id) AS CountStudent
					FROM	stdStudent AS std LEFT JOIN
							acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
							acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
							perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
							perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
							ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel LEFT JOIN
							ectDocMgmt AS cd ON std.id = cd.StudentID AND std.programId = cd.programId'
		SET @sql = @sql + @where					
		EXEC (@sql)

		SET @sql = 'SELECT	*
					FROM	(SELECT ROW_NUMBER() OVER(ORDER BY std.id) AS RowNum,
									std.studentCode AS StudentID, perpes.perTitlePrefixId AS TitleCode, bt.enTitleInitials AS TitleEName, bt.thTitleFullName AS TitleTName, perpes.enFirstName AS FirstName, perpes.enLastName AS LastName, perpes.firstName AS ThaiFName, perpes.lastName AS ThaiLName,
									cptpg.FacultyCode, bf.nameTh AS FactTName, cptpg.ProgramCode, cp.nameTh AS ProgTName,
									cptpg.MajorCode, cptpg.GroupNum, cptpg.DLevel,
									(
										CASE cptpg.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END					
									) AS DLevelName,														
									(SUBSTRING(CONVERT(VARCHAR, std.admissionDate, 103), 1, 6) + CONVERT(VARCHAR, CONVERT(INT, SUBSTRING(CONVERT(VARCHAR, std.admissionDate, 103), 7, 4)) + 543)) AS AdmissionDate,
									(SUBSTRING(CONVERT(VARCHAR, std.graduateDate, 103), 1, 6) + CONVERT(VARCHAR, CONVERT(INT, SUBSTRING(CONVERT(VARCHAR, std.graduateDate, 103), 7, 4)) + 543)) AS GraduateDate,
									(SUBSTRING(CONVERT(VARCHAR, cd.contractDateSignByStudent, 103), 1, 6) + CONVERT(VARCHAR, CONVERT(INT, SUBSTRING(CONVERT(VARCHAR, cd.contractDateSignByStudent, 103), 7, 4)) + 543)) AS ContractDate,
									(SUBSTRING(CONVERT(VARCHAR, cd.contractDateSignByParent2, 103), 1, 6) + CONVERT(VARCHAR, CONVERT(INT, SUBSTRING(CONVERT(VARCHAR, cd.contractDateSignByParent2, 103), 7, 4)) + 543)) AS ContractDateAgreement,
									vwp.TitleTName AS GuarantorTitleTName, vwp.FirstName AS GuarantorFirstName, vwp.LastName AS GuarantorLastName
							 FROM	stdStudent AS std LEFT JOIN
									acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
									acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
									perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
									perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
									ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel LEFT JOIN
									ectDocMgmt AS cd ON std.id = cd.StudentID AND std.programId = cd.programId LEFT JOIN
									vw_ectGetListParent AS vwp ON cd.StudentID = vwp.id AND cd.parentCode = vwp.Type ' + @where + ') AS std1 '
		
		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (std1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'
		EXEC (@sql)

		IF ((@studentid <> NULL) AND (@faculty = NULL) AND (@program = NULL) AND (@major = NULL) AND (@groupnum = NULL))
		BEGIN
			SET @where = ' WHERE spl.studentCode = "' + @studentid + '"'

			SET @sql = 'SELECT	DISTINCT spl.studentCode, spl.pictureName AS FileName, "" AS FolderName
						FROM	stdStudent AS spl'
			SET @sql = @sql + @where					   					
			SET @sql = @sql + ' ORDER BY spl.studentCode'
			EXEC (@sql)
		END		

	END

	/*SELECT STUDENT IN ecpTransBreakContract*/
	IF (@ordertable = 9)
	BEGIN
		SET @where = ''
	
		IF (@studentid <> NULL)
			SET @where = ' WHERE (cptbc.StudentID = "' + @studentid + '") AND (cptbc.StatusCancel = 1)'
		
		SET @sql = 'SELECT	cptbc.ID, cptbc.StudentID 
					FROM	ecpTransBreakContract AS cptbc'
		SET @sql = @sql + @where					   					
		EXEC (@sql)
	END
	
	/*SELECT ecpTransBreakContract*/
	IF (@ordertable = 10)
	BEGIN
		SET @where = ''
		SET @order = ''
		
		IF (@cp1id <> NULL)
			SET @where = '(cptbc.ID = ' + @cp1id + ')'

		IF (@statussend <> NULL AND @statusedit <> NULL AND @statuscancel <> NULL)		
			SET @where = '(((cptbc.StatusSend = ' + @statussend + ') AND (cptbc.StatusReceiver = 1) AND (cptbc.StatusEdit = 1) AND (cptbc.StatusCancel = 1)) OR
						   ((cptbc.StatusSend = 2) AND (cptbc.StatusReceiver = 1) AND (cptbc.StatusEdit = ' + @statusedit + ') AND (cptbc.StatusCancel = 1)) OR
						   (cptbc.StatusCancel = ' + @statuscancel + '))'
		ELSE					
			BEGIN
				IF (@statussend <> NULL)
					SET @where = '((cptbc.StatusSend = ' + @statussend + ') AND (cptbc.StatusReceiver = 1) AND (cptbc.StatusEdit = 1) AND (cptbc.StatusCancel = 1))'

				IF (@statusreceiver <> NULL)
					SET @where = '((cptbc.StatusSend = 2) AND (cptbc.StatusReceiver = ' + @statusreceiver + ') AND (cptbc.StatusEdit = 1) AND (cptbc.StatusCancel = 1))'
		
				IF (@statusedit <> NULL)				
					SET @where = '((cptbc.StatusSend = 2) AND (cptbc.StatusReceiver = 1) AND (cptbc.StatusEdit = ' + @statusedit + ') AND (cptbc.StatusCancel = 1))'

				IF (@statuscancel <> NULL)	
					SET @where = '(cptbc.StatusCancel = ' + @statuscancel + ')'
			END
		
		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '" or cptbc.facultyId = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '(((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '")) or cptbc.programId ="' + @program + '" )'
		END
		
		IF ((@datestart <> NULL) AND (@dateend <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			IF (@section = '1') SET @where = @where + '(CONVERT(DATE,cptbc.DateTimeSend) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'				
			IF (@section = '2') SET @where = @where + '(CONVERT(DATE,cptbc.DateTimeCreate) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		END
		
		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '
		
		IF (@section = '1')	SET @where = @where + @trackingstatusorla
		IF (@section = '2') SET @where = @where + @trackingstatusoraa		
		IF (@section = '3') SET @where = @where + @trackingstatusorfa		
		
		SET @sql = 'SELECT	COUNT(cptbc.ID) AS CountCPTransBreakContract
					FROM	ecpTransBreakContract AS cptbc'
		SET @sql = @sql + @where	
		EXEC (@sql)

		IF (@section = '1')	SET @order = 'cptbc.DateTimeSend'
		IF (@section = '2') SET @order = 'cptbc.DateTimeCreate'
		IF (@section = '3') SET @order = 'cptbc.StudentID'
		
		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY ' + @order + ' DESC) AS RowNum,
									cptbc.ID, cptbc.StudentID, cptbc.TitleCode, cptbc.TitleEName, cptbc.TitleTName, cptbc.FirstEName, cptbc.LastEName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName,																							
									cptbc.PursuantBook, cptbc.Pursuant, cptbc.PursuantBookDate, cptbc.Location, 
									cptbc.InputDate, cptbc.StateLocation, cptbc.StateLocationDate,
									cptbc.ContractDate, cptbc.ContractDateAgreement, cptbc.Guarantor, cptbc.ScholarFlag, cptbc.ScholarshipMoney, cptbc.ScholarshipYear, cptbc.ScholarshipMonth,
									cptbc.EducationDate, cptbc.GraduateDate, cptbc.ContractForceStartDate, cptbc.ContractForceEndDate,
									cptbc.CaseGraduate, cptbc.CivilFlag, cptbc.CalDateCondition, cptbc.IndemnitorYear, cptbc.IndemnitorCash,
									cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel,
									cptbc.DateTimeCreate, cptbc.DateTimeModify, cptbc.DateTimeCancel, cptbc.DateTimeSend, cptbc.DateTimeReceiver,
									spl1.FileName, spl1.FolderName
							 FROM	ecpTransBreakContract AS cptbc LEFT JOIN
									(SELECT DISTINCT spl.studentCode AS StudentID, spl.pictureName AS FileName, "" AS FolderName FROM stdStudent AS spl) AS spl1 ON cptbc.StudentID = spl1.StudentID' + @where + ' ) AS cptbc1'		

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptbc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END

	/*SELECT PROVINCE*/
	IF (@ordertable = 11)
	BEGIN
		SET @sql = 'SELECT	 bp.id AS ProvinceID, bp.provinceNameTH AS ProvinceTName
				    FROM	 plcProvince AS bp
					WHERE	 (bp.plcCountryId = "217")
					ORDER BY bp.provinceNameTH'
		EXEC (@sql)
	END			

	/*SELECT ecpTransRequireContract*/
	IF (@ordertable = 12)
	BEGIN
		SET @where = ''
		
		IF (@cp1id <> NULL)
			SET @where = '(cptbc.ID = ' + @cp1id + ')'

		IF (@statusrepay <> NULL)
			SET @where = '(cptrc.StatusRepay = ' + @statusrepay + ')'
		
		IF (@statusreply <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrp.StatusReply = ' + @statusreply + ')'
		END			

		IF (@replyresult <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrp.ReplyResult = ' + @replyresult + ')'
		END			

		IF (@statuspayment <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrc.StatusPayment = ' + @statuspayment + ')'
		END			

		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END
		
		IF ((@datestart <> NULL) AND (@dateend <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '(CONVERT(DATE,cptbc.DateTimeReceiver) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		END
		
		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '
		
		IF (@cp1id <> NULL)
			SET @where = @where + @repaystatus1
		ELSE
			SET @where = @where + @repaystatus2			
		
		SET @sql = 'SELECT	COUNT(cptrc.ID) AS CountRepay
					FROM	ecpTransRequireContract AS cptrc LEFT JOIN
							ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
							plcProvince AS bp ON cptrc.Province = bp.id INNER JOIN
							ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID'
		SET @sql = @sql + @where					   										
		EXEC (@sql)
		
		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.DateTimeReceiver DESC) AS RowNum,
									cptrc.ID, cptrc.BCID, cptrc.IndemnitorAddress, bp.id AS ProvinceID, bp.provinceNameTH AS ProvinceTName,
									cptrc.RequireDate, cptrc.ApproveDate, cptrc.ActualMonthScholarship, cptrc.ActualScholarship, cptrc.TotalPayScholarship,
									cptrc.ActualMonth, cptrc.ActualDay, cptrc.AllActualDate, cptrc.ActualDate, cptrc.RemainDate, cptrc.SubtotalPenalty, cptrc.TotalPenalty,
									cptrc.StatusRepay, cptrc.StatusPayment,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName,																																
									cptbc.PursuantBook, cptbc.Pursuant, cptbc.PursuantBookDate, cptbc.Location,
									cptbc.InputDate, cptbc.StateLocation, cptbc.StateLocationDate,
									cptbc.ContractDate, cptbc.ContractDateAgreement, cptbc.Guarantor, cptbc.ScholarFlag, cptbc.ScholarshipMoney, cptbc.ScholarshipYear, cptbc.ScholarshipMonth,
									cptbc.EducationDate, cptbc.GraduateDate, cptbc.ContractForceStartDate, cptbc.ContractForceEndDate,
									cptbc.CaseGraduate, cptbc.CivilFlag, cptbc.CalDateCondition, cptbc.IndemnitorYear, cptbc.IndemnitorCash,
									cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel,
									cptbc.DateTimeCreate, cptbc.DateTimeModify, cptbc.DateTimeCancel, cptbc.DateTimeSend, cptbc.DateTimeReceiver,
									spl1.FileName, spl1.FolderName								
							FROM	ecpTransRequireContract AS cptrc LEFT JOIN
									ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
									plcProvince AS bp ON cptrc.Province = bp.id INNER JOIN
									ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID LEFT JOIN
									(SELECT DISTINCT spl.studentCode AS StudentID, spl.pictureName AS FileName, "" AS FolderName FROM stdStudent AS spl) AS spl1 ON cptbc.StudentID = spl1.StudentID' + @where + ' ) AS cptrc1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptrc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
	
	/*SEARCH STATUS REPAY DETAIL*/
	IF (@ordertable = 13)
	BEGIN
		SET @where = '(cptrc.StatusRepay <> 0) AND (cptrc.StatusPayment <> 2) AND (cptrc.StatusPayment <> 3) '
		
		IF (@cp2id <> NULL)
			SET @where = @where + 'AND (cptrp.RCID = ' + @cp2id + ') '

		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '
		
		SET @where = @where + @repaystatus1

		SET @sql = 'SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.StatusReply, cptrp.ReplyResult
					FROM	ecpTransRepayContract AS cptrp INNER JOIN
							ecpTransRequireContract AS cptrc ON cptrp.RCID = cptrc.ID INNER JOIN
							ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID		'
		SET @sql = @sql + @where
		SET @sql = @sql + ' ORDER BY cptrp.RCID, cptrp.StatusRepay'
		EXEC (@sql)
	END
	
	/*SELECT CPTabScholarship*/
	IF (@ordertable = 14)
	BEGIN
		SET @where = ''	
			
		IF (@cp1id <> NULL) SET @where = ' WHERE (cptss.ID = ' + @cp1id + ')'

		SET @sql = 'SELECT	cptss.ID, cptss.FacultyCode, bf.nameTh AS FactTName, cptss.ProgramCode,
							cp.nameTh AS ProgTName, cptss.MajorCode, cptss.GroupNum, cptss.ScholarshipMoney,
							cptss.Dlevel, 
							(
								CASE cptss.Dlevel
									WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
									WHEN "B" THEN "ปริญญาตรี"
									ELSE NULL
								END					
							) AS DlevelName																			
				    FROM	ecpTabScholarship AS cptss INNER JOIN
							acaFaculty AS bf ON cptss.FacultyCode = bf.facultyCode INNER JOIN
							ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cptss.ProgramCode = cptpg.ProgramCode AND cptss.MajorCode = cptpg.MajorCode AND cptss.GroupNum = cptpg.GroupNum AND cptss.Dlevel = cptpg.Dlevel INNER JOIN
							acaProgram AS cp ON bf.id = cp.facultyId AND cptpg.ProgramCode = cp.programCode AND cptpg.MajorCode = cp.majorCode AND cptpg.GroupNum = cp.groupNum AND cptpg.Dlevel = cp.dLevel '
		SET @sql = @sql + @where					   
		SET @sql = @sql + ' ORDER BY DlevelName, cptss.FacultyCode, cptss.ProgramCode'
		EXEC (@sql)
	END		

	/*SELECT ecpTabScholarship ON REPEAT*/
	IF (@ordertable = 15)
	BEGIN
		SET @where = ''	
			
		IF ((@dlevel <> NULL) AND
			(@faculty <> NULL) AND
			(@program <> NULL) AND
			(@major <> NULL) AND
			(@groupnum <> NULL))
		BEGIN			
			SET @where = ' WHERE ((cptss.Dlevel = "' + @dlevel + '") AND
								  (cptss.FacultyCode = "' + @faculty + '") AND
								  (cptss.ProgramCode = "' + @program + '") AND
								  (cptss.MajorCode = "' + @major + '") AND
								  (cptss.GroupNum = "' + @groupnum + '"))'							  
			IF (@cp1id <> NULL) SET @where = @where + ' AND (cptss.ID <> ' + @cp1id + ')'
		END
		
		SET @sql = 'SELECT	cptss.ID, cptss.ScholarshipMoney
				    FROM	ecpTabScholarship AS cptss INNER JOIN
							acaFaculty AS bf ON cptss.FacultyCode = bf.facultyCode INNER JOIN
							ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cptss.ProgramCode = cptpg.ProgramCode AND cptss.MajorCode = cptpg.MajorCode AND cptss.GroupNum = cptpg.GroupNum AND cptss.Dlevel = cptpg.Dlevel INNER JOIN
							acaProgram AS cp ON bf.id = cp.facultyId AND cptpg.ProgramCode = cp.programCode AND cptpg.MajorCode = cp.majorCode AND cptpg.GroupNum = cp.groupNum AND cptpg.Dlevel = cp.dLevel'
		SET @sql = @sql + @where					   
		SET @sql = @sql + ' ORDER BY cptss.ID'
		EXEC (@sql)
	END		

	/*SELECT ecpTransRepayContract*/
	IF (@ordertable = 16)
	BEGIN
		SET @where = ''
		
		IF (@cp2id <> NULL)
			SET @where = '(cptrc.ID = ' + @cp2id + ')'
		
		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '
		
		SET @where = @where + @repaystatus2

		SET @sql = 'SELECT	cptrc.ID, cptrc.BCID, cptrc.TotalPenalty, cptrc.StatusRepay, cptrp.StatusReply, cptrp.ReplyResult,
							cptrp.RepayDate, cptrp.ReplyDate, cptrc.StatusPayment
					FROM	ecpTransRepayContract AS cptrp INNER JOIN
							ecpTransRequireContract AS cptrc ON cptrp.RCID = cptrc.ID AND cptrp.StatusRepay = cptrc.StatusRepay INNER JOIN
							ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID'
		SET @sql = @sql + @where
		SET @sql = @sql + ' ORDER BY cptrp.RCID, cptrp.StatusRepay'
		EXEC (@sql)
	END

	/*SEARCH MAX REPLY DATE*/
	IF (@ordertable = 17)
	BEGIN	
		SET @where = ''
		
		IF (@cp2id <> NULL)
			SET @where = '(cptrp.RCID = ' + @cp2id + ') '

		IF (@where <> '') 
			SET @where = ' WHERE ' + @where
		
		SET @sql = 'SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.RepayDate, cptrp.StatusReply, cptrp.ReplyResult, cptrp.ReplyDate
					FROM	ecpTransRepayContract AS cptrp INNER JOIN
							(SELECT		cptrp.RCID, MAX(cptrp.StatusRepay) AS StatusRepay
							 FROM		ecpTransRepayContract AS cptrp
							 GROUP BY	cptrp.RCID) AS cptrp1 ON cptrp.RCID = cptrp1.RCID AND cptrp.StatusRepay = cptrp1.StatusRepay'
		SET @sql = @sql + @where
		SET @sql = @sql + ' ORDER BY cptrp.RCID, cptrp.StatusRepay'
		EXEC (@sql)
	END		

	/*SELECT ecpTransRepayContract No Current Status Repay*/
	IF (@ordertable = 18)
	BEGIN
		SET @where = ''
		
		IF ((@cp2id <> NULL) AND (@statusrepay <> NULL))
			SET @where = '(cptrp.RCID = ' + @cp2id + ') AND (cptrp.StatusRepay <> ' + @statusrepay + ')'
		
		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '
		
		SET @where = @where + @repaystatus2

		SET @sql = '	SELECT	cptrc.ID, cptrc.BCID, cptrp.StatusRepay, cptrp.StatusReply, cptrp.ReplyResult,
							cptrp.RepayDate, cptrp.ReplyDate
					FROM	ecpTransRepayContract AS cptrp INNER JOIN
							ecpTransRequireContract AS cptrc ON cptrp.RCID = cptrc.ID INNER JOIN
							ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID'
		SET @sql = @sql + @where
		SET @sql = @sql + ' ORDER BY cptrp.StatusRepay'
		EXEC (@sql)
	END

	/*SELECT Payment On ecpTransRequireContract*/
	IF (@ordertable = 19)
	BEGIN
		SET @where = ''
		
		IF (@cp2id <> NULL)
			SET @where = '(cptrc.ID = ' + @cp2id + ')'

		IF (@statusrepay <> NULL)
			SET @where = '(cptrc.StatusRepay = ' + @statusrepay + ')'

		IF (@statuspayment <> NULL)
			SET @where = '(cptrc.StatusPayment = ' + @statuspayment + ')'

		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END
			
		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '
		
		SET @where = @where + '(cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1) AND ' + @repaystatus2
		
		SET @sql = 'SELECT	COUNT(cptrc.ID) AS CountPayment
					FROM	ecpTransRepayContract AS cptrp INNER JOIN
							ecpTransRequireContract AS cptrc ON cptrp.RCID = cptrc.ID AND cptrp.StatusRepay = cptrc.StatusRepay INNER JOIN
							ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID'
		SET @sql = @sql + @where					   										
		EXEC (@sql)
		
		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.StudentID) AS RowNum,
									cptrc.ID, cptrc.BCID, cptrc.IndemnitorAddress, bp.id AS ProvinceID, bp.provinceNameTH AS ProvinceTName,
									cptrc.RequireDate, cptrc.ApproveDate, cptrc.ActualMonthScholarship, cptrc.ActualScholarship, cptrc.TotalPayScholarship,
									cptrc.ActualMonth, cptrc.ActualDay, cptrc.AllActualDate, cptrc.ActualDate, cptrc.RemainDate, cptrc.SubtotalPenalty, cptrc.TotalPenalty,
									cptrc.StatusRepay, cptrc.StatusPayment, cptrc.FormatPayment, cptrp.StatusReply, cptrp.ReplyDate,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName,																																									
									cptbc.PursuantBook, cptbc.Pursuant, cptbc.PursuantBookDate, cptbc.Location,
									cptbc.InputDate, cptbc.StateLocation, cptbc.StateLocationDate,
									cptbc.ContractDate, cptbc.Guarantor, cptbc.ScholarFlag, cptbc.ScholarshipMoney, cptbc.ScholarshipYear, cptbc.ScholarshipMonth,
									cptbc.EducationDate, cptbc.GraduateDate, cptbc.ContractForceStartDate, cptbc.ContractForceEndDate,
									cptbc.CaseGraduate, cptbc.CivilFlag, cptbc.CalDateCondition, cptbc.IndemnitorYear, cptbc.IndemnitorCash,
									cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel,
									cptbc.DateTimeCreate, cptbc.DateTimeModify, cptbc.DateTimeCancel, cptbc.DateTimeSend, cptbc.DateTimeReceiver,
									spl1.FileName, spl1.FolderName
							FROM	ecpTransRepayContract AS cptrp INNER JOIN
									ecpTransRequireContract AS cptrc ON cptrp.RCID = cptrc.ID AND cptrp.StatusRepay = cptrc.StatusRepay LEFT JOIN
									plcProvince AS bp ON cptrc.Province = bp.id INNER JOIN
									ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID LEFT JOIN
									(SELECT DISTINCT spl.studentCode AS StudentID, spl.pictureName AS FileName, "" AS FolderName FROM stdStudent AS spl) AS spl1 ON cptbc.StudentID = spl1.StudentID' + @where + ' ) AS cptrc1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptrc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
	
	/*SELECT Last Comment ON Reject ecpTransBreakContract*/
	IF (@ordertable = 20)
	BEGIN	
		SET @where = ''
		
		IF ((@cp1id <> NULL) AND (@actioncomment <> NULL))
			SET @where = '(cptrj.BCID = ' + @cp1id + ') AND (cptrj.Action = "' + @actioncomment + '")'

		IF (@where <> '') 
			SET @where = ' HAVING ' + @where
		
		SET @sql = 'SELECT	cptrj.ID, cptrj.BCID, cptrj.Comment, cptrj.DateTimeReject
					FROM	ecpTransReject AS cptrj INNER JOIN
							(SELECT		MAX(cptrj.ID) AS ID, cptrj.BCID
							 FROM		ecpTransReject AS cptrj INNER JOIN
										ecpTransBreakContract AS cptbc ON cptrj.BCID = cptbc.ID
							 GROUP BY	cptrj.BCID, cptrj.Action' + @where +' ) AS cptrj1 ON cptrj.ID = cptrj1.ID'
		EXEC (@sql)
	END		

	/*SELECT ecpTransPayment*/
	IF (@ordertable = 21)
	BEGIN
		SET @where = ''
		SET @where1 = ''
		
		IF (@cp1id <> NULL)
			SET @where = '(cptpy.RCID = ' + @cp1id + ')'
		
		IF (@cp2id <> NULL)
			SET @where = '(cptpy.ID = ' + @cp2id + ')'

		IF ((@datestart <> NULL) AND (@dateend <> NULL))
			SET @where1 = '(CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptpy.DateTimePayment, 7, 4)) - 543)) + "-" + SUBSTRING(cptpy.DateTimePayment, 4, 2) + "-" + SUBSTRING(cptpy.DateTimePayment, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'			

		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '
			
		IF (@where1 <> '') 
			SET @where1 = @where + @where1 + ' AND '
		ELSE
			SET @where1 = @where
		
		SET @where = @where + '(cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1) AND ' + @repaystatus2
		SET @where1 = @where1 + '(cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1) AND ' + @repaystatus2

		SET @sql = 'SELECT	cptpy1.*
					FROM	ecpTransRequireContract AS cptrc INNER JOIN
							ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
							ecpTransPayment AS cptpy ON cptrc.ID = cptpy.RCID INNER JOIN
							ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID INNER JOIN	
							(SELECT	(ROW_NUMBER() OVER(ORDER BY cptpy.ID)) AS RowNum,
									cptpy.ID, cptpy.RCID, cptpy.CalInterestYesNo, cptpy.OverpaymentDateStart, cptpy.OverpaymentDateEnd,
									cptpy.OverpaymentYear, cptpy.OverpaymentDay, cptpy.OverpaymentInterest, cptpy.OverpaymentTotalInterest,
									cptpy.PayRepayDateStart, cptpy.PayRepayDateEnd, cptpy.PayRepayYear, cptpy.PayRepayDay,
									cptpy.PayRepayInterest, cptpy.PayRepayTotalInterest, cptpy.DateTimePayment,
									cptpy.Capital, cptpy.Interest, cptpy.TotalAccruedInterest, cptpy.TotalPayment, cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay,
									cptpy.RemainCapital, cptpy.AccruedInterest, cptpy.RemainAccruedInterest, cptpy.TotalRemain, cptpy.Channel,
									cptpy.ReceiptNo, cptpy.ReceiptBookNo, cptpy.ReceiptDate, cptpy.ReceiptSendNo, ReceiptFund,
									cptpy.ChequeNo, cptpy.ChequeBank, cptpy.ChequeBankBranch, cptpy.ChequeDate,
									cptpy.CashBank, cptpy.CashBankBranch, cptpy.CashBankAccount, cptpy.CashBankAccountNo, cptpy.CashBankDate
							 FROM	ecpTransRequireContract AS cptrc INNER JOIN
									ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
									ecpTransPayment AS cptpy ON cptrc.ID = cptpy.RCID INNER JOIN
									ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID' + @where + ') AS cptpy1 ON cptpy.ID = cptpy1.ID'
		SET @sql = @sql + @where1					   										
		EXEC (@sql)
	END

	/*SELECT Last Trans Payment*/
	IF (@ordertable = 22)
	BEGIN	
		SET @where = ''
		
		IF (@cp2id <> NULL)
			SET @where = '(cptpy.RCID = ' + @cp2id + ')'
		
		IF (@where <> '') 
			SET @where = ' HAVING ' + @where
		
		SET @sql = 'SELECT	cptpy.ID, cptpy.RCID, cptpy.DateTimePayment, cptpy.RemainAccruedInterest, cptpy.TotalRemain
					FROM	ecpTransPayment AS cptpy INNER JOIN
							(SELECT		MAX(cptpy.ID) AS ID, cptpy.RCID
							 FROM		ecpTransRequireContract AS cptrc INNER JOIN
										ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
										ecpTransPayment AS cptpy ON cptrc.ID = cptpy.RCID INNER JOIN
										ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID
							 GROUP BY	cptpy.RCID' + @where + ') AS cptpy1 ON cptpy.ID = cptpy1.ID'
		EXEC (@sql)
	END		

	/*SELECT ecpTabProgram*/
	IF (@ordertable = 23)
	BEGIN
		SET @where = ''	
			
		IF (@cp1id <> NULL) SET @where = ' WHERE (cptpg.ID = ' + @cp1id + ')'

		SET @sql = 'SELECT	cptpg.ID, cptpg.FacultyCode, bf.nameTh AS FactTName, cptpg.ProgramCode,
							cp.nameTh AS ProgTName, cptpg.MajorCode, cptpg.GroupNum,
							cptpg.Dlevel, 
							(
								CASE cptpg.Dlevel
									WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
									WHEN "B" THEN "ปริญญาตรี"
									ELSE NULL
								END					
							) AS DlevelName																			
				    FROM	ecpTabProgram AS cptpg INNER JOIN
							acaFaculty AS bf ON cptpg.FacultyCode = bf.facultyCode INNER JOIN
							acaProgram AS cp ON bf.id = cp.facultyId AND cptpg.ProgramCode = cp.programCode AND cptpg.MajorCode = cp.majorCode AND cptpg.GroupNum = cp.groupNum AND cptpg.Dlevel = cp.dLevel'
		SET @sql = @sql + @where					   
		SET @sql = @sql + ' ORDER BY DlevelName, cptpg.FacultyCode, cptpg.ProgramCode'
		EXEC (@sql)
	END		

	/*SELECT ecpTabProgram ON REPEAT*/
	IF (@ordertable = 24)
	BEGIN
		SET @where = ''	
			
		IF ((@dlevel <> NULL) AND
			(@faculty <> NULL) AND
			(@program <> NULL) AND
			(@major <> NULL) AND
			(@groupnum <> NULL))
		BEGIN			
			SET @where = ' WHERE ((cptpg.Dlevel = "' + @dlevel + '") AND
								  (cptpg.FacultyCode = "' + @faculty + '") AND
								  (cptpg.ProgramCode = "' + @program + '") AND
								  (cptpg.MajorCode = "' + @major + '") AND
								  (cptpg.GroupNum = "' + @groupnum + '"))'							  
			IF (@cp1id <> NULL) SET @where = @where + ' AND (cptpg.ID <> ' + @cp1id + ')'
		END
		
		SET @sql = 'SELECT	cptpg.ID
				    FROM	ecpTabProgram AS cptpg INNER JOIN
							acaFaculty AS bf ON cptpg.FacultyCode = bf.facultyCode INNER JOIN
							acaProgram AS cp ON bf.id = cp.facultyId AND cptpg.ProgramCode = cp.programCode AND cptpg.MajorCode = cp.majorCode AND cptpg.GroupNum = cp.groupNum AND cptpg.Dlevel = cp.dLevel '

		SET @sql = @sql + @where					   
		SET @sql = @sql + ' ORDER BY cptpg.ID'
		EXEC (@sql)
	END		

	/*SELECT FACULTY FROM ecpTabProgram*/
	IF (@ordertable = 25)
	BEGIN
		SET @sql = 'SELECT		bf.id,cptpg.FacultyCode, bf.nameTh AS FactTName
				    FROM		ecpTabProgram AS cptpg INNER JOIN
								acaFaculty AS bf ON cptpg.FacultyCode = bf.facultyCode
					GROUP BY	bf.id,cptpg.FacultyCode, bf.nameTh'
		SET @sql = @sql + ' ORDER BY cptpg.FacultyCode'					   

		EXEC (@sql)
	END		

	/*SELECT PROGRAM ON FACULTY FROM ecpTabProgram*/
	IF (@ordertable = 26)
	BEGIN
		SET @where = ''		
		
		IF ((@dlevel = NULL) AND (@faculty <> NULL))
			SET @where = ' WHERE (cptpg.FacultyCode = "' + @faculty + '")'
			
		IF ((@dlevel <> NULL) AND (@faculty <> NULL))
			SET @where = ' WHERE (cptpg.FacultyCode = "' + @faculty + '") AND (cptpg.DLevel = "' + @dlevel + '")'

		SET @sql = 'SELECT	cptpg.ProgramCode, cptpg.MajorCode, cptpg.GroupNum, cp.nameTh As ProgTName, cptpg.DLevel,
							(
								CASE cptpg.DLevel
									WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
									WHEN "B" THEN "ปริญญาตรี"
									ELSE NULL
								END					
							) AS DLevelName	
				    FROM	ecpTabProgram AS cptpg INNER JOIN				    
							acaFaculty AS bf ON cptpg.FacultyCode = bf.facultyCode INNER JOIN
							acaProgram AS cp ON bf.id = cp.facultyId AND cptpg.ProgramCode = cp.programCode AND cptpg.MajorCode = cp.majorCode AND cptpg.GroupNum = cp.groupNum AND cptpg.Dlevel = cp.dLevel '
		SET @sql = @sql + @where				    
		SET @sql = @sql + ' ORDER BY cptpg.ProgramCode'
		EXEC (@sql)
	END		

	/*SELECT TITLE NAME*/
	IF (@ordertable = 27)
	BEGIN
		SET @sql = 'SELECT	 bt.id AS TitleCode, bt.enTitleInitials AS TitleEName, bt.thTitleFullName AS TitleTName, ge.enGenderInitials AS Sex
				    FROM	 perTitlePrefix AS bt LEFT JOIN
							 perGender AS ge ON bt.perGenderId = ge.id 
					ORDER BY bt.id'
		EXEC (@sql)
	END			

	/*SELECT ReportTableCalCapitalAndInterest*/
	IF (@ordertable = 28)
	BEGIN
		SET @where = ''
		
		IF (@cp2id <> NULL)
			SET @where = '(cptrc.ID = ' + @cp2id + ')'

		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END
			
		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '
		
		SET @where = @where + '(cptrc.StatusPayment <> 3) AND (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1) AND ' + @repaystatus2
		
		SET @sql = 'SELECT	COUNT(cptrc.ID) AS CountReportTableCalCapitalAndInterest
					FROM	ecpTransRepayContract AS cptrp INNER JOIN
							ecpTransRequireContract AS cptrc ON cptrp.RCID = cptrc.ID AND cptrp.StatusRepay = cptrc.StatusRepay INNER JOIN
							ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID'
		SET @sql = @sql + @where					   										
		EXEC (@sql)
		
		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.StudentID) AS RowNum,
									cptrc.ID, cptrc.BCID, cptrc.TotalPenalty,
									cptrc.StatusRepay, cptrc.StatusPayment, cptrc.FormatPayment, cptrp.StatusReply, cptrp.ReplyResult,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName,																																									
									cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel,
									spl1.FileName, spl1.FolderName
							FROM	ecpTransRepayContract AS cptrp INNER JOIN
									ecpTransRequireContract AS cptrc ON cptrp.RCID = cptrc.ID AND cptrp.StatusRepay = cptrc.StatusRepay INNER JOIN
									ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID LEFT JOIN
									(SELECT DISTINCT spl.studentCode AS StudentID, spl.pictureName AS FileName, "" AS FolderName FROM stdStudent AS spl) AS spl1 ON cptbc.StudentID = spl1.StudentID' + @where + ') AS cptrc1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptrc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
	
	/*SELECT SUM PayCapital, PayInterest, TotalPay On Payment*/
	IF (@ordertable = 29)
	BEGIN	
		SET @where = ''
		
		IF (@cp2id <> NULL)
			SET @where = '(cptpy.RCID = ' + @cp2id + ')'
		
		IF (@where <> '') 
			SET @where = ' HAVING ' + @where
		
		SET @sql = 'SELECT		SUM(cptpy.PayCapital) AS SumPayCapital,
								SUM(cptpy.PayInterest) AS SumPayInterest,
								SUM(cptpy.TotalPay) AS SumTotalPay,
								cptpy.RCID
					FROM		ecpTransRequireContract AS cptrc INNER JOIN
								ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
								ecpTransPayment AS cptpy ON cptrc.ID = cptpy.RCID INNER JOIN
								ecpTransBreakContract AS cptbc ON cptrc.BCID = cptbc.ID
					GROUP BY	cptpy.RCID'
		SET @sql = @sql + @where
		EXEC (@sql)
	END		
	
	/*SELECT ListCalCPReportTableCalCapitalAndInterest*/
	IF (@ordertable = 30)
	BEGIN	
		IF (@paiddate <> NULL)
			SET @paiddate = CONVERT(VARCHAR, CONVERT(INT, SUBSTRING(@paiddate, 7, 4)) - 543) + SUBSTRING(@paiddate, 4, 2) + SUBSTRING(@paiddate, 1, 2)
		
		SET @sql = 'SELECT	PaidPeriod, Capital, Paid, Interest, PayTotal, (SUBSTRING(CONVERT(VARCHAR(10), PaidDate, 103), 1, 6) + CONVERT(VARCHAR, CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(10), PaidDate, 103), 7, 4)) + 543)) AS PaidDate
					FROM	fnc_ecpGetInterest("' + @capital + '", "' + @pay + '", "' + @paiddate + '", "' + @interest + '")'
		EXEC (@sql)
		
		SET @sql = 'SELECT	SUM(Paid) AS SumPaid, SUM(Interest) AS SumINterest, SUM(PayTotal) AS SumPayTotal
					FROM	fnc_ecpGetInterest("' + @capital + '", "' + @pay + '", "' + @paiddate + '", "' + @interest + '")'					
		EXEC (@sql)
	END		

	/*SELECT ReportStepOfWork*/
	IF (@ordertable = 31)
	BEGIN
		SET @where = ''
		
		IF (@acadamicyear <> NULL)
		BEGIN
			SET @where = '(LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '")'
		END			
			
		IF (@statusstepofwork <> NULL)
		BEGIN		
			SET @where = (CASE @statusstepofwork
							WHEN '1'  THEN '((cptbc.StatusSend = 1) AND (cptbc.StatusReceiver = 1) AND (cptbc.StatusEdit = 1) AND (cptbc.StatusCancel = 1))'
							WHEN '2'  THEN '((cptbc.StatusSend = 2) AND (cptbc.StatusReceiver = 1) AND (cptbc.StatusEdit = 1) AND (cptbc.StatusCancel = 1))'
							WHEN '3'  THEN '((cptbc.StatusSend = 2) AND (cptbc.StatusReceiver = 2) AND (cptbc.StatusEdit = 1) AND (cptbc.StatusCancel = 1))'
							WHEN '4'  THEN '((cptbc.StatusSend = 2) AND (cptbc.StatusReceiver = 1) AND (cptbc.StatusEdit = 2) AND (cptbc.StatusCancel = 1))'
							WHEN '5'  THEN '(cptbc.StatusCancel = 2)'
							WHEN '6'  THEN '(cptrc.StatusRepay = 0)'
							WHEN '7'  THEN '((cptrc.StatusRepay = 1) AND (cptrp.StatusReply = 1))'
							WHEN '8'  THEN '((cptrc.StatusRepay = 1) AND (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1))'
							WHEN '9'  THEN '((cptrc.StatusRepay = 1) AND (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 2))'
							WHEN '10' THEN '((cptrc.StatusRepay = 2) AND (cptrp.StatusReply = 1))'
							WHEN '11' THEN '((cptrc.StatusRepay = 2) AND (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1))'
							WHEN '12' THEN '((cptrc.StatusRepay = 2) AND (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 2))'
							WHEN '13' THEN '((cptrc.StatusPayment = 1) OR (cptrc.StatusPayment IS NULL))'
							WHEN '14' THEN '(cptrc.StatusPayment = 2)'
							WHEN '15' THEN '(cptrc.StatusPayment = 3)'
						  END)							
		END

		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END
			
		IF (@where <> '') 
			SET @where = ' WHERE (' + @where + ') AND '
		ELSE
			SET @where = ' WHERE '		

		IF (@section = '1')	SET @where = @where + @trackingstatusorla
		IF (@section = '2') SET @where = @where + @trackingstatusoraa
		IF (@section = NULL) SET @where = @where + '(cptbc.StatusCancel = 1)'
				
		SET @sql = 'SELECT	COUNT(cptbc.ID) AS CountReportStepOfWork
					FROM	ecpTransBreakContract AS cptbc LEFT JOIN 
							ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID LEFT JOIN
							ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay'
		SET @sql = @sql + @where					   										
		EXEC (@sql)
		
		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.StudentID) AS RowNum,
									cptbc.ID AS BCID, cptrc.ID AS RCID,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName,																																									
									cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel,
									cptrc.StatusRepay, cptrp.StatusReply, cptrp.ReplyResult, cptrc.StatusPayment,
									spl1.FileName, spl1.FolderName
							FROM	ecpTransBreakContract AS cptbc LEFT JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID LEFT JOIN
									ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
									(SELECT DISTINCT spl.studentCode AS StudentID, spl.pictureName AS FileName, "" AS FolderName FROM stdStudent AS spl) AS spl1 ON cptbc.StudentID = spl1.StudentID' + @where + ' ) AS cptbc1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptbc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
	
	/*SELECT ReportStatisticRepay*/
	IF (@ordertable = 32)
	BEGIN	
		SET @sql = 'SELECT	ROW_NUMBER() OVER(ORDER BY t1.AcadamicYear) AS RowNum,
							t1.AcadamicYear,
							t2.CountProgram,
							t3.CountStudent,
							t4.CountStudentNoPayment,
							t5.CountStudentPaymentComplete,
							t6.CountStudentPaymentIncomplete,
							t7.SumTotalPenalty,
							t8.SumTotalPay
					FROM	(SELECT	DISTINCT LEFT(cptbc.StudentID, 2) AS AcadamicYear
							 FROM	ecpTransBreakContract AS cptbc
							 WHERE	cptbc.StatusCancel = 1) AS t1 LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, COUNT(tt1.ProgramCode) AS CountProgram
							 FROM		(SELECT	DISTINCT LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
										 FROM	ecpTransBreakContract AS cptbc
										 WHERE	cptbc.StatusCancel = 1) AS tt1
							 GROUP BY	tt1.AcadamicYear) AS t2 ON t1.AcadamicYear = t2.AcadamicYear LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, COUNT(tt1.StudentID) AS CountStudent
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID
										 FROM	ecpTransBreakContract AS cptbc
										 WHERE	cptbc.StatusCancel = 1) AS tt1
							 GROUP BY	tt1.AcadamicYear) AS t3 ON t1.AcadamicYear = t3.AcadamicYear LEFT JOIN

							(SELECT		tt1.AcadamicYear, COUNT(tt1.StudentID) AS CountStudentNoPayment
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID
										 FROM	ecpTransBreakContract AS cptbc LEFT JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID LEFT JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
										 WHERE	(cptbc.StatusCancel = 1) AND ((cptrc.StatusPayment = 1) OR (cptrc.StatusPayment IS NULL))) AS tt1
							 GROUP BY	tt1.AcadamicYear) AS t4 ON t1.AcadamicYear = t4.AcadamicYear LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, COUNT(tt1.StudentID) AS CountStudentPaymentComplete
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
										 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment = 3)) AS tt1
							 GROUP BY	tt1.AcadamicYear) AS t5 ON t1.AcadamicYear = t5.AcadamicYear LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, COUNT(tt1.StudentID) AS CountStudentPaymentIncomplete
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay							
										 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment = 2)) AS tt1
							 GROUP BY	tt1.AcadamicYear) AS t6 ON t1.AcadamicYear = t6.AcadamicYear LEFT JOIN
		  
		  					(SELECT		tt1.AcadamicYear, SUM(tt1.TotalPenalty) AS SumTotalPenalty
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptrc.TotalPenalty
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID
										 WHERE	cptbc.StatusCancel = 1) AS tt1
							 GROUP BY	tt1.AcadamicYear) AS t7 ON t1.AcadamicYear = t7.AcadamicYear LEFT JOIN
							 
							(SELECT		tt1.AcadamicYear, SUM(tt1.PayCapital) AS SumTotalPay
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptpy.PayCapital
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
												ecpTransPayment AS cptpy ON cptrc.ID = cptpy.RCID
										 WHERE	cptbc.StatusCancel = 1) AS tt1
							 GROUP BY	tt1.AcadamicYear) AS t8 ON t1.AcadamicYear = t8.AcadamicYear'
		EXEC (@sql)
	END
	
	/*SELECT ReportStatisticRepayByProgram*/
	IF (@ordertable = 33)
	BEGIN
		SET @sql = 'SELECT	ROW_NUMBER() OVER(ORDER BY t1.ProgramCode) AS RowNum,
							t1.AcadamicYear,
							t1.FacultyCode,
							t1.FacultyName,
							t1.ProgramCode,
							t1.ProgramName,
							t1.MajorCode,
							t1.GroupNum,
							t2.CountStudent,
							t3.CountStudentNoPayment,
							t4.CountStudentPaymentComplete,
							t5.CountStudentPaymentIncomplete,
							t6.SumTotalPenalty,
							t7.SumTotalPay
					FROM	(SELECT	DISTINCT LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
							 FROM	ecpTransBreakContract AS cptbc
							 WHERE	(cptbc.StatusCancel = 1) AND (LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '")) AS t1 LEFT JOIN

							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudent
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
										 FROM	ecpTransBreakContract AS cptbc
										 WHERE	(cptbc.StatusCancel = 1) AND (LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '")) AS tt1
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t2 ON t1.AcadamicYear = t2.AcadamicYear AND t1.FacultyCode = t2.FacultyCode AND t1.ProgramCode = t2.ProgramCode AND t1.MajorCode = t2.MajorCode AND t1.GroupNum = t2.GroupNum LEFT JOIN

							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudentNoPayment
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
										 FROM	ecpTransBreakContract AS cptbc LEFT JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID LEFT JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
										 WHERE	(cptbc.StatusCancel = 1) AND (LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '") AND ((cptrc.StatusPayment = 1) OR (cptrc.StatusPayment IS NULL))) AS tt1
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t3 ON t1.AcadamicYear = t3.AcadamicYear AND t1.FacultyCode = t3.FacultyCode AND t1.ProgramCode = t3.ProgramCode AND t1.MajorCode = t3.MajorCode AND t1.GroupNum = t3.GroupNum LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudentPaymentComplete
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
										 WHERE	(cptbc.StatusCancel = 1) AND (LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '") AND (cptrc.StatusPayment = 3)) AS tt1
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t4 ON t1.AcadamicYear = t4.AcadamicYear AND t1.FacultyCode = t4.FacultyCode AND t1.ProgramCode = t4.ProgramCode AND t1.MajorCode = t4.MajorCode AND t1.GroupNum = t4.GroupNum LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudentPaymentIncomplete
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay							
										 WHERE	(cptbc.StatusCancel = 1) AND (LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '") AND (cptrc.StatusPayment = 2)) AS tt1
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t5 ON t1.AcadamicYear = t5.AcadamicYear AND t1.FacultyCode = t5.FacultyCode AND t1.ProgramCode = t5.ProgramCode AND t1.MajorCode = t5.MajorCode AND t1.GroupNum = t5.GroupNum LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, SUM(tt1.TotalPenalty) AS SumTotalPenalty
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptrc.TotalPenalty
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID
										 WHERE	(cptbc.StatusCancel = 1) AND (LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '")) AS tt1
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t6 ON t1.AcadamicYear = t6.AcadamicYear AND t1.FacultyCode = t6.FacultyCode AND  t1.ProgramCode = t6.ProgramCode AND t1.MajorCode = t6.MajorCode AND t1.GroupNum = t6.GroupNum LEFT JOIN

							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, SUM(tt1.PayCapital) AS SumTotalPay
							 FROM		(SELECT	LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptpy.PayCapital
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
												ecpTransPayment AS cptpy ON cptrc.ID = cptpy.RCID
										 WHERE	(cptbc.StatusCancel = 1) AND (LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '")) AS tt1
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t7 ON t1.AcadamicYear = t7.AcadamicYear AND t1.FacultyCode = t7.FacultyCode AND t1.ProgramCode = t7.ProgramCode AND t1.MajorCode = t7.MajorCode AND t1.GroupNum = t7.GroupNum'
		EXEC (@sql)
	END

	/*SELECT ReportNoticeRepayComplete*/
	IF (@ordertable = 34)
	BEGIN
		SET @where = ''
		
		IF (@cp1id <> NULL)
			SET @where = '(cptbc.ID = ' + @cp1id + ')'

		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END
			
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'
				
		SET @sql = 'SELECT	COUNT(cptbc.ID) AS CountReportNoticeRepayComplete
					FROM	ecpTransBreakContract AS cptbc INNER JOIN 
							ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
					WHERE	' + @repaystatus2 + ' AND (cptrc.StatusPayment = 3)' + @where
		EXEC (@sql)
		
		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.StudentID) AS RowNum,
									cptbc.ID AS BCID, cptrc.ID AS RCID,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
									cptbc.GraduateDate, cptbc.IndemnitorYear, cptrc.IndemnitorAddress, cptrc.TotalPenalty, cptrc.StatusPayment
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
							 WHERE	' + @repaystatus2 + ' AND (cptrc.StatusPayment = 3)' + @where + ') AS cptbc1'
						
		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptbc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
		
	/*SELECT ReportNoticeClaimDebt*/
	IF (@ordertable = 35)
	BEGIN
		SET @where = ''
		
		IF (@cp1id <> NULL)
			SET @where = '(cptbc.ID = ' + @cp1id + ')'
				
		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END
			
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'
				
		SET @sql = 'SELECT	COUNT(cptbc.ID) AS CountReportNoticeClaimDebt
					FROM	ecpTransBreakContract AS cptbc INNER JOIN 
							ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
					WHERE	' + @repaystatus2 + ' AND (cptrc.StatusRepay <> 0)' + @where
		EXEC (@sql)
		
		SET @sql = 'SELECT	*
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.StudentID) AS RowNum,
									cptbc.ID AS BCID, cptrc.ID AS RCID,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
									cptbc.IndemnitorYear, cptbc.IndemnitorCash, cptbc.ContractDate, cptbc.ContractDateAgreement, cptbc.Guarantor,
									cptrc.ApproveDate, cptrc.TotalPenalty, cptrc.StatusRepay, cptrc.StatusPayment
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
							 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							 ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
							 WHERE	' + @repaystatus2 + ' AND (cptrc.StatusRepay <> 0)' + @where + ') AS cptbc1'
		
		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptbc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
		
	/*SELECT ReportStatisticContract*/
	IF (@ordertable = 38)
	BEGIN	
		SET @sql = 'SELECT	ROW_NUMBER() OVER(ORDER BY t1.AcadamicYear) AS RowNum,
							t1.AcadamicYear,
							t2.CountStudent,
							t3.CountStudentSignContract,
							t4.CountStudentContractPenalty
					FROM	(SELECT	DISTINCT LEFT(std.studentCode, 2) AS AcadamicYear
							 FROM	stdStudent AS std LEFT JOIN
									acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
									acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
									perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
									perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
									ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel
							 WHERE	' + @nostudentid + ' AND (std.studentCode IS NOT NULL)) AS t1 LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, COUNT(tt1.StudentID) AS CountStudent
							 FROM		(SELECT DISTINCT LEFT(std.studentCode, 2) AS AcadamicYear, std.studentCode AS StudentID
										 FROM	stdStudent AS std LEFT JOIN
												acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
												acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
												perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
												perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
												ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel
										 WHERE	' + @nostudentid + ' AND ' + @nostudentstatus + ') AS tt1 
							 GROUP BY	tt1.AcadamicYear) AS t2 ON t1.AcadamicYear = t2.AcadamicYear LEFT JOIN
		 
							(SELECT		tt1.AcadamicYear, COUNT(tt1.StudentID) AS CountStudentSignContract
							 FROM		(SELECT DISTINCT LEFT(std.studentCode, 2) AS AcadamicYear, std.studentCode AS StudentID
										 FROM	stdStudent AS std LEFT JOIN
												acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
												acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
												perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
												perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
												ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel INNER JOIN
												ectDocMgmt AS cd ON std.id = cd.StudentID AND std.programId = cd.programId
										 WHERE	(cd.operationType = "S" OR cd.operationType = "M") AND ' + @nostudentid + ' AND ' + @nostudentstatus + ') AS tt1									 
							 GROUP BY	tt1.AcadamicYear) AS t3 ON t1.AcadamicYear = t3.AcadamicYear LEFT JOIN

							(SELECT		tt1.AcadamicYear, COUNT(tt1.StudentID) AS CountStudentContractPenalty
							 FROM		(SELECT LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID
										 FROM	ecpTransBreakContract AS cptbc
										 WHERE  cptbc.StatusCancel = 1) AS tt1
							 GROUP BY	tt1.AcadamicYear) AS t4 ON t1.AcadamicYear = t4.AcadamicYear'

		EXEC (@sql)
	END							 

	/*SELECT ReportStatisticContractByProgram*/
	IF (@ordertable = 39)
	BEGIN	
		SET @sql = ' SELECT	ROW_NUMBER() OVER(ORDER BY t1.ProgramCode) AS RowNum,
							t1.AcadamicYear,
							t1.FacultyCode,
							t1.FactTName,
							t1.ProgramCode,
							t1.ProgTName,
							t1.MajorCode,
							t1.GroupNum,
							t2.CountStudent,
							t3.CountStudentSignContract,
							t4.CountStudentContractPenalty
					FROM	(SELECT	DISTINCT LEFT(std.studentCode, 2) AS AcadamicYear, cptpg.FacultyCode, bf.nameTh AS FactTName, cptpg.ProgramCode, cp.nameTh AS ProgTName, cptpg.MajorCode, cptpg.GroupNum
							 FROM	stdStudent AS std LEFT JOIN
									acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
									acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
									perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
									perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
									ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel
							 WHERE	' + @nostudentid + ' AND (LEFT(std.studentCode, 2) = "' + @acadamicyear + '")) AS t1 LEFT JOIN

							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudent
							 FROM		(SELECT	LEFT(std.studentCode, 2) AS AcadamicYear, std.studentCode AS StudentID, cptpg.FacultyCode, bf.nameTh AS FactTName, cptpg.ProgramCode, cp.nameTh AS ProgTName, cptpg.MajorCode, cptpg.GroupNum
										 FROM	stdStudent AS std LEFT JOIN
												acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
												acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
												perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
												perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
												ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel
										 WHERE	' + @nostudentid + ' AND ' + @nostudentstatus + ' AND (LEFT(std.studentCode, 2) = "' + @acadamicyear + '")) AS tt1
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t2 ON t1.AcadamicYear = t2.AcadamicYear AND t1.FacultyCode = t2.FacultyCode AND t1.ProgramCode = t2.ProgramCode AND t1.MajorCode = t2.MajorCode AND t1.GroupNum = t2.GroupNum LEFT JOIN

							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudentSignContract
							 FROM		(SELECT LEFT(std.studentCode, 2) AS AcadamicYear, std.studentCode AS StudentID, cptpg.FacultyCode, bf.nameTh AS FactTName, cptpg.ProgramCode, cp.nameTh AS ProgTName, cptpg.MajorCode, cptpg.GroupNum
										 FROM	stdStudent AS std LEFT JOIN
												acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
												acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
												perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
												perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
												ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel INNER JOIN
												ectDocMgmt AS cd ON std.id = cd.StudentID AND std.programId = cd.programId
										 WHERE	(cd.operationType = "S" OR cd.operationType = "M") AND ' + @nostudentid + ' AND ' + @nostudentstatus + ' AND (LEFT(std.studentCode, 2) = "' + @acadamicyear + '")) AS tt1 
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t3 ON t1.AcadamicYear = t2.AcadamicYear AND t1.FacultyCode = t3.FacultyCode AND t1.ProgramCode = t3.ProgramCode AND t1.MajorCode = t3.MajorCode AND t1.GroupNum = t3.GroupNum LEFT JOIN

							(SELECT		tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudentContractPenalty
							 FROM		(SELECT LEFT(cptbc.StudentID, 2) AS AcadamicYear, cptbc.StudentID, cptbc.FacultyCode, cptbc.FacultyName AS FactTName, cptbc.ProgramCode, cptbc.ProgramName AS ProgTName, cptbc.MajorCode, cptbc.GroupNum
										 FROM	ecpTransBreakContract AS cptbc
										 WHERE  (cptbc.StatusCancel = 1) AND (LEFT(cptbc.StudentID, 2) = "' + @acadamicyear + '")) AS tt1
							 GROUP BY	tt1.AcadamicYear, tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t4 ON t1.AcadamicYear = t4.AcadamicYear AND t1.FacultyCode = t4.FacultyCode AND t1.ProgramCode = t4.ProgramCode AND t1.MajorCode = t4.MajorCode AND t1.GroupNum = t4.GroupNum'

		EXEC (@sql)
	END				
			 
	/*SELECT ReportStudentSignContract*/
	IF (@ordertable = 40)
	BEGIN
		SET @where = ''
		
		IF (@acadamicyear <> NULL)
		BEGIN
			SET @where = '(LEFT(std.studentCode, 2) = "' + @acadamicyear + '")'
		END			
			
		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((std.studentCode LIKE "' + @studentid + '%") OR (perpes.firstName LIKE "%' + @studentid + '%") OR (perpes.lastName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptpg.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptpg.ProgramCode = "' + @program + '") AND (cptpg.MajorCode = "' + @major + '") AND (cptpg.GroupNum = "' + @groupnum + '"))'
		END
			
		IF (@where <> '') SET @where = ' AND (' + @where + ')'
			
		SET @sql = 'SELECT	COUNT(std.id) AS CountReportStudentSignContract		
					FROM	stdStudent AS std LEFT JOIN
							acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
							acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
							perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
							perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
							ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel LEFT JOIN
							ectDocMgmt AS cd ON std.id = cd.StudentID AND std.programId = cd.programId LEFT JOIN
							vw_ectGetListParent AS vwp ON cd.StudentID = vwp.id AND cd.parentCode = vwp.Type
					WHERE	(cd.operationType = "S" OR cd.operationType = "M") AND ' + @nostudentid + ' AND ' + @nostudentstatus + @where

		EXEC (@sql)
		
		SET @sql = 'SELECT	*									
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY std.studentCode) AS RowNum,
									std.studentCode AS StudentID, bt.thTitleFullName AS TitleTName, perpes.firstName AS ThaiFName, perpes.lastName AS ThaiLName,
									cptpg.FacultyCode, bf.nameTh AS FactTName, cptpg.ProgramCode, cp.nameTh AS ProgTName, cptpg.MajorCode, cptpg.GroupNum, cptpg.DLevel,
									(
										CASE cptpg.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName,	
									cd.contractDateSignByStudent, vwp.TitleTName AS GuarantorTitleTName, vwp.FirstName AS GuarantorFirstName, vwp.LastName AS GuarantorLastName
							FROM	stdStudent AS std LEFT JOIN
									acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
									acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
									perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
									perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
									ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel LEFT JOIN
									ectDocMgmt AS cd ON std.id = cd.StudentID AND std.programId = cd.programId LEFT JOIN
									vw_ectGetListParent AS vwp ON cd.StudentID = vwp.id AND cd.parentCode = vwp.Type
							WHERE	(cd.operationType = "S" OR cd.operationType = "M") AND ' + @nostudentid + ' AND ' + @nostudentstatus + @where + ') AS std1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (std1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END

	/*SELECT ReportStatisticPaymentByDate*/
	IF (@ordertable = 41)
	BEGIN
		SET @where = ''
		SET @where1 = ''
		
		IF (@cp1id <> NULL)
			SET @where = '(cptbc.ID = ' + @cp1id + ')'
				
		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END

		IF (@formatpayment <> NULL)			
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrc.FormatPayment = ' + @formatpayment + ')'		
		END
		
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'	

		IF ((@datestart <> NULL) AND (@dateend <> NULL))
			SET @where1 = 'WHERE (CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptpy.DateTimePayment, 7, 4)) - 543)) + "-" + SUBSTRING(cptpy.DateTimePayment, 4, 2) + "-" + SUBSTRING(cptpy.DateTimePayment, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'			
			
		SET @sql = 'SELECT	COUNT(cptbc.StudentID) AS CountReportStatisticPaymentByDate		
					FROM	ecpTransBreakContract AS cptbc INNER JOIN 
							ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
							(SELECT DISTINCT spl.studentCode, spl.pictureName AS FileName FROM stdStudent AS spl) AS spl1 ON cptbc.StudentID = spl1.studentCode INNER JOIN
							(SELECT	  cptpy1.RCID
							 FROM	  (SELECT cptpy.RCID, cptpy.PayCapital
									   FROM	  ecpTransPayment AS cptpy ' + @where1 + ') AS cptpy1	 
							 GROUP BY cptpy1.RCID) AS cptpy2 ON cptrc.ID = cptpy2.RCID
					WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where
		EXEC (@sql)
		
		SET @sql = 'SELECT	*									
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.StudentID) AS RowNum,
									cptbc.ID AS BCID, cptrc.ID AS RCID, cptrc.TotalPenalty, cptpy2.TotalPay, cptrc.FormatPayment,
									(
										CASE cptrc.FormatPayment
											WHEN 1 THEN "ชำระแบบเต็มจำนวน"
											WHEN 2 THEN "ชำระแบบผ่อนชำระ"
											ELSE NULL
										END											
									) AS FormatPaymentName,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName,																																									
									cptbc.StatusCancel, cptrc.StatusPayment, spl1.FileName									
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
									(SELECT DISTINCT spl.studentCode, spl.pictureName AS FileName FROM stdStudent AS spl) AS spl1 ON cptbc.StudentID = spl1.studentCode INNER JOIN
									(SELECT	  cptpy1.RCID, SUM(cptpy1.PayCapital) AS TotalPay
									 FROM	  (SELECT cptpy.RCID, cptpy.PayCapital
											   FROM	  ecpTransPayment AS cptpy ' + @where1 + ') AS cptpy1	 
									 GROUP BY cptpy1.RCID) AS cptpy2 ON cptrc.ID = cptpy2.RCID
							 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where + ') AS cptbc1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptbc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END

	
	/*SELECT ReportEContract*/
	IF (@ordertable = 42)
	BEGIN
		SET @where = ''
		
		IF (@acadamicyear <> NULL)
		BEGIN
			SET @where = '(LEFT(std.studentCode, 2) = RIGHT("' + @acadamicyear + '", 2))'
		END			
					  			
		IF (@studentid <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '
			SET @where = @where + '((std.StudentCode LIKE "' + @studentid + '%") OR (perpes.firstName LIKE "%' + @studentid + '%") OR (perpes.lastName LIKE "%' + @studentid + '%"))'
		END
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptpg.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cp.ProgramCode = "' + @program + '") AND (cp.MajorCode = "' + @major + '") AND (cp.GroupNum = "' + @groupnum + '"))'
		END

		IF (@where <> '') 
			SET @where = ' AND ' + @where
					
		SET @sql = 'SELECT	COUNT(std.id) AS CountReportEContract
					FROM	stdStudent AS std LEFT JOIN
							acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
							acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
							perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
							perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
							ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel LEFT JOIN
							ectDocMgmt AS cd ON std.id = cd.StudentID AND std.programId = cd.programId LEFT JOIN
							vw_ectGetListParent AS vwp ON cd.StudentID = vwp.id AND cd.parentCode = vwp.Type
					WHERE	(cd.operationType = "S" OR cd.operationType = "M" OR cd.operationType = "O")' + @where + ' AND ' + @nostudentid + ' AND ' + @nostudentstatus

		EXEC (@sql)
		
		SET @sql = 'SELECT	*									
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY std.studentCode) AS RowNum,
									std.StudentCode AS StudentID, bt.thTitleFullName AS TitleTName, perpes.firstName AS ThaiFName, perpes.lastName AS ThaiLName, 
									cptpg.FacultyCode, bf.nameTh AS FactTName, cp.ProgramCode, cp.nameTh AS ProgTName, 
									cp.MajorCode, cp.GroupNum, cptpg.DLevel,
									(
										CASE cptpg.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName,	
									cd.contractDateSignByStudent, vwp.TitleTName AS GuarantorTitleTName, vwp.FirstName AS GuarantorFirstName, vwp.LastName AS GuarantorLastName,
									cd.QuotaCode, cd.operationType, cd.contractSignByStudent, cd.parentContractSignFlagF1 & cd.parentContractSignFlagF2 AS parentContractSignFlagF, cd.parentContractSignFlagM1 & cd.parentContractSignFlagM2 AS parentContractSignFlagM
							 FROM	stdStudent AS std LEFT JOIN
									acaFaculty AS bf ON std.facultyId = bf.id LEFT JOIN
									acaProgram AS cp ON std.facultyId = cp.facultyId AND std.programId = cp.id INNER JOIN
									perPerson AS perpes ON std.personId = perpes.id LEFT JOIN
									perTitlePrefix AS bt ON perpes.perTitlePrefixId = bt.id INNER JOIN
									ecpTabProgram AS cptpg ON bf.facultyCode = cptpg.FacultyCode AND cp.programCode = cptpg.ProgramCode AND cp.majorCode = cptpg.MajorCode AND cp.groupNum = cptpg.GroupNum AND cp.dLevel = cptpg.Dlevel LEFT JOIN
									ectDocMgmt AS cd ON std.id = cd.StudentID AND std.programId = cd.programId LEFT JOIN
									vw_ectGetListParent AS vwp ON cd.StudentID = vwp.id AND cd.parentCode = vwp.Type
							 WHERE	(cd.operationType = "S" OR cd.operationType = "M" OR cd.operationType = "O")' + @where + ' AND ' + @nostudentid + ' AND ' + @nostudentstatus + ') AS std1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (std1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'
		EXEC (@sql)
	END
	
	/*SELECT ReportDebtorContract*/
	IF (@ordertable = 43)
	BEGIN
		SET @where = ''
		
		IF ((@datestart <> NULL) AND (@dateend <> NULL))
			SET @where = ' AND (CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		
		SET @sql = 'SELECT	ROW_NUMBER() OVER(ORDER BY t1.ProgramCode) AS RowNum,
							t1.FacultyCode,
							t1.FacultyName,
							t1.ProgramCode,
							t1.ProgramName,
							t1.MajorCode,
							t1.GroupNum,
							t1.DLevel,
							t1.DLevelName,
							t2.CountStudentDebtor,
							t3.SumTotalPenalty,
							t4.SumTotalPayCapital,
							t4.SumTotalPayInterest
					FROM	(SELECT	DISTINCT cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
									cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
									 FROM	ecpTransRepayContract AS cptrp
									 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
							 WHERE	(cptbc.StatusCancel = 1)' + @where + ') AS t1 LEFT JOIN

							(SELECT		tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudentDebtor
							 FROM		(SELECT	cptbc.StudentID, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
												 FROM	ecpTransRepayContract AS cptrp
												 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
										 WHERE	(cptbc.StatusCancel = 1)' + @where + ') AS tt1
							 GROUP BY	tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t2 ON t1.FacultyCode = t2.FacultyCode AND t1.ProgramCode = t2.ProgramCode AND t1.MajorCode = t2.MajorCode AND t1.GroupNum = t2.GroupNum LEFT JOIN
		 	 
							(SELECT		tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, SUM(tt1.TotalPenalty) AS SumTotalPenalty
							 FROM		(SELECT	cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptrc.TotalPenalty
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
												 FROM	ecpTransRepayContract AS cptrp
												 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
										 WHERE	(cptbc.StatusCancel = 1)' + @where + ') AS tt1
							 GROUP BY	tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t3 ON t1.FacultyCode = t3.FacultyCode AND t1.ProgramCode = t3.ProgramCode AND t1.MajorCode = t3.MajorCode AND t1.GroupNum = t3.GroupNum LEFT JOIN
							 
	 						(SELECT		tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, SUM(tt1.PayCapital) AS SumTotalPayCapital, SUM(tt1.PayInterest) AS SumTotalPayInterest
							 FROM		(SELECT	cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
												 FROM	ecpTransRepayContract AS cptrp
												 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
												ecpTransPayment AS cptpy ON cptrc.ID = cptpy.RCID
										 WHERE	(cptbc.StatusCancel = 1)' + @where + ') AS tt1
							 GROUP BY	tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t4 ON t1.FacultyCode = t4.FacultyCode AND t1.ProgramCode = t4.ProgramCode AND t1.MajorCode = t4.MajorCode AND t1.GroupNum = t4.GroupNum'
		EXEC (@sql)							 
	END

	/*SELECT ReportDebtorContractByProgram*/
	IF (@ordertable = 44)
	BEGIN
		SET @where = ''
				
		IF (@studentid <> NULL)
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END

		IF (@formatpayment <> NULL)			
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrc.FormatPayment = ' + @formatpayment + ')'		
		END

		IF ((@datestart <> NULL) AND (@dateend <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '(CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		END
					
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'	
			
		SET @sql = 'SELECT	COUNT(cptbc.StudentID) AS CountReportDebtorContractByProgram		
					FROM	ecpTransBreakContract AS cptbc INNER JOIN 
							ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
							 FROM	ecpTransRepayContract AS cptrp
							 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
							(SELECT		cptpy.RCID
							 FROM		ecpTransPayment AS cptpy
							 GROUP BY	cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
					WHERE	(cptbc.StatusCancel = 1)' + @where
		EXEC (@sql)
		
		SET @sql = 'SELECT	*									
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.ProgramCode, cptbc.StudentID) AS RowNum,
									cptbc.ID AS BCID, cptrc.ID AS RCID, cptrc.TotalPenalty, cptpy.PayCapital, cptpy.PayInterest, cptrp.ReplyDate, cptrc.FormatPayment,
									(
										CASE cptrc.FormatPayment
											WHEN 1 THEN "ชำระแบบเต็มจำนวน"
											WHEN 2 THEN "ชำระแบบผ่อนชำระ"
											ELSE NULL
										END											
									) AS FormatPaymentName,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
									cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
									 FROM	ecpTransRepayContract AS cptrp
									 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
									(SELECT		cptpy.RCID, SUM(cptpy.PayCapital) AS PayCapital, SUM(cptpy.PayInterest) AS PayInterest, SUM(cptpy.TotalPay) AS TotalPay
									 FROM		ecpTransPayment AS cptpy
									 GROUP BY	cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
							 WHERE	(cptbc.StatusCancel = 1)' + @where + ') AS cptbc1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptbc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
	
	/*SELECT ReportDebtorContractPaid*/
	IF (@ordertable = 45)
	BEGIN
		SET @where = ''

		IF ((@datestart <> NULL) AND (@dateend <> NULL))
			SET @where = ' AND (CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'			

		SET @sql = 'SELECT	ROW_NUMBER() OVER(ORDER BY t1.ProgramCode) AS RowNum,
							t1.FacultyCode,
							t1.FacultyName,
							t1.ProgramCode,
							t1.ProgramName,
							t1.MajorCode,
							t1.GroupNum,
							t1.DLevel,
							t1.DLevelName,
							t2.CountStudentDebtor,
							t3.SumTotalPenalty,
							t4.SumTotalPayCapital,
							t4.SumTotalPayInterest							
					FROM	(SELECT	DISTINCT cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
									cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
									(SELECT	  cptpy.RCID
									 FROM	  ecpTransPayment AS cptpy
									 GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
							 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where + ') AS t1 LEFT JOIN

							(SELECT		tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudentDebtor
							 FROM		(SELECT	cptbc.StudentID, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
												(SELECT	  cptpy.RCID
												 FROM	  ecpTransPayment AS cptpy
												 GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID							 							 												
										 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where + ') AS tt1
							 GROUP BY	tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t2 ON t1.FacultyCode = t2.FacultyCode AND t1.ProgramCode = t2.ProgramCode AND t1.MajorCode = t2.MajorCode AND t1.GroupNum = t2.GroupNum LEFT JOIN
		 	 
							(SELECT		tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, SUM(tt1.TotalPenalty) AS SumTotalPenalty
							 FROM		(SELECT	cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptrc.TotalPenalty
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
												(SELECT	  cptpy.RCID
												 FROM	  ecpTransPayment AS cptpy
												 GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID							 							 												
										 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where + ') AS tt1
							 GROUP BY	tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t3 ON t1.FacultyCode = t3.FacultyCode AND t1.ProgramCode = t3.ProgramCode AND t1.MajorCode = t3.MajorCode AND t1.GroupNum = t3.GroupNum LEFT JOIN
							 
	 						(SELECT		tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, SUM(tt1.PayCapital) AS SumTotalPayCapital, SUM(tt1.PayInterest) AS SumTotalPayInterest
							 FROM		(SELECT	cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay
										 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
												ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
												ecpTransRepayContract AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
												(SELECT	  cptpy.RCID, SUM(cptpy.PayCapital) AS PayCapital, SUM(cptpy.PayInterest) AS PayInterest, SUM(cptpy.TotalPay) AS TotalPay
												 FROM	  ecpTransPayment AS cptpy
												 GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID							 							 												
										 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where + ') AS tt1
							 GROUP BY	tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t4 ON t1.FacultyCode = t4.FacultyCode AND t1.ProgramCode = t4.ProgramCode AND t1.MajorCode = t4.MajorCode AND t1.GroupNum = t4.GroupNum'
		EXEC (@sql)							 
	END
	
	/*SELECT ReportDebtorContractPaidByProgram*/
	IF (@ordertable = 46)
	BEGIN
		SET @where = ''
				
		IF (@studentid <> NULL)
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END
		
		IF (@formatpayment <> NULL)			
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrc.FormatPayment = ' + @formatpayment + ')'		
		END
		
		IF ((@datestart <> NULL) AND (@dateend <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '(CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		END
			
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'	
						
		SET @sql = 'SELECT	COUNT(cptbc.StudentID) AS CountReportDebtorContractByProgram		
					FROM	ecpTransBreakContract AS cptbc INNER JOIN 
							ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
							 FROM	ecpTransRepayContract AS cptrp
							 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
							(SELECT	  cptpy.RCID
							 FROM	  ecpTransPayment AS cptpy
							 GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
					WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where
		EXEC (@sql)
		
		SET @sql = 'SELECT	*									
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.ProgramCode, cptbc.StudentID) AS RowNum,
									cptbc.ID AS BCID, cptrc.ID AS RCID, cptrc.TotalPenalty, cptpy.PayCapital, cptpy.PayInterest, cptrp.ReplyDate, cptrc.FormatPayment,
									(
										CASE cptrc.FormatPayment
											WHEN 1 THEN "ชำระแบบเต็มจำนวน"
											WHEN 2 THEN "ชำระแบบผ่อนชำระ"
											ELSE NULL
										END											
									) AS FormatPaymentName,									
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
									cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
									 FROM	ecpTransRepayContract AS cptrp
									 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
									(SELECT	  cptpy.RCID, SUM(cptpy.PayCapital) AS PayCapital, SUM(cptpy.PayInterest) AS PayInterest, SUM(cptpy.TotalPay) AS TotalPay
									 FROM	  ecpTransPayment AS cptpy
									 GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
							 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where + ') AS cptbc1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptbc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END	
	
	/*SELECT ReportDebtorContractRemain*/
	IF (@ordertable = 47)
	BEGIN
		SET @where = ''
		
		IF ((@datestart <> NULL) AND (@dateend <> NULL))
			SET @where = ' AND (CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		
		SET @sql = 'SELECT	ROW_NUMBER() OVER(ORDER BY t1.ProgramCode) AS RowNum,
							t1.FacultyCode,
							t1.FacultyName,
							t1.ProgramCode,
							t1.ProgramName,
							t1.MajorCode,
							t1.GroupNum,
							t1.DLevel,
							t1.DLevelName,
							t2.CountStudentDebtor,
							ISNULL(t3.SumTotalPenalty, 0) AS SumTotalPenalty,
							ISNULL(t4.SumTotalPayCapital, 0) AS SumTotalPayCapital,
							ISNULL(t4.SumTotalPayInterest, 0) AS SumTotalPayInterest
					FROM	(SELECT	DISTINCT cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
									cptbc.DLevel,
									(
										CASE cptbc.DLevel
											WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
											WHEN "B" THEN "ปริญญาตรี"
											ELSE NULL
										END	
									) AS DLevelName
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
									 FROM	ecpTransRepayContract AS cptrp
									 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
									(SELECT	  cptpy.RCID
									 FROM	  ecpTransPayment AS cptpy
									 GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
							 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 3)' + @where + ') AS t1 LEFT JOIN

							(SELECT	 tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, COUNT(tt1.StudentID) AS CountStudentDebtor
							 FROM	 (SELECT cptbc.StudentID, cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum
									  FROM	 ecpTransBreakContract AS cptbc INNER JOIN 
											 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
											 (SELECT cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
											  FROM	 ecpTransRepayContract AS cptrp
											  WHERE	 (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
											 (SELECT   cptpy.RCID
											  FROM	   ecpTransPayment AS cptpy
											  GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
									  WHERE	 (cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 3)' + @where + ') AS tt1
							 GROUP BY tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t2 ON t1.FacultyCode = t2.FacultyCode AND t1.ProgramCode = t2.ProgramCode AND t1.MajorCode = t2.MajorCode AND t1.GroupNum = t2.GroupNum LEFT JOIN
		 	 
							(SELECT	 tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, SUM(tt1.TotalPenalty) AS SumTotalPenalty
							 FROM	 (SELECT cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptrc.TotalPenalty
									  FROM	 ecpTransBreakContract AS cptbc INNER JOIN
											 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
											 (SELECT cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
											  FROM	 ecpTransRepayContract AS cptrp
											  WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
											 (SELECT   cptpy.RCID
											  FROM	   ecpTransPayment AS cptpy
											  GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
									  WHERE	 (cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 3)' + @where + ') AS tt1
							 GROUP BY tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t3 ON t1.FacultyCode = t3.FacultyCode AND t1.ProgramCode = t3.ProgramCode AND t1.MajorCode = t3.MajorCode AND t1.GroupNum = t3.GroupNum LEFT JOIN
							 
	 						(SELECT  tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum, SUM(tt1.PayCapital) AS SumTotalPayCapital, SUM(tt1.PayInterest) AS SumTotalPayInterest
							 FROM	 (SELECT cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum, cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay
									  FROM	 ecpTransBreakContract AS cptbc INNER JOIN
											 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
											 (SELECT cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
											  FROM	 ecpTransRepayContract AS cptrp
											  WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
											 ecpTransPayment AS cptpy ON cptrc.ID = cptpy.RCID
									  WHERE	 (cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 3)' + @where + ') AS tt1
							 GROUP BY	tt1.FacultyCode, tt1.ProgramCode, tt1.MajorCode, tt1.GroupNum) AS t4 ON t1.FacultyCode = t4.FacultyCode AND t1.ProgramCode = t4.ProgramCode AND t1.MajorCode = t4.MajorCode AND t1.GroupNum = t4.GroupNum'
		EXEC (@sql)							 
	END

	/*SELECT ReportDebtorContractReaminByProgram*/
	IF (@ordertable = 48)
	BEGIN
		SET @where = ''
				
		IF (@studentid <> NULL)
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END

		IF (@formatpayment <> NULL)			
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrc.FormatPayment = ' + @formatpayment + ')'		
		END

		IF ((@datestart <> NULL) AND (@dateend <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '(CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		END
					
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'	
			
		SET @sql = 'SELECT	COUNT(cptbc.StudentID) AS CountReportDebtorContractByProgram		
					FROM	ecpTransBreakContract AS cptbc INNER JOIN 
							ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
							 FROM	ecpTransRepayContract AS cptrp
							 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
							(SELECT		cptpy.RCID
							 FROM		ecpTransPayment AS cptpy
							 GROUP BY	cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
					WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 3)' + @where
		EXEC (@sql)
		
		SET @sql = 'SELECT	*									
					FROM	(SELECT	ROW_NUMBER() OVER(ORDER BY cptbc.ProgramCode, cptbc.StudentID) AS RowNum,
									cptbc.ID AS BCID, cptrc.ID AS RCID, cptrc.TotalPenalty, cptpy.PayCapital, cptpy.PayInterest, cptrp.ReplyDate, cptrc.FormatPayment,
									(
										CASE cptrc.FormatPayment
											WHEN 1 THEN "ชำระแบบเต็มจำนวน"
											WHEN 2 THEN "ชำระแบบผ่อนชำระ"
											ELSE NULL
										END											
									) AS FormatPaymentName,
									cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
									cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
									cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
									 FROM	ecpTransRepayContract AS cptrp
									 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
									(SELECT		cptpy.RCID, SUM(cptpy.PayCapital) AS PayCapital, SUM(cptpy.PayInterest) AS PayInterest, SUM(cptpy.TotalPay) AS TotalPay
									 FROM		ecpTransPayment AS cptpy
									 GROUP BY	cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
							 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 3)' + @where + ') AS cptbc1'

		IF ((@startrow <> NULL) AND (@endrow <> NULL))
			SET @sql = @sql + ' WHERE (cptbc1.RowNum BETWEEN ' + CONVERT(VARCHAR, @startrow) + ' AND ' + CONVERT(VARCHAR, @endrow) + ')'			
		EXEC (@sql)
	END
		
	/*SELECT ExportDebtorContract*/
	IF (@ordertable = 49)
	BEGIN											
		SET @where = ''
				
		IF (@studentid <> NULL)
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END

		IF (@formatpayment <> NULL)			
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrc.FormatPayment = ' + @formatpayment + ')'		
		END

		IF ((@datestart <> NULL) AND (@dateend <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '(CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		END
			
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'	
			
		SET @sql = 'SELECT	 cptbc.ID AS BCID, cptrc.ID AS RCID, cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
							 cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
							 cptbc.DLevel,
							 (
								CASE cptbc.DLevel
									WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
									WHEN "B" THEN "ปริญญาตรี"
									ELSE NULL
								END	
							 ) AS DLevelName,							 
							 cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel, cptbc.CivilFlag,
							 cptbc.IndemnitorYear, cptrc.AllActualDate, cptbc.IndemnitorCash,
							 cptrc.RequireDate, cptrc.ApproveDate, cptrc.ActualDate, cptrc.RemainDate,
							 cptrc.TotalPenalty, cptrp.ReplyDate, cptrc.FormatPayment,
							 (
								CASE cptrc.FormatPayment
									WHEN 1 THEN "ชำระแบบเต็มจำนวน"
									WHEN 2 THEN "ชำระแบบผ่อนชำระ"
									ELSE NULL
								END											
							 ) AS FormatPaymentName
					FROM	 ecpTransBreakContract AS cptbc INNER JOIN 
	 						 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							 (SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
							  FROM		ecpTransRepayContract AS cptrp
							  WHERE		(cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
					WHERE	 (cptbc.StatusCancel = 1)' + @where + ' 
					ORDER BY cptbc.ProgramCode, cptbc.StudentID'
		EXEC (@sql)
		
		SET @sql = 'SELECT	 SUM(tt1.TotalPenalty) AS TotalPenalty
					FROM	 (SELECT cptrc.TotalPenalty
							  FROM	 ecpTransBreakContract AS cptbc INNER JOIN 
	 								 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									 (SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
									  FROM		ecpTransRepayContract AS cptrp
									  WHERE		(cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay
							  WHERE	 (cptbc.StatusCancel = 1)' + @where + ') AS tt1'							  
		EXEC (@sql)		
	END
	
	/*SELECT ExportDebtorContractPaid*/
	IF (@ordertable = 50)
	BEGIN								
		SET @where = ''
		SET @where1 = ''
				
		IF (@studentid <> NULL)
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END

		IF (@formatpayment <> NULL)			
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrc.FormatPayment = ' + @formatpayment + ')'		
		END
										
		IF ((@datestart <> NULL) AND (@dateend <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '	
			SET @where = @where + '(CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'	
		END
		
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'	
			
		SET @sql = 'SELECT	 cptbc.ID AS BCID, cptrc.ID AS RCID, cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
							 cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
							 cptbc.DLevel,
							 (
								CASE cptbc.DLevel
									WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
									WHEN "B" THEN "ปริญญาตรี"
									ELSE NULL
								END	
							 ) AS DLevelName,
							 cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel,
							 cptrp.ReplyDate, cptpy.DateTimePayment, cptpy.Capital, cptpy.Interest, cptpy.TotalAccruedInterest, cptpy.TotalInterest, cptpy.TotalPayment,
							 cptpy.ReceiptDate, cptpy.ReceiptBookNo, cptpy.ReceiptNo, cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay,
							 cptpy.ReceiptSendNo, cptpy.ReceiptFund, cptpy.RemainCapital, cptpy.AccruedInterest, cptpy.RemainAccruedInterest, cptpy.TotalRemain, cptrc.FormatPayment,
							 (
								CASE cptrc.FormatPayment
									WHEN 1 THEN "ชำระแบบเต็มจำนวน"
									WHEN 2 THEN "ชำระแบบผ่อนชำระ"
									ELSE NULL
								END											
							 ) AS FormatPaymentName
					FROM	 ecpTransBreakContract AS cptbc INNER JOIN 
							 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
							 (SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
							  FROM		ecpTransRepayContract AS cptrp
							  WHERE		(cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
							 (SELECT	 cptpy.RCID, cptpy.ID, cptpy.Capital, cptpy.Interest, cptpy.TotalAccruedInterest, (cptpy.Interest + cptpy.TotalAccruedInterest) AS TotalInterest, cptpy.TotalPayment,
										 cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay,
										 cptpy.RemainCapital, cptpy.AccruedInterest, cptpy.RemainAccruedInterest, cptpy.TotalRemain,
										 cptpy.DateTimePayment, cptpy.ReceiptDate, cptpy.ReceiptBookNo, cptpy.ReceiptNo, cptpy.ReceiptSendNo, cptpy.ReceiptFund			 
							  FROM		 ecpTransPayment AS cptpy INNER JOIN
										(SELECT   cptpy.RCID, MAX(cptpy.ID) AS MaxPeriod
										 FROM	  ecpTransPayment AS cptpy
										 GROUP BY cptpy.RCID) AS cptpy1 ON cptpy.ID = cptpy1.MaxPeriod) AS cptpy ON cptrc.ID = cptpy.RCID
					WHERE	 (cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where + ' 
					ORDER BY cptbc.ProgramCode, cptbc.StudentID, cptpy.ID'
		EXEC (@sql)
				
		SET @sql = 'SELECT	SUM(t1.Capital) AS TotalCapital, SUM(t1.TotalInterest) AS TotalInterest, SUM(t1.TotalPayment) AS TotalPayment,
							SUM(t1.PayCapital) AS PayCapital, SUM(t1.PayInterest) AS PayInterest, SUM(t1.TotalPay) AS TotalPay,
							SUM(t1.RemainCapital) AS RemainCapital, SUM(t1.RemainInterest) AS RemainInterest, SUM(t1.TotalRemain) AS TotalRemain
					FROM	(SELECT	cptpy.RCID, cptpy.ID, cptpy.Capital, cptpy.Interest, cptpy.TotalInterest, cptpy.TotalPayment,
									cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay,
									cptpy.RemainCapital, cptpy.RemainAccruedInterest AS RemainInterest, cptpy.TotalRemain
							 FROM	ecpTransBreakContract AS cptbc INNER JOIN 
									ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									(SELECT	cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
									 FROM	ecpTransRepayContract AS cptrp
									 WHERE  (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay INNER JOIN
									(SELECT	 cptpy.RCID, cptpy.ID, cptpy.Capital, cptpy.Interest, (cptpy.Interest + cptpy.TotalAccruedInterest) AS TotalInterest, cptpy.TotalPayment,
											 cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay,
											 cptpy.RemainCapital, cptpy.RemainAccruedInterest, cptpy.TotalRemain				 
									 FROM	 ecpTransPayment AS cptpy INNER JOIN
											 (SELECT   cptpy.RCID, MAX(cptpy.ID) AS MaxPeriod
											  FROM	   ecpTransPayment AS cptpy
											  GROUP BY cptpy.RCID) AS cptpy1 ON cptpy.ID = cptpy1.MaxPeriod) AS cptpy ON cptrc.ID = cptpy.RCID
							 WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 1)' + @where + ') AS t1'
		EXEC (@sql)
	END
	
	/*SELECT ExportDebtorContractRemain*/
	IF (@ordertable = 51)
	BEGIN											
		SET @where = ''
				
		IF (@studentid <> NULL)
			SET @where = @where + '((cptbc.StudentID LIKE "' + @studentid + '%") OR (cptbc.FirstTName LIKE "%' + @studentid + '%") OR (cptbc.LastTName LIKE "%' + @studentid + '%"))'
		
		IF (@faculty <> NULL)
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptbc.FacultyCode = "' + @faculty + '")'
		END
		
		IF ((@program <> NULL) AND (@major <> NULL) AND	(@groupnum <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '((cptbc.ProgramCode = "' + @program + '") AND (cptbc.MajorCode = "' + @major + '") AND (cptbc.GroupNum = "' + @groupnum + '"))'
		END

		IF (@formatpayment <> NULL)			
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '		
			SET @where = @where + '(cptrc.FormatPayment = ' + @formatpayment + ')'		
		END

		IF ((@datestart <> NULL) AND (@dateend <> NULL))
		BEGIN
			IF (@where <> '')
				SET @where = @where + ' AND '			
			SET @where = @where + '(CONVERT(DATE, CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(cptrp.ReplyDate, 7, 4)) - 543)) + "-" + SUBSTRING(cptrp.ReplyDate, 4, 2) + "-" + SUBSTRING(cptrp.ReplyDate, 1, 2)) BETWEEN "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@datestart, 7, 4)) - 543)) + "-" + SUBSTRING(@datestart, 4, 2) + "-" + SUBSTRING(@datestart, 1, 2) + '" AND "' + CONVERT(VARCHAR, (CONVERT(INT, SUBSTRING(@dateend, 7, 4)) - 543)) + "-" + SUBSTRING(@dateend, 4, 2) + "-" + SUBSTRING(@dateend, 1, 2) + '")'
		END
			
		IF (@where <> '') 
			SET @where = ' AND (' + @where + ')'	
			
		SET @sql = 'SELECT	 cptbc.ID AS BCID, cptrc.ID AS RCID, cptbc.StudentID, cptbc.TitleTName, cptbc.FirstTName, cptbc.LastTName, 
							 cptbc.FacultyCode, cptbc.FacultyName, cptbc.ProgramCode, cptbc.ProgramName, cptbc.MajorCode, cptbc.GroupNum,
							 cptbc.DLevel,
							 (
								CASE cptbc.DLevel
									WHEN "U" THEN "ต่ำกว่าปริญญาตรี"
									WHEN "B" THEN "ปริญญาตรี"
									ELSE NULL
								END	
							 ) AS DLevelName,							 
							 cptbc.StatusSend, cptbc.StatusReceiver, cptbc.StatusEdit, cptbc.StatusCancel, cptbc.CivilFlag,
							 cptbc.IndemnitorYear, cptrc.AllActualDate, cptbc.IndemnitorCash,
							 cptrc.RequireDate, cptrc.ApproveDate, cptrc.ActualDate, cptrc.RemainDate,
							 cptrc.TotalPenalty, cptpy.RemainCapital, cptpy.AccruedInterest, cptpy.RemainAccruedInterest, cptpy.TotalRemain,
							 cptrp.ReplyDate, cptrc.StatusPayment, cptrc.FormatPayment,
							 (
								CASE cptrc.FormatPayment
									WHEN 1 THEN "ชำระแบบเต็มจำนวน"
									WHEN 2 THEN "ชำระแบบผ่อนชำระ"
									ELSE NULL
								END											
							 ) AS FormatPaymentName
					FROM	 ecpTransBreakContract AS cptbc INNER JOIN 
	 						 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
	 						 (SELECT cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
							  FROM	 ecpTransRepayContract AS cptrp
							  WHERE	 (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN							  
							 (SELECT	 cptpy.RCID, cptpy.ID, cptpy.Capital, cptpy.Interest, cptpy.TotalAccruedInterest, (cptpy.Interest + cptpy.TotalAccruedInterest) AS TotalInterest, cptpy.TotalPayment,
										 cptpy.PayCapital, cptpy.PayInterest, cptpy.TotalPay,
										 cptpy.RemainCapital, cptpy.AccruedInterest, cptpy.RemainAccruedInterest, cptpy.TotalRemain
							  FROM		 ecpTransPayment AS cptpy INNER JOIN
										(SELECT   cptpy.RCID, MAX(cptpy.ID) AS MaxPeriod
										 FROM	  ecpTransPayment AS cptpy
										 GROUP BY cptpy.RCID) AS cptpy1 ON cptpy.ID = cptpy1.MaxPeriod) AS cptpy ON cptrc.ID = cptpy.RCID
					WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 3)' + @where + ' 
					ORDER BY cptbc.ProgramCode, cptbc.StudentID'
		EXEC (@sql)
		
		SET @sql = 'SELECT	 SUM(tt1.TotalPenalty) AS TotalPenalty
					FROM	 (SELECT cptrc.TotalPenalty
							  FROM	 ecpTransBreakContract AS cptbc INNER JOIN 
	 								 ecpTransRequireContract AS cptrc ON cptbc.ID = cptrc.BCID INNER JOIN
									 (SELECT cptrp.RCID, cptrp.StatusRepay, cptrp.ReplyDate
									  FROM	 ecpTransRepayContract AS cptrp
									  WHERE	 (cptrp.StatusReply = 2) AND (cptrp.ReplyResult = 1)) AS cptrp ON cptrc.ID = cptrp.RCID AND cptrc.StatusRepay = cptrp.StatusRepay LEFT JOIN
									 (SELECT   cptpy.RCID
									  FROM	   ecpTransPayment AS cptpy
									  GROUP BY cptpy.RCID) AS cptpy ON cptrc.ID = cptpy.RCID
							  WHERE	(cptbc.StatusCancel = 1) AND (cptrc.StatusPayment <> 3)' + @where + ') AS tt1'
		EXEC (@sql)		
	END
			
	/*INSERT UPDATE DELETE*/
	IF (@ordertable = 52)
	BEGIN
		SET @sql = NULL
		IF (@cmd <> NULL)
		BEGIN
			SELECT @sql = @cmd	
		
			BEGIN TRAN
				EXEC (@sql)
				IF (@@ERROR <> 0)
				BEGIN
					ROLLBACK TRAN
					RETURN	
				END
			COMMIT TRAN
		END			
	END	
END