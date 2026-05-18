CREATE TABLE [dbo].[Users] (
    [UserId] INT IDENTITY(1,1) NOT NULL,
    [Email] NVARCHAR(255) NOT NULL,
    [PasswordHash] NVARCHAR(255) NOT NULL,
    [Role] NVARCHAR(20) NOT NULL,
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),

    [ResetCode] NVARCHAR(10) NULL,
    [ResetExpiry] DATETIME NULL,
    [ResetAttempts] INT NOT NULL DEFAULT 0,
    [ResetLockedUntil] DATETIME NULL,

    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId]),
    CONSTRAINT [UQ_Users_Email] UNIQUE ([Email]),
    CONSTRAINT [CK_Users_Role] CHECK ([Role] IN ('Patient', 'Doctor', 'Admin'))
);

CREATE TABLE [dbo].[Patients] (
    [PatientId] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [FullName] NVARCHAR(100) NOT NULL,
    [PhoneNumber] NVARCHAR(20) NULL,
    [Age] INT NOT NULL,
    [Height] FLOAT NULL,
    [Weight] FLOAT NULL,
    [Disability] NVARCHAR(255) NULL,
    [ChronicDisease] NVARCHAR(255) NULL,
    [FamilyHistory] NVARCHAR(MAX) NULL,

    CONSTRAINT [PK_Patients] PRIMARY KEY CLUSTERED ([PatientId]),
    CONSTRAINT [CK_Patients_Age] CHECK ([Age] > 0 AND [Age] <= 150)
);

CREATE TABLE [dbo].[Doctors] (
    [DoctorId] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [FullName] NVARCHAR(100) NOT NULL,
    [PhoneNumber] NVARCHAR(20) NULL,
    [Age] INT NOT NULL,
    [CertificatePath] NVARCHAR(500) NOT NULL,
    [ClinicAddress] NVARCHAR(255) NULL,
    CONSTRAINT [PK_Doctors] PRIMARY KEY CLUSTERED ([DoctorId]),
    CONSTRAINT [CK_Doctors_Age] CHECK ([Age] > 0 AND [Age] <= 150)
);


ALTER TABLE [dbo].[Patients]
    ADD CONSTRAINT [FK_Patients_Users]
    FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
    ON DELETE CASCADE;

ALTER TABLE [dbo].[Doctors]
    ADD CONSTRAINT [FK_Doctors_Users]
    FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId])
    ON DELETE CASCADE;

CREATE NONCLUSTERED INDEX [IX_Users_Email]
    ON [dbo].[Users] ([Email]);

CREATE NONCLUSTERED INDEX [IX_Users_Role]
    ON [dbo].[Users] ([Role]);

CREATE NONCLUSTERED INDEX [IX_Users_CreatedAt]
    ON [dbo].[Users] ([CreatedAt]);

CREATE NONCLUSTERED INDEX [IX_Patients_UserId]
    ON [dbo].[Patients] ([UserId]);

CREATE NONCLUSTERED INDEX [IX_Patients_FullName]
    ON [dbo].[Patients] ([FullName]);

CREATE NONCLUSTERED INDEX [IX_Patients_Age]
    ON [dbo].[Patients] ([Age]);

CREATE NONCLUSTERED INDEX [IX_Doctors_UserId]
    ON [dbo].[Doctors] ([UserId]);

CREATE NONCLUSTERED INDEX [IX_Doctors_FullName]
    ON [dbo].[Doctors] ([FullName]);
