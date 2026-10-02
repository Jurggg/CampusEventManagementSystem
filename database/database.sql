CREATE DATABASE CampusEventManagement;
GO

USE CampusEventManagement;
GO

-- =========================================
-- USERS TABLE
-- =========================================

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) NOT NULL,
    StudentNumber VARCHAR(20) NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    CreatedAt DATETIME2 NOT NULL
        CONSTRAINT DF_Users_CreatedAt
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_Users
        PRIMARY KEY (UserID),

    CONSTRAINT UQ_Users_StudentNumber
        UNIQUE (StudentNumber),

    CONSTRAINT UQ_Users_Email
        UNIQUE (Email),

    CONSTRAINT CK_Users_Role
        CHECK (Role IN ('Student', 'Administrator'))
);
GO


-- =========================================
-- EVENTS TABLE
-- =========================================

CREATE TABLE Events (
    EventID INT IDENTITY(1,1) NOT NULL,
    CreatedBy INT NOT NULL,
    EventName VARCHAR(150) NOT NULL,
    Description VARCHAR(500) NULL,
    Location VARCHAR(150) NOT NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Capacity INT NOT NULL,

    CONSTRAINT PK_Events
        PRIMARY KEY (EventID),

    CONSTRAINT FK_Events_Users
        FOREIGN KEY (CreatedBy)
        REFERENCES Users(UserID),

    CONSTRAINT CK_Events_Capacity
        CHECK (Capacity > 0),

    CONSTRAINT CK_Events_Time
        CHECK (EndTime > StartTime)
);
GO


-- =========================================
-- REGISTRATIONS TABLE
-- =========================================

CREATE TABLE Registrations (
    RegistrationID INT IDENTITY(1,1) NOT NULL,
    UserID INT NOT NULL,
    EventID INT NOT NULL,
    RegisteredAt DATETIME2 NOT NULL
        CONSTRAINT DF_Registrations_RegisteredAt
        DEFAULT SYSDATETIME(),
    Status VARCHAR(20) NOT NULL
        CONSTRAINT DF_Registrations_Status
        DEFAULT 'Registered',

    CONSTRAINT PK_Registrations
        PRIMARY KEY (RegistrationID),

    CONSTRAINT FK_Registrations_Users
        FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Registrations_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT UQ_Registrations_User_Event
        UNIQUE (UserID, EventID),

    CONSTRAINT CK_Registrations_Status
        CHECK (Status IN (
            'Registered',
            'Cancelled',
            'Attended'
        ))
);
GO


-- =========================================
-- FOREIGN KEY INDEXES
-- =========================================

CREATE INDEX IX_Events_CreatedBy
ON Events(CreatedBy);
GO

CREATE INDEX IX_Registrations_UserID
ON Registrations(UserID);
GO

CREATE INDEX IX_Registrations_EventID
ON Registrations(EventID);
GO