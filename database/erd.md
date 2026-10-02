# Online Campus Event Management System ERD

```mermaid
erDiagram

    USERS {
        INT UserID PK
        VARCHAR StudentNumber UK
        VARCHAR FirstName
        VARCHAR LastName
        VARCHAR Email UK
        VARCHAR Role
        DATETIME2 CreatedAt
    }

    EVENTS {
        INT EventID PK
        INT CreatedBy FK
        VARCHAR EventName
        VARCHAR Description
        VARCHAR Location
        DATE EventDate
        TIME StartTime
        TIME EndTime
        INT Capacity
    }

    REGISTRATIONS {
        INT RegistrationID PK
        INT UserID FK
        INT EventID FK
        DATETIME2 RegisteredAt
        VARCHAR Status
    }

    USERS ||--o{ EVENTS : creates
    USERS ||--o{ REGISTRATIONS : makes
    EVENTS ||--o{ REGISTRATIONS : receives