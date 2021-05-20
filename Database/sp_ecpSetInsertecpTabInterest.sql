USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetInsertecpTabInterest]    Script Date: 26/1/2559 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<INSERT ecpTabInterest>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetInsertecpTabInterest]
	@InContractInterest float
	,@OutContractInterest float
	,@UseContractInterest int
AS
BEGIN
INSERT INTO ecpTabInterest (InContractInterest, OutContractInterest, UseContractInterest)
SELECT @InContractInterest,@OutContractInterest,@UseContractInterest
END
