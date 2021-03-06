USE [TestDB]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 8/18/2021 5:51:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[ContactId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[PhoneNumber] [varchar](12) NULL,
	[Status] [bit] NULL,
	[IsSoftDeleted] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[ModifiedDateTime] [datetime] NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Contact] ON 

INSERT [dbo].[Contact] ([ContactId], [FirstName], [LastName], [Email], [PhoneNumber], [Status], [IsSoftDeleted], [CreatedDateTime], [ModifiedDateTime]) VALUES (1, N'Mike', N'Hussey', N'mh123@test.com', N'1119374243', 1, 0, CAST(N'2021-08-15T04:51:36.470' AS DateTime), CAST(N'2021-08-15T10:09:06.303' AS DateTime))
INSERT [dbo].[Contact] ([ContactId], [FirstName], [LastName], [Email], [PhoneNumber], [Status], [IsSoftDeleted], [CreatedDateTime], [ModifiedDateTime]) VALUES (2, N'Tim', N'Southee', N'ts123@test.com', N'1119374243', 1, 1, CAST(N'2021-08-15T08:39:26.220' AS DateTime), CAST(N'2021-08-15T10:12:14.650' AS DateTime))
SET IDENTITY_INSERT [dbo].[Contact] OFF
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_IsSoftDeleted]  DEFAULT ((0)) FOR [IsSoftDeleted]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
ALTER TABLE [dbo].[Contact] ADD  CONSTRAINT [DF_Contact_ModifiedDateTime]  DEFAULT (getdate()) FOR [ModifiedDateTime]
GO
/****** Object:  StoredProcedure [dbo].[DELETEContact]    Script Date: 8/18/2021 5:51:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DELETEContact]
(
	@ContactId int,
	@ReturnCode tinyint OUTPUT
)

AS
BEGIN TRY
	IF NOT EXISTS (SELECT 1 FROM [Contact] WHERE ContactId = @ContactId)
        BEGIN
            SET @ReturnCode = 3
            RETURN
        END

	BEGIN TRAN;

		UPDATE [dbo].[Contact]
		   SET [IsSoftDeleted] = 1
			  ,[ModifiedDateTime] = GETDATE()
		WHERE ContactId = @ContactId

	COMMIT TRAN;

	SET @ReturnCode = 1
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN

	SET @ReturnCode = 0
	RETURN
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[GETContactById]    Script Date: 8/18/2021 5:51:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETContactById] 
(
	@ContactId int
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [ContactId]
      ,[FirstName]
      ,[LastName]
      ,[Email]
      ,[PhoneNumber]
      ,[Status]
      ,[CreatedDateTime]
      ,[ModifiedDateTime]
  FROM [dbo].[Contact]
	WHERE IsSoftDeleted = 0
		AND ContactId = @ContactId


END
GO
/****** Object:  StoredProcedure [dbo].[GETContacts]    Script Date: 8/18/2021 5:51:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETContacts]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [ContactId]
      ,[FirstName]
      ,[LastName]
      ,[Email]
      ,[PhoneNumber]
      ,[Status]
      ,[CreatedDateTime]
      ,[ModifiedDateTime]
  FROM [dbo].[Contact]
	WHERE IsSoftDeleted = 0


END
GO
/****** Object:  StoredProcedure [dbo].[POSTContact]    Script Date: 8/18/2021 5:51:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[POSTContact]
(
	@FirstName varchar(50),
	@LastName varchar(50),
	@Email varchar(100),
	@PhoneNumber varchar(12),
	@Status bit,
	@ReturnCode tinyint OUTPUT
)

AS
BEGIN TRY
	IF EXISTS (SELECT 1 FROM [Contact] WHERE Email = @Email)
        BEGIN
            SET @ReturnCode = 2
            RETURN
        END

	BEGIN TRAN;

		INSERT INTO [dbo].[Contact]
				   (
				   [FirstName]
				   ,[LastName]
				   ,[Email]
				   ,[PhoneNumber]
				   ,[Status]
				   )
			 VALUES
				   (
				   @FirstName,
				   @LastName,
				   @Email,
				   @PhoneNumber,
				   @Status
				   )

	COMMIT TRAN;

	SET @ReturnCode = 1
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN

	SET @ReturnCode = 0
	RETURN
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[PUTContact]    Script Date: 8/18/2021 5:51:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[PUTContact]
(
	@ContactId int,
	@FirstName varchar(50),
	@LastName varchar(50),
	@Email varchar(100),
	@PhoneNumber varchar(12),
	@Status bit,
	@ReturnCode tinyint OUTPUT
)

AS
BEGIN TRY
	IF EXISTS (SELECT 1 FROM [Contact] WHERE Email = @Email and ContactId <> @ContactId)
        BEGIN
            SET @ReturnCode = 2
            RETURN
        END

	BEGIN TRAN;

		UPDATE [dbo].[Contact]
		   SET [FirstName] = @FirstName
			  ,[LastName] = @LastName
			  ,[Email] = @Email
			  ,[PhoneNumber] = @PhoneNumber
			  ,[Status] = @Status
			  ,[ModifiedDateTime] = GETDATE()
		 WHERE ContactId = @ContactId

	COMMIT TRAN;

	SET @ReturnCode = 1
END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN

	SET @ReturnCode = 0
	RETURN
END CATCH

GO
