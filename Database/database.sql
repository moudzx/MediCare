-- Tables:

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
    [ClinicAddress] NVARCHAR(255) NULL,
    [CertificatePath] NVARCHAR(500) NOT NULL,

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

CREATE TABLE [dbo].[Food] (
    [id] INT PRIMARY KEY,
    [description] NVARCHAR(255),
    [calories] FLOAT,
    [protein] FLOAT,
    [total_fat] FLOAT,
    [carbohydrate] FLOAT,
    [sodium] FLOAT,
    [saturated_fat] FLOAT,
    [cholesterol] FLOAT,
    [sugar] FLOAT,
    [calcium] FLOAT,
    [iron] FLOAT,
    [potassium] FLOAT,
    [vitamin_c] FLOAT,
    [vitamin_e] FLOAT,
    [vitamin_d] FLOAT
);


CREATE TABLE [dbo].[Medicine] (
    [atc] NVARCHAR(20) PRIMARY KEY,
    [name] NVARCHAR(255),
    [b_g] NVARCHAR(10),
    [ingredients] NVARCHAR(MAX),
    [dosage] NVARCHAR(100),
    [form] NVARCHAR(255),
    [price] NVARCHAR(50)
);


CREATE TABLE [dbo].[PatientDoctorConnections] (
    [ConnectionId] INT IDENTITY(1,1) NOT NULL,
    [PatientId] INT NOT NULL,
    [DoctorId] INT NOT NULL,

    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    [RequestedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    [RespondedAt] DATETIME NULL,

    CONSTRAINT [PK_PatientDoctorConnections] PRIMARY KEY CLUSTERED ([ConnectionId]),
    CONSTRAINT [UQ_PatientDoctorConnections] UNIQUE ([PatientId], [DoctorId]),
    CONSTRAINT [CK_PatientDoctorConnections_Status]
        CHECK ([Status] IN ('Pending','Accepted','Rejected'))
);



CREATE TABLE [dbo].[Appointments] (
    [AppointmentId] INT IDENTITY(1,1) NOT NULL,
    [PatientId] INT NOT NULL,
    [DoctorId] INT NOT NULL,

    [AppointmentDate] DATETIME NOT NULL,
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Pending',
    [Reason] NVARCHAR(MAX) NULL,

    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT [PK_Appointments] PRIMARY KEY CLUSTERED ([AppointmentId]),
    CONSTRAINT [CK_Appointments_Status]
        CHECK ([Status] IN ('Pending','Accepted','Rejected','Cancelled','Completed'))
);



CREATE TABLE [dbo].[DoctorAvailability] (
    [AvailabilityId] INT IDENTITY(1,1) NOT NULL,
    [DoctorId] INT NOT NULL,

    [StartTime] DATETIME NOT NULL,
    [EndTime] DATETIME NOT NULL,

    CONSTRAINT [PK_DoctorAvailability] PRIMARY KEY CLUSTERED ([AvailabilityId])
);



CREATE TABLE [dbo].[Notifications] (
    [NotificationId] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,

    [Type] NVARCHAR(50) NOT NULL,
    [Title] NVARCHAR(255) NOT NULL,
    [Message] NVARCHAR(MAX) NOT NULL,

    [RelatedId] INT NULL,
    [IsRead] BIT NOT NULL DEFAULT 0,

    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([NotificationId]),
    CONSTRAINT [CK_Notifications_Type]
        CHECK ([Type] IN (
            'ConnectionRequest',
            'ConnectionAccepted',
            'ConnectionRejected',
            'MedicationAdded',
            'NutritionPlanAdded',
            'AppointmentRequested',
            'AppointmentAccepted',
            'AppointmentRejected'
        ))
);



CREATE TABLE [dbo].[NutritionPlans] (
    [PlanId] INT IDENTITY(1,1) NOT NULL,
    [PatientId] INT NOT NULL,
    [DoctorId] INT NULL,

    [Calories] INT NULL,
    [Protein] INT NULL,
    [Carbs] INT NULL,
    [Fat] INT NULL,

    [Goal] NVARCHAR(100) NULL,
    [Notes] NVARCHAR(MAX) NULL,

    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Active',

    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),
    [UpdatedAt] DATETIME NULL,

    CONSTRAINT [PK_NutritionPlans] PRIMARY KEY CLUSTERED ([PlanId]),
    CONSTRAINT [CK_NutritionPlans_Status]
        CHECK ([Status] IN ('Active','Inactive','Completed','Replaced'))
);



CREATE TABLE [dbo].[PatientMedications] (
    [PatientMedicationId] INT IDENTITY(1,1) NOT NULL,
    [PatientId] INT NOT NULL,
    [DoctorId] INT NOT NULL,
    [MedicineId] NVARCHAR(20) NOT NULL,

    [Dosage] NVARCHAR(100) NOT NULL,
    [Frequency] NVARCHAR(100) NOT NULL,
    [Duration] NVARCHAR(100) NULL,

    [StartDate] DATE NULL,
    [EndDate] DATE NULL,

    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Active',
    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT [PK_PatientMedications] PRIMARY KEY CLUSTERED ([PatientMedicationId]),
    CONSTRAINT [CK_PatientMedications_Status]
        CHECK ([Status] IN ('Active','Stopped','Completed'))
);

