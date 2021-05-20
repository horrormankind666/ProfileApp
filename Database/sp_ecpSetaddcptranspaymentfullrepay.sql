USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_ecpSetaddcptranspaymentfullrepay]    Script Date: 26/1/2559 12:28:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Anussara Wanwang>
-- Create date: <19-03-2015>
-- Description:	<UPDATE INSERT addcptranspaymentfullrepay>
-- =============================================
ALTER PROCEDURE [dbo].[sp_ecpSetaddcptranspaymentfullrepay]
	 @overpayment int
	,@calinterestyesno varchar(1)
	,@id int
	,@overpaymentdatestart varchar(10)
	,@overpaymentdateend varchar(10)
	,@overpaymentyear int
	,@overpaymentday int
	,@OverpaymentInterest float
	,@overpaymenttotalinterest float
	,@datetimepayment varchar(10)
	,@capital float 
	,@Interest float 
	,@TotalAccruedInterest float
	,@TotalPayment float
	,@PayCapital float --_payRemain[0]
	,@PayInterest float --_payRemain[1]
	,@TotalPay float --_pay
	,@RemainCapital float   --_payRemain[2]
	,@AccruedInterest float  --_payRemain[3]
	,@RemainAccruedInterest float   --_payRemain[4]
	,@TotalRemain float  --_payRemain[2]
	,@ReceiptNo varchar(50)
	,@ReceiptBookNo varchar(50)
	,@receiptdate varchar(10)
	,@ReceiptSendNo varchar(50)
	,@receiptfund varchar(255)
	,@ChequeNo varchar(50)
	,@ChequeBank varchar(100)
	,@ChequeBankBranch varchar(100)
	,@ChequeDate varchar(10)
	,@channel int
	,@CashBank varchar(100)
	,@CashBankBranch varchar(100)
	,@CashBankAccount varchar(100)
	,@CashBankAccountNo varchar(50)
	,@CashBankDate varchar(10)
	--,@StatusPayment int
AS
BEGIN
	UPDATE ecpTransRequireContract SET
	StatusPayment = 3,
	FormatPayment = 1
	WHERE ID = @id

	IF @overpayment > 0
	BEGIN
		IF @calinterestyesno = 'Y'
		BEGIN
			IF @channel = 1
			BEGIN
			
			INSERT INTO ecpTransPayment
			(RCID, CalInterestYesNo, OverpaymentDateStart, OverpaymentDateEnd, OverpaymentYear, OverpaymentDay, OverpaymentInterest, OverpaymentTotalInterest, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT @id,@calinterestyesno,@overpaymentdatestart,@overpaymentdateend,@overpaymentyear,@overpaymentday,@OverpaymentInterest,@overpaymenttotalinterest,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			
			END
			ELSE IF @channel = 2
			BEGIN
			
			INSERT INTO ecpTransPayment
			(RCID, CalInterestYesNo, OverpaymentDateStart, OverpaymentDateEnd, OverpaymentYear, OverpaymentDay, OverpaymentInterest, OverpaymentTotalInterest, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,ChequeNo, ChequeBank, ChequeBankBranch, ChequeDate, ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT @id,@calinterestyesno,@overpaymentdatestart,@overpaymentdateend,@overpaymentyear,@overpaymentday,@OverpaymentInterest,@overpaymenttotalinterest,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@ChequeNo,@ChequeBank,@ChequeBankBranch,@ChequeDate,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			
			END
			ELSE IF @channel = 3
			BEGIN
			INSERT INTO ecpTransPayment
			(RCID, CalInterestYesNo, OverpaymentDateStart, OverpaymentDateEnd, OverpaymentYear, OverpaymentDay, OverpaymentInterest, OverpaymentTotalInterest, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,CashBank, CashBankBranch, CashBankAccount, CashBankAccountNo, CashBankDate, ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT @id,@calinterestyesno,@overpaymentdatestart,@overpaymentdateend,@overpaymentyear,@overpaymentday,@OverpaymentInterest,@overpaymenttotalinterest,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@CashBank,@CashBankBranch,@CashBankAccount,@CashBankAccountNo,@CashBankDate,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			END

		END
		IF @calinterestyesno = 'N'
		BEGIN
		   IF @channel = 1
			BEGIN
			
			INSERT INTO ecpTransPayment
			(RCID, CalInterestYesNo, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT @id,@calinterestyesno,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			
			END
			ELSE IF @channel = 2
			BEGIN
			
			INSERT INTO ecpTransPayment
			(RCID, CalInterestYesNo, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,ChequeNo, ChequeBank, ChequeBankBranch, ChequeDate, ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT  @id,@calinterestyesno,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@ChequeNo,@ChequeBank,@ChequeBankBranch,@ChequeDate,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			
			END
			ELSE IF @channel = 3
			BEGIN
			INSERT INTO ecpTransPayment
			(RCID, CalInterestYesNo, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,CashBank, CashBankBranch, CashBankAccount, CashBankAccountNo, CashBankDate, ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT  @id,@calinterestyesno,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@CashBank,@CashBankBranch,@CashBankAccount,@CashBankAccountNo,@CashBankDate,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			END
		END
	
	END
	IF @overpayment <= 0
	BEGIN
	 IF @channel = 1
			BEGIN
			
			INSERT INTO ecpTransPayment
			(RCID, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT @id,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			
			END
			ELSE IF @channel = 2
			BEGIN
			
			INSERT INTO ecpTransPayment
			(RCID, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,ChequeNo, ChequeBank, ChequeBankBranch, ChequeDate, ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT  @id,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@ChequeNo,@ChequeBank,@ChequeBankBranch,@ChequeDate,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			
			END
			ELSE IF @channel = 3
			BEGIN
			INSERT INTO ecpTransPayment
			(RCID, DateTimePayment, Capital, Interest, TotalAccruedInterest, TotalPayment, PayCapital, PayInterest, TotalPay, RemainCapital, AccruedInterest, RemainAccruedInterest, TotalRemain, Channel,CashBank, CashBankBranch, CashBankAccount, CashBankAccountNo, CashBankDate, ReceiptNo, ReceiptBookNo, ReceiptDate, ReceiptSendNo, ReceiptFund)
			SELECT  @id,@datetimepayment,@capital,@Interest,@TotalAccruedInterest,@TotalPayment,@PayCapital,@PayInterest,@TotalPay,@RemainCapital,@AccruedInterest,@RemainAccruedInterest,@TotalRemain,@channel,@CashBank,@CashBankBranch,@CashBankAccount,@CashBankAccountNo,@CashBankDate,@ReceiptNo,@ReceiptBookNo,@receiptdate,@ReceiptSendNo,@receiptfund
			END
	
	END


END
