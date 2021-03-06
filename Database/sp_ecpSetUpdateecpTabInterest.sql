USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetUpdateecpTabInterest]    Script Date: 26/1/2559 12:31:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<Update ecpTabInterest>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetUpdateecpTabInterest]
	@InContractInterest float
	,@OutContractInterest float
	,@id int
AS
BEGIN

UPDATE ecpTabInterest 
SET InContractInterest = @InContractInterest
    ,OutContractInterest = @OutContractInterest
 WHERE ID = @id
END
