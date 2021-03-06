USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_stdTransferStudentRecordsToMUStudent]    Script Date: 11-10-2016 10:55:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๓/๐๓/๒๕๕๘>
-- Description	: <สำหรับดึงข้อมูลนักศึกษาจากฐานข้อมูล Infinity มาบันทึกที่ฐานข้อมูล MUStudent>
--  1. personId	เป็น VARCHAR	รับค่ารหัสบุคคล
-- =============================================
--sp_stdTransferStudentRecordsToMUStudent '2553000562'
ALTER PROCEDURE [dbo].[sp_stdTransferStudentRecordsToMUStudent]
(	
	@personId VARCHAR(10) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	
	SET @personId = LTRIM(RTRIM(@personId))
	
	DECLARE @recordCount INT = 0
	DECLARE @recordCountMUStudent INT = 0
	DECLARE @action VARCHAR(10) = ''
	
	IF (OBJECT_ID('tempdb..#tbStudentRecords') IS NOT NULL) DROP TABLE #tbStudentRecords
	
	SET @personId = ISNULL(@personId, '')
			
	IF (@personId IS NOT NULL AND LEN(@personId) > 0)
	BEGIN		
		SELECT	 stdstd.id,
				 ISNULL(stdstd.studentCode, stdstd.tempCode) AS studentId,
				 stdstd.yearEntry
		INTO	 #tbStudentRecords
		FROM	 fnc_perGetPersonStudent(@personId) AS stdstd
		ORDER BY stdstd.studentId				 

		SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecords)
		
		IF (@recordCount > 0)			
		BEGIN
			--MUStudent..Student			
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransStudent') IS NOT NULL) DROP TABLE #tbStudentRecordsTransStudent
			
			SELECT	tmpstd.studentId,
					LTRIM(RTRIM(stdstd.perTitlePrefixId)) AS perTitlePrefixId,
					LTRIM(RTRIM(stdstd.perTitlePrefixIdOld)) AS perTitlePrefixIdOld,
					LTRIM(RTRIM(ISNULL(stdstd.enTitleInitials, stdstd.enTitleFullName))) AS enTitleName,
					UPPER(LTRIM(RTRIM(stdstd.enFirstName))) AS enFirstName,
					UPPER(LTRIM(RTRIM(stdstd.enMiddleName))) AS enMiddleName,
					UPPER(LTRIM(RTRIM(stdstd.enLastName))) AS enLastName,
					LTRIM(RTRIM(ISNULL(stdstd.thTitleFullName, stdstd.thTitleInitials))) AS thTitleName,
					LTRIM(RTRIM(stdstd.firstName)) AS firstName,	
					LTRIM(RTRIM(stdstd.middleName)) AS middleName,	
					LTRIM(RTRIM(stdstd.lastName)) AS lastName,
					LTRIM(RTRIM(ISNULL(stdstd.enGenderInitialsTitlePrefix, stdstd.enGenderInitials))) AS enGenderInitialsTitlePrefix,
					stdstd.birthDate,
					LTRIM(RTRIM(stdstd.programCode)) AS programCode,
					LTRIM(RTRIM(stdstd.majorCode)) AS majorCode,
					LTRIM(RTRIM(stdstd.groupNum)) AS groupNum,
					LTRIM(RTRIM(stdstd.studyYear)) AS studyYear,
					NULL AS programStatus,
					LTRIM(RTRIM(stdstd.degree)) AS degree,
					LTRIM(RTRIM(stdstd.isoOriginName3Letter)) AS isoOriginName3Letter,
					LTRIM(RTRIM(stdstd.isoNationalityName3Letter)) AS isoNationalityName3Letter,
					LTRIM(RTRIM(stdstd.thNationalityName)) AS thNationalityName,
					stdstd.admissionDate,
					NULL AS schoolCode,
					NULL AS pinCode,
					LTRIM(RTRIM(stdstd.idCard)) AS idCard,
					NULL AS photo,
					MUStudent.dbo.fnGenBarcode(tmpstd.studentId, stdstd.degree) AS barcode,
					LTRIM(RTRIM(stdstd.perEntranceTypeIdOld)) AS perEntranceTypeIdOld,
					NULL AS scholarshipCode,
					NULL AS schoolGPA,
					LTRIM(RTRIM(stdstd.distinction)) AS distinction,
					NULL AS flagApprove, 
					NULL AS flagParentStatus,  
					LTRIM(RTRIM(stdstd.graduateYear)) AS graduateYear,
					NULL AS quotaCode, 
					NULL AS transferIntDate,
					LTRIM(RTRIM(stdstd.tempCode)) AS tempCode,
					NULL AS studentOffice,
					LTRIM(RTRIM(stdstd.email)) AS email
			INTO	#tbStudentRecordsTransStudent				
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetPersonStudent(@personId) AS stdstd ON tmpstd.id = stdstd.id
			
			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransStudent)
			
			IF (@recordCount > 0)
			BEGIN
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..Student AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId)
													
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)

				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..Student
						SET		StudentID			= tmpstd.studentId,
								TitleCode			= tmpstd.perTitlePrefixIdOld,
								FirstName			= tmpstd.enFirstName,							
								LastName			= ((CASE WHEN (tmpstd.enMiddleName IS NOT NULL AND LEN(tmpstd.enMiddleName) > 0) THEN (tmpstd.enMiddleName + ' ') ELSE '' END) + tmpstd.enLastName),
								ThaiFName			= tmpstd.firstName,
								ThaiLName			= ((CASE WHEN (tmpstd.middleName IS NOT NULL AND LEN(tmpstd.middleName) > 0) THEN (tmpstd.middleName + ' ') ELSE '' END) + tmpstd.lastName),
								Gender				= tmpstd.enGenderInitialsTitlePrefix,
								BirthDate			= tmpstd.birthDate,
								ProgramCode			= tmpstd.programCode,
								MajorCode			= tmpstd.majorCode,
								GroupNum			= tmpstd.groupNum,
								ProgramYear			= tmpstd.studyYear,
								ProgramStatus		= musstd.ProgramStatus,
								Degree				= tmpstd.degree,
								RaceCode			= tmpstd.isoOriginName3Letter,
								NationalityCode		= tmpstd.isoNationalityName3Letter,
								AdmissionDate		= tmpstd.admissionDate,
								SchoolCode			= musstd.SchoolCode,
								PinCode				= musstd.PinCode,
								IdCard				= tmpstd.idCard,
								Photo				= musstd.Photo,
								Barcode				= tmpstd.barcode,
								EntType				= tmpstd.perEntranceTypeIdOld,
								ScholarShipCode		= musstd.ScholarShipCode,
								SchoolGPA			= musstd.SchoolGPA,
								Distinction			= tmpstd.distinction,
								FlagApprove			= musstd.FlagApprove,
								FlagParentStatus	= musstd.FlagParentStatus,
								GradYear			= tmpstd.graduateYear,
								QuotaCode			= musstd.QuotaCode,
								TransferIntDate		= musstd.TransferIntDate,
								TempStudentID		= tmpstd.tempCode,
								StudentOffice		= musstd.StudentOffice,
								Email				= tmpstd.email
						FROM	MUStudent..Student AS musstd INNER JOIN
								#tbStudentRecordsTransStudent AS tmpstd ON musstd.StudentID = tmpstd.studentId

						UPDATE	MURegistration..WebStudentInfo
						SET		StudentID			= tmpstd.studentId,
								Title				= tmpstd.thTitleName,
								FirstName			= tmpstd.firstName,
								LastName			= ((CASE WHEN (tmpstd.middleName IS NOT NULL AND LEN(tmpstd.middleName) > 0) THEN (tmpstd.middleName + ' ') ELSE '' END) + tmpstd.lastName),
								ETitle				= tmpstd.enTitleName,
								EFirstName			= tmpstd.enFirstName,
								ELastName			= ((CASE WHEN (tmpstd.enMiddleName IS NOT NULL AND LEN(tmpstd.enMiddleName) > 0) THEN (tmpstd.enMiddleName + ' ') ELSE '' END) + tmpstd.enLastName),
								Gender				= tmpstd.enGenderInitialsTitlePrefix,
								BirthDate			= tmpstd.birthDate,
								NationalityTName	= tmpstd.thNationalityName
						FROM	MURegistration..WebStudentInfo AS murstd INNER JOIN
								#tbStudentRecordsTransStudent AS tmpstd ON murstd.StudentID = tmpstd.studentId
					END TRY	
					BEGIN CATCH
					END CATCH							
				END
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..Student
						(
							StudentID,
							TitleCode,
							FirstName,
							LastName,
							ThaiFName,
							ThaiLName,
							Gender,
							BirthDate,
							ProgramCode,
							MajorCode,
							GroupNum,
							ProgramYear,
							ProgramStatus,
							Degree,
							RaceCode,
							NationalityCode,
							AdmissionDate,
							SchoolCode,
							PinCode,
							IdCard,
							Photo,
							Barcode,
							EntType,
							ScholarShipCode,
							SchoolGPA,
							Distinction,
							FlagApprove,
							FlagParentStatus,
							GradYear,
							QuotaCode,
							TransferIntDate,
							TempStudentID,
							StudentOffice,
							Email
						)
						SELECT 	studentId,
								perTitlePrefixIdOld,
								enFirstName,
								enLastName,
								firstName,	
								lastName,
								enGenderInitialsTitlePrefix,
								birthDate,
								programCode,
								majorCode,
								groupNum,
								studyYear,
								NULL,
								degree,
								isoOriginName3Letter,
								isoNationalityName3Letter,
								admissionDate,
								NULL,
								NULL,
								idCard,
								NULL,
								barcode,
								perEntranceTypeIdOld,
								NULL,
								NULL,
								distinction,
								NULL, 
								NULL,  
								graduateYear,
								NULL, 
								NULL,
								tempCode,
								NULL,
								email					
						FROM	#tbStudentRecordsTransStudent
					END TRY
					BEGIN CATCH
					END CATCH						
				END
			END

			--MUStudent..SProfile
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransSProfile') IS NOT NULL) DROP TABLE #tbStudentRecordsTransSProfile
			
			SELECT	tmpstd.studentId,
					NULL AS maritalStatus,
					NULL AS noOfChildren,
					NULL AS birthPlace,
					NULL AS bCountryCode,
					NULL AS idType,
					LTRIM(RTRIM(stdstd.idCard)) AS idCard,
					NULL AS expirationDate,
					NULL AS idCountryCode,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(stdstd.perReligionId))) > 0) THEN						
								(SELECT	musrlg.ReligionCode
								 FROM	MUStudent..BReligion AS musrlg INNER JOIN
										Infinity..perReligion AS insrlg ON musrlg.ReligionName = insrlg.enReligionName
								 WHERE  (insrlg.id = stdstd.perReligionId))
							ELSE NULL									 
						END																
					) AS religionCode,
					LTRIM(RTRIM(stdstd.enBloodTypeName)) AS bloodType,
					NULL AS otherContact,
					(
						CASE LTRIM(RTRIM(stdstd.perMaritalStatusId))
							WHEN '01' THEN '0'
							WHEN '02' THEN '1'
							WHEN '04' THEN '2'
							WHEN '05' THEN '3'
							WHEN '03' THEN '4'
							ELSE NULL
						END								
					) AS marriageStatus,
					LTRIM(RTRIM(stdstd.childhoodNumber)) AS childhoodNumber,
					LTRIM(RTRIM(stdstd.brotherhoodNumber)) AS brotherhoodNumber,
					LTRIM(RTRIM(stdstd.studyhoodNumber)) AS studyhoodNumber,
					(
						CASE LTRIM(RTRIM(perfnc.worked))
							WHEN 'Y' THEN '2'
							WHEN 'N' THEN '1'
							ELSE NULL
						END								
					) AS worked,
					LTRIM(RTRIM(perfnc.salary)) AS salary,
					(
						CASE LTRIM(RTRIM(perfnc.gotMoneyFrom))
							WHEN '01' THEN '1'
							WHEN '02' THEN '2'
							WHEN '03' THEN '3'
							WHEN '04' THEN '4'
							WHEN '05' THEN '5'
							WHEN '06' THEN '6'
							WHEN '07' THEN '7'
							ELSE NULL
						END								
					) AS gotMoneyFrom,
					LTRIM(RTRIM(perfnc.gotMoneyFromOther)) AS gotMoneyFromOther,
					LTRIM(RTRIM(perfnc.gotMoneyPerMonth)) AS gotMoneyPerMonth,
					LTRIM(RTRIM(perfnc.costPerMonth)) AS costPerMonth
			INTO	#tbStudentRecordsTransSProfile			
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetPersonStudent(@personId) AS stdstd ON tmpstd.id = stdstd.id LEFT JOIN
					fnc_perGetFinancial(@personId) AS perfnc ON stdstd.id = perfnc.id

			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransSProfile)					
			
			IF (@recordCount > 0)
			BEGIN					
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..SProfile AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId)
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)
				
				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..SProfile
						SET		StudentID		= tmpstd.studentId,
								MaritalStatus	= musstd.MaritalStatus,
								NoOfChildren	= musstd.NoOfChildren,
								BirthPlace		= musstd.BirthPlace,
								BCountryCode	= musstd.BCountryCode,
								IDType			= musstd.IDType,
								IDNo			= tmpstd.idCard,
								ExpirationDate	= musstd.ExpirationDate,
								IDCountryCode	= musstd.IDCountryCode,
								ReligionCode	= tmpstd.religionCode,
								BloodType		= tmpstd.bloodType,
								OtherContact	= musstd.OtherContact,
								MarriageStatus	= tmpstd.marriageStatus,
								StudenthoodNum	= tmpstd.childhoodNumber,
								Brotherhood		= tmpstd.brotherhoodNumber,
								Studyhood		= tmpstd.studyhoodNumber,
								Worked			= tmpstd.worked,
								WorkedSalary	= tmpstd.salary,
								GotSalaryStatus	= tmpstd.gotMoneyFrom,
								GotSalaryDetail	= tmpstd.gotMoneyFromOther,
								SalaryFrom		= tmpstd.gotMoneyPerMonth,
								AvgSalary		= tmpstd.costPerMonth
						FROM	MUStudent..SProfile AS musstd INNER JOIN
								#tbStudentRecordsTransSProfile AS tmpstd ON musstd.StudentID = tmpstd.studentId
					END TRY
					BEGIN CATCH
					END CATCH								
				END				

				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..SProfile
						(
							StudentID,
							MaritalStatus,
							NoOfChildren,
							BirthPlace,
							BCountryCode,
							IDType,
							IDNo,
							ExpirationDate,
							IDCountryCode,
							ReligionCode,
							BloodType,
							OtherContact,
							MarriageStatus,
							StudenthoodNum,
							Brotherhood,
							Studyhood,
							Worked,
							WorkedSalary,
							GotSalaryStatus,
							GotSalaryDetail,
							SalaryFrom,
							AvgSalary
						)
						SELECT	studentId,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								idCard,
								NULL,
								NULL,
								religionCode,
								bloodType,
								NULL,
								marriageStatus,
								childhoodNumber,
								brotherhoodNumber,
								studyhoodNumber,
								worked,
								salary,
								gotMoneyFrom,
								gotMoneyFromOther,
								gotMoneyPerMonth,
								costPerMonth				
						 FROM	#tbStudentRecordsTransSProfile
					END TRY
					BEGIN CATCH
					END CATCH						 
				END				
			END				

			--MUStudent..SAddress Type Permanent
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransSAddressPermanent') IS NOT NULL) DROP TABLE #tbStudentRecordsTransSAddressPermanent
			
			SELECT	tmpstd.studentId,
					'1' AS typePermanent,						 
					LTRIM(RTRIM(peradd.addressPermanent)) AS addressPermanent,
					LTRIM(RTRIM(peradd.thPlaceNamePermanent)) AS thPlaceNamePermanent,
					LTRIM(RTRIM(peradd.thCountryNamePermanent)) AS thCountryNamePermanent,
					LTRIM(RTRIM(peradd.zipCodePermanent)) AS zipCodePermanent,
					LTRIM(RTRIM(peradd.mobileNumberPermanent)) AS telephoneNumberPermanent,
					NULL AS otherContactPermanent,
					NULL AS flagContactPermanent,
					NULL AS flagStatusPermanent,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(peradd.plcProvinceIdPermanent))) > 0) THEN						
								(SELECT	musprv.ProvinceID
								 FROM	MUStudent..BProvince AS musprv INNER JOIN
										Infinity..plcProvince AS insprv ON musprv.ProvinceTName = insprv.provinceNameTH
								 WHERE  (insprv.id = peradd.plcProvinceIdPermanent))
							ELSE NULL									 
						END																
					) AS plcProvinceIdPermanent,
					LTRIM(RTRIM(peradd.noPermanent)) AS noPermanent,
					LTRIM(RTRIM(peradd.mooPermanent)) AS mooPermanent,
					LTRIM(RTRIM(peradd.villagePermanent)) AS detailPermanent,
					LTRIM(RTRIM(peradd.soiPermanent)) AS soiPermanent,
					LTRIM(RTRIM(peradd.roadPermanent)) AS roadPermanent,
					LTRIM(RTRIM(peradd.thSubdistrictNamePermanent)) AS thSubdistrictNamePermanent,
					LTRIM(RTRIM(peradd.thDistrictNamePermanent)) AS thDistrictNamePermanent,
					LTRIM(RTRIM(peradd.phoneNumberPermanent)) AS phoneNumberPermanent,
					LTRIM(RTRIM(peradd.mobileNumberPermanent)) AS mobileNumberPermanent,
					LTRIM(RTRIM(peradd.faxNumberPermanent)) AS faxNumberPermanent,
					NULL AS uFlagPermanent
			INTO	#tbStudentRecordsTransSAddressPermanent				 
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetAddress(@personId) AS peradd ON tmpstd.id = peradd.id

			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransSAddressPermanent)

			IF (@recordCount > 0)
			BEGIN
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..SAddress AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId
											 WHERE	musstd.Type = '1')
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)

				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..SAddress
						SET		StudentID		= tmpstd.studentId,
								Type			= tmpstd.typePermanent,
								Address			= tmpstd.addressPermanent,
								Province		= tmpstd.thPlaceNamePermanent,
								Country			= tmpstd.thCountryNamePermanent,
								ZipCode			= tmpstd.zipCodePermanent,
								Telephone		= tmpstd.telephoneNumberPermanent,
								OtherContact	= musstd.OtherContact,
								FlagContact		= musstd.FlagContact,
								FlagStatus		= musstd.FlagStatus,
								MUA_Province	= tmpstd.plcProvinceIdPermanent,
								AddrNo			= tmpstd.noPermanent,
								AddrMoo			= tmpstd.mooPermanent,
								AddrDetail		= tmpstd.detailPermanent,
								AddrSoi			= tmpstd.soiPermanent,
								AddrStreet		= tmpstd.roadPermanent,
								AddrSubDistrict	= tmpstd.thSubdistrictNamePermanent,
								AddrDistrict	= tmpstd.thDistrictNamePermanent,
								AddrTel			= tmpstd.phoneNumberPermanent,
								AddrCell		= tmpstd.mobileNumberPermanent,
								AddrFax			= tmpstd.faxNumberPermanent,
								uFlag			= musstd.uFlag
						FROM	MUStudent..SAddress AS musstd INNER JOIN
								#tbStudentRecordsTransSAddressPermanent AS tmpstd ON musstd.StudentID = tmpstd.studentId AND musstd.Type = tmpstd.typePermanent
					END TRY
					BEGIN CATCH
					END CATCH																		
				END				

				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..SAddress
						(
							StudentID,
							Type,
							Address,
							Province,
							Country,
							ZipCode,
							Telephone,
							OtherContact,
							FlagContact,
							FlagStatus,
							MUA_Province,
							AddrNo,
							AddrMoo,
							AddrDetail,
							AddrSoi,
							AddrStreet,
							AddrSubDistrict,
							AddrDistrict,
							AddrTel,
							AddrCell,
							AddrFax,
							uFlag
						)
						SELECT	studentId,
								typePermanent,						 
								addressPermanent,
								thPlaceNamePermanent,
								thCountryNamePermanent,
								zipCodePermanent,
								telephoneNumberPermanent,
								NULL,
								NULL,
								NULL,
								plcProvinceIdPermanent,
								noPermanent,
								mooPermanent,
								detailPermanent,
								soiPermanent,
								roadPermanent,
								thSubdistrictNamePermanent,
								thDistrictNamePermanent,
								phoneNumberPermanent,
								mobileNumberPermanent,
								faxNumberPermanent,
								NULL
						FROM	#tbStudentRecordsTransSAddressPermanent
					END TRY						
					BEGIN CATCH
					END CATCH
				END
			END				

			--MUStudent..SAddress Type Current
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransSAddressCurrent') IS NOT NULL) DROP TABLE #tbStudentRecordsTransSAddressCurrent
			
			SELECT	tmpstd.studentId,
					'2' AS typeCurrent,						 
					LTRIM(RTRIM(peradd.addressCurrent)) AS addressCurrent,
					LTRIM(RTRIM(peradd.thPlaceNameCurrent)) AS thPlaceNameCurrent,
					LTRIM(RTRIM(peradd.thCountryNameCurrent)) AS thCountryNameCurrent,
					LTRIM(RTRIM(peradd.zipCodeCurrent)) AS zipCodeCurrent,
					LTRIM(RTRIM(peradd.mobileNumberCurrent)) AS telephoneNumberCurrent,
					NULL AS otherContactCurrent,
					NULL AS flagContactCurrent,
					NULL AS flagStatusCurrent,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(peradd.plcProvinceIdCurrent))) > 0) THEN						
								(SELECT	musprv.ProvinceID
								 FROM	MUStudent..BProvince AS musprv INNER JOIN
										Infinity..plcProvince AS insprv ON musprv.ProvinceTName = insprv.provinceNameTH
								 WHERE  (insprv.id = peradd.plcProvinceIdCurrent))
							ELSE NULL									 
						END																
					) AS plcProvinceIdCurrent,
					LTRIM(RTRIM(peradd.noCurrent)) AS noCurrent,
					LTRIM(RTRIM(peradd.mooCurrent)) AS mooCurrent,
					LTRIM(RTRIM(peradd.villageCurrent)) AS detailCurrent,
					LTRIM(RTRIM(peradd.soiCurrent)) AS soiCurrent,
					LTRIM(RTRIM(peradd.roadCurrent)) AS roadCurrent,
					LTRIM(RTRIM(peradd.thSubdistrictNameCurrent)) AS thSubdistrictNameCurrent,
					LTRIM(RTRIM(peradd.thDistrictNameCurrent)) AS thDistrictNameCurrent,
					LTRIM(RTRIM(peradd.phoneNumberCurrent)) AS phoneNumberCurrent,
					LTRIM(RTRIM(peradd.mobileNumberCurrent)) AS mobileNumberCurrent,
					LTRIM(RTRIM(peradd.faxNumberCurrent)) AS faxNumberCurrent,
					NULL AS uFlag
			INTO	#tbStudentRecordsTransSAddressCurrent
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetAddress(@personId) AS peradd ON tmpstd.id = peradd.id

			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransSAddressCurrent)
			
			IF (@recordCount > 0)
			BEGIN			
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..SAddress AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId
											 WHERE	musstd.Type = '2')
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)

				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..SAddress
						SET		StudentID		= tmpstd.studentId,
								Type			= tmpstd.typeCurrent,
								Address			= tmpstd.addressCurrent,
								Province		= tmpstd.thPlaceNameCurrent,
								Country			= tmpstd.thCountryNameCurrent,
								ZipCode			= tmpstd.zipCodeCurrent,
								Telephone		= tmpstd.telephoneNumberCurrent,
								OtherContact	= musstd.OtherContact,
								FlagContact		= musstd.FlagContact,
								FlagStatus		= musstd.FlagStatus,
								MUA_Province	= tmpstd.plcProvinceIdCurrent,
								AddrNo			= tmpstd.noCurrent,
								AddrMoo			= tmpstd.mooCurrent,
								AddrDetail		= tmpstd.detailCurrent,
								AddrSoi			= tmpstd.soiCurrent,
								AddrStreet		= tmpstd.roadCurrent,
								AddrSubDistrict	= tmpstd.thSubdistrictNameCurrent,
								AddrDistrict	= tmpstd.thDistrictNameCurrent,
								AddrTel			= tmpstd.phoneNumberCurrent,
								AddrCell		= tmpstd.mobileNumberCurrent,
								AddrFax			= tmpstd.faxNumberCurrent,
								uFlag			= musstd.uFlag
						FROM	MUStudent..SAddress AS musstd INNER JOIN
								#tbStudentRecordsTransSAddressCurrent AS tmpstd ON musstd.StudentID = tmpstd.studentId AND musstd.Type = tmpstd.typeCurrent
					END TRY
					BEGIN CATCH
					END CATCH								
				END				

				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..SAddress
						(
							StudentID,
							Type,
							Address,
							Province,
							Country,
							ZipCode,
							Telephone,
							OtherContact,
							FlagContact,
							FlagStatus,
							MUA_Province,
							AddrNo,
							AddrMoo,
							AddrDetail,
							AddrSoi,
							AddrStreet,
							AddrSubDistrict,
							AddrDistrict,
							AddrTel,
							AddrCell,
							AddrFax,
							uFlag
						)
						SELECT	studentId,
								typeCurrent,						 
								addressCurrent,
								thPlaceNameCurrent,
								thCountryNameCurrent,
								zipCodeCurrent,
								telephoneNumberCurrent,
								NULL,
								NULL,
								NULL,
								plcProvinceIdCurrent,
								noCurrent,
								mooCurrent,
								detailCurrent,
								soiCurrent,
								roadCurrent,
								thSubdistrictNameCurrent,
								thDistrictNameCurrent,
								phoneNumberCurrent,
								mobileNumberCurrent,
								faxNumberCurrent,
								NULL
						FROM	#tbStudentRecordsTransSAddressCurrent
					END TRY
					BEGIN CATCH
					END CATCH						
				END
			END				

			--MUStudent..AcademicBG ระดับประถม
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransAcademicBGPrimarySchool') IS NOT NULL) DROP TABLE #tbStudentRecordsTransAcademicBGPrimarySchool
			
			SELECT	tmpstd.studentId,
					'003' AS idPrimarySchool,
					'001' AS levelPrimarySchool,
					NULL AS primarySchoolId,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(peredu.plcProvinceIdPrimarySchool))) > 0) THEN						
								(SELECT	musprv.ProvinceID
								 FROM	MUStudent..BProvince AS musprv INNER JOIN
										Infinity..plcProvince AS insprv ON musprv.ProvinceTName = insprv.provinceNameTH
								 WHERE  (insprv.id = peredu.plcProvinceIdPrimarySchool)) 
							ELSE NULL									 
						END																
					) AS provinceIdPrimarySchool,
					NULL AS primarySchoolStudentId,
					NULL AS primarySchoolMajor,
					LTRIM(RTRIM(peredu.primarySchoolGPA)) AS primarySchoolGPA,
					LTRIM(RTRIM(peredu.primarySchoolYearAttended)) AS primarySchoolYearAttended,
					LTRIM(RTRIM(peredu.primarySchoolYearGraduate)) AS primarySchoolYearGraduate,
					'ประถม' AS primarySchoolDegree,
					LTRIM(RTRIM(peredu.primarySchoolName)) AS primarySchoolName,
					NULL AS flagCV,
					NULL AS changeIndex,
					NULL AS educationalBackground,
					NULL AS graduateBy,
					NULL AS graduateBySchoolName,
					NULL AS entranceTime,
					NULL AS studentIs,
					NULL AS studentIsUniversity,
					NULL AS studentIsFaculty,
					NULL AS studentIsProgram,
					NULL AS entranceType,
					NULL AS admissionRanking,
					NULL AS scoreONET01,
					NULL AS scoreONET02,
					NULL AS scoreONET03,
					NULL AS scoreONET04,
					NULL AS scoreONET05,
					NULL AS scoreONET06,
					NULL AS scoreONET07,
					NULL AS scoreONET08,
					NULL AS scoreGAT85,
					NULL AS scorePAT71,
					NULL AS scorePAT72,
					NULL AS scorePAT73,
					NULL AS scorePAT74,
					NULL AS scorePAT75,
					NULL AS scorePAT76,
					NULL AS scorePAT77,
					NULL AS scorePAT78,
					NULL AS scorePAT79,
					NULL AS scorePAT80,
					NULL AS scorePAT81,
					NULL AS scorePAT82,
					NULL AS scoreANET11,
					NULL AS scoreANET12,
					NULL AS scoreANET13,
					NULL AS scoreANET14,
					NULL AS scoreANET15
			INTO	#tbStudentRecordsTransAcademicBGPrimarySchool					 
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetEducation(@personId) AS peredu ON tmpstd.id = peredu.id
					
			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransAcademicBGPrimarySchool)

			IF (@recordCount > 0)
			BEGIN					
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..AcademicBG AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId
											 WHERE	(musstd.Aca_ID = '003') AND (musstd.Aca_Level = '001'))
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)					

				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..AcademicBG
						SET		StudentID				= tmpstd.studentId,
								Aca_ID					= tmpstd.idPrimarySchool,
								Aca_Level				= tmpstd.levelPrimarySchool,
								InstituteID				= musstd.InstituteID,
								MUA_Province			= tmpstd.provinceIdPrimarySchool,
								StudentIDAcaBG			= tmpstd.primarySchoolStudentId,
								Major					= musstd.Major,
								CGPA					= tmpstd.primarySchoolGPA,
								From_Year				= tmpstd.primarySchoolYearAttended,
								To_Year					= tmpstd.primarySchoolYearGraduate,
								Degree					= tmpstd.primarySchoolDegree,
								InstituteName			= tmpstd.primarySchoolName,
								FlagCV					= musstd.FlagCV,
								ChangeIndex				= musstd.ChangeIndex,
								GraduateDegree			= musstd.GraduateDegree,
								Entrance_Status			= musstd.Entrance_Status,
								Entrance_StatusDetail	= musstd.Entrance_StatusDetail,
								Entrance_Time			= musstd.Entrance_Time,
								studyFrom				= musstd.studyFrom,
								Entrance_University		= musstd.Entrance_University,
								Entrance_UniFaculty		= musstd.Entrance_UniFaculty,
								Entrance_UniBranch		= musstd.Entrance_UniBranch,
								EntranceBy				= musstd.EntranceBy,
								EntranceBy_Detail		= musstd.EntranceBy_Detail,
								ONET_01					= musstd.ONET_01,
								ONET_02					= musstd.ONET_02,
								ONET_03					= musstd.ONET_03,	
								ONET_04					= musstd.ONET_04,
								ONET_05					= musstd.ONET_05,				
								ONET_06					= musstd.ONET_06,
								ONET_07					= musstd.ONET_07,
								ONET_08					= musstd.ONET_08,
								GAT_85					= musstd.GAT_85,
								PAT_71					= musstd.PAT_71,
								PAT_72					= musstd.PAT_72,
								PAT_73					= musstd.PAT_73,
								PAT_74					= musstd.PAT_74,
								PAT_75					= musstd.PAT_75,
								PAT_76					= musstd.PAT_76,
								PAT_77					= musstd.PAT_77,
								PAT_78					= musstd.PAT_78,
								PAT_79					= musstd.PAT_79,
								PAT_80					= musstd.PAT_80,
								PAT_81					= musstd.PAT_81,
								PAT_82					= musstd.PAT_82,
								ANET_11					= musstd.ANET_11,
								ANET_12					= musstd.ANET_12,
								ANET_13					= musstd.ANET_13,
								ANET_14					= musstd.ANET_14,
								ANET_15					= musstd.ANET_15
						FROM	MUStudent..AcademicBG AS musstd INNER JOIN
								#tbStudentRecordsTransAcademicBGPrimarySchool AS tmpstd ON musstd.StudentID = tmpstd.studentId AND musstd.Aca_ID = tmpstd.idPrimarySchool AND musstd.Aca_Level = tmpstd.levelPrimarySchool
					END TRY
					BEGIN CATCH
					END CATCH								
				END	
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..AcademicBG
						(
							StudentID,
							Aca_ID,
							Aca_Level,
							InstituteID,
							MUA_Province,
							StudentIDAcaBG,
							Major,
							CGPA,
							From_Year,
							To_Year,
							Degree,
							InstituteName,
							FlagCV,
							ChangeIndex,
							GraduateDegree,
							Entrance_Status,
							Entrance_StatusDetail,
							Entrance_Time,
							studyFrom,
							Entrance_University,
							Entrance_UniFaculty,
							Entrance_UniBranch,
							EntranceBy,
							EntranceBy_Detail,
							ONET_01,
							ONET_02,
							ONET_03,	
							ONET_04,
							ONET_05,
							ONET_06,
							ONET_07,
							ONET_08,
							GAT_85,
							PAT_71,
							PAT_72,
							PAT_73,
							PAT_74,
							PAT_75,
							PAT_76,
							PAT_77,
							PAT_78,
							PAT_79,
							PAT_80,
							PAT_81,
							PAT_82,
							ANET_11,
							ANET_12,
							ANET_13,
							ANET_14,
							ANET_15
						)
						SELECT	studentId,
								idPrimarySchool,
								levelPrimarySchool,
								NULL,
								provinceIdPrimarySchool,
								NULL,
								NULL,
								primarySchoolGPA,
								primarySchoolYearAttended,
								primarySchoolYearGraduate,
								primarySchoolDegree,
								primarySchoolName,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL
						FROM	#tbStudentRecordsTransAcademicBGPrimarySchool
					END TRY
					BEGIN CATCH
					END CATCH											
				END			
			END				

			--MUStudent..AcademicBG ระดับมัธยมต้น
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransAcademicBGJuniorHighSchool') IS NOT NULL) DROP TABLE #tbStudentRecordsTransAcademicBGJuniorHighSchool
			
			SELECT	tmpstd.studentId,
					'002' AS idJuniorHighSchool,
					'002' AS levelJuniorHighSchool,
					NULL AS juniorHighSchoolSchoolId,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(peredu.plcProvinceIdJuniorHighSchool))) > 0) THEN						
								(SELECT	musprv.ProvinceID
								 FROM	MUStudent..BProvince AS musprv INNER JOIN
										Infinity..plcProvince AS insprv ON musprv.ProvinceTName = insprv.provinceNameTH
								 WHERE  (insprv.id = peredu.plcProvinceIdJuniorHighSchool))
							ELSE NULL									 
						END																
					) AS provinceIdJuniorHighSchool,
					NULL AS juniorHighSchoolStudentId,
					NULL AS juniorHighSchoolMajor,
					LTRIM(RTRIM(peredu.juniorHighSchoolGPA)) AS juniorHighSchoolGPA,
					LTRIM(RTRIM(peredu.juniorHighSchoolYearAttended)) AS juniorHighSchoolYearAttended,
					LTRIM(RTRIM(peredu.juniorHighSchoolYearGraduate)) AS juniorHighSchoolYearGraduate,
					'มัธยมต้น' AS juniorHighSchoolDegree,
					LTRIM(RTRIM(peredu.juniorHighSchoolName)) AS juniorHighSchoolName,
					NULL AS flagCV,
					NULL AS changeIndex,
					NULL AS educationalBackground,
					NULL AS graduateBy,
					NULL AS graduateBySchoolName,
					NULL AS entranceTime,
					NULL AS studentIs,
					NULL AS studentIsUniversity,
					NULL AS studentIsFaculty,
					NULL AS studentIsProgram,
					NULL AS entranceType,
					NULL AS admissionRanking,
					NULL AS scoreONET01,
					NULL AS scoreONET02,
					NULL AS scoreONET03,
					NULL AS scoreONET04,
					NULL AS scoreONET05,
					NULL AS scoreONET06,
					NULL AS scoreONET07,
					NULL AS scoreONET08,
					NULL AS scoreGAT85,
					NULL AS scorePAT71,
					NULL AS scorePAT72,
					NULL AS scorePAT73,
					NULL AS scorePAT74,
					NULL AS scorePAT75,
					NULL AS scorePAT76,
					NULL AS scorePAT77,
					NULL AS scorePAT78,
					NULL AS scorePAT79,
					NULL AS scorePAT80,
					NULL AS scorePAT81,
					NULL AS scorePAT82,
					NULL AS scoreANET11,
					NULL AS scoreANET12,
					NULL AS scoreANET13,
					NULL AS scoreANET14,
					NULL AS scoreANET15
			INTO	#tbStudentRecordsTransAcademicBGJuniorHighSchool					 
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetEducation(@personId) AS peredu ON tmpstd.id = peredu.id

			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransAcademicBGJuniorHighSchool)

			IF (@recordCount > 0)
			BEGIN
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..AcademicBG AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId
											 WHERE	(musstd.Aca_ID = '002') AND (musstd.Aca_Level = '002'))
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)

				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..AcademicBG
						SET		StudentID				= tmpstd.studentId,
								Aca_ID					= tmpstd.idJuniorHighSchool,
								Aca_Level				= tmpstd.levelJuniorHighSchool,
								InstituteID				= musstd.InstituteID,
								MUA_Province			= tmpstd.provinceIdJuniorHighSchool,
								StudentIDAcaBG			= tmpstd.juniorHighSchoolStudentId,
								Major					= musstd.Major,
								CGPA					= tmpstd.juniorHighSchoolGPA,
								From_Year				= tmpstd.juniorHighSchoolYearAttended,
								To_Year					= tmpstd.juniorHighSchoolYearGraduate,
								Degree					= tmpstd.juniorHighSchoolDegree,
								InstituteName			= tmpstd.juniorHighSchoolName,
								FlagCV					= musstd.FlagCV,
								ChangeIndex				= musstd.ChangeIndex,
								GraduateDegree			= musstd.GraduateDegree,
								Entrance_Status			= musstd.Entrance_Status,
								Entrance_StatusDetail	= musstd.Entrance_StatusDetail,
								Entrance_Time			= musstd.Entrance_Time,
								studyFrom				= musstd.studyFrom,
								Entrance_University		= musstd.Entrance_University,
								Entrance_UniFaculty		= musstd.Entrance_UniFaculty,
								Entrance_UniBranch		= musstd.Entrance_UniBranch,
								EntranceBy				= musstd.EntranceBy,
								EntranceBy_Detail		= musstd.EntranceBy_Detail,
								ONET_01					= musstd.ONET_01,
								ONET_02					= musstd.ONET_02,
								ONET_03					= musstd.ONET_03,	
								ONET_04					= musstd.ONET_04,
								ONET_05					= musstd.ONET_05,				
								ONET_06					= musstd.ONET_06,
								ONET_07					= musstd.ONET_07,
								ONET_08					= musstd.ONET_08,
								GAT_85					= musstd.GAT_85,
								PAT_71					= musstd.PAT_71,
								PAT_72					= musstd.PAT_72,
								PAT_73					= musstd.PAT_73,
								PAT_74					= musstd.PAT_74,
								PAT_75					= musstd.PAT_75,
								PAT_76					= musstd.PAT_76,
								PAT_77					= musstd.PAT_77,
								PAT_78					= musstd.PAT_78,
								PAT_79					= musstd.PAT_79,
								PAT_80					= musstd.PAT_80,
								PAT_81					= musstd.PAT_81,
								PAT_82					= musstd.PAT_82,
								ANET_11					= musstd.ANET_11,
								ANET_12					= musstd.ANET_12,
								ANET_13					= musstd.ANET_13,
								ANET_14					= musstd.ANET_14,
								ANET_15					= musstd.ANET_15
						FROM	MUStudent..AcademicBG AS musstd INNER JOIN
								#tbStudentRecordsTransAcademicBGJuniorHighSchool AS tmpstd ON musstd.StudentID = tmpstd.studentId AND musstd.Aca_ID = tmpstd.idJuniorHighSchool AND musstd.Aca_Level = tmpstd.levelJuniorHighSchool
					END TRY
					BEGIN CATCH
					END CATCH													
				END
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..AcademicBG
						(
							StudentID,
							Aca_ID,
							Aca_Level,
							InstituteID,
							MUA_Province,
							StudentIDAcaBG,
							Major,
							CGPA,
							From_Year,
							To_Year,
							Degree,
							InstituteName,
							FlagCV,
							ChangeIndex,
							GraduateDegree,
							Entrance_Status,
							Entrance_StatusDetail,
							Entrance_Time,
							studyFrom,
							Entrance_University,
							Entrance_UniFaculty,
							Entrance_UniBranch,
							EntranceBy,
							EntranceBy_Detail,
							ONET_01,
							ONET_02,
							ONET_03,	
							ONET_04,
							ONET_05,
							ONET_06,
							ONET_07,
							ONET_08,
							GAT_85,
							PAT_71,
							PAT_72,
							PAT_73,
							PAT_74,
							PAT_75,
							PAT_76,
							PAT_77,
							PAT_78,
							PAT_79,
							PAT_80,
							PAT_81,
							PAT_82,
							ANET_11,
							ANET_12,
							ANET_13,
							ANET_14,
							ANET_15
						)
						SELECT	studentId,
								idJuniorHighSchool,
								levelJuniorHighSchool,
								NULL,
								provinceIdJuniorHighSchool,
								NULL,
								NULL,
								juniorHighSchoolGPA,
								juniorHighSchoolYearAttended,
								juniorHighSchoolYearGraduate,
								juniorHighSchoolDegree,
								juniorHighSchoolName,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL
						FROM	#tbStudentRecordsTransAcademicBGJuniorHighSchool
					END TRY
					BEGIN CATCH
					END CATCH											
				END
			END
			
			--MUStudent..AcademicBG ระดับมัธยมปลาย
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransAcademicBGHighSchool') IS NOT NULL) DROP TABLE #tbStudentRecordsTransAcademicBGHighSchool
			
			SELECT	tmpstd.studentId,
					'001' AS idHighSchool,
					'003' AS levelHighSchool,
					NULL AS highSchoolSchoolId,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(peredu.plcProvinceIdHighSchool))) > 0) THEN						
								(SELECT	musprv.ProvinceID
								 FROM	MUStudent..BProvince AS musprv INNER JOIN
										Infinity..plcProvince AS insprv ON musprv.ProvinceTName = insprv.provinceNameTH
								 WHERE  (insprv.id = peredu.plcProvinceIdHighSchool))
							ELSE NULL									 
						END																
					) AS provinceIdHighSchool,
					LTRIM(RTRIM(peredu.highSchoolStudentId)) AS highSchoolStudentId,
					(
						CASE LTRIM(RTRIM(peredu.perEducationalMajorIdHighSchool))
							WHEN '01' THEN 'วิทย์-คณิต'
							WHEN '02' THEN 'ศิลป์-คำนวน'
							WHEN '03' THEN 'ศิลป์-ภาษา'
							ELSE peredu.educationalMajorOtherHighSchool
						END								
					) AS highSchoolMajor,						 						 
					LTRIM(RTRIM(peredu.highSchoolGPA)) AS highSchoolGPA,
					LTRIM(RTRIM(peredu.highSchoolYearAttended)) AS highSchoolYearAttended,
					LTRIM(RTRIM(peredu.highSchoolYearGraduate)) AS highSchoolYearGraduate,
					'ม.6' AS highSchoolDegree,
					LTRIM(RTRIM(peredu.highSchoolName)) AS highSchoolName,
					NULL AS flagCV,
					NULL AS changeIndex,
					(
						CASE LTRIM(RTRIM(peredu.perEducationalBackgroundId))
							WHEN '02' THEN 'ม.3'
							WHEN '03' THEN 'ม.6'
							WHEN '04' THEN 'ประกาศนียบัตร'
							WHEN '05' THEN 'อนุปริญญาหรือเทียบเท่า'
							WHEN '06' THEN 'อนุปริญญาหรือเทียบเท่า'
							WHEN '07' THEN 'ปริญญาตรี'
							ELSE peredu.thEducationalBackgroundName
						END								
					) AS educationalBackground,
					(
						CASE LTRIM(RTRIM(peredu.graduateBy))
							WHEN '01' THEN '1'
							WHEN '02' THEN '2'
							ELSE NULL
						END
					) AS graduateBy,
					LTRIM(RTRIM(peredu.graduateBySchoolName)) AS graduateBySchoolName,
					LTRIM(RTRIM(peredu.entranceTime)) AS entranceTime,
					(
						CASE LTRIM(RTRIM(peredu.studentIs))
							WHEN '01' THEN '1'
							WHEN '02' THEN '2'
							ELSE NULL
						END								
					) AS studentIs,
					LTRIM(RTRIM(peredu.studentIsUniversity)) AS studentIsUniversity,
					LTRIM(RTRIM(peredu.studentIsFaculty)) AS studentIsFaculty,
					LTRIM(RTRIM(peredu.studentIsProgram)) AS studentIsProgram,
					(
						CASE LTRIM(RTRIM(peredu.perEntranceTypeId))
							WHEN 'CPRID_01'		THEN '1' 
							WHEN 'CA_01'		THEN '1' 
							WHEN 'DEP_UNI_01'	THEN '1' 
							WHEN 'QT_MU_01'		THEN '2'
							WHEN 'DA_01'		THEN '3'
							WHEN 'FAC_01'		THEN '3'
							ELSE NULL
						END
					) AS entranceType,
					LTRIM(RTRIM(peredu.admissionRanking)) AS admissionRanking,
					LTRIM(RTRIM(peredu.scoreONET01)) AS scoreONET01,
					LTRIM(RTRIM(peredu.scoreONET02)) AS scoreONET02,
					LTRIM(RTRIM(peredu.scoreONET03)) AS scoreONET03,
					LTRIM(RTRIM(peredu.scoreONET04)) AS scoreONET04,
					LTRIM(RTRIM(peredu.scoreONET05)) AS scoreONET05,
					LTRIM(RTRIM(peredu.scoreONET06)) AS scoreONET06,
					LTRIM(RTRIM(peredu.scoreONET07)) AS scoreONET07,
					LTRIM(RTRIM(peredu.scoreONET08)) AS scoreONET08,
					LTRIM(RTRIM(peredu.scoreGAT85)) AS scoreGAT85,
					LTRIM(RTRIM(peredu.scorePAT71)) AS scorePAT71,
					LTRIM(RTRIM(peredu.scorePAT72)) AS scorePAT72,
					LTRIM(RTRIM(peredu.scorePAT73)) AS scorePAT73,
					LTRIM(RTRIM(peredu.scorePAT74)) AS scorePAT74,
					LTRIM(RTRIM(peredu.scorePAT75)) AS scorePAT75,
					LTRIM(RTRIM(peredu.scorePAT76)) AS scorePAT76,
					LTRIM(RTRIM(peredu.scorePAT77)) AS scorePAT77,
					LTRIM(RTRIM(peredu.scorePAT78)) AS scorePAT78,
					LTRIM(RTRIM(peredu.scorePAT79)) AS scorePAT79,
					LTRIM(RTRIM(peredu.scorePAT80)) AS scorePAT80,
					LTRIM(RTRIM(peredu.scorePAT81)) AS scorePAT81,
					LTRIM(RTRIM(peredu.scorePAT82)) AS scorePAT82,
					LTRIM(RTRIM(peredu.scoreANET11)) AS scoreANET11,
					LTRIM(RTRIM(peredu.scoreANET12)) AS scoreANET12,
					LTRIM(RTRIM(peredu.scoreANET13)) AS scoreANET13,
					LTRIM(RTRIM(peredu.scoreANET14)) AS scoreANET14,
					LTRIM(RTRIM(peredu.scoreANET15)) AS scoreANET15
			INTO	#tbStudentRecordsTransAcademicBGHighSchool					
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetEducation(@personId) AS peredu ON tmpstd.id = peredu.id 

			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransAcademicBGHighSchool)

			IF (@recordCount > 0)
			BEGIN
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..AcademicBG AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId
											 WHERE	(musstd.Aca_ID = '001') AND (musstd.Aca_Level = '003'))
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)

				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..AcademicBG
						SET		StudentID				= tmpstd.studentId,
								Aca_ID					= tmpstd.idHighSchool,
								Aca_Level				= tmpstd.levelHighSchool,
								InstituteID				= musstd.InstituteID,
								MUA_Province			= tmpstd.provinceIdHighSchool,
								StudentIDAcaBG			= tmpstd.highSchoolStudentId,
								Major					= tmpstd.highSchoolMajor,
								CGPA					= tmpstd.highSchoolGPA,
								From_Year				= tmpstd.highSchoolYearAttended,
								To_Year					= tmpstd.highSchoolYearGraduate,
								Degree					= tmpstd.highSchoolDegree,
								InstituteName			= tmpstd.highSchoolName,
								FlagCV					= musstd.FlagCV,
								ChangeIndex				= musstd.ChangeIndex,
								GraduateDegree			= tmpstd.educationalBackground,
								Entrance_Status			= tmpstd.graduateBy,
								Entrance_StatusDetail	= tmpstd.graduateBySchoolName,
								Entrance_Time			= tmpstd.entranceTime,
								studyFrom				= tmpstd.studentIs,
								Entrance_University		= tmpstd.studentIsUniversity,
								Entrance_UniFaculty		= tmpstd.studentIsFaculty,
								Entrance_UniBranch		= tmpstd.studentIsProgram,
								EntranceBy				= tmpstd.entranceType,
								EntranceBy_Detail		= tmpstd.admissionRanking,
								ONET_01					= tmpstd.scoreONET01,
								ONET_02					= tmpstd.scoreONET02,
								ONET_03					= tmpstd.scoreONET03,	
								ONET_04					= tmpstd.scoreONET04,
								ONET_05					= tmpstd.scoreONET05,
								ONET_06					= tmpstd.scoreONET06,
								ONET_07					= tmpstd.scoreONET07,
								ONET_08					= tmpstd.scoreONET08,
								GAT_85					= tmpstd.scoreGAT85,
								PAT_71					= tmpstd.scorePAT71,
								PAT_72					= tmpstd.scorePAT72,
								PAT_73					= tmpstd.scorePAT73,
								PAT_74					= tmpstd.scorePAT74,
								PAT_75					= tmpstd.scorePAT75,
								PAT_76					= tmpstd.scorePAT76,
								PAT_77					= tmpstd.scorePAT77,
								PAT_78					= tmpstd.scorePAT78,
								PAT_79					= tmpstd.scorePAT79,
								PAT_80					= tmpstd.scorePAT80,
								PAT_81					= tmpstd.scorePAT81,
								PAT_82					= tmpstd.scorePAT82,
								ANET_11					= tmpstd.scoreANET11,
								ANET_12					= tmpstd.scoreANET12,
								ANET_13					= tmpstd.scoreANET13,
								ANET_14					= tmpstd.scoreANET14,
								ANET_15					= tmpstd.scoreANET15
						FROM	MUStudent..AcademicBG AS musstd INNER JOIN
								#tbStudentRecordsTransAcademicBGHighSchool AS tmpstd ON musstd.StudentID = tmpstd.studentId AND musstd.Aca_ID = tmpstd.idHighSchool AND musstd.Aca_Level = tmpstd.levelHighSchool
					END TRY
					BEGIN CATCH
					END CATCH													
				END
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..AcademicBG
						(
							StudentID,
							Aca_ID,
							Aca_Level,
							InstituteID,
							MUA_Province,
							StudentIDAcaBG,
							Major,
							CGPA,
							From_Year,
							To_Year,
							Degree,
							InstituteName,
							FlagCV,
							ChangeIndex,
							GraduateDegree,
							Entrance_Status,
							Entrance_StatusDetail,
							Entrance_Time,
							studyFrom,
							Entrance_University,
							Entrance_UniFaculty,
							Entrance_UniBranch,
							EntranceBy,
							EntranceBy_Detail,
							ONET_01,
							ONET_02,
							ONET_03,	
							ONET_04,
							ONET_05,
							ONET_06,
							ONET_07,
							ONET_08,
							GAT_85,
							PAT_71,
							PAT_72,
							PAT_73,
							PAT_74,
							PAT_75,
							PAT_76,
							PAT_77,
							PAT_78,
							PAT_79,
							PAT_80,
							PAT_81,
							PAT_82,
							ANET_11,
							ANET_12,
							ANET_13,
							ANET_14,
							ANET_15
						)
						SELECT	studentId,
								idHighSchool,
								levelHighSchool,
								NULL,
								provinceIdHighSchool,
								highSchoolStudentId,
								highSchoolMajor,
								highSchoolGPA,
								highSchoolYearAttended,
								highSchoolYearGraduate,
								highSchoolDegree,
								highSchoolName,
								NULL,
								NULL,
								educationalBackground,
								graduateBy,
								graduateBySchoolName,
								entranceTime,
								studentIs,
								studentIsUniversity,
								studentIsFaculty,
								studentIsProgram,
								entranceType,
								admissionRanking,
								scoreONET01,
								scoreONET02,
								scoreONET03,
								scoreONET04,
								scoreONET05,
								scoreONET06,
								scoreONET07,
								scoreONET08,
								scoreGAT85,
								scorePAT71,
								scorePAT72,
								scorePAT73,
								scorePAT74,
								scorePAT75,
								scorePAT76,
								scorePAT77,
								scorePAT78,
								scorePAT79,
								scorePAT80,
								scorePAT81,
								scorePAT82,
								scoreANET11,
								scoreANET12,
								scoreANET13,
								scoreANET14,
								scoreANET15
						FROM	#tbStudentRecordsTransAcademicBGHighSchool
					END TRY
					BEGIN CATCH
					END CATCH											
				END
			END
			
			--MUStudent..StdActivities
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransStdActivities') IS NOT NULL) DROP TABLE #tbStudentRecordsTransStdActivities
			
			SELECT	tmpstd.studentId,
					'14' AS actTypeCode,
					NULL AS actDesp,
					NULL AS actFromDate,
					NULL AS actToDate,
					NULL AS actSource,
					NULL AS activeFlag,
					NULL AS flagCV,
					NULL AS flagPF,
					(
						CASE LTRIM(RTRIM(peract.sportsman))
							WHEN 'Y' THEN '2'
							WHEN 'N' THEN '1'
							ELSE NULL				
						END				
					) AS sportsman,
					LTRIM(RTRIM(peract.sportsmanDetail)) AS sportsmanDetail,
					(
						CASE LTRIM(RTRIM(peract.specialist))
							WHEN 'Y' THEN '2'
							WHEN 'N' THEN '1'
							ELSE NULL
						END						
					) AS specialist,
					(
						CASE LTRIM(RTRIM(peract.specialistSport))
							WHEN 'Y' THEN '1'
							WHEN 'N' THEN NULL
							ELSE NULL
						END				
					) AS specialistSport,
					LTRIM(RTRIM(peract.specialistSportDetail)) AS specialistSportDetail,
					(
						CASE LTRIM(RTRIM(peract.specialistArt))
							WHEN 'Y' THEN '1'
							WHEN 'N' THEN NULL
							ELSE NULL
						END		
					) AS specialistArt,
					LTRIM(RTRIM(peract.specialistArtDetail)) AS specialistArtDetail,
					(
						CASE LTRIM(RTRIM(peract.specialistTechnical))
							WHEN 'Y' THEN '1'
							WHEN 'N' THEN NULL
							ELSE NULL
						END		
					) AS specialistTechnical,
					LTRIM(RTRIM(peract.specialistTechnicalDetail)) AS specialistTechnicalDetail,
					(
						CASE LTRIM(RTRIM(peract.specialistOther))
							WHEN 'Y' THEN '1'
							WHEN 'N' THEN NULL
							ELSE NULL
						END		
					) AS specialistOther,						 
					LTRIM(RTRIM(peract.specialistOtherDetail)) AS specialistOtherDetail,
					(
						CASE LTRIM(RTRIM(peract.activity))
							WHEN 'Y' THEN '2'
							WHEN 'N' THEN '1'
							ELSE NULL				
						END				
					) AS activity,
					LTRIM(RTRIM(peract.activityDetail)) AS activityDetail,
					(
						CASE LTRIM(RTRIM(peract.reward))
							WHEN 'Y' THEN '2'
							WHEN 'N' THEN '1'
							ELSE NULL				
						END				
					) AS reward,
					LTRIM(RTRIM(peract.rewardDetail)) AS rewardDetail,
					(						 
						CASE LTRIM(RTRIM(perfnc.scholarshipFirstBachelor))
							WHEN 'Y' THEN
								(		
									CASE LTRIM(RTRIM(perfnc.scholarshipFirstBachelorFrom))
										WHEN '01' THEN ('กยศ.' + (CASE WHEN (LEN(LTRIM(RTRIM(perfnc.scholarshipFirstBachelorName))) > 0) THEN (' - ' + LTRIM(RTRIM(perfnc.scholarshipFirstBachelorName))) ELSE '' END))
										WHEN '02' THEN ('หน่วยงานรัฐ' + (CASE WHEN (LEN(LTRIM(RTRIM(perfnc.scholarshipFirstBachelorName))) > 0) THEN (' - ' + LTRIM(RTRIM(perfnc.scholarshipFirstBachelorName))) ELSE '' END))
										WHEN '03' THEN ('หน่วยงานเอกชน' + (CASE WHEN (LEN(LTRIM(RTRIM(perfnc.scholarshipFirstBachelorName))) > 0) THEN (' - ' + LTRIM(RTRIM(perfnc.scholarshipFirstBachelorName))) ELSE '' END))
										ELSE NULL				
									END				
								)
							WHEN 'N' THEN 'ไม่เคย'
							ELSE NULL				
						END				
					) AS scholarshipFirstBachelor,
					LTRIM(RTRIM(perfnc.scholarshipFirstBachelorMoney)) AS scholarshipFirstBachelorMoney,
					(						 
						CASE LTRIM(RTRIM(perfnc.scholarshipBachelor))
							WHEN 'Y' THEN
								(		
									CASE LTRIM(RTRIM(perfnc.scholarshipBachelorFrom))
										WHEN '01' THEN ('กยศ.' + (CASE WHEN (LEN(LTRIM(RTRIM(perfnc.scholarshipBachelorName))) > 0) THEN (' - ' + LTRIM(RTRIM(perfnc.scholarshipBachelorName))) ELSE '' END))
										WHEN '02' THEN ('หน่วยงานรัฐ' + (CASE WHEN (LEN(LTRIM(RTRIM(perfnc.scholarshipBachelorName))) > 0) THEN (' - ' + LTRIM(RTRIM(perfnc.scholarshipBachelorName))) ELSE '' END))
										WHEN '03' THEN ('หน่วยงานเอกชน' + (CASE WHEN (LEN(LTRIM(RTRIM(perfnc.scholarshipBachelorName))) > 0) THEN (' - ' + LTRIM(RTRIM(perfnc.scholarshipBachelorName))) ELSE '' END))
										ELSE NULL				
									END				
								)
							WHEN 'N' THEN 'ไม่เคย'
							ELSE NULL				
						END				
					) AS scholarshipBachelor,
					LTRIM(RTRIM(perfnc.scholarshipBachelorMoney)) AS scholarshipBachelorMoney
			INTO	#tbStudentRecordsTransStdActivities					 
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetActivity(@personId) AS peract ON tmpstd.id = peract.id LEFT JOIN
					fnc_perGetFinancial(@personId) AS perfnc ON tmpstd.id = perfnc.id
			
			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransStdActivities)
			
			IF (@recordCount > 0)
			BEGIN			
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..StdActivities AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId)
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)

				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY					
						UPDATE	MUStudent..StdActivities
						SET		StudentID			= tmpstd.studentId,
								Act_typeCode		= tmpstd.actTypeCode,
								Act_Desp			= musstd.Act_Desp,
								Act_FromDate		= musstd.Act_FromDate,
								Act_ToDate			= musstd.Act_ToDate,
								Act_Source			= musstd.Act_Source,
								ActiveFlag			= musstd.ActiveFlag,
								FlagCV				= musstd.FlagCV,
								FlagPF				= musstd.FlagPF,
								Sporter				= tmpstd.sportsman,
								Sporter_Detail		= tmpstd.sportsmanDetail,
								Special_Status		= tmpstd.specialist,
								Special1			= tmpstd.specialistSport,
								Special1_Detail		= tmpstd.specialistSportDetail,
								Special2			= tmpstd.specialistArt,
								Special2_Detail		= tmpstd.specialistArtDetail,
								Special3			= tmpstd.specialistTechnical,
								Special3_Detail		= tmpstd.specialistTechnicalDetail,
								Special4			= tmpstd.specialistOther,
								Special4_Detail		= tmpstd.specialistOtherDetail,
								Activity			= tmpstd.activity,
								Activity_Detail		= tmpstd.activityDetail,
								Reward				= tmpstd.reward,
								Reward_Detail		= tmpstd.rewardDetail,
								Scholarship			= tmpstd.scholarshipFirstBachelor,
								ScholarshipMoney	= tmpstd.scholarshipFirstBachelorMoney,
								Bscholarship		= tmpstd.scholarshipBachelor,
								BscholarshipMoney	= tmpstd.scholarshipBachelorMoney
						FROM	MUStudent..StdActivities AS musstd INNER JOIN
								#tbStudentRecordsTransStdActivities	AS tmpstd ON musstd.StudentID = tmpstd.studentId
					END TRY
					BEGIN CATCH
					END CATCH													
				END
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..StdActivities
						(
							StudentID,
							Act_typeCode,
							Act_Desp,
							Act_FromDate,
							Act_ToDate,
							Act_Source,
							ActiveFlag,
							FlagCV,
							FlagPF,
							Sporter,
							Sporter_Detail,
							Special_Status,
							Special1,
							Special1_Detail,
							Special2,
							Special2_Detail,
							Special3,
							Special3_Detail,
							Special4,
							Special4_Detail,
							Activity,
							Activity_Detail,
							Reward,
							Reward_Detail,
							Scholarship,
							ScholarshipMoney,
							Bscholarship,
							BscholarshipMoney
						)
						SELECT	studentId,
								actTypeCode,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								NULL,
								sportsman,
								sportsmanDetail,
								specialist,
								specialistSport,
								specialistSportDetail,
								specialistArt,
								specialistArtDetail,
								specialistTechnical,
								specialistTechnicalDetail,
								specialistOther,						 
								specialistOtherDetail,
								activity,
								activityDetail,
								reward,
								rewardDetail,
								scholarshipFirstBachelor,
								scholarshipFirstBachelorMoney,
								scholarshipBachelor,
								scholarshipBachelorMoney
						FROM	#tbStudentRecordsTransStdActivities
					END TRY
					BEGIN CATCH
					END CATCH											
				END
			END
			
			--MUStudent..SHealthy
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransSHealthy') IS NOT NULL) DROP TABLE #tbStudentRecordsTransSHealthy
			
			SELECT	tmpstd.studentId,
					(
						CASE perhat.intolerance
							WHEN 'Y' THEN '2'
							WHEN 'N' THEN '1'
							ELSE NULL
						END				
					) AS intolerance,
					LTRIM(RTRIM(perhat.intoleranceDetail)) AS intoleranceDetail,			
					LTRIM(RTRIM(perhat.diseasesDetail)) AS diseasesDetail,
					NULL AS ailHistoryFamily,
					LTRIM(RTRIM(perhat.travelAbroadDetail)) AS travelAbroadDetail,
					NULL AS countryEverAwayGoDate,
					NULL AS impairments,
					NULL AS impairmentsEquipment
			INTO	#tbStudentRecordsTransSHealthy					
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetHealthy(@personId) AS perhat ON tmpstd.id = perhat.id
					
			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransSHealthy)
			
			IF (@recordCount > 0)
			BEGIN					
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..SHealthy AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId)
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)
				
				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..SHealthy
						SET		StudentID				= tmpstd.studentId,
								Intolerance				= tmpstd.intolerance,	
								IntoleranceDetail		= tmpstd.intoleranceDetail,
								Diseases				= tmpstd.diseasesDetail,
								AilHistoryFamily		= musstd.AilHistoryFamily,
								CountryEverAwayGo		= tmpstd.travelAbroadDetail,
								CountryEverAwayGoDate	= musstd.CountryEverAwayGoDate,
								Impairments				= musstd.Impairments,
								ImpairmentsEquipment	= musstd.ImpairmentsEquipment
						FROM	MUStudent..SHealthy AS musstd INNER JOIN
								#tbStudentRecordsTransSHealthy AS tmpstd ON musstd.StudentID = tmpstd.studentId
					END TRY
					BEGIN CATCH
					END CATCH													
				END
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..SHealthy
						(
							StudentID,
							Intolerance,
							IntoleranceDetail,
							Diseases,
							AilHistoryFamily,
							CountryEverAwayGo,
							CountryEverAwayGoDate,
							Impairments,
							ImpairmentsEquipment
						)
						SELECT	studentId,
								intolerance,
								intoleranceDetail,
								diseasesDetail,
								NULL,
								travelAbroadDetail,
								NULL,
								NULL,
								NULL
						FROM	#tbStudentRecordsTransSHealthy
					END TRY
					BEGIN CATCH
					END CATCH											
				END
			END							

			--MUStudent..SParent Type Father
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransSParentFather') IS NOT NULL) DROP TABLE #tbStudentRecordsTransSParentFather
			
			SELECT	tmpstd.studentId,
					'F' AS type,
					LTRIM(RTRIM(perperparent.perTitlePrefixIdOldFather)) AS perTitlePrefixIdFather,
					LTRIM(RTRIM(perperparent.firstNameFather)) AS firstNameFather,	
					LTRIM(RTRIM(perperparent.middleNameFather)) AS middleNameFather,	
					LTRIM(RTRIM(perperparent.lastNameFather)) AS lastNameFather,
					(
						CASE LTRIM(RTRIM(perperparent.perEducationalBackgroundIdFather))
							WHEN '01' THEN '1'
							WHEN '02' THEN '2'
							WHEN '03' THEN '2'
							WHEN '04' THEN '3'
							WHEN '05' THEN '3'
							WHEN '06' THEN '3'
							WHEN '07' THEN '4'
							WHEN '08' THEN '5'
							WHEN '09' THEN '6'
							ELSE NULL
						END								
					) AS educationalBackgroundFather,
					NULL AS educationalBackgroundNameFather,
					(
						CASE LTRIM(RTRIM(perwokparent.occupationFather))
							WHEN '01' THEN '1'
							WHEN '02' THEN '6'
							WHEN '03' THEN '3'
							WHEN '04' THEN '2'
							WHEN '05' THEN '4'
							WHEN '06' THEN '5'
							WHEN '07' THEN '8'
							WHEN '08' THEN '7'
							ELSE NULL
						END				
					) AS occupationFather,
					NULL AS occupationNameFather,
					LTRIM(RTRIM(perperparent.isoOriginName3LetterFather)) AS isoOriginName3LetterFather,
					LTRIM(RTRIM(perperparent.isoNationalityName3LetterFather)) AS isoNationalityName3LetterFather,
					LTRIM(RTRIM(perwokparent.salaryFather)) AS salaryFather,
					'01' AS relationshipFather,
					(
						CASE LTRIM(RTRIM(perperparent.perMaritalStatusIdFather))
							WHEN '02' THEN '1'
							WHEN '03' THEN '3'
							WHEN '04' THEN ''
							WHEN '05' THEN '2'
							WHEN '06' THEN '4'
							ELSE NULL
						END				
					) AS maritalStatusFather,
					(
						CASE LTRIM(RTRIM(perperparent.aliveFather))
							WHEN 'Y' THEN '1'
							WHEN 'N' THEN '0'
							ELSE NULL
						END
					) AS aliveFather,
					LTRIM(RTRIM(perperparent.idCardFather)) AS idCardFather,
					LTRIM(RTRIM(perperparent.enBirthDateFather)) AS enBirthDateFather,
					LTRIM(RTRIM(perperparent.ageFather)) AS ageFather,
					LTRIM(RTRIM(peraddparent.noCurrentFather)) AS noCurrentFather,
					LTRIM(RTRIM(peraddparent.mooCurrentFather)) AS mooCurrentFather,
					LTRIM(RTRIM(peraddparent.villageCurrentFather)) AS villageCurrentFather,	
					LTRIM(RTRIM(peraddparent.soiCurrentFather)) AS soiCurrentFather,
					LTRIM(RTRIM(peraddparent.roadCurrentFather)) AS roadCurrentFather,						 					 
					LTRIM(RTRIM(peraddparent.thSubdistrictNameCurrentFather)) AS thSubdistrictNameCurrentFather,
					LTRIM(RTRIM(peraddparent.thDistrictNameCurrentFather)) AS thDistrictNameCurrentFather,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(peraddparent.plcCountryIdCurrentFather))) > 0) THEN						
								(SELECT	musprv.ProvinceID
								 FROM	MUStudent..BProvince AS musprv INNER JOIN
										Infinity..plcProvince AS insprv ON musprv.ProvinceTName = insprv.provinceNameTH
								 WHERE  (insprv.id = peraddparent.plcProvinceIdCurrentFather))
							ELSE NULL									 
						END																
					) AS provinceIdCurrentFather,
					LTRIM(RTRIM(peraddparent.thCountryNameCurrentFather)) AS thCountryNameCurrentFather,
					LTRIM(RTRIM(peraddparent.zipCodeCurrentFather)) AS zipCodeCurrentFather,
					LTRIM(RTRIM(peraddparent.phoneNumberCurrentFather)) AS phoneNumberCurrentFather,
					LTRIM(RTRIM(peraddparent.mobileNumberCurrentFather)) AS mobileNumberCurrentFather,
					LTRIM(RTRIM(peraddparent.faxNumberCurrentFather)) AS faxNumberCurrentFather,
					NULL AS flagAddrFather
			INTO	#tbStudentRecordsTransSParentFather					 
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetPersonParent(@personId) AS perperparent ON tmpstd.id = perperparent.id LEFT JOIN
					fnc_perGetWorkParent(@personId) AS perwokparent ON perperparent.id = perwokparent.id LEFT JOIN
					fnc_perGetAddressParent(@personId) AS peraddparent ON perperparent.id = peraddparent.id

			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransSParentFather)
			
			IF (@recordCount > 0)
			BEGIN
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..SParent AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId
											 WHERE	musstd.Type = 'F')
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)					 
				
				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..SParent
						SET		StudentID		= tmpstd.studentId,
								Type			= tmpstd.type,
								TitleCode		= tmpstd.perTitlePrefixIdFather,
								FirstName		= tmpstd.firstNameFather,
								MiddleName		= tmpstd.middleNameFather,
								LastName		= tmpstd.lastNameFather,
								EducateCode		= tmpstd.educationalBackgroundFather,
								EducateName		= musstd.EducateName,
								OccupationCode	= tmpstd.occupationFather,
								Occupation		= musstd.Occupation,
								racecode		= tmpstd.isoOriginName3LetterFather,
								nationalitycode	= tmpstd.isoNationalityName3LetterFather,
								MonthlyIncome	= tmpstd.salaryFather,
								Relationship	= tmpstd.relationshipFather,
								Marriage		= tmpstd.maritalStatusFather,
								Alive			= tmpstd.aliveFather,
								IdCard			= tmpstd.idCardFather,
								BirthDate		= tmpstd.enBirthDateFather,
								Age				= tmpstd.ageFather,
								AddrNo			= tmpstd.noCurrentFather,
								AddrMoo			= tmpstd.mooCurrentFather,
								AddrDetail		= tmpstd.villageCurrentFather,
								AddrSoi			= tmpstd.soiCurrentFather,
								AddrStreet		= tmpstd.roadCurrentFather,
								AddrSubDistrict	= tmpstd.thSubdistrictNameCurrentFather,
								AddrDistrict	= tmpstd.thDistrictNameCurrentFather,
								MUA_Province	= tmpstd.provinceIdCurrentFather,
								Country			= tmpstd.thCountryNameCurrentFather,
								ZipCode			= tmpstd.zipCodeCurrentFather,
								AddrTel			= tmpstd.phoneNumberCurrentFather,
								AddrPhone		= tmpstd.mobileNumberCurrentFather,
								AddrFax			= tmpstd.faxNumberCurrentFather,
								FlagAddr		= musstd.FlagAddr
						FROM	MUStudent..SParent AS musstd INNER JOIN
								#tbStudentRecordsTransSParentFather AS tmpstd ON musstd.StudentID = tmpstd.studentId AND musstd.Type = tmpstd.type
					END TRY
					BEGIN CATCH
					END CATCH													
				END
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..SParent
						(
							StudentID,
							Type,
							TitleCode,
							FirstName,
							MiddleName,
							LastName,
							EducateCode,
							EducateName,
							OccupationCode,
							Occupation,
							racecode,
							nationalitycode,
							MonthlyIncome,
							Relationship,
							Marriage,
							Alive,
							IdCard,
							BirthDate,
							Age,
							AddrNo,
							AddrMoo,
							AddrDetail,
							AddrSoi,
							AddrStreet,
							AddrSubDistrict,
							AddrDistrict,
							MUA_Province,
							Country,
							ZipCode,
							AddrTel,
							AddrPhone,
							AddrFax,
							FlagAddr
						)
						SELECT	studentId,
								type,
								perTitlePrefixIdFather,
								firstNameFather,	
								middleNameFather,	
								lastNameFather,
								educationalBackgroundFather,
								NULL,
								occupationFather,
								NULL,
								isoOriginName3LetterFather,
								isoNationalityName3LetterFather,
								salaryFather,
								relationshipFather,
								maritalStatusFather,
								aliveFather,
								idCardFather,
								enBirthDateFather,
								ageFather,
								noCurrentFather,
								mooCurrentFather,
								villageCurrentFather,
								soiCurrentFather,
								roadCurrentFather,
								thSubdistrictNameCurrentFather,
								thDistrictNameCurrentFather,
								provinceIdCurrentFather,
								thCountryNameCurrentFather,
								zipCodeCurrentFather,
								phoneNumberCurrentFather,
								mobileNumberCurrentFather,
								faxNumberCurrentFather,
								NULL
						FROM	#tbStudentRecordsTransSParentFather
					END TRY
					BEGIN CATCH
					END CATCH											
				END									
			END				

			--MUStudent..SParent Type Mother
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransSParentMother') IS NOT NULL) DROP TABLE #tbStudentRecordsTransSParentMother
			
			SELECT	tmpstd.studentId,
					'M' AS type,
					LTRIM(RTRIM(perperparent.perTitlePrefixIdOldMother)) AS perTitlePrefixIdMother,
					LTRIM(RTRIM(perperparent.firstNameMother)) AS firstNameMother,	
					LTRIM(RTRIM(perperparent.middleNameMother)) AS middleNameMother,	
					LTRIM(RTRIM(perperparent.lastNameMother)) AS lastNameMother,
					(
						CASE LTRIM(RTRIM(perperparent.perEducationalBackgroundIdMother))
							WHEN '01' THEN '1'
							WHEN '02' THEN '2'
							WHEN '03' THEN '2'
							WHEN '04' THEN '3'
							WHEN '05' THEN '3'
							WHEN '06' THEN '3'
							WHEN '07' THEN '4'
							WHEN '08' THEN '5'
							WHEN '09' THEN '6'
							ELSE NULL
						END								
					) AS educationalBackgroundMother,
					NULL AS educationalBackgroundNameMother,
					(
						CASE LTRIM(RTRIM(perwokparent.occupationMother))
							WHEN '01' THEN '1'
							WHEN '02' THEN '6'
							WHEN '03' THEN '3'
							WHEN '04' THEN '2'
							WHEN '05' THEN '4'
							WHEN '06' THEN '5'
							WHEN '07' THEN '8'
							WHEN '08' THEN '7'
							ELSE NULL
						END				
					) AS occupationMother,
					NULL AS occupationNameMother,
					LTRIM(RTRIM(perperparent.isoOriginName3LetterMother)) AS isoOriginName3LetterMother,
					LTRIM(RTRIM(perperparent.isoNationalityName3LetterMother)) AS isoNationalityName3LetterMother,
					LTRIM(RTRIM(perwokparent.salaryMother)) AS salaryMother,
					'02' AS relationshipMother,
					(
						CASE LTRIM(RTRIM(perperparent.perMaritalStatusIdMother))
							WHEN '02' THEN '1'
							WHEN '03' THEN '3'
							WHEN '04' THEN ''
							WHEN '05' THEN '2'
							WHEN '06' THEN '4'
							ELSE NULL
						END				
					) AS maritalStatusMother,
					(
						CASE LTRIM(RTRIM(perperparent.aliveMother))
							WHEN 'Y' THEN '1'
							WHEN 'N' THEN '0'
							ELSE NULL
						END
					) AS aliveMother,
					LTRIM(RTRIM(perperparent.idCardMother)) AS idCardMother,
					LTRIM(RTRIM(perperparent.enBirthDateMother)) AS enBirthDateMother,
					LTRIM(RTRIM(perperparent.ageMother)) AS ageMother,
					LTRIM(RTRIM(peraddparent.noCurrentMother)) AS noCurrentMother,
					LTRIM(RTRIM(peraddparent.mooCurrentMother)) AS mooCurrentMother,
					LTRIM(RTRIM(peraddparent.villageCurrentMother)) AS villageCurrentMother,
					LTRIM(RTRIM(peraddparent.soiCurrentMother)) AS soiCurrentMother,
					LTRIM(RTRIM(peraddparent.roadCurrentMother)) AS roadCurrentMother,						 					 
					LTRIM(RTRIM(peraddparent.thSubdistrictNameCurrentMother)) AS thSubdistrictNameCurrentMother,
					LTRIM(RTRIM(peraddparent.thDistrictNameCurrentMother)) AS thDistrictNameCurrentMother,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(peraddparent.plcCountryIdCurrentMother))) > 0) THEN						
								(SELECT	musprv.ProvinceID
								 FROM	MUStudent..BProvince AS musprv INNER JOIN
										Infinity..plcProvince AS insprv ON musprv.ProvinceTName = insprv.provinceNameTH
								 WHERE  (insprv.id = peraddparent.plcProvinceIdCurrentMother))
							ELSE NULL									 
						END																
					) AS provinceIdCurrentMother,
					LTRIM(RTRIM(peraddparent.thCountryNameCurrentMother)) AS thCountryNameCurrentMother,
					LTRIM(RTRIM(peraddparent.zipCodeCurrentMother)) AS zipCodeCurrentMother,
					LTRIM(RTRIM(peraddparent.phoneNumberCurrentMother)) AS phoneNumberCurrentMother,
					LTRIM(RTRIM(peraddparent.mobileNumberCurrentMother)) AS mobileNumberCurrentMother,
					LTRIM(RTRIM(peraddparent.faxNumberCurrentMother)) AS faxNumberCurrentMother,
					NULL AS flagAddrMother
			INTO	#tbStudentRecordsTransSParentMother					 
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetPersonParent(@personId) AS perperparent ON tmpstd.id = perperparent.id LEFT JOIN
					fnc_perGetWorkParent(@personId) AS perwokparent ON perperparent.id = perwokparent.id LEFT JOIN
					fnc_perGetAddressParent(@personId) AS peraddparent ON perperparent.id = peraddparent.id

			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransSParentMother)
			
			IF (@recordCount > 0)
			BEGIN			
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..SParent AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId
											 WHERE	musstd.Type = 'M')
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)
				
				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY					
						UPDATE	MUStudent..SParent
						SET		StudentID		= tmpstd.studentId,
								Type			= tmpstd.type,
								TitleCode		= tmpstd.perTitlePrefixIdMother,
								FirstName		= tmpstd.firstNameMother,
								MiddleName		= tmpstd.middleNameMother,
								LastName		= tmpstd.lastNameMother,
								EducateCode		= tmpstd.educationalBackgroundMother,
								EducateName		= musstd.EducateName,
								OccupationCode	= tmpstd.occupationMother,
								Occupation		= musstd.Occupation,
								racecode		= tmpstd.isoOriginName3LetterMother,
								nationalitycode	= tmpstd.isoNationalityName3LetterMother,
								MonthlyIncome	= tmpstd.salaryMother,
								Relationship	= tmpstd.relationshipMother,
								Marriage		= tmpstd.maritalStatusMother,
								Alive			= tmpstd.aliveMother,
								IdCard			= tmpstd.idCardMother,
								BirthDate		= tmpstd.enBirthDateMother,
								Age				= tmpstd.ageMother,
								AddrNo			= tmpstd.noCurrentMother,
								AddrMoo			= tmpstd.mooCurrentMother,
								AddrDetail		= tmpstd.villageCurrentMother,
								AddrSoi			= tmpstd.soiCurrentMother,
								AddrStreet		= tmpstd.roadCurrentMother,
								AddrSubDistrict	= tmpstd.thSubdistrictNameCurrentMother,
								AddrDistrict	= tmpstd.thDistrictNameCurrentMother,
								MUA_Province	= tmpstd.provinceIdCurrentMother,
								Country			= tmpstd.thCountryNameCurrentMother,
								ZipCode			= tmpstd.zipCodeCurrentMother,
								AddrTel			= tmpstd.phoneNumberCurrentMother,
								AddrPhone		= tmpstd.mobileNumberCurrentMother,
								AddrFax			= tmpstd.faxNumberCurrentMother,
								FlagAddr		= musstd.FlagAddr
						FROM	MUStudent..SParent AS musstd INNER JOIN
								#tbStudentRecordsTransSParentMother AS tmpstd ON musstd.StudentID = tmpstd.studentId AND musstd.Type = tmpstd.type
					END TRY
					BEGIN CATCH
					END CATCH													
				END
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..SParent
						(
							StudentID,
							Type,
							TitleCode,
							FirstName,
							MiddleName,
							LastName,
							EducateCode,
							EducateName,
							OccupationCode,
							Occupation,
							racecode,
							nationalitycode,
							MonthlyIncome,
							Relationship,
							Marriage,
							Alive,
							IdCard,
							BirthDate,
							Age,
							AddrNo,
							AddrMoo,
							AddrDetail,
							AddrSoi,
							AddrStreet,
							AddrSubDistrict,
							AddrDistrict,
							MUA_Province,
							Country,
							ZipCode,
							AddrTel,
							AddrPhone,
							AddrFax,
							FlagAddr
						)
						SELECT	studentId,
								type,
								perTitlePrefixIdMother,
								firstNameMother,	
								middleNameMother,	
								lastNameMother,
								educationalBackgroundMother,
								NULL,
								occupationMother,
								NULL,
								isoOriginName3LetterMother,
								isoNationalityName3LetterMother,
								salaryMother,
								relationshipMother,
								maritalStatusMother,
								aliveMother,
								idCardMother,
								enBirthDateMother,
								ageMother,
								noCurrentMother,
								mooCurrentMother,
								villageCurrentMother,	
								soiCurrentMother,
								roadCurrentMother,
								thSubdistrictNameCurrentMother,
								thDistrictNameCurrentMother,
								provinceIdCurrentMother,
								thCountryNameCurrentMother,
								zipCodeCurrentMother,
								phoneNumberCurrentMother,
								mobileNumberCurrentMother,
								faxNumberCurrentMother,
								NULL
						FROM	#tbStudentRecordsTransSParentMother
					END TRY
					BEGIN CATCH
					END CATCH											
				END				
			END				

			--MUStudent..SParent Type Guardian
			IF (OBJECT_ID('tempdb..#tbStudentRecordsTransSParentGuardian') IS NOT NULL) DROP TABLE #tbStudentRecordsTransSParentGuardian
			
			SELECT	tmpstd.studentId,
					'G' AS type,
					LTRIM(RTRIM(perperparent.perTitlePrefixIdOldParent)) AS perTitlePrefixIdParent,
					LTRIM(RTRIM(perperparent.firstNameParent)) AS firstNameParent,	
					LTRIM(RTRIM(perperparent.middleNameParent)) AS middleNameParent,	
					LTRIM(RTRIM(perperparent.lastNameParent)) AS lastNameParent,
					(
						CASE LTRIM(RTRIM(perperparent.perEducationalBackgroundIdParent))
							WHEN '01' THEN '1'
							WHEN '02' THEN '2'
							WHEN '03' THEN '2'
							WHEN '04' THEN '3'
							WHEN '05' THEN '3'
							WHEN '06' THEN '3'
							WHEN '07' THEN '4'
							WHEN '08' THEN '5'
							WHEN '09' THEN '6'
							ELSE NULL
						END								
					) AS educationalBackgroundParent,
					NULL AS educationalBackgroundNameParent,
					(
						CASE LTRIM(RTRIM(perwokparent.occupationParent))
							WHEN '01' THEN '1'
							WHEN '02' THEN '6'
							WHEN '03' THEN '3'
							WHEN '04' THEN '2'
							WHEN '05' THEN '4'
							WHEN '06' THEN '5'
							WHEN '07' THEN '8'
							WHEN '08' THEN '7'
							ELSE NULL
						END				
					) AS occupationParent,
					NULL AS occupationNameParent,
					LTRIM(RTRIM(perperparent.isoOriginName3LetterParent)) AS isoOriginName3LetterParent,
					LTRIM(RTRIM(perperparent.isoNationalityName3LetterParent)) AS isoNationalityName3LetterParent,
					LTRIM(RTRIM(perwokparent.salaryParent)) AS salaryParent,
					(
						CASE LTRIM(RTRIM(perperparent.perRelationshipId))
							WHEN '03' THEN '01'
							WHEN '04' THEN '02'
							WHEN '07' THEN '03'
							WHEN '09' THEN '03'
							WHEN '17' THEN '04'
							WHEN '20' THEN '05'
							WHEN '18' THEN '06'
							WHEN '21' THEN '06'
							WHEN '19' THEN '07'
							WHEN '22' THEN '07'
							WHEN '11' THEN '08'
							WHEN '13' THEN '09'
							WHEN '12' THEN '10'
							WHEN '14' THEN '11'
							ELSE NULL
						END				
					) AS relationshipParent,
					(
						CASE LTRIM(RTRIM(perperparent.perMaritalStatusIdParent))
							WHEN '02' THEN '1'
							WHEN '03' THEN '3'
							WHEN '04' THEN ''
							WHEN '05' THEN '2'
							WHEN '06' THEN '4'
							ELSE NULL
						END				
					) AS maritalStatusParent,
					(
						CASE LTRIM(RTRIM(perperparent.aliveParent))
							WHEN 'Y' THEN '1'
							WHEN 'N' THEN '0'
							ELSE NULL
						END
					) AS aliveParent,
					LTRIM(RTRIM(perperparent.idCardParent)) AS idCardParent,
					LTRIM(RTRIM(perperparent.enBirthDateParent)) AS enBirthDateParent,
					LTRIM(RTRIM(perperparent.ageParent)) AS ageParent,
					LTRIM(RTRIM(peraddparent.noCurrentParent)) AS noCurrentParent,
					LTRIM(RTRIM(peraddparent.mooCurrentParent)) AS mooCurrentParent,
					LTRIM(RTRIM(peraddparent.villageCurrentParent)) AS villageCurrentParent,
					LTRIM(RTRIM(peraddparent.soiCurrentParent)) AS soiCurrentParent,
					LTRIM(RTRIM(peraddparent.roadCurrentParent)) AS roadCurrentParent,						 					 
					LTRIM(RTRIM(peraddparent.thSubdistrictNameCurrentParent)) AS thSubdistrictNameCurrentParent,
					LTRIM(RTRIM(peraddparent.thDistrictNameCurrentParent)) AS thDistrictNameCurrentParent,
					(
						CASE
							WHEN (LEN(LTRIM(RTRIM(peraddparent.plcCountryIdCurrentParent))) > 0) THEN						
								(SELECT	musprv.ProvinceID
								 FROM	MUStudent..BProvince AS musprv INNER JOIN
										Infinity..plcProvince AS insprv ON musprv.ProvinceTName = insprv.provinceNameTH
								 WHERE  (insprv.id = peraddparent.plcProvinceIdCurrentParent))
							ELSE NULL									 
						END																
					) AS provinceIdCurrentParent,
					LTRIM(RTRIM(peraddparent.thCountryNameCurrentParent)) AS thCountryNameCurrentParent,
					LTRIM(RTRIM(peraddparent.zipCodeCurrentParent)) AS zipCodeCurrentParent,
					LTRIM(RTRIM(peraddparent.phoneNumberCurrentParent)) AS phoneNumberCurrentParent,
					LTRIM(RTRIM(peraddparent.mobileNumberCurrentParent)) AS mobileNumberCurrentParent,
					LTRIM(RTRIM(peraddparent.faxNumberCurrentParent)) AS faxNumberCurrentParent,
					NULL AS flagAddrParent
			INTO	#tbStudentRecordsTransSParentGuardian					 
			FROM	#tbStudentRecords AS tmpstd INNER JOIN
					fnc_perGetPersonParent(@personId) AS perperparent ON tmpstd.id = perperparent.id LEFT JOIN
					fnc_perGetWorkParent(@personId) AS perwokparent ON perperparent.id = perwokparent.id LEFT JOIN
					fnc_perGetAddressParent(@personId) AS peraddparent ON perperparent.id = peraddparent.id
			
			SET @recordCount = (SELECT COUNT(studentId) FROM #tbStudentRecordsTransSParentGuardian)
			
			IF (@recordCount > 0)
			BEGIN					
				SET @recordCountMUStudent = 0
				SET @recordCountMUStudent = (SELECT	COUNT(musstd.StudentID)
											 FROM	MUStudent..SParent AS musstd INNER JOIN
													#tbStudentRecords AS tmpstd ON musstd.StudentID = tmpstd.studentId
											 WHERE	musstd.Type = 'G')
				
				SET @action = ''
				SET @action = (CASE WHEN (@recordCountMUStudent > 0) THEN 'UPDATE' ELSE 'INSERT' END)					

				IF (@action = 'UPDATE')
				BEGIN
					BEGIN TRY
						UPDATE	MUStudent..SParent
						SET		StudentID		= tmpstd.studentId,
								Type			= tmpstd.type,
								TitleCode		= tmpstd.perTitlePrefixIdParent,
								FirstName		= tmpstd.firstNameParent,
								MiddleName		= tmpstd.middleNameParent,
								LastName		= tmpstd.lastNameParent,
								EducateCode		= tmpstd.educationalBackgroundParent,
								EducateName		= musstd.EducateName,
								OccupationCode	= tmpstd.occupationParent,
								Occupation		= musstd.Occupation,
								racecode		= tmpstd.isoOriginName3LetterParent,
								nationalitycode	= tmpstd.isoNationalityName3LetterParent,
								MonthlyIncome	= tmpstd.salaryParent,
								Relationship	= tmpstd.relationshipParent,
								Marriage		= tmpstd.maritalStatusParent,
								Alive			= tmpstd.aliveParent,
								IdCard			= tmpstd.idCardParent,
								BirthDate		= tmpstd.enBirthDateParent,
								Age				= tmpstd.ageParent,
								AddrNo			= tmpstd.noCurrentParent,
								AddrMoo			= tmpstd.mooCurrentParent,
								AddrDetail		= tmpstd.villageCurrentParent,
								AddrSoi			= tmpstd.soiCurrentParent,
								AddrStreet		= tmpstd.roadCurrentParent,
								AddrSubDistrict	= tmpstd.thSubdistrictNameCurrentParent,
								AddrDistrict	= tmpstd.thDistrictNameCurrentParent,
								MUA_Province	= tmpstd.provinceIdCurrentParent,
								Country			= tmpstd.thCountryNameCurrentParent,
								ZipCode			= tmpstd.zipCodeCurrentParent,
								AddrTel			= tmpstd.phoneNumberCurrentParent,
								AddrPhone		= tmpstd.mobileNumberCurrentParent,
								AddrFax			= tmpstd.faxNumberCurrentParent,
								FlagAddr		= musstd.FlagAddr
						FROM	MUStudent..SParent AS musstd INNER JOIN
								#tbStudentRecordsTransSParentGuardian AS tmpstd ON musstd.StudentID = tmpstd.studentId AND musstd.Type = tmpstd.type
					END TRY
					BEGIN CATCH
					END CATCH													
				END
				
				IF (@action = 'INSERT')
				BEGIN
					BEGIN TRY
						INSERT INTO MUStudent..SParent
						(
							StudentID,
							Type,
							TitleCode,
							FirstName,
							MiddleName,
							LastName,
							EducateCode,
							EducateName,
							OccupationCode,
							Occupation,
							racecode,
							nationalitycode,
							MonthlyIncome,
							Relationship,
							Marriage,
							Alive,
							IdCard,
							BirthDate,
							Age,
							AddrNo,
							AddrMoo,
							AddrDetail,
							AddrSoi,
							AddrStreet,
							AddrSubDistrict,
							AddrDistrict,
							MUA_Province,
							Country,
							ZipCode,
							AddrTel,
							AddrPhone,
							AddrFax,
							FlagAddr
						)
						SELECT	studentId,
								type,
								perTitlePrefixIdParent,
								firstNameParent,	
								middleNameParent,	
								lastNameParent,
								educationalBackgroundParent,
								NULL,
								occupationParent,
								NULL,
								isoOriginName3LetterParent,
								isoNationalityName3LetterParent,
								salaryParent,
								relationshipParent,
								maritalStatusParent,
								aliveParent,
								idCardParent,
								enBirthDateParent,
								ageParent,
								noCurrentParent,
								mooCurrentParent,
								villageCurrentParent,
								soiCurrentParent,
								roadCurrentParent,						 					 
								thSubdistrictNameCurrentParent,
								thDistrictNameCurrentParent,
								provinceIdCurrentParent,
								thCountryNameCurrentParent,
								zipCodeCurrentParent,
								phoneNumberCurrentParent,
								mobileNumberCurrentParent,
								faxNumberCurrentParent,
								NULL
						FROM	#tbStudentRecordsTransSParentGuardian
					END TRY
					BEGIN CATCH
					END CATCH											
				END		
			END				

			/*
			SELECT 	 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musstd.IdCard)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musstd.IdCard))) > 0) THEN LTRIM(RTRIM(musstd.IdCard)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musstd.TitleCode)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musstd.TitleCode))) > 0) THEN LTRIM(RTRIM(musstd.TitleCode)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musstd.ThaiFName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musstd.ThaiFName))) > 0) THEN LTRIM(RTRIM(musstd.ThaiFName)) ELSE NULL END),
					 NULL,
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musstd.ThaiLName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musstd.ThaiLName))) > 0) THEN LTRIM(RTRIM(musstd.ThaiLName)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musstd.FirstName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musstd.FirstName))) > 0) THEN LTRIM(RTRIM(musstd.FirstName)) ELSE NULL END),
					 NULL,
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musstd.LastName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musstd.LastName))) > 0) THEN LTRIM(RTRIM(musstd.LastName)) ELSE NULL END),
					 (
						CASE LTRIM(RTRIM(musstd.Gender))
							WHEN 'M' THEN '01'
							WHEN 'F' THEN '02'
							ELSE NULL
						END
					 ),
					 'Y',
					 (CASE WHEN (LEN(LTRIM(RTRIM(musstd.BirthDate))) > 0) THEN LTRIM(RTRIM(musstd.BirthDate)) ELSE NULL END),
					 (CASE LTRIM(RTRIM(musstd.NationalityCode)) WHEN 'THA' THEN '217' ELSE NULL END),
					 (Case LTRIM(RTRIM(musstd.NationalityCode)) WHEN 'THA' Then '177' ELSE NULL END),
					 (CASE LTRIM(RTRIM(musstd.RaceCode)) WHEN 'THA' THEN '177' ELSE NULL END),
					 (
						CASE LTRIM(RTRIM(muspro.ReligionCode))
							WHEN 'B' THEN '06'
							WHEN 'C' THEN '01'
							WHEN 'H' THEN '03'
							WHEN 'I' THEN '02'
							WHEN 'M' THEN '05'
							WHEN 'O' THEN '04'
							WHEN 'S' THEN '07'
							ELSE NULL
						END							
					 ),
					 (
						CASE LTRIM(RTRIM(muspro.BloodType))
							WHEN 'A' THEN '01'
							WHEN 'B' THEN '02'
							WHEN 'O' THEN '04'
							WHEN 'AB' THEN '03'
							ELSE NULL
						END								
					 ),
					 (
						CASE LTRIM(RTRIM(muspro.MarriageStatus))
							WHEN '0' THEN '01'
							WHEN '1' THEN '02'
							WHEN '2' THEN '04'
							WHEN '3' THEN '05'
							WHEN '4' THEN '03'
							ELSE NULL
						END								
					 ),
					 NULL,
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musstd.Email)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musstd.Email))) > 0) THEN LTRIM(RTRIM(musstd.Email)) ELSE NULL END),
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(muspro.Brotherhood)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspro.Brotherhood))) > 0) THEN LTRIM(RTRIM(muspro.Brotherhood)) ELSE NULL END)), 0), '.00', '')),
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(muspro.StudenthoodNum)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspro.StudenthoodNum))) > 0) THEN LTRIM(RTRIM(muspro.StudenthoodNum)) ELSE NULL END)), 0), '.00', '')),
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(muspro.Studyhood)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspro.Studyhood))) > 0) THEN LTRIM(RTRIM(muspro.Studyhood)) ELSE NULL END)), 0), '.00', ''))
			FROM	 #tbStudentRecords AS stdstd INNER JOIN
					 MUStudent..Student AS musstd ON stdstd.studentIdJoin = musstd.StudentID AND stdstd.programCode = musstd.ProgramCode AND stdstd.majorCode = musstd.MajorCode AND stdstd.groupNum = musstd.GroupNum LEFT JOIN
					 MUStudent..SProfile AS muspro ON musstd.StudentID = muspro.StudentID
			ORDER BY musstd.studentId
			*/
			/*		
			SELECT	 insstd.id,
					 '217',
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrDetail)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrDetail))) > 0) THEN LTRIM(RTRIM(musadd.AddrDetail)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrNo)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrNo))) > 0) THEN LTRIM(RTRIM(musadd.AddrNo)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrMoo)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrMoo))) > 0) THEN LTRIM(RTRIM(musadd.AddrMoo)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrSoi)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrSoi))) > 0) THEN LTRIM(RTRIM(musadd.AddrSoi)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrStreet)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrStreet))) > 0) THEN LTRIM(RTRIM(musadd.AddrStreet)) ELSE NULL END),
					 (
						CASE
							WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrSubDistrict)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrSubDistrict))) > 0) THEN
								(SELECT	plcsdt.id
								 FROM	plcProvince AS plcpov INNER JOIN
										plcDistrict AS plcdst ON plcpov.id = plcdst.plcProvinceId INNER JOIN
										plcSubdistrict AS plcsdt ON plcdst.id = plcsdt.plcDistrictId
								 WHERE	(plcpov.thPlaceName = LTRIM(RTRIM(musadd.Province))) AND
										(plcdst.thDistrictName = LTRIM(RTRIM(musadd.AddrDistrict))) AND
										(plcsdt.thSubdistrictName = LTRIM(RTRIM(musadd.AddrSubDistrict))))
							ELSE NULL
						END
					 ),																				
					 (
						CASE
							WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrDistrict)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrDistrict))) > 0) THEN
								(SELECT	plcdst.id
								 FROM	plcProvince AS plcpov INNER JOIN
										plcDistrict AS plcdst ON plcpov.id = plcdst.plcProvinceId
								 WHERE	(plcpov.thPlaceName = LTRIM(RTRIM(musadd.Province))) AND
										(plcdst.thDistrictName = LTRIM(RTRIM(musadd.AddrDistrict))))
							ELSE NULL
						END
					 ),
					 (
						CASE
							WHEN (CHARINDEX(LTRIM(RTRIM(musadd.Province)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.Province))) > 0) THEN
								(SELECT	id
								 FROM	plcProvince
								 WHERE	(plcCountryId = '217') AND (thPlaceName = LTRIM(RTRIM(musadd.Province))))
							ELSE NULL
						END
					 ),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.ZipCode)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.ZipCode))) > 0) THEN LTRIM(RTRIM(musadd.ZipCode)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrTel)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrTel))) > 0) THEN LTRIM(RTRIM(musadd.AddrTel)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrCell)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrCell))) > 0) THEN LTRIM(RTRIM(musadd.AddrCell)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrFax)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrFax))) > 0) THEN LTRIM(RTRIM(musadd.AddrFax)) ELSE NULL END)
			FROM	 #tbStudentRecords AS insstd INNER JOIN
					 MUStudent..Student AS musstd ON insstd.studentId = musstd.StudentID AND insstd.programCode = musstd.ProgramCode AND insstd.majorCode = musstd.MajorCode AND insstd.groupNum = musstd.GroupNum LEFT JOIN
					 MUStudent..SAddress AS musadd ON musstd.StudentID = musadd.StudentID
			WHERE	 musadd.Type = '1'
			ORDER BY musstd.studentId
			*/
			/*
			SELECT	 insstd.id,
					 '217',
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrDetail)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrDetail))) > 0) THEN LTRIM(RTRIM(musadd.AddrDetail)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrNo)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrNo))) > 0) THEN LTRIM(RTRIM(musadd.AddrNo)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrMoo)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrMoo))) > 0) THEN LTRIM(RTRIM(musadd.AddrMoo)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrSoi)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrSoi))) > 0) THEN LTRIM(RTRIM(musadd.AddrSoi)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrStreet)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrStreet))) > 0) THEN LTRIM(RTRIM(musadd.AddrStreet)) ELSE NULL END),
					 (
						CASE
							WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrSubDistrict)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrSubDistrict))) > 0) THEN
								(SELECT	plcsdt.id
								 FROM	plcProvince AS plcpov INNER JOIN
										plcDistrict AS plcdst ON plcpov.id = plcdst.plcProvinceId INNER JOIN
										plcSubdistrict AS plcsdt ON plcdst.id = plcsdt.plcDistrictId
								 WHERE	(plcpov.thPlaceName = LTRIM(RTRIM(musadd.Province))) AND
										(plcdst.thDistrictName = LTRIM(RTRIM(musadd.AddrDistrict))) AND
										(plcsdt.thSubdistrictName = LTRIM(RTRIM(musadd.AddrSubDistrict))))
							ELSE NULL
						END
					 ),																				
					 (
						CASE
							WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrDistrict)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrDistrict))) > 0) THEN
								(SELECT	plcdst.id
								 FROM	plcProvince AS plcpov INNER JOIN
										plcDistrict AS plcdst ON plcpov.id = plcdst.plcProvinceId
								 WHERE	(plcpov.thPlaceName = LTRIM(RTRIM(musadd.Province))) AND
										(plcdst.thDistrictName = LTRIM(RTRIM(musadd.AddrDistrict))))
							ELSE NULL
						END
					 ),
					 (
						CASE
							WHEN (CHARINDEX(LTRIM(RTRIM(musadd.Province)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.Province))) > 0) THEN
								(SELECT	id
								 FROM	plcProvince
								 WHERE	(plcCountryId = '217') AND (thPlaceName = LTRIM(RTRIM(musadd.Province))))
							ELSE NULL
						END
					 ),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.ZipCode)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.ZipCode))) > 0) THEN LTRIM(RTRIM(musadd.ZipCode)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrTel)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrTel))) > 0) THEN LTRIM(RTRIM(musadd.AddrTel)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrCell)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrCell))) > 0) THEN LTRIM(RTRIM(musadd.AddrCell)) ELSE NULL END),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musadd.AddrFax)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musadd.AddrFax))) > 0) THEN LTRIM(RTRIM(musadd.AddrFax)) ELSE NULL END)
			FROM	 #tbStudentRecords AS insstd INNER JOIN
					 MUStudent..Student AS musstd ON insstd.studentId = musstd.StudentID AND insstd.programCode = musstd.ProgramCode AND insstd.majorCode = musstd.MajorCode AND insstd.groupNum = musstd.GroupNum LEFT JOIN
					 MUStudent..SAddress AS musadd ON musstd.StudentID = musadd.StudentID
			WHERE	 musadd.Type = '2'
			ORDER BY musstd.studentId	
			*/				
			/*			
			SELECT	 insstd.id,
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(muspov.ProvinceTName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspov.ProvinceTName))) > 0) THEN '217' ELSE NULL END),
					 (
						CASE 
							WHEN (CHARINDEX(LTRIM(RTRIM(muspov.ProvinceTName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspov.ProvinceTName))) > 0) THEN
								(SELECT plcpov.id
								 FROM	plcProvince AS plcpov
								 WHERE	(plcpov.thPlaceName = LTRIM(RTRIM(muspov.ProvinceTName))))
							ELSE NULL
						END
					 ),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(mussch.SchoolTname)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(mussch.SchoolTname))) > 0) THEN LTRIM(RTRIM(mussch.SchoolTname)) ELSE LTRIM(RTRIM(musedu.InstituteName)) END),						 
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.From_Year)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.From_Year))) > 0) THEN LTRIM(RTRIM(musedu.From_Year)) ELSE NULL END)), 0), '.00', '')),
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.To_Year)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.To_Year))) > 0) THEN LTRIM(RTRIM(musedu.To_Year)) ELSE NULL END)), 0), '.00', '')),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.CGPA)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.CGPA))) > 0) THEN LTRIM(RTRIM(musedu.CGPA)) ELSE NULL END)), 0))
			FROM	 #tbStudentRecords AS insstd INNER JOIN
					 MUStudent..Student AS musstd ON insstd.studentId = musstd.StudentID AND insstd.programCode = musstd.ProgramCode AND insstd.majorCode = musstd.MajorCode AND insstd.groupNum = musstd.GroupNum LEFT JOIN
					 MUStudent..AcademicBG AS musedu ON musstd.StudentID = musedu.StudentID LEFT JOIN
					 MUStudent..BSchool AS mussch ON musedu.InstituteID = mussch.SchoolCode LEFT JOIN
					 MUStudent..BProvince AS muspov ON mussch.ProvinceID = muspov.ProvinceID
			WHERE	 musedu.Aca_Level = '001'
			ORDER BY musstd.studentId
			*/
			/*
			SELECT	 insstd.id,
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(muspov.ProvinceTName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspov.ProvinceTName))) > 0) THEN '217' ELSE NULL END),
					 (
						CASE 
							WHEN (CHARINDEX(LTRIM(RTRIM(muspov.ProvinceTName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspov.ProvinceTName))) > 0) THEN
								(SELECT plcpov.id
								 FROM	plcProvince AS plcpov
								 WHERE	(plcpov.thPlaceName = LTRIM(RTRIM(muspov.ProvinceTName))))
							ELSE NULL
						END
					 ),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(mussch.SchoolTname)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(mussch.SchoolTname))) > 0) THEN LTRIM(RTRIM(mussch.SchoolTname)) ELSE LTRIM(RTRIM(musedu.InstituteName)) END),						 
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.From_Year)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.From_Year))) > 0) THEN LTRIM(RTRIM(musedu.From_Year)) ELSE NULL END)), 0), '.00', '')),
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.To_Year)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.To_Year))) > 0) THEN LTRIM(RTRIM(musedu.To_Year)) ELSE NULL END)), 0), '.00', '')),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.CGPA)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.CGPA))) > 0) THEN LTRIM(RTRIM(musedu.CGPA)) ELSE NULL END)), 0))
			FROM	 #tbStudentRecords AS insstd INNER JOIN
					 MUStudent..Student AS musstd ON insstd.studentId = musstd.StudentID AND insstd.programCode = musstd.ProgramCode AND insstd.majorCode = musstd.MajorCode AND insstd.groupNum = musstd.GroupNum LEFT JOIN
					 MUStudent..AcademicBG AS musedu ON musstd.StudentID = musedu.StudentID LEFT JOIN
					 MUStudent..BSchool AS mussch ON musedu.InstituteID = mussch.SchoolCode LEFT JOIN
					 MUStudent..BProvince AS muspov ON mussch.ProvinceID = muspov.ProvinceID
			WHERE	 musedu.Aca_Level = '002'
			ORDER BY musstd.studentId
			*/
			/*
			SELECT	 insstd.id,
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(muspov.ProvinceTName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspov.ProvinceTName))) > 0) THEN '217' ELSE NULL END),
					 (
						CASE 
							WHEN (CHARINDEX(LTRIM(RTRIM(muspov.ProvinceTName)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(muspov.ProvinceTName))) > 0) THEN
								(SELECT plcpov.id
								 FROM	plcProvince AS plcpov
								 WHERE	(plcpov.thPlaceName = LTRIM(RTRIM(muspov.ProvinceTName))))
							ELSE NULL
						END
					 ),
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(mussch.SchoolTname)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(mussch.SchoolTname))) > 0) THEN LTRIM(RTRIM(mussch.SchoolTname)) ELSE LTRIM(RTRIM(musedu.InstituteName)) END),						 
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.StudentIDAcaBG)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.StudentIDAcaBG))) > 0) THEN LTRIM(RTRIM(musedu.StudentIDAcaBG)) ELSE NULL END),
					 NULL,
					 (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.Major)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.Major))) > 0) THEN LTRIM(RTRIM(musedu.Major)) ELSE NULL END),
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.From_Year)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.From_Year))) > 0) THEN LTRIM(RTRIM(musedu.From_Year)) ELSE NULL END)), 0), '.00', '')),
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.To_Year)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.To_Year))) > 0) THEN LTRIM(RTRIM(musedu.To_Year)) ELSE NULL END)), 0), '.00', '')),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.CGPA)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.CGPA))) > 0) THEN LTRIM(RTRIM(musedu.CGPA)) ELSE NULL END)), 0)),
					 (
						CASE LTRIM(RTRIM(musedu.Degree))
							WHEN 'ม.6'		THEN '03'
							WHEN 'มัธยมปลาย'	THEN '03'
							WHEN 'ปวช.'		THEN '04'
							WHEN 'อนุปริญญา'	THEN '05'
							ELSE NULL
						END
					 ),
					 (
						CASE LTRIM(RTRIM(musedu.GraduateDegree))
							WHEN 'ม.3'				THEN '02'
							WHEN 'ม.6'				THEN '03'
							WHEN 'ปวช'				THEN '04'
							WHEN 'อนุปริญญาหรือเทียบเท่า'	THEN '05'
							WHEN 'ปริญญาตรี'			THEN '07'
							WHEN 'ปริญญาโท'			THEN '08'
							WHEN 'ปริญญาเอก'			THEN '09'
							ELSE NULL
						END								
					 ),
					 (
						CASE LTRIM(RTRIM(musedu.Entrance_Status))
							WHEN '1' THEN '01'
							WHEN '2' THEN '02'
							ELSE NULL								
						END								
					 ),						 
					 (CASE WHEN (LTRIM(RTRIM(musedu.Entrance_Status)) = '2' AND CHARINDEX(LTRIM(RTRIM(musedu.Entrance_StatusDetail)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.Entrance_StatusDetail))) > 0) THEN LTRIM(RTRIM(musedu.Entrance_StatusDetail)) ELSE NULL END),
					 (
						CASE LTRIM(RTRIM(musedu.Entrance_Time))
							WHEN '1' THEN '1'
							WHEN '2' THEN '2'
							WHEN '3' THEN '3'
							WHEN '4' THEN '4'
							ELSE NULL
						END								
					 ),
					 (
						CASE LTRIM(RTRIM(musedu.studyFrom))
							WHEN '1' THEN '01'
							WHEN '2' THEN '02'
							ELSE NULL
						END
					 ),
					 (CASE WHEN (LTRIM(RTRIM(musedu.studyFrom)) = '2' AND CHARINDEX(LTRIM(RTRIM(musedu.Entrance_University)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.Entrance_University))) > 0) THEN LTRIM(RTRIM(musedu.Entrance_University)) ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musedu.studyFrom)) = '2' AND CHARINDEX(LTRIM(RTRIM(musedu.Entrance_UniFaculty)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.Entrance_UniFaculty))) > 0) THEN LTRIM(RTRIM(musedu.Entrance_UniFaculty)) ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musedu.studyFrom)) = '2' AND CHARINDEX(LTRIM(RTRIM(musedu.Entrance_UniBranch)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.Entrance_UniBranch))) > 0) THEN LTRIM(RTRIM(musedu.Entrance_UniBranch)) ELSE NULL END),
					 (
						CASE LTRIM(RTRIM(musstd.EntType))
							WHEN '1' THEN 'DEP_UNI_01'
							WHEN '3' THEN 'QT_MU_01'
							WHEN '4' THEN 'DA_01'
							WHEN '5' THEN 'CA_01'
							WHEN '6' THEN 'CPRID_01'
							WHEN 'N' THEN 'FAC_01'
							ELSE NULL
						END
					 ),
					 (REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.EntranceBy_Detail)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.EntranceBy_Detail))) > 0) THEN LTRIM(RTRIM(musedu.EntranceBy_Detail)) ELSE NULL END)), 0), '.00', '')),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ONET_01)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ONET_01))) > 0) THEN LTRIM(RTRIM(musedu.ONET_01)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ONET_02)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ONET_02))) > 0) THEN LTRIM(RTRIM(musedu.ONET_02)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ONET_03)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ONET_03))) > 0) THEN LTRIM(RTRIM(musedu.ONET_03)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ONET_04)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ONET_04))) > 0) THEN LTRIM(RTRIM(musedu.ONET_04)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ONET_05)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ONET_05))) > 0) THEN LTRIM(RTRIM(musedu.ONET_05)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ONET_06)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ONET_06))) > 0) THEN LTRIM(RTRIM(musedu.ONET_06)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ONET_07)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ONET_07))) > 0) THEN LTRIM(RTRIM(musedu.ONET_07)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ONET_08)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ONET_08))) > 0) THEN LTRIM(RTRIM(musedu.ONET_08)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ANET_11)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ANET_11))) > 0) THEN LTRIM(RTRIM(musedu.ANET_11)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ANET_12)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ANET_12))) > 0) THEN LTRIM(RTRIM(musedu.ANET_12)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ANET_13)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ANET_13))) > 0) THEN LTRIM(RTRIM(musedu.ANET_13)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ANET_14)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ANET_14))) > 0) THEN LTRIM(RTRIM(musedu.ANET_14)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.ANET_15)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.ANET_15))) > 0) THEN LTRIM(RTRIM(musedu.ANET_15)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.GAT_85)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.GAT_85))) > 0) THEN LTRIM(RTRIM(musedu.GAT_85)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_71)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_71))) > 0) THEN LTRIM(RTRIM(musedu.PAT_71)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_72)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_72))) > 0) THEN LTRIM(RTRIM(musedu.PAT_72)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_73)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_73))) > 0) THEN LTRIM(RTRIM(musedu.PAT_73)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_74)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_74))) > 0) THEN LTRIM(RTRIM(musedu.PAT_74)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_75)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_75))) > 0) THEN LTRIM(RTRIM(musedu.PAT_75)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_76)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_76))) > 0) THEN LTRIM(RTRIM(musedu.PAT_76)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_77)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_77))) > 0) THEN LTRIM(RTRIM(musedu.PAT_77)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_78)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_78))) > 0) THEN LTRIM(RTRIM(musedu.PAT_78)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_79)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_79))) > 0) THEN LTRIM(RTRIM(musedu.PAT_79)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_80)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_80))) > 0) THEN LTRIM(RTRIM(musedu.PAT_80)) ELSE NULL END)), 0)),
					 (CONVERT(VARCHAR, CONVERT(MONEY, (CASE WHEN (CHARINDEX(LTRIM(RTRIM(musedu.PAT_82)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musedu.PAT_82))) > 0) THEN LTRIM(RTRIM(musedu.PAT_82)) ELSE NULL END)), 0))
			FROM	 #tbStudentRecords AS insstd INNER JOIN
					 MUStudent..Student AS musstd ON insstd.studentId = musstd.StudentID AND insstd.programCode = musstd.ProgramCode AND insstd.majorCode = musstd.MajorCode AND insstd.groupNum = musstd.GroupNum LEFT JOIN
					 MUStudent..AcademicBG AS musedu ON musstd.StudentID = musedu.StudentID LEFT JOIN
					 MUStudent..BSchool AS mussch ON musedu.InstituteID = mussch.SchoolCode LEFT JOIN
					 MUStudent..BProvince AS muspov ON mussch.ProvinceID = muspov.ProvinceID
			WHERE	 musedu.Aca_Level = '003'
			ORDER BY musstd.studentId
			*/
			/*
			SELECT	 insstd.id,
					 (
			 			CASE LTRIM(RTRIM(musact.Sporter))
							WHEN '1' THEN 'N'
							WHEN '2' THEN 'Y'
							ELSE NULL
						END
					 ),
					 (CASE WHEN (LTRIM(RTRIM(musact.Sporter)) = '2' AND CHARINDEX(LTRIM(RTRIM(musact.Sporter_Detail)), @strBlank) = 0 AND LEN(LTRIM(RTRIM(musact.Sporter_Detail))) > 0) THEN LTRIM(RTRIM(musact.Sporter_Detail)) ELSE NULL END),
					 (
			 			CASE LTRIM(RTRIM(musact.Special_Status))
							WHEN '1' THEN 'N'
							WHEN '2' THEN 'Y'
							ELSE NULL
						END
					 ),
					 (CASE WHEN (LTRIM(RTRIM(musact.Special_Status)) = '2' AND LTRIM(RTRIM(musact.Special1)) = '1') THEN 'Y' ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musact.Special_Status)) = '2' AND LTRIM(RTRIM(musact.Special1)) = '1' AND LEN(LTRIM(RTRIM(musact.Special1_Detail))) > 0) THEN LTRIM(RTRIM(musact.Special1_Detail)) ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musact.Special_Status)) = '2' AND LTRIM(RTRIM(musact.Special2)) = '1') THEN 'Y' ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musact.Special_Status)) = '2' AND LTRIM(RTRIM(musact.Special2)) = '1' AND LEN(LTRIM(RTRIM(musact.Special2_Detail))) > 0) THEN LTRIM(RTRIM(musact.Special2_Detail)) ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musact.Special_Status)) = '2' AND LTRIM(RTRIM(musact.Special3)) = '1') THEN 'Y' ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musact.Special_Status)) = '2' AND LTRIM(RTRIM(musact.Special3)) = '1' AND LEN(LTRIM(RTRIM(musact.Special3_Detail))) > 0) THEN LTRIM(RTRIM(musact.Special3_Detail)) ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musact.Special_Status)) = '2' AND LTRIM(RTRIM(musact.Special4)) = '1') THEN 'Y' ELSE NULL END),
					 (CASE WHEN (LTRIM(RTRIM(musact.Special_Status)) = '2' AND LTRIM(RTRIM(musact.Special4)) = '1' AND LEN(LTRIM(RTRIM(musact.Special4_Detail))) > 0) THEN LTRIM(RTRIM(musact.Special4_Detail)) ELSE NULL END),
					 (
			 			CASE LTRIM(RTRIM(musact.Activity))
							WHEN '1' THEN 'N'
							WHEN '2' THEN 'Y'
							ELSE NULL
						END
					 ),
					 (CASE WHEN (LTRIM(RTRIM(musact.Activity)) = '2' AND CHARINDEX(LTRIM(RTRIM(CONVERT(VARCHAR(MAX), musact.Activity_Detail))), @strBlank) = 0 AND LEN(LTRIM(RTRIM(CONVERT(VARCHAR(MAX), musact.Activity_Detail)))) > 0) THEN LTRIM(RTRIM(CONVERT(VARCHAR(MAX), musact.Activity_Detail))) ELSE NULL END)
			FROM	 #tbStudentRecords AS insstd INNER JOIN
					 MUStudent..Student AS musstd ON insstd.studentId = musstd.StudentID AND insstd.programCode = musstd.ProgramCode AND insstd.majorCode = musstd.MajorCode AND insstd.groupNum = musstd.GroupNum LEFT JOIN
					 MUStudent..StdActivities AS musact ON musstd.StudentID = musact.StudentID
			ORDER BY musstd.studentId				
			*/
		END					
	END			

	--SELECT @recordCount
END
