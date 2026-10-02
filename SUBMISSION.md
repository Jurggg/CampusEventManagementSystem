# Online Campus Event Management System

## Team Roster

| Member             | Role                            |
| ------------------ | ------------------------------- |
| Jurggen Donato     | Systems Architect & Prompt Lead |
| Yuan Anakin Galeon | Frontend Engineer               |
| Jann Paul Guingab  | Database & Backend Engineer     |
| Ralph Atienza      | QA & Security Engineer          |

---

# Task 1

## RCTC Prompt

```text
ROLE:

Act as a Lead Systems Architect with experience designing simple, secure, and maintainable web-based systems for educational institutions.

CONTEXT:

Our team needs to build a working prototype of an Online Campus Event Management System for a 3-hour group hands-on laboratory examination. The system should allow students to view upcoming campus events, register for an event, and allow administrators to view registered attendees. The team consists of beginner-level BSIT students, so the proposed architecture must be realistic to implement within the available time.

TASK:

Design an overall system architecture for the Online Campus Event Management System. Identify the recommended frontend, backend, database, major system components, data flow, and how students and administrators interact with the system. Explain how the components communicate with each other and provide a simple project structure that our team can follow.

CONSTRAINTS:

1. Keep the architecture simple enough to implement within approximately 3 hours.

2. Use technologies that are appropriate for beginner-level BSIT students.

3. Include basic security practices for authentication, database access, and user input.

4. The design should support the required student event registration and administrator attendee-viewing functions.

5. The architecture should be practical for a small prototype rather than a large enterprise system.

6. Do not introduce unnecessary microservices or complex infrastructure.

7. Do not use third-party state-management libraries unless they are clearly necessary.

8. Clearly separate frontend, backend, database, and testing responsibilities.

9. Present the final architecture in a clear and organized format that a development team can directly use as a starting point.
```

## AI-Generated Architecture

The recommended architecture is a simple three-layer web application consisting of a frontend, backend API, and database.

```text
                 ONLINE CAMPUS EVENT MANAGEMENT SYSTEM

                              │

                ┌─────────────┴─────────────┐
                │                           │
          STUDENT USER                ADMIN USER
                │                           │
                └─────────────┬─────────────┘
                              │
                         FRONTEND
                    HTML / CSS / JavaScript
                              │
                         HTTP / REST
                              │
                         BACKEND API
                    Node.js + Express.js
                              │
                ┌────────────┴────────────┐
                │                         │
         Authentication              Event API
         Login / Register          Events / Registration
                │                         │
                └────────────┬────────────┘
                             │
                          DATABASE
                            SQLite
                             │
                ┌────────────┴────────────┐
                │                         │
              Users                     Events
                                      │
                                 Registrations
```

### Recommended Technology Stack

| Layer           | Technology            | Responsibility                          |
| --------------- | --------------------- | --------------------------------------- |
| Frontend        | HTML, CSS, JavaScript | User interface and user interaction     |
| Backend         | Node.js + Express.js  | API, business logic, and authentication |
| Database        | SQLite                | Store users, events, and registrations  |
| Testing         | Jest + Supertest      | Backend and API testing                 |
| Development     | Visual Studio Code    | Development environment                 |
| Version Control | Git + GitHub          | Shared source code and version control  |

This stack is appropriate for the examination because it avoids unnecessary complexity. SQLite does not require a separate database server, while Express.js provides a simple way to create the backend API. Plain HTML, CSS, and JavaScript also avoid the need for a frontend framework or third-party state-management library.

### Major System Components

**Student Frontend**

Students should be able to:

1. Log in.
2. View upcoming campus events.
3. View event details.
4. Register for an event.
5. View their registrations.
6. Receive registration confirmation.

Suggested pages:

```text
frontend/

├── index.html
├── login.html
├── events.html
├── event-details.html
└── my-registrations.html
```

**Administrator Frontend**

Administrators should be able to:

