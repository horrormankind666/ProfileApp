USE [Infinity]
GO
/****** Object:  StoredProcedure [dbo].[sp_perGeneratePersonId]    Script Date: 20/9/2564 12:09:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		: <ยุทธภูมิ ตวันนา>
-- Create date	: <๒๑/๑๑/๒๕๕๖>
-- Description	: <สำหรับสร้างรหัสให้กับตาราง perPerson>
-- Parameter
--  1. personId เป็น varchar	ส่งค่ารหัสบุคคล
-- =============================================
ALTER procedure [dbo].[sp_perGeneratePersonId]
(
	@personId varchar(10) output
)
as
begin
	set concat_null_yields_null off
	
	declare @year int = null
	declare @seq int = null
	declare @seqPerson int = null

	set @year = year(getdate()) + 543
	set @seq = (select max(seqPerson) as seq from perPersonIdLog where yearPerson = @year group by yearPerson)
	
	;with
	#tb_temp
	as
	(
		select	convert(int, left(id, 4)) as year,
				convert(int, right(id, 6)) as seq
		from	perPerson
		where	(convert(int, left(id, 4)) = @year)
	)

	select	 @seqPerson = max(seq)
	from	 #tb_temp
	group by year

	set @seq = isnull(@seq, 0)
	set @seqPerson = isnull(@seqPerson, 0)

	if (@seq < @seqPerson)
	begin
		set @seq = @seq + 1

		while (@seq <= @seqPerson)
		begin
			insert into perPersonIdLog (yearPerson, seqPerson) values (@year, @seq)	

			set @seq = @seq + 1
		end
	end

	set @seq = (select max(seqPerson) as seq from perPersonIdLog where yearPerson = @year group by yearPerson)
	set @seq = isnull(@seq, 0)

	insert into perPersonIdLog (yearPerson, seqPerson) values (@year, @seq + 1)	
	
	set @personId = (select convert(varchar(4), @year) + right('000000' + convert(varchar, (@seq + 1)), 6))
end