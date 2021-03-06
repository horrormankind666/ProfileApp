USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetupdatecptransrequirecontract]    Script Date: 26/1/2559 12:31:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE UPDATE updatecptransrequirecontract>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetupdatecptransrequirecontract]
	 @indemnitoryear int
	,@indemnitorcash float
    ,@id int
	,@casegraduate int
	,@actualmonthscholarship int
	,@actualscholarship float
	,@totalpayscholarship float
	,@actualmonth int
	,@actualday int
	,@subtotalpenalty float
	,@totalpenalty float
	,@civil int
	,@IndemnitorAddress ntext
	,@province varchar(2)
	,@requiredate varchar(10)
	,@approvedate varchar(10)
	,@allactualdate int
	,@actualdate int
	,@remaindate int
AS
BEGIN
	UPDATE ecpTransBreakContract SET
	IndemnitorYear = @indemnitoryear,
	IndemnitorCash = @indemnitorcash,
	StatusReceiver = 2,
	DateTimeModify = GETDATE()
	WHERE ID = @id

	IF @casegraduate = 1
	BEGIN 
	UPDATE ecpTransRequireContract SET
	ActualMonthScholarship = @actualmonthscholarship,
	ActualScholarship = @actualscholarship,
	TotalPayScholarship = @totalpayscholarship,
	ActualMonth = @actualmonth,
	ActualDay = @actualday,
	SubtotalPenalty = @subtotalpenalty,
	TotalPenalty = @totalpenalty,
	StatusRepay = 0,
	StatusPayment = 1,
	FormatPayment = 0 
	WHERE ID = @id
	END

	IF @casegraduate = 2
	BEGIN
		IF @civil = 1
		BEGIN
		UPDATE ecpTransRequireContract SET
		IndemnitorAddress = @IndemnitorAddress,
		Province = @province,
		RequireDate = @requiredate,
		ApproveDate = @approvedate,
		TotalPayScholarship = @totalpayscholarship,
		AllActualDate = @allactualdate,
		ActualDate = @actualdate,
		RemainDate = @remaindate,
		SubtotalPenalty = @subtotalpenalty,
		TotalPenalty = @totalpenalty,
		StatusRepay = 0,
		StatusPayment = 1,
		FormatPayment = 0
		WHERE ID = @id
		END
		ELSE
		BEGIN
		UPDATE ecpTransRequireContract SET
		TotalPayScholarship = @totalpayscholarship,
		SubtotalPenalty = @subtotalpenalty,
		TotalPenalty = @totalpenalty,
		StatusRepay = 0,
		StatusPayment = 1,
		FormatPayment = 0	
		WHERE ID = @id	
		END

	END

END
