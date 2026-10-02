# Online Campus Event Management System

## Team Roster

| Member             | Role                            |
| ------------------ | ------------------------------- |
| Jurggen Donato     | Systems Architect & Prompt Lead |
| Yuan Anakin Galeon | Frontend Engineer               |
| Jann Paul Guingab  | Database & Backend Engineer     |
| Ralph Atienza      | QA & Security Engineer          |

## Task 1

### RCTC Prompt

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

### AI-Generated Architecture

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
          Login / Register         Events / Registration
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

#### Recommended Technology Stack

| Layer           | Technology            | Responsibility                          |
| --------------- | --------------------- | --------------------------------------- |
| Frontend        | HTML, CSS, JavaScript | User interface and user interaction     |
| Backend         | Node.js + Express.js  | API, business logic, and authentication |
| Database        | SQLite                | Store users, events, and registrations  |
| Testing         | Jest + Supertest      | Backend and API testing                 |
| Development     | Visual Studio Code    | Development environment                 |
| Version Control | Git + GitHub          | Shared source code and version control  |

This stack is appropriate for the examination because it avoids unnecessary complexity. SQLite does not require a separate database server, while Express.js provides a simple way to create the backend API. Plain HTML, CSS, and JavaScript also avoid the need for a frontend framework or third-party state-management library.

#### Major System Components

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

#### Backend API

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

#### Database Design

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
Events
```

A student can register for multiple events, while an event can have multiple registered students. The `Registrations` table connects users and events.

#### Student Event Viewing Data Flow

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

#### Student Registration Data Flow

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

#### Administrator Attendee Data Flow

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

#### Basic Security Practices

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

#### Simple Project Structure

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

#### Responsibility Separation

| Component | Responsibility                                                                        |
| --------- | ------------------------------------------------------------------------------------- |
| Frontend  | Display information, collect input, send API requests, and display responses          |
| Backend   | Authentication, authorization, validation, business logic, and database communication |
| Database  | Store users, events, registrations, and maintain relationships                        |
| Testing   | Test authentication, events, registration, authorization, and attendee viewing        |

#### Three-Hour Implementation Plan

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

#### Final Architecture

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