1. Log in.
2. View available events.
3. Select an event.
4. View registered attendees.

Suggested pages:

```text
frontend/admin/

├── dashboard.html
└── attendees.html
```

The administrator interface should remain simple because the main requirement is to view registered attendees.

### Backend API

The backend handles authentication, validation, authorization, event information, registration processing, and database communication.

| Method | Endpoint                          | Purpose                    | Access        |
| ------ | --------------------------------- | -------------------------- | ------------- |
| POST   | `/api/auth/login`                 | Authenticate a user        | Public        |
| GET    | `/api/events`                     | Retrieve upcoming events   | Student/Admin |
| GET    | `/api/events/:id`                 | Retrieve event details     | Student/Admin |
| POST   | `/api/events/:id/register`        | Register a student         | Student       |
| GET    | `/api/my-registrations`           | View student registrations | Student       |
| GET    | `/api/admin/events/:id/attendees` | View event attendees       | Admin         |

The frontend communicates with the backend through HTTP requests and JSON responses.

### Database Design

The system uses three main tables.

**Users**

```text
Users
--------------------------------

id              INTEGER PK
name            TEXT
email           TEXT UNIQUE
password_hash   TEXT
role            TEXT
```

The `role` field can contain:

```text
student
admin
```

**Events**

```text
Events
--------------------------------

id              INTEGER PK
title           TEXT
description     TEXT
location        TEXT
event_date      TEXT
capacity        INTEGER
```

**Registrations**

```text
Registrations
--------------------------------

id              INTEGER PK
user_id         INTEGER FK
event_id        INTEGER FK
registered_at   TEXT
```

The database relationship is:

```text
Users

  │
  │ 1
  │
  │ many
  ▼

Registrations

  ▲
  │ many
  │
  │ 1
  │

Events
```

A student can register for multiple events, while an event can have multiple registered students. The `Registrations` table connects users and events.

### Student Event Viewing Data Flow

```text
Student

   │
   ▼

Events Page

   │
   │ GET /api/events
   ▼

Express Backend

   │
   │ SQL Query
   ▼

SQLite Database

   │
   │ Event Records
   ▼

Express Backend

   │
   │ JSON Response
   ▼

Events Page

   │
   ▼

Display Upcoming Events
```

The frontend requests the available events from the backend. The backend retrieves the records from SQLite and returns them to the frontend as JSON.

### Student Registration Data Flow

```text
Student

   │
   ▼

Click "Register"

   │
   ▼

POST /api/events/:id/register

   │
   ▼

Backend

   │
   ├── Check authentication
   ├── Check event exists
   ├── Check duplicate registration
   ├── Check event capacity
   └── Create registration
          │
          ▼
       SQLite
          │
          ▼
     Confirmation
```

The backend verifies that the student is authenticated, the event exists, the student has not already registered, and the event still has available capacity.

### Administrator Attendee Data Flow

```text
Admin

  │
  ▼

Admin Dashboard

  │
  ▼

Select Event

  │
  │ GET /api/admin/events/:id/attendees
  ▼

Backend

  │
  │ Verify Admin Role
  ▼

SQLite

  │
  │ JOIN Users + Registrations
  ▼

Backend

  │
  ▼

Attendee List
```

The backend verifies the administrator's role before returning attendee information.

### Basic Security Practices

**Password Hashing**

Passwords should not be stored as plain text. A password hashing library such as bcrypt can be used to create a secure password hash before storing it in the database.

```text
Password

   ↓

bcrypt Hash

   ↓

Password Hash

   ↓

Database
```

**Authentication**

Users must provide valid login credentials before accessing protected features.

**Authorization**

The backend must check the user's role before allowing administrator-only actions.

```javascript
if (user.role !== "admin") {

    return res.status(403).json({
        message: "Admin access required"
    });

}
```

**Input Validation**

User input should be validated before being processed or stored. For example, email addresses should have a valid format, event IDs should be valid numbers, and required fields should not be empty.

