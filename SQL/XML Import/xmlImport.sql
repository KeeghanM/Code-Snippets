/* RUN FOR FIRST SETUP */
    /*
    CREATE TABLE [dbo].[tbl_XMLrowset](
	    [XMLData] [xml] NULL,
	    [LoadedDateTime] [datetime] NULL
    )

    CREATE TABLE [dbo].[tbl_XMLcomparison](
	    [id] [int] NULL,
	    [yourField1] [type] NULL,
	    [yourField2] [type] NULL
    )
    */

-- Clear out the table from last run
delete from tbl_XMLrowset

/* DECLARE VARIABLES */
DECLARE @cmd1 VARCHAR(MAX)
DECLARE @counter INT
DECLARE @XMLname VARCHAR(MAX)
DECLARE @XMLfull VARCHAR(MAX)
DECLARE @rowset VARCHAR(MAX)
DECLARE @XML AS XML
DECLARE @hDoc AS INT
DECLARE @SQL NVARCHAR(MAX)
DECLARE @XMLfolder VARCHAR(MAX)= 'D:\XML\' -- NOTE: This is local to the DB Server
DECLARE @XMLdata TABLE(xmlOutput VARCHAR(MAX))
/* END VARIABLES */

-- Get a list of all XMLs in the folder
-- and get ONLY their file names
select @cmd1 = 'EXEC '+ 'master.dbo.xp_cmdshell ' + char(39)+ 'dir '+@XMLfolder+' /b /a-d'+ char(39)
insert into @XMLdata
exec (@cmd1)

-- Begin a loop for each XML file
set @counter = (select count(*) from @XMLdata)
while @counter > 0 begin
    -- Get just a single file to work with 
    set @XMLname = (select top 1 xmlOutput from @XMLdata)
    set @XMLfull = 'D:\XML\'+@XMLname

    -- Construct a select statement that will open and read the XML file
    set @rowset = 'SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
    FROM OPENROWSET(BULK ''' + @XMLfull + ''', SINGLE_BLOB) AS x;'

    -- Insert into the XML rowset data using the select
    -- statement constructed above
    INSERT INTO tbl_XMLrowset (XMLData, LoadedDateTime)
    exec(@rowset)

    -- Clear out the row we just processed
    -- and decrease the counter
    delete from @XMLdata where xmlOutput = @XMLname
    set @counter = @counter - 1
end

-- These next two lines are optional. They are used
-- for filtering out XML data that you may not need
-- for instance the XML folder might have three types,
-- you only need one. Delete ones like, or not like, 
-- certain things
delete from tbl_XMLrowset where convert(varchar(max),XMLdata) not like '<NewDataSet>%'
delete from tbl_XMLrowset where convert(varchar(max),XMLdata) like '%permit%'

-- After clearing out unneeded XMLs
-- We now need to put them into the table
-- soooo.. New Counter!
set @counter = (select count(*) from tbl_XMLrowset)
while @counter > 0 begin
    -- Get just one to process
    SET @XML = (select top 1 XMLData FROM tbl_XMLrowset)

    -- Process the XML and output to @hDoc -- "Opens"
    EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

    -- Now to actually put the final opened XML
    -- into a table to use later!
    insert into tbl_XMLcomparison
    Select id,yourField1,yourField2 -- NOTE: Change these columns to the ones in the table
    from OPENXML(@hdoc, 'NewDataSet/Table')
    with ( -- NOTE: Change these columns to the ones in the table
    id int 'id',
    yourField1 yourType 'FieldOne', 
    yourField2 yourType 'FieldTwo'
    )

    -- remove the documents -- "Closes"
    EXEC sp_xml_removedocument @hDoc

    -- Clear out the row we just processed
    -- and decrease the counter
    delete from tbl_XMLrowset where XMLData = @XML
    set @counter = @counter - 1
end

-- These next two lines are optional. If you want to keep 
-- the XML's after the processing then remove them
--select @cmd1 = 'EXEC '+ 'master.dbo.xp_cmdshell ' + char(39)+ 'del '+@XMLfolder+'*.xml'+ char(39)
--exec (@cmd1)

-- View your beatifully imported XML Data!
select * from tbl_XMLcomparison