CREATE TABLE [dbo].[Conversations] (
    [ConversationId] INT IDENTITY(1,1) NOT NULL,
    [PatientId] INT NOT NULL,
    [DoctorId] INT NOT NULL,

    [CreatedAt] DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT [PK_Conversations]
        PRIMARY KEY CLUSTERED ([ConversationId]),

    CONSTRAINT [UQ_Conversations_Pair]
        UNIQUE ([PatientId], [DoctorId])
);

CREATE TABLE [dbo].[Messages] (
    [MessageId] INT IDENTITY(1,1) NOT NULL,
    [ConversationId] INT NOT NULL,
    [SenderUserId] INT NOT NULL,

    [MessageText] NVARCHAR(MAX) NOT NULL,

    [IsRead] BIT NOT NULL DEFAULT 0,
    [SentAt] DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT [PK_Messages]
        PRIMARY KEY CLUSTERED ([MessageId])
);


-- Indexes:


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

CREATE INDEX [IX_food_id] ON [dbo].[Food] ([id]);
CREATE INDEX [IX_food_description] ON [dbo].[Food] ([description]);
CREATE INDEX [IX_food_calories] ON [dbo].[Food] ([calories]);
CREATE INDEX [IX_food_calories_protein] ON [dbo].[Food] ([calories], [protein]);

CREATE INDEX [IX_medicine_atc] ON [dbo].[Medicine] ([atc]);
CREATE INDEX [IX_medicine_name] ON [dbo].[Medicine] ([name]);
CREATE INDEX [IX_medicine_b_g] ON [dbo].[Medicine] ([b_g]);
CREATE INDEX [IX_medicine_form] ON [dbo].[Medicine] ([form]);
CREATE INDEX [IX_medicine_atc_price] ON [dbo].[Medicine] ([atc], [price]);


CREATE NONCLUSTERED INDEX IX_Connections_Patient
ON [dbo].[PatientDoctorConnections] ([PatientId]);

CREATE NONCLUSTERED INDEX IX_Connections_Doctor
ON [dbo].[PatientDoctorConnections] ([DoctorId]);

CREATE NONCLUSTERED INDEX IX_Appointments_Doctor_Date
ON [dbo].[Appointments] ([DoctorId], [AppointmentDate]);

CREATE NONCLUSTERED INDEX IX_Appointments_Patient
ON [dbo].[Appointments] ([PatientId]);

CREATE NONCLUSTERED INDEX IX_Notifications_User
ON [dbo].[Notifications] ([UserId], [IsRead]);

CREATE NONCLUSTERED INDEX IX_NutritionPlans_Patient
ON [dbo].[NutritionPlans] ([PatientId], [Status]);

CREATE NONCLUSTERED INDEX IX_PatientMedications_Patient
ON [dbo].[PatientMedications] ([PatientId], [Status]);

CREATE NONCLUSTERED INDEX IX_Conversations_Patient
ON [dbo].[Conversations] ([PatientId]);

CREATE NONCLUSTERED INDEX IX_Conversations_Doctor
ON [dbo].[Conversations] ([DoctorId]);

CREATE NONCLUSTERED INDEX IX_Messages_Conversation
ON [dbo].[Messages] ([ConversationId], [SentAt]);

CREATE NONCLUSTERED INDEX IX_Messages_Read
ON [dbo].[Messages] ([ConversationId], [IsRead]);



-- Insert CSV

BULK INSERT [dbo].[Medicine]
FROM '~\lebanon_drugs_database.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FORMAT = 'CSV'
);

BULK INSERT [dbo].[Food]
FROM '~\lebanese_food_database.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FORMAT = 'CSV'
);

-- Alternative for Food using OPENROWSET
INSERT INTO [dbo].[Food] ([id], [description], [calories], [protein], [total_fat], [carbohydrate], [sodium], [saturated_fat], [cholesterol], [sugar], [calcium], [iron], [potassium], [vitamin_c], [vitamin_e], [vitamin_d])
SELECT *
FROM OPENROWSET(
    BULK '~\lebanese_food_database.csv',
    FORMATFILE = '~\food_format.xml',
    FIRSTROW = 2
) AS csv;

-- Alternative for Medicine using OPENROWSET
INSERT INTO [dbo].[Medicine] ([atc], [name], [b_g], [ingredients], [dosage], [form], [price])
SELECT *
FROM OPENROWSET(
    BULK '~\lebanon_drugs_database.csv',
    FORMATFILE = '~\medicine_format.xml',
    FIRSTROW = 2
) AS csv;