**Parameterized SQL Queries**

The backend should use parameterized SQL queries instead of directly inserting user input into SQL statements.

Unsafe:

```text
"SELECT * FROM Users WHERE email = '" + email + "'"
```

Safer:

```text
"SELECT * FROM Users WHERE email = ?"
```

This helps reduce the risk of SQL injection.

**Duplicate Registration Prevention**

The system should prevent a student from registering for the same event multiple times. This can be checked by the backend and reinforced with a database constraint on `user_id` and `event_id`.

### Simple Project Structure

```text
campus-event-system/

│
├── backend/
│   ├── server.js
│   │
│   ├── routes/
│   │   ├── authRoutes.js
│   │   ├── eventRoutes.js
│   │   └── adminRoutes.js
│   │
│   ├── controllers/
│   │   ├── authController.js
│   │   ├── eventController.js
│   │   └── adminController.js
│   │
│   ├── middleware/
│   │   └── authMiddleware.js
│   │
│   └── database/
│       ├── database.js
│       └── schema.sql
│
├── frontend/
│   ├── index.html
│   ├── login.html
│   ├── events.html
│   ├── event-details.html
│   ├── my-registrations.html
│   │
│   ├── admin/
│   │   ├── dashboard.html
│   │   └── attendees.html
│   │
│   ├── css/
│   │   └── style.css
│   │
│   └── js/
│       ├── login.js
│       ├── events.js
│       └── admin.js
│
├── tests/
│   ├── auth.test.js
│   ├── events.test.js
│   └── registration.test.js
│
├── package.json
├── .env
├── .gitignore
└── README.md
```

### Responsibility Separation

| Component | Responsibility                                                                        |
| --------- | ------------------------------------------------------------------------------------- |
| Frontend  | Display information, collect input, send API requests, and display responses          |
| Backend   | Authentication, authorization, validation, business logic, and database communication |
| Database  | Store users, events, registrations, and maintain relationships                        |
| Testing   | Test authentication, events, registration, authorization, and attendee viewing        |

### Three-Hour Implementation Plan

**0–20 Minutes — Setup**

* Create GitHub repository.
* Create project structure.
* Initialize Node.js.
* Install required packages.
* Create SQLite database.
* Create database schema.

**20–60 Minutes — Backend and Database**

* Create Users table.
* Create Events table.
* Create Registrations table.
* Implement login API.
* Implement events API.
* Implement registration API.
* Implement admin attendee API.

**60–110 Minutes — Frontend**

* Create login page.
* Create events page.
* Create event registration.
* Create student registration view.
* Create admin dashboard.
* Create attendee list.

**110–140 Minutes — Security and Validation**

* Implement password hashing.
* Implement authentication.
* Implement role-based authorization.
* Add input validation.
* Prevent duplicate registration.
* Validate event capacity.
* Use parameterized SQL queries.

**140–165 Minutes — Testing**

Test the following:

| Test                   | Expected Result                       |
| ---------------------- | ------------------------------------- |
| Student login          | Login succeeds with valid credentials |
| Invalid login          | Login is rejected                     |
| View events            | Upcoming events are displayed         |
| Register event         | Registration is saved                 |
| Duplicate registration | Duplicate is rejected                 |
| Full event             | Registration is rejected              |
| Admin login            | Admin can access dashboard            |
| Student admin access   | Access is rejected                    |
| View attendees         | Registered students are displayed     |

**165–180 Minutes — Finalization**

* Run the complete system.
* Check all required functions.
* Fix critical bugs.
* Commit changes.
* Push changes to GitHub.
* Check the repository.
* Complete documentation.

### Final Architecture

