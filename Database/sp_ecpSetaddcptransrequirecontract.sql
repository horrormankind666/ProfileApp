USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetaddcptransrequirecontract]    Script Date: 26/1/2559 12:29:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE INSERT addcptransrequirecontract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetaddcptransrequirecontract]
	@indemnitoryear int
	,@indemnitorcash float
	,@id int
	,@casegraduate int
	,@scholar int
	,@actualmonthscholarship int
	,@actualscholarship float
	,@totalpayscholarship float
	,@actualmonth int
	,@actualday int
	,@subtotalpenalty float
	,@totalpenalty float
	,@IndemnitorAddress ntext
	,@province varchar(2)
	,@requiredate varchar(10)
	,@approvedate varchar(10)
	,@allactualdate int
	,@actualdate int
	,@remaindate int
	,@civil int

	
AS
BEGIN
	UPDATE ecpTransBreakContract SET
	IndemnitorYear = @indemnitoryear
	,IndemnitorCash = @indemnitorcash
	,StatusReceiver = 2
	,DateTimeReceiver = GETDATE()
	WHERE ID = @id 

	IF @casegraduate =1 
	BEGIN
		IF @scholar = 1
		BEGIN 

		INSERT INTO ecpTransRequireContract
		(BCID, ActualMonthScholarship, ActualScholarship, TotalPayScholarship, ActualMonth, ActualDay, SubtotalPenalty, TotalPenalty, StatusRepay, StatusPayment, FormatPayment)
		SELECT @id,@actualmonthscholarship,@actualscholarship,@totalpayscholarship,@actualmonth,@actualday,@subtotalpenalty,@totalpenalty,0,1,0
		
		END
		ELSE
		BEGIN

		INSERT INTO ecpTransRequireContract
		(BCID, TotalPayScholarship, ActualMonth, ActualDay, SubtotalPenalty, TotalPenalty, StatusRepay, StatusPayment, FormatPayment)
		SELECT @id,@totalpayscholarship,@actualmonth,@actualday,@subtotalpenalty,@totalpenalty,0,1,0
		
		END
	END

	IF @casegraduate = 2
	BEGIN 
		IF @civil = 1
		BEGIN

		INSERT INTO ecpTransRequireContract
		(BCID, IndemnitorAddress, Province, RequireDate, ApproveDate, TotalPayScholarship, AllActualDate, ActualDate, RemainDate, SubtotalPenalty, TotalPenalty, StatusRepay, StatusPayment, FormatPayment)
		SELECT @id,@IndemnitorAddress,@province,@requiredate,@approvedate,@totalpayscholarship,@allactualdate,@actualdate,@remaindate,@subtotalpenalty,@totalpenalty,0,1,0

		END
		ELSE
		BEGIN

		INSERT INTO ecpTransRequireContract
		(BCID, TotalPayScholarship, SubtotalPenalty, TotalPenalty, StatusRepay, StatusPayment, FormatPayment)
		SELECT @id,@totalpayscholarship,@subtotalpenalty,@totalpenalty,0,1,0
		
		END
	END
END
