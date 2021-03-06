USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetInsertTransactionLog]    Script Date: 26/1/2559 12:31:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<InsertTransactionLog eCPDB.cs >
-- =============================================
-- sp_ecpSetInsertTransactionLog ''
ALTER PROCEDURE [dbo].[sp_ecpSetInsertTransactionLog] 
	 @whoIs varchar(50)
	,@name varchar(100)
	,@GetIP varchar(20)
	,@what varchar(50)
	,@where varchar(50)
	,@function varchar(200)
	,@sqlCommand ntext
AS
BEGIN
	INSERT INTO ecpTransLog 
                    (WhoIs, Name, IP, WhatIs, WhereIs, FunctionIs, SQLCommand, WhenIs) 
                    VALUES 
                    (@whoIs,
					 @name,
					 @GetIP,
					 @what,
					 @where,
					 @function,
					 @sqlCommand,
                     GETDATE()
                    )
END