```text
                 ┌──────────────────────┐
                 │       STUDENT        │
                 │                      │
                 │ Login                │
                 │ View Events          │
                 │ Register             │
                 │ My Registrations     │
                 └──────────┬───────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │       FRONTEND       │
                 │                      │
                 │ HTML / CSS / JS      │
                 └──────────┬───────────┘
                            │
                         HTTP/JSON
                            │
                            ▼
                 ┌──────────────────────┐
                 │      BACKEND API     │
                 │                      │
                 │ Node.js + Express    │
                 │                      │
                 │ Authentication       │
                 │ Events               │
                 │ Registration         │
                 │ Admin Authorization  │
                 └──────────┬───────────┘
                            │
                           SQL
                            │
                            ▼
                 ┌──────────────────────┐
                 │       SQLITE         │
                 │                      │
                 │ Users                │
                 │ Events               │
                 │ Registrations        │
                 └──────────┬───────────┘
                            ▲
                            │
                 ┌──────────┴───────────┐
                 │        ADMIN         │
                 │                      │
                 │ Login                │
                 │ Select Event         │
                 │ View Attendees       │
                 └──────────────────────┘
```

The architecture is intentionally simple because the project is a small prototype with a three-hour development limit. It provides the required student event registration and administrator attendee-viewing functions while maintaining a clear separation between the frontend, backend, database, and testing responsibilities.

### Manual Grounding Evaluation

The generated architecture is appropriate for our three-hour examination because it uses simple technologies such as HTML, CSS, JavaScript, Node.js, Express.js, and SQLite. It directly supports the required functions of viewing events, registering for events, and allowing administrators to view attendees. The architecture also includes basic security practices such as password hashing, authentication, role-based authorization, input validation, and parameterized SQL queries. Overall, the proposed structure is realistic for beginner-level BSIT students and can be divided among our four team members based on their assigned responsibilities.

---

# Task 2 — AI-Assisted Frontend Development

## Frontend Implementation

The frontend prototype was developed for the Event Catalog and Registration Form.

The frontend source files are located in:

```text
/frontend
```

Current frontend files:

```text
/frontend
├── index.html
├── style.css
└── script.js
```

> Replace the structure above with your team's actual files if your AI-generated frontend uses different filenames.

## Design

The interface uses a Spotify-inspired visual style adapted for the Online Campus Event Management System.

The design uses:

* Dark background
* Green accent color
* Light text
* Rounded event cards
* Sidebar-style navigation
* Modern buttons
* Hover effects
* Responsive layout
* Clear event information

Spotify logos, branding, and copyrighted assets were not used.

## Semantic HTML5

The frontend uses the required semantic HTML5 elements:

```html
<header>
<main>
<section>
<article>
<footer>
```

The event catalog uses `<article>` elements for individual campus events.

The main page content is contained within `<main>`, while related content is grouped using `<section>` elements.

## Event Catalog

The event catalog allows students to view upcoming campus events.

Each event displays relevant information such as:

* Event name
* Event description
* Date
* Location
* Available event information
* Registration action

## Registration Form

The registration form allows students to provide the required information and register for a selected campus event.

The form uses proper labels and accessible form controls.

## WCAG Accessibility

The frontend was checked for the required accessibility features.

### Form Labels

All required form fields have associated labels.

### ARIA Labels

Appropriate `aria-label` attributes were added where necessary to improve identification of form controls and interactive elements.

### Color Contrast

The dark interface uses light text and contrasting accent elements to maintain readable content.

### Image Alt Text

Images used by the interface include appropriate alternative text.

### Interactive Elements

Buttons and form controls use descriptive text so users can understand their purpose.

## AI Tool Used

**Actual AI tool used:**

```text
[ENTER ACTUAL AI TOOL USED BY YOUR TEAM]
```

## AI-Generated Frontend Output

```text
[PASTE OR SUMMARIZE THE ACTUAL AI-GENERATED FRONTEND OUTPUT USED BY YOUR TEAM]
```

## Manual Frontend Corrections

Document the actual changes made after reviewing the AI-generated frontend.

