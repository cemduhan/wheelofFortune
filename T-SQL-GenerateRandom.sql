GO
CREATE VIEW vw_getNEWID
AS
SELECT ABS(CONVERT(BIGINT,CONVERT(BINARY(8), NEWID())))  AS Value 
GO

GO
CREATE function [dbo].[RandomStringGenerator]()
returns nvarchar(8)
WITH EXECUTE AS CALLER
AS
begin
    DECLARE @TotalNumberOfCharToReturn bigint
     
    SET @TotalNumberOfCharToReturn = 6 
 
    DECLARE @AllChar as nvarchar(max) = 'ACDEFGHKLMNPRTXYZ234579'
 
    declare @MyRnd as int
    declare @Out as nvarchar(8) = ''
 
    while LEN(@Out) < @TotalNumberOfCharToReturn begin
       set @MyRnd = ((SELECT Value FROM vw_getNEWID) % (LEN(@AllChar))) + 1
       set @Out += SUBSTRING(@AllChar,@MyRnd,1)
    end


	--RETURN @Out


	set @TotalNumberOfCharToReturn += 2
	declare @grouping as int = 3
	declare @QQ02 as int = 0
	declare @QQ03 as int = 1
    while LEN(@Out) < @TotalNumberOfCharToReturn begin
       SELECT @QQ02 = 0
	   SELECT @MyRnd = 0
		   while @QQ02 < @grouping begin
			   SELECT @QQ03 += 1
			   SELECT @QQ02 += 1
			   set @MyRnd += (ASCII(SUBSTRING(@Out,@QQ03,1)))
		   end
    select @MyRnd = (@MyRnd % LEN(@AllChar)) + 1
    set @Out += SUBSTRING(@AllChar,@MyRnd,1)
    end



    RETURN @Out
end
GO
CREATE function [dbo].[ValidateRandomString](
    @randomString nvarchar(8)
)
returns bit
WITH EXECUTE AS CALLER
AS
begin
    DECLARE @TotalNumberOfCharToReturn bigint
     
    SET @TotalNumberOfCharToReturn = 8 
 
    DECLARE @AllChar as nvarchar(max) = 'ACDEFGHKLMNPRTXYZ234579'
	
    declare @MyRnd as bigint
    declare @Out as nvarchar(max) = SUBSTRING(@randomString,1,6)

	declare @grouping as int = 3
	declare @QQ02 as int = 0
	declare @QQ03 as int = 1
    while LEN(@Out) < @TotalNumberOfCharToReturn begin
       SELECT @QQ02 = 0
	   SELECT @MyRnd = 0
		   while @QQ02 < @grouping begin
			   SELECT @QQ03 += 1
			   SELECT @QQ02 += 1
			   set @MyRnd += (ASCII(SUBSTRING(@Out,@QQ03,1)))
		   end
    select @MyRnd = (@MyRnd % LEN(@AllChar)) + 1
    set @Out += SUBSTRING(@AllChar,@MyRnd,1)
    end

	IF @Out = @randomString
    BEGIN
        return 1;
    END

    RETURN 0;
end
GO

GO
declare @randomNum1 as nvarchar(max) = ''
declare @QQ02 as int = 0
DECLARE @AllChar as nvarchar(max) = 'ACDEFGHKLMNPRTXYZ234579'
declare @limit as int = 10000
	while @QQ02 < @limit begin
		select @QQ02 += 1
		select @randomNum1 = [dbo].[RandomStringGenerator]()
		print @randomNum1
		print [dbo].[ValidateRandomString](@randomNum1)
	end
GO

DROP VIEW  vw_getNEWID;
DROP FUNCTION [dbo].[RandomStringGenerator]
DROP FUNCTION [dbo].[ValidateRandomString]
GO