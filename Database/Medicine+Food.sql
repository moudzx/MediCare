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


CREATE INDEX [IX_food_id] ON [dbo].[Food] ([id]);
CREATE INDEX [IX_food_description] ON [dbo].[Food] ([description]);
CREATE INDEX [IX_food_calories] ON [dbo].[Food] ([calories]);
CREATE INDEX [IX_food_calories_protein] ON [dbo].[Food] ([calories], [protein]);

CREATE INDEX [IX_medicine_atc] ON [dbo].[Medicine] ([atc]);
CREATE INDEX [IX_medicine_name] ON [dbo].[Medicine] ([name]);
CREATE INDEX [IX_medicine_b_g] ON [dbo].[Medicine] ([b_g]);
CREATE INDEX [IX_medicine_form] ON [dbo].[Medicine] ([form]);
CREATE INDEX [IX_medicine_atc_price] ON [dbo].[Medicine] ([atc], [price]);


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