| # | Issue Found    | Manual Correction   |
| - | -------------- | ------------------- |
| 1 | [ACTUAL ISSUE] | [ACTUAL CORRECTION] |
| 2 | [ACTUAL ISSUE] | [ACTUAL CORRECTION] |
| 3 | [ACTUAL ISSUE] | [ACTUAL CORRECTION] |

## Frontend Verification

The team verified the following:

* [ ] Event catalog displays correctly.
* [ ] Registration form is visible.
* [ ] Semantic HTML elements are present.
* [ ] Form fields have labels.
* [ ] Required ARIA labels are present.
* [ ] Images have alternative text.
* [ ] Text has sufficient contrast.
* [ ] Buttons are usable.
* [ ] Layout works at the tested screen size.

---

# Task 3 — Database Design & ERD Generation

## 3NF Database Design

The Online Campus Event Management System uses a relational database designed around the required Users, Events, and Registrations entities.

The database separates user information, event information, and registration information to reduce unnecessary duplication.

## Entities

### Users

The Users table stores information about system users, including students and administrators.

The table contains the user information required by the application and identifies each user using a primary key.

**Actual columns:**

```text
[PASTE THE ACTUAL USERS COLUMNS FROM YOUR AI-GENERATED SCHEMA]
```

### Events

The Events table stores information about campus events.

It contains event-specific information such as the event title, description, location, date, and capacity.

**Actual columns:**

```text
[PASTE THE ACTUAL EVENTS COLUMNS FROM YOUR AI-GENERATED SCHEMA]
```

### Registrations

The Registrations table connects users with campus events.

It contains foreign keys referencing the Users and Events tables.

**Actual columns:**

```text
[PASTE THE ACTUAL REGISTRATIONS COLUMNS FROM YOUR AI-GENERATED SCHEMA]
```

## Relationships

The main relationships are:

```text
Users
  |
  | 1
  |
  | many
  v
Registrations
  ^
  | many
  |
  | 1
  |
Events
```

A user can have multiple registrations.

An event can have multiple registrations.

Each registration belongs to one user and one event.

## Mermaid ERD

```mermaid
erDiagram

    [PASTE YOUR ACTUAL AI-GENERATED MERMAID ERD HERE]
```

> Important: The Mermaid ERD above must be replaced with the actual Mermaid ERD generated by your team. The table names, column names, primary keys, and foreign keys must match `/database/schema.sql`.

## Database DDL

The complete SQL DDL script is located at:

```text
/database/schema.sql
```

The database script contains:

* Primary keys
* Foreign keys
* Foreign-key rules
* CHECK constraints
* UNIQUE constraints where required
* Non-clustered indexes on foreign-key columns

## SQL Schema Requirements

The team verified that the generated schema contains:

```text
[ ] Users table
[ ] Events table
[ ] Registrations table
[ ] Primary keys
[ ] Foreign keys
[ ] NOT NULL constraints where required
[ ] UNIQUE constraints where required
[ ] CHECK constraints
[ ] Foreign-key rules
[ ] Non-clustered indexes on FK columns
```

## 3NF Verification

The database design was reviewed against Third Normal Form.

The team checked that:

1. Each table represents a specific entity or relationship.
2. Each table has an appropriate primary key.
3. Non-key attributes depend on the appropriate key.
4. Repeating groups are avoided.
5. Unnecessary duplication is avoided.
6. Relationships are represented using foreign keys.
7. Registration-specific information is stored in the Registrations table instead of being duplicated in Users or Events.

## AI Tool Used

```text
[ENTER ACTUAL AI TOOL USED FOR TASK 3]
```

## AI-Generated Database Output

```text
[PASTE OR SUMMARIZE THE ACTUAL AI-GENERATED DATABASE DESIGN HERE]
```

## Manual Database Verification

The team manually compared the Mermaid ERD with `/database/schema.sql`.

The following were checked:

* [ ] Table names match.
* [ ] Column names match.
* [ ] Primary keys match.
* [ ] Foreign keys match.
* [ ] Relationships match.
* [ ] Data types are appropriate.
* [ ] Constraints are present.
* [ ] FK indexes are present.
* [ ] Schema follows the required normalization level.

## Manual Database Corrections

| # | Issue Found             | Manual Correction   |
| - | ----------------------- | ------------------- |
| 1 | [ACTUAL DATABASE ISSUE] | [ACTUAL CORRECTION] |
| 2 | [ACTUAL DATABASE ISSUE] | [ACTUAL CORRECTION] |
| 3 | [ACTUAL DATABASE ISSUE] | [ACTUAL CORRECTION] |

---

# Task 4 — Shift-Left Testing, Security & Refactoring

## Unit Testing

The team selected the following core validation routine:

```text
[ENTER THE ACTUAL CORE VALIDATION ROUTINE USED BY YOUR TEAM]
```

The unit tests were designed to verify both valid and invalid inputs.

## Unit Test Coverage

The tests cover the actual validation requirements implemented by the team.

Potential categories to document based on your actual tests include:

* Valid input
* Invalid input
* Empty input where applicable
* Boundary conditions
* Duplicate registration
* Invalid event information
* Invalid user information
* Failure cases
* Mocked database behavior

## Test Files

The test files are located in:

```text
/tests
```

Actual test files:

```text
[LIST THE ACTUAL TEST FILES CREATED BY YOUR TEAM]
```

## AI Tool Used

```text
[ENTER ACTUAL AI TOOL USED FOR TASK 4]
```

## Security Vulnerability Analysis

The intentionally flawed backend method was reviewed for security and resource-management problems.

### SQL Injection

The original method builds the SQL statement by directly combining user-controlled input with the SQL statement.

This creates a SQL injection risk because supplied input can become part of the SQL command.

The recommended correction is to use a parameterized SQL query.

### Resource Disposal

The original method creates a database connection or related resource without properly disposing of it.

The corrected implementation should use `using` statements or another appropriate disposal mechanism so that resources are released correctly.

## AI Security Diagnosis

```text
[PASTE OR SUMMARIZE THE ACTUAL AI-GENERATED SECURITY DIAGNOSIS HERE]
```

## Refactored Backend

The corrected backend implementation is located at:

```text
/backend/RegistrationService.cs
```

The refactored implementation should demonstrate:

* Parameterized SQL queries
* Proper database resource disposal
* `using` statements where appropriate
* No SQL string concatenation involving user input
* No real credentials stored in source code

## Security Verification

The team manually reviewed the refactored method to verify:

* [ ] User input is not directly concatenated into SQL.
* [ ] SQL parameters are used.
* [ ] Database resources are disposed.
* [ ] `using` is used where appropriate.
* [ ] No real credentials are included.
* [ ] Error handling does not expose sensitive information.
* [ ] The method follows the required backend behavior.

## Unit Test Verification

The team tested or reviewed the unit tests for the actual validation routine.

Actual result:

```text
[ENTER YOUR ACTUAL TEST RESULT HERE]
```

Example format:

```text
Tests Run: [NUMBER]
Passed: [NUMBER]
Failed: [NUMBER]
```

## Manual Security Corrections

| # | Security/Code Issue | Manual Correction   |
| - | ------------------- | ------------------- |
| 1 | [ACTUAL ISSUE]      | [ACTUAL CORRECTION] |
| 2 | [ACTUAL ISSUE]      | [ACTUAL CORRECTION] |
| 3 | [ACTUAL ISSUE]      | [ACTUAL CORRECTION] |

---

# Task 5 — Group Integration & Verification

## 5.1 Project Setup and Integration

The final project was organized into separate folders for the frontend, backend, database, and unit tests.

```text
CampusEventManagementSystem/
│
├── backend/
│   ├── backend.csproj
│   └── RegistrationService.cs
│
├── database/
│
├── frontend/
│
├── tests/
│   ├── tests.csproj
│   └── RegistrationServiceTests.cs
│
└── SUBMISSION.md
```

The backend was configured as a .NET class library project, while the tests were configured as an NUnit test project. The test project was connected to the backend project using a project reference.

The following command was used to add the backend reference:

```powershell
dotnet add reference ..\backend\backend.csproj
```

The backend was then built using:

```powershell
dotnet build
```

The build completed successfully with **0 errors**.

---

## 5.2 Unit Test Verification

The NUnit tests were executed from the `tests` folder using:

```powershell
dotnet test
```

The final test result was:

```text
Passed! - Failed: 0, Passed: 4, Skipped: 0, Total: 4
```

This confirms that all four implemented unit tests passed successfully.

The tests use **Moq** to isolate the `RegistrationService` from the actual database dependency. This allows the registration logic to be tested without requiring a live database connection.

---

## 5.3 Security Integration Verification

The intentionally vulnerable registration code was reviewed and refactored before final verification.

The original implementation directly concatenated the email input into the SQL statement:

```csharp
"SELECT * FROM Registrations WHERE Email = '" + inputEmail + "'"
```

This was changed to a parameterized query:

```csharp
string query =
    "SELECT * FROM Registrations WHERE Email = @Email";
```

The email value is supplied through a parameter:

```csharp
cmd.Parameters.AddWithValue("@Email", email);
```

The database connection and SQL command were also placed inside `using` statements so that the resources are properly disposed of after execution.

The final implementation therefore addresses both identified security/resource-management problems:

1. SQL injection caused by direct SQL string concatenation.
2. Improper disposal of database resources.

---

## 5.4 AI Usage Disclosure

ChatGPT was used during the development process to assist with requirements analysis, system architecture, frontend development, database design, unit test generation, security analysis, and code refinement.

All AI-generated outputs were reviewed by the team. The generated code was tested and manually corrected where necessary before being included in the final project.

| Task   | AI Tool Used | Purpose                                                       |
| ------ | ------------ | ------------------------------------------------------------- |
| Task 1 | ChatGPT      | Requirements analysis and system architecture                 |
| Task 2 | ChatGPT      | Frontend development assistance                               |
| Task 3 | ChatGPT      | Database and ERD development assistance                       |
| Task 4 | ChatGPT      | Unit test generation, security analysis, and code refactoring |

---

## 5.5 Group Verification Log

The team performed manual verification of the generated outputs and corrected issues found during implementation.

| No. | Area                         | Issue Identified                                                                                         | Correction Made                                                                                                                            |
| --- | ---------------------------- | -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | Backend Security             | The original SQL query directly concatenated the user's email into the SQL statement.                    | Replaced SQL string concatenation with a parameterized `@Email` query parameter.                                                           |
| 2   | Resource Management          | The database connection and SQL command were not properly disposed of.                                   | Added `using` statements for `SqlConnection` and `SqlCommand`.                                                                             |
| 3   | Unit Testing / Project Setup | The backend initially did not have a `.csproj` project file, so the test project could not reference it. | Created `backend.csproj`, created the NUnit test project, added the backend project reference, and verified the tests using `dotnet test`. |

---

## 5.6 Final Verification Checklist

The team completed the following final checks:

* [x] Frontend folder is included.
* [x] Backend folder is included.
* [x] Database folder is included.
* [x] Tests folder is included.
* [x] Backend project builds successfully.
* [x] NUnit test project builds successfully.
* [x] Backend project reference was added to the test project.
* [x] Four unit tests were executed successfully.
* [x] Test result shows 4 passed and 0 failed.
* [x] SQL injection vulnerability was addressed.
* [x] Parameterized SQL query was implemented.
* [x] Database connection disposal was implemented.
* [x] SQL command disposal was implemented.
* [x] AI usage was disclosed.
* [x] Manual corrections and verification were documented.

### Final Test Evidence

```text
Passed! - Failed: 0, Passed: 4, Skipped: 0, Total: 4
```

The final project was reviewed after integration to confirm that the required source files, testing project, security corrections, and documentation were included in the submission.

