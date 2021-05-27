drop database dbmsproject;
create database dbmsproject;
use dbmsproject;

create table Person
(
    PersonId   integer      not null auto_increment,
    FirstName  varchar(100) not null,
    MiddleName varchar(100) default null,
    LastName   varchar(100) not null,
    EmailId    varchar(100) not null unique,
    StreetName varchar(100) not null,
    CityName   varchar(100) not null,
    State      varchar(100) not null,
    Country    varchar(100) not null,
    PinCode    integer      not null,
    Gender     enum ('male', 'female', 'others', 'prefer not to answer'),
    primary key (PersonId)
);

create table PersonPhone
(
    PersonId    integer     not null,
    PhoneNumber varchar(10) not null,
    primary key (PersonId, PhoneNumber),
    foreign key (PersonId) references Person (PersonId)
);

create table Client
(
    ClientId    integer not null,
    Business    integer not null default 0,
    companyName varchar(100),
    primary key (ClientId),
    foreign key (ClientId) references Person (PersonId)
);

create table Project
(
    ProjectId             integer primary key not null auto_increment,
    DomainType            varchar(10)         not null,
    ProjectName           varchar(50)         not null,
    ProjectDeadline       date                not null,
    Status                varchar(20)                  default 'ASSIGNED' not null,
    ProjectDesc           varchar(100),
    ProjectSubmissionDate DATE                         default null,
    cost                  integer             not null default 0
);

create table Employee
(
    EmpId       integer primary key                                  not null,
    DomainType  varchar(10)                                          not null,
    Status      enum ('Occupied', 'Unoccupied') default 'Unoccupied' not null,
    JoiningDate DATE                                                 not null,
    LeavingDate DATE                                                 null,
    Position    enum ('Company Owner', 'Project Manager', 'Team Lead', 'General Employee'),
    DateOfBirth date                                                 not null,
    foreign key (EmpId) references Person (PersonId),
    constraint LeavingDate check (LeavingDate >= JoiningDate)
);

create table Task
(
    TaskId         integer primary key not null auto_increment,
    TaskStatus     varchar(100) default 'ASSIGNED',
    ProjectId      integer             not null,
    TaskName       varchar(50)         not null,
    TaskDeadline   date                not null,
    TaskSubmission varchar(100) default null,
    startDate      date                not null,
    endDate        date         default null,
    foreign key (ProjectId) references Project (ProjectId),
    constraint startDate check ( startDate <= TaskDeadline ) # First relationship constraint
);

create table Authentication
(
    EmailId           varchar(100) primary key not null unique, #Second constraint
    EncryptedPassword varchar(100)             not null,
    foreign key (EmailId) references Person (EmailId)
);

create table PersonAuthentication
(
    PersonId integer      not null,
    EmailId  varchar(100) not null,
    primary key (PersonId, EmailId),
    foreign key (PersonId) references Person (PersonId),
    foreign key (EmailId) references Person (EmailId)
);

create table Queries
(
    QuestionId  integer      not null UNIQUE auto_increment,
    ProjectId   integer      not null,
    Title       varchar(100) not null,
    Description varchar(100) not null,
    Resolution  varchar(100) default null,
    Status      varchar(50)  default ' OPEN ',
    primary key (QuestionId, ProjectId),
    foreign key (ProjectId) references Project (ProjectId)
);

create table PerformanceReview
(
    EmpReviewId   integer       not null,
    EmpReviewerId integer       not null,
    year          YEAR          not null,
    review        varchar(1000) not null,
    primary key (EmpReviewId, EmpReviewerId, year),
    foreign key (EmpReviewId) references Employee (EmpId),
    foreign key (EmpReviewerId) references Employee (EmpId)
);

create table Brings
(
    ClientId      integer not null,
    ProjectId     integer not null,
    ReceivingDate date    not null,
    primary key (ClientId, ProjectId),
    foreign key (ClientId) references Client (ClientId),
    foreign key (ProjectId) references Project (ProjectId)
);

create table Gets
(
    ProjectId integer not null,
    EmpId     integer not null,
    primary key (ProjectId, EmpId),
    foreign key (ProjectId) references Project (ProjectId),
    foreign key (EmpId) references Employee (EmpId)
);

create table Creates
(
    EmpId  integer not null,
    TaskId integer not null,
    primary key (EmpId, TaskId),
    foreign key (EmpId) references Employee (EmpId),
    foreign key (TaskId) references Task (TaskId)
);

create table Does
(
    EmpId  integer not null,
    TaskId integer not null,
    primary key (EmpId, TaskId),
    foreign key (EmpId) references Employee (EmpId),
    foreign key (TaskId) references Task (TaskId)
);

create table Reviews
(
    EmpId  integer not null,
    TaskId integer not null,
    primary key (EmpId, TaskId),
    foreign key (EmpId) references Employee (EmpId),
    foreign key (TaskId) references Task (TaskId)
);

create table Asks
(
    EmpId      integer not null,
    ProjectId  integer not null,
    QuestionId integer not null,
    primary key (EmpId, ProjectId, QuestionId),
    foreign key (EmpId) references Employee (EmpId),
    foreign key (ProjectId) references Project (ProjectId),
    foreign key (QuestionId) references Queries (QuestionId)
);

create table Resolves
(
    EmpId      integer not null,
    ProjectId  integer not null,
    QuestionId integer not null,
    primary key (EmpId, ProjectId, QuestionId),
    foreign key (EmpId) references Employee (EmpId),
    foreign key (ProjectId) references Project (ProjectId),
    foreign key (QuestionId) references Queries (QuestionId)
);

# Queries begins here
# Queries begins here
# Queries begins here
# Queries begins here

#WORKING HERE
Select T.TaskId,P.EmpId from Task as T, Task as D, Does as P where T.TaskId>120 && D.TaskId<121 and T.ProjectId=D.ProjectId and P.TaskId=D.TaskId;
Select * from Employee where Position=4;
Select * from Creates;
Select * from Does;

insert into Person (FirstName, LastName, StreetName, CityName, State, Country, PinCode, EmailId, Gender)
values ('Robert', 'James', 'Tale Lane', 'New York', 'Washington', 'USA', '233423', 'robert1234@gmail.com', 2);
insert into Person (FirstName, LastName, StreetName, CityName, State, Country, PinCode, EmailId, Gender)
values ('Peter', 'Erickson', 'Tale Lane', 'New York', 'Washington', 'USA', '255423', 'robert12@gmail.com', 1);
insert into Person (FirstName, LastName, StreetName, CityName, State, Country, PinCode, EmailId, Gender)
values ('Jeff', 'Bond', 'NY Street 2', 'New York', 'Washington', 'New York', '233051', 'Jeff12345@gmail.com', 3);
insert into Person (FirstName, LastName, StreetName, CityName, State, Country, PinCode, EmailId, Gender)
values ('Peter', 'Elfredo', 'Fanny Hands Lane', 'Georgia', 'USA', 'USA', '225592', 'peter9213@gmail.com', 2);
insert into Person (FirstName, LastName, StreetName, CityName, State, Country, PinCode, EmailId, Gender)
values ('Leslie', 'Calderon', 'Marietta Street', 'Bombay', 'Maharashtra', 'India', '201052', 'leslie7832@gmail.com', 1);

insert into PersonPhone
values ('1', '8287734630');
insert into PersonPhone
values ('2', '8287745362');
insert into PersonPhone
values ('3', '9823764231');
insert into PersonPhone
values ('4', '8824521346');
insert into PersonPhone
values ('5', '9812346231');

insert into Person (FirstName, LastName, Gender, EmailId, StreetName, CityName, State, Pincode, Country)
values ('Keshav', 'Gambhir', 1, 'keshav19249@iiitd.ac.in', 'Lajpat Nagar', 'New Delhi', 'Delhi', '110024', 'India');

insert into Person (FirstName, LastName, Gender, EmailId, StreetName, CityName, State, Pincode, Country)
values ('Pritish', 'Wadhwa', 1, 'pritish19440@iiitd.ac.in', 'Rohini', 'New Delhi', 'Delhi', '110034', 'India');

insert into Person (FirstName, LastName, Gender, EmailId, StreetName, CityName, State, Pincode, Country)
values ('Vinay', 'Pandey', 1, 'vinay19288@iiitd.ac.in', 'East Delhi', 'New Delhi', 'Delhi', '110034', 'India');

insert into Person (FirstName, LastName, Gender, EmailId, StreetName, CityName, State, Pincode, Country)
values ('Yash', 'Mathne', 1, 'yash19129@iiitd.ac.in', 'Dubai', 'Dubai', 'Dubai', '115634', 'India');

insert into Person (FirstName, LastName, Gender, EmailId, StreetName, CityName, State, Pincode, Country)
values ('Rasagya', 'Shokeen', 1, 'rasagya19088@iiitd.ac.in', 'Lodhi Road', 'New Delhi', 'Delhi', '110034', 'India');

insert into PersonPhone
values ('6', '9821955543');
insert into PersonPhone
values ('7', '9821956324');
insert into PersonPhone
values ('8', '9821816234');
insert into PersonPhone
values ('9', '9958344612');
insert into PersonPhone
values ('10', '8825321498');

insert into Client (ClientId, Business, companyName)
values ('1', 2500000, 'TechnoGroup');
insert into Client ()
values ('2', 50000000, 'GeeksForGeeks');
insert into Client ()
values ('3', 50512339, 'StarTech');
insert into Client ()
values ('4', 72500000, 'Verzeo');
insert into Client ()
values ('5', 25000000, 'CodingNinjas');

insert into Project (DomainType, ProjectName, ProjectDeadline, ProjectDesc)
values ('Design', 'Prj1', '2021-08-10', 'hello world project');
insert into Project (DomainType, ProjectName, ProjectDeadline, ProjectDesc)
values ('Dev-ops', 'Prj2', '2020-12-31', 'Website development for organization');
insert into Project (DomainType, ProjectName, ProjectDeadline, ProjectDesc)
values ('Tech', 'Prj3', '2020-08-30', 'App development for GoldMan Sachs');
insert into Project (DomainType, ProjectName, ProjectDeadline, ProjectDesc)
values ('Logistics', 'Prj4', '2017-05-23', 'Auditorium Development for ABCCorporation');
insert into Project (DomainType, ProjectName, ProjectDeadline, ProjectDesc)
values ('Design', 'Prj5', '2015-01-31', 'Poster and Video development for Sarthak Prayas NGO');

insert into Employee (EmpId, DomainType, JoiningDate, Position, DateOfBirth)
values (6, 'Dev', '2019-03-10', 4, '2001-05-30');

insert into Employee (EmpId, DomainType, JoiningDate, Position, DateOfBirth)
values (7, 'Design', '2018-04-11', 1, '2000-11-11');

insert into Employee (EmpId, DomainType, JoiningDate, Position, DateOfBirth)
values (8, 'Dev-ops', '2017-01-01', 2, '2001-05-23');

insert into Employee (EmpId, DomainType, JoiningDate, Position, DateOfBirth)
values (9, 'Design', '2020-04-01', 3, '2001-04-02');

insert into Employee (EmpId, DomainType, JoiningDate, Position, DateOfBirth)
values (10, 'Dev', '2018-01-01', 4, '2001-10-10');

Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-33', '2021-3-3', '2020-7-7');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-54', '2021-5-4', '2020-2-2');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-65', '2021-6-5', '2020-3-5');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-44', '2021-4-4', '2020-12-11');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-52', '2021-5-2', '2020-5-13');

Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (2,'Task-77', '2020-7-7', '2020-6-6');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (2,'Task-729', '2020-7-29', '2020-7-10');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (2,'Task-829', '2020-8-29', '2020-8-12');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (2,'Task-1212', '2020-12-12', '2020-8-4');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (2,'Task-1212', '2020-12-12', '2020-9-3');

insert into Authentication(EmailId, EncryptedPassword)
values ('robert1234@gmail.com', 'This is my password');
insert into Authentication(EmailId, EncryptedPassword)
values ('robert12@gmail.com', 'IamAlpha');
insert into Authentication(EmailId, EncryptedPassword)
values ('Jeff12345@gmail.com', 'drowssap');
insert into Authentication(EmailId, EncryptedPassword)
values ('peter9213@gmail.com', 'MahendraSinghDhoni');
insert into Authentication(EmailId, EncryptedPassword)
values ('leslie7832@gmail.com', 'YourPasswordIsIncorrect');

insert into Authentication(EmailId, EncryptedPassword)
values ('keshav19249@iiitd.ac.in', 'I dont know my password');
insert into Authentication(EmailId, EncryptedPassword)
values ('pritish19440@iiitd.ac.in', 'aSmallPassword');
insert into Authentication(EmailId, EncryptedPassword)
values ('vinay19288@iiitd.ac.in', 'quertyuiop');
insert into Authentication(EmailId, EncryptedPassword)
values ('yash19129@iiitd.ac.in', 'callmeyash');
insert into Authentication(EmailId, EncryptedPassword)
values ('rasagya19088@iiitd.ac.in', 'rockandrolll');

insert into PersonAuthentication(PersonId, EmailId)
values (1, 'robert1234@gmail.com');

insert into PersonAuthentication(PersonId, EmailId)
values (2, 'robert12@gmail.com');

insert into PersonAuthentication(PersonId, EmailId)
values (3, 'Jeff12345@gmail.com');

insert into PersonAuthentication(PersonId, EmailId)
values (4, 'peter9213@gmail.com');

insert into PersonAuthentication(PersonId, EmailId)
values (5, 'leslie7832@gmail.com');

insert into PersonAuthentication(PersonId, EmailId)
values (6, 'keshav19249@iiitd.ac.in');

insert into PersonAuthentication(PersonId, EmailId)
values (7, 'pritish19440@iiitd.ac.in');

insert into PersonAuthentication(PersonId, EmailId)
values (8, 'vinay19288@iiitd.ac.in');

insert into PersonAuthentication(PersonId, EmailId)
values (9, 'yash19129@iiitd.ac.in');

insert into PersonAuthentication(PersonId, EmailId)
values (10, 'rasagya19088@iiitd.ac.in');

insert into Queries(ProjectId, Title, Description)
values (1, 'Ambiguity in work', 'Assignment has been partially uploaded');
insert into Queries(ProjectId, Title, Description)
values (2, 'Ambiguity in design', 'Design software not suggested and do format');
insert into Queries(ProjectId, Title, Description)
values (3, 'Number of People required are not available', 'Insufficient Technicians Required');
insert into Queries(ProjectId, Title, Description)
values (4, 'Deadline Extension ', 'Please provide a deadline Extension');

insert into Brings (ClientId, ProjectId, ReceivingDate)
values (1, 1, '2020-1-1');

insert into Brings (ClientId, ProjectId, ReceivingDate)
values (2, 2, '2020-5-23');

insert into Brings (clientid, projectid, ReceivingDate)
values (3, 3, '2020-4-20');

insert into Brings (clientid, projectid, ReceivingDate)
values (4, 4, '2020-6-6');

insert into Brings (clientid, projectid, ReceivingDate)
values (5, 5, '2020-7-5');

insert into gets(ProjectId, EmpId)
values (1, 8);
insert into gets(ProjectId, EmpId)
values (2, 8);
insert into gets(ProjectId, EmpId)
values (3, 8);
insert into gets(ProjectId, EmpId)
values (4, 8);
insert into gets(ProjectId, EmpId)
values (5, 8);

UPDATE Employee
Set Status='Occupied'
where EmpId in (Select EmpId from Gets);

insert into Creates(EmpId, TaskId)
values (8, 1);
insert into Creates(EmpId, TaskId)
values (8, 2);
insert into Creates(EmpId, TaskId)
values (8, 3);
insert into Creates(EmpId, TaskId)
values (8, 4);
insert into Creates(EmpId, TaskId)
values (8, 5);

insert into Creates(EmpId, TaskId)
values (8, 6);
insert into Creates(EmpId, TaskId)
values (8, 7);
insert into Creates(EmpId, TaskId)
values (8, 8);
insert into Creates(EmpId, TaskId)
values (8, 9);
insert into Creates(EmpId, TaskId)
values (8, 10);

insert into does(EmpId, TaskId)
values (9, 1);
insert into does(EmpId, TaskId)
values (9, 2);
insert into does(EmpId, TaskId)
values (9, 3);
insert into does(EmpId, TaskId)
values (9, 4);
insert into does(EmpId, TaskId)
values (9, 5);

insert into does(EmpId, TaskId)
values (6, 6);
insert into does(EmpId, TaskId)
values (10, 6);

insert into does(EmpId, TaskId)
values (6, 7);
insert into does(EmpId, TaskId)
values (10, 7);

insert into does(EmpId, TaskId)
values (6, 8);
insert into does(EmpId, TaskId)
values (10, 8);

insert into does(EmpId, TaskId)
values (10, 9);
insert into does(EmpId, TaskId)
values (10, 10);
UPDATE Employee
Set Status='Occupied'
where EmpId in (Select EmpId from does);

insert into asks(EmpId, ProjectId, QuestionId)
values (8, 1, 1);
insert into asks(EmpId, ProjectId, QuestionId)
values (8, 2, 2);
insert into asks(EmpId, ProjectId, QuestionId)
values (8, 3, 3);
insert into asks(EmpId, ProjectId, QuestionId)
values (8, 4, 4);


# Query for authentication
# Authentication of a person
Select *
from Authentication;
Select *
from Authentication as EmailCheck
where EmailId = 'vinay19288@iiitd.ac.in'
  and EncryptedPassword = 'quertyuiop';
Select *
from Person as P,
     Employee as E,
     Authentication as A
where P.PersonId = E.EmpId
  and P.EmailId = 'vinay19288@iiitd.ac.in'
  and P.EmailId = A.EmailId;


#INSERT QUERIES BEGINS HERE
#INSERT QUERIES BEGINS HERE
#INSERT QUERIES BEGINS HERE
#INSERT QUERIES BEGINS HERE
#INSERT QUERIES BEGINS HERE

#INSERT QUERIES FOR TEAM LEADS
#INSERT QUERIES FOR TEAM LEADS
#INSERT QUERIES FOR TEAM LEADS
#INSERT QUERIES FOR TEAM LEADS
#INSERT QUERIES FOR TEAM LEADS

#1
#Breakdown a task into smaller tasks and assign it automatically to some employee
Select *
from Employee
where Status = 'Unoccupied';
INSERT into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-22', '2021-2-2', '2020-8-8');
INSERT into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-44', '2021-4-4', '2020-5-23');
INSERT into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-61', '2021-6-1', '2020-8-8');
INSERT into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-329', '2021-3-29', '2020-12-20');
INSERT into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (1,'Task-430', '2021-4-30', '2020-8-20');

Insert Into Creates(EmpId, TaskId)
values (9, 11);
Insert Into Creates(EmpId, TaskId)
values (9, 12);
Insert Into Creates(EmpId, TaskId)
values (9, 13);
Insert Into Creates(EmpId, TaskId)
values (9, 14);
Insert Into Creates(EmpId, TaskId)
values (9, 15);

Insert Into Does(EmpId, TaskId)
values (6, 11);
Insert Into Does(EmpId, TaskId)
values (6, 12);
Insert Into Does(EmpId, TaskId)
values (6, 13);
Insert Into Does(EmpId, TaskId)
values (6, 14);
Insert Into Does(EmpId, TaskId)
values (6, 15);

Insert Into Does(EmpId, TaskId)
values (10, 11);
Insert Into Does(EmpId, TaskId)
values (10, 12);
Insert Into Does(EmpId, TaskId)
values (10, 13);
Insert Into Does(EmpId, TaskId)
values (10, 14);
Insert Into Does(EmpId, TaskId)
values (10, 15);

UPDATE Employee
Set Status='Occupied'
where EmpId in (Select EmpId from Does);


#INSERT QUERIES FOR PROJECT MANAGER
#INSERT QUERIES FOR PROJECT MANAGER
#INSERT QUERIES FOR PROJECT MANAGER
#INSERT QUERIES FOR PROJECT MANAGER
#INSERT QUERIES FOR PROJECT MANAGER

#1
#Creating a task and assigning it to some employee(automatic) from Project Manager
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (4,'Task-220', '2017-2-20', '2016-12-12');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (4,'Task-131', '2017-1-31', '2016-11-2');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (4,'Task-1220', '2016-12-20', '2016-1-17');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (4,'Task-1225', '2016-12-25', '2016-6-22');
Insert into Task(ProjectId, TaskName, TaskDeadline, startDate)
values (4,'Task-113', '2017-1-13', '2016-4-25');

Insert into Creates(EmpId, TaskId)
values (8, 16);
Insert into Creates(EmpId, TaskId)
values (8, 17);
Insert into Creates(EmpId, TaskId)
values (8, 18);
Insert into Creates(EmpId, TaskId)
values (8, 19);
Insert into Creates(EmpId, TaskId)
values (8, 20);

Select *
from Employee
where Status = 'Unoccupied'
  and Position > 2;

Insert into Does(EmpId, TaskId)
values (9, 16);
Insert into Does(EmpId, TaskId)
values (9, 17);
Insert into Does(EmpId, TaskId)
values (9, 18);
Insert into Does(EmpId, TaskId)
values (9, 19);
Insert into Does(EmpId, TaskId)
values (9, 20);

UPDATE Employee
Set Status='Occupied'
where EmpId in (Select EmpId from Does);

#3
#Employees for which project manager can take the review and their reviews
Select *
from Employee
where Position > 2;

Insert into Reviews(EmpId, TaskId)
values (8, 1);
Insert into Reviews(EmpId, TaskId)
values (8, 2);
Insert into Reviews(EmpId, TaskId)
values (8, 3);
Insert into Reviews(EmpId, TaskId)
values (8, 4);
Insert into Reviews(EmpId, TaskId)
values (8, 5);
Insert into Reviews(EmpId, TaskId)
values (8, 6);
Insert into Reviews(EmpId, TaskId)
values (8, 7);
Insert into Reviews(EmpId, TaskId)
values (8, 8);
Insert into Reviews(EmpId, TaskId)
values (8, 9);
Insert into Reviews(EmpId, TaskId)
values (8, 10);

Insert into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (9, 8, 2021, 'Remained inactive for more than 2 months');
Insert into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (9, 8, 2020, 'Work done casually');
Insert into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (10, 8, 2020, 'Missed 3 deadlines');
Insert into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (10, 8, 2021, 'Excellent Work- Consider for promotion');
Insert into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (6, 8, 2021, 'Did a good job');

#4
#Answering queries related to the project which have been assigned to this project manager

Select *
from Queries as Q,
     Gets as G
where Q.ProjectId = G.ProjectId
    and G.EmpId=8;

Select * from Queries as Q where Q.QuestionId in(Select Q.QuestionId
from Queries as Q,
     Gets as G
where Q.ProjectId = G.ProjectId
    and G.EmpId=8) and Q.QuestionId=5 and Q.status='OPEN';

#Answering queries related to the project which have been assigned to this project manager
Update Queries
Set Resolution='Ask again for submission',
    Status='Closed'
where QuestionId = 1;
Update Queries
Set Resolution='Use Adobe Express',
    Status='Closed'
where QuestionId = 2;

Insert into resolves(EmpId, ProjectId, QuestionId)
values (8, 1, 1);
Insert into resolves(EmpId, ProjectId, QuestionId)
values (8, 2, 2);


#5
#Raise some queries related to the project.
Insert into Queries(ProjectId, Title, Description)
values (4, 'Project203', 'Final Goal still unclear even after reading the brochure');
Insert into Queries(ProjectId, Title, Description)
values (5, 'Project611', 'Requires more manforce as compared to other projects');

insert into asks(EmpId, ProjectId, QuestionId)
values (8, 4, 5);
insert into asks(EmpId, ProjectId, QuestionId)
values (8, 5, 6);

#10
#Update the deadline for a specific task
Update Task
Set Task.TaskDeadline = '2021-7-12'
where TaskId = 3;


#INSERT QUERIES FOR TEAM LEADS
#INSERT QUERIES FOR TEAM LEADS
#INSERT QUERIES FOR TEAM LEADS
#INSERT QUERIES FOR TEAM LEADS
#INSERT QUERIES FOR TEAM LEADS

#3
#Employees for which team lead can take the review and their reviews
Select *
from Employee
where Position > 3;

Insert into reviews(EmpId, TaskId)
values (9, 6);
Insert into reviews(EmpId, TaskId)
values (9, 7);
Insert into reviews(EmpId, TaskId)
values (9, 8);
Insert into reviews(EmpId, TaskId)
values (9, 9);
Insert into reviews(EmpId, TaskId)
values (9, 10);
Insert into reviews(EmpId, TaskId)
values (9, 11);
Insert into reviews(EmpId, TaskId)
values (9, 12);
Insert into reviews(EmpId, TaskId)
values (9, 13);
Insert into reviews(EmpId, TaskId)
values (9, 14);
Insert into reviews(EmpId, TaskId)
values (9, 15);
Insert into reviews(EmpId, TaskId)
values (9, 16);

INSERT into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (10, 9, 2021, 'Did a great job for the company');
INSERT into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (10, 9, 2020, 'Improved from previous year');
INSERT into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (6, 9, 2021, 'Good work');
INSERT into performancereview(EmpReviewId, EmpReviewerId, year, review)
values (6, 9, 2020, 'Did not complete few deadlines on time');


#4
#Raise some queries related to the project
Select *
from Task;
Insert into queries(ProjectId, Title, Description)
values (1, 'Design Team not recruited', 'Manpower of atleast 20 designers is required');
Insert into asks(EmpId, ProjectId, QuestionId)
values (9, 1, 7);

#5
#Answering queries related to the project which have been assigned to this project manager
Select *
from Queries as Q
where Q.ProjectId in (Select ProjectId
                      from Task as T,
                           Does as D
                      where T.TaskId = D.TaskId
                        and D.EmpId = 9);
Update Queries
Set Resolution='Read the updated brochure',
    Status='Closed'
where QuestionId = 5;
Insert into resolves(EmpId, ProjectId, QuestionId)
values (9, 1, 5);

#9
#Update the deadline for a specific task
Update Task
Set TaskDeadline = '2021-1-31'
where TaskId = 11;

#INSERT QUERIES FOR COMPANY OWNER
#INSERT QUERIES FOR COMPANY OWNER
#INSERT QUERIES FOR COMPANY OWNER
#INSERT QUERIES FOR COMPANY OWNER
#INSERT QUERIES FOR COMPANY OWNER

# 3
insert into performancereview(EmpReviewId, EmpReviewerId, year, review) value (8, 7, 2021, 'This is a performance review');
insert into performancereview(EmpReviewId, EmpReviewerId, year, review) value (8, 7, 2020, 'Fabulous Job');

# 4
insert into Project (DomainType, ProjectName, ProjectDeadline, Status, ProjectDesc, ProjectSubmissionDate,
                     cost) VALUE ('Dev', 'TestProj', '2021-04-10', 'Assigned', 'This is a test project', '2021-05-10',
                                  1000);
insert into brings(ClientId, ProjectId, ReceivingDate)
values (2, 6, '2019-10-10');
insert into gets(ProjectId, EmpId)
values (6, 8);
Update Employee
Set Status='Occupied'
where EmpId in (Select EmpId from Gets);

#INSERT QUERIES FOR EMPLOYEE
#INSERT QUERIES FOR EMPLOYEE
#INSERT QUERIES FOR EMPLOYEE
#INSERT QUERIES FOR EMPLOYEE
#INSERT QUERIES FOR EMPLOYEE


# 1
update Task
set TaskStatus    = 'DONE',
    endDate       = curdate(),
    TaskSubmission='drive.google.com/aadgw213123?=1231'
where taskId = 6;

update Task
set TaskStatus    = 'DONE',
    endDate       = curdate(),
    TaskSubmission='drive.google.com/aadgw213123?=1231'
where taskId = 7;

update Task
set TaskStatus    = 'DONE',
    endDate       = curdate(),
    TaskSubmission='drive.google.com/aadgw213123?=1231'
where taskId = 8;

DELETE
from Does
WHERE EmpId = 6
  and TaskId = 6;

DELETE
from Does
WHERE EmpId = 6
  and TaskId = 7;

DELETE
from Does
WHERE EmpId = 6
  and TaskId = 8;

# 2
insert into Queries (ProjectId, Title, Description, Status) value (1, 'Doubt', 'This is a test doubt', 'OPEN');

insert into asks (EmpId, ProjectId, QuestionId) value (6, 1, 8);


# 3
update Queries
set Resolution = 'This is a resolution to query 1',
    Status     = 'CLOSED'
where QuestionId = 8;
insert into resolves (EmpId, ProjectId, QuestionId) VALUE (6, 1, 8);

#INSERT QUERIES ENDS
#INSERT QUERIES ENDS
#INSERT QUERIES ENDS
#INSERT QUERIES ENDS
#INSERT QUERIES ENDS

#INDEXING
#INDEXING
#INDEXING
#INDEXING
#INDEXING

#index tables
create index Project_ProjectID_Index on Project (ProjectId);
create index Project_Status_Index on Project (Status);
create index Project_ProjectDeadline_Index on Project (ProjectDeadline);
create index Gets_ProjectID_Index on Gets (ProjectId);
create index Task_TaskID_Index on Task (TaskId);
create index Task_TaskStatus_Index on Task (TaskStatus);
create index Task_ProjectID_Index on Task (ProjectId);
create index Creates_TaskID_Index on Creates (TaskId);
create index Does_TaskID_Index on Does (TaskId);
create index Does_EmpID_Index on Does (EmpId);
create index Employee_EmpID_Index on Employee (EmpId);
create index Employee_Position_Index on Employee (Position);
create index Employee_DomainType_Index on Employee (DomainType);
create index Person_PersonID_Index on Person (PersonId);
create index Person_EmailId_Index on Person (EmailId);
create index Client_ClientID_Index on Client (ClientId);
create index Asks_QuestionID_Index on Asks (QuestionId);
create index Brings_ProjectID_Index on Brings (ProjectId);
create index Brings_ClientID_Index on Brings (ClientId);
create index Authentication_EmailId_Index on Authentication (EmailId);

#SELECT QUERIES BEGINS HERE
#SELECT QUERIES BEGINS HERE
#SELECT QUERIES BEGINS HERE
#SELECT QUERIES BEGINS HERE
#SELECT QUERIES BEGINS HERE


#SELECT QUERIES FOR PROJECT MANAGER
#SELECT QUERIES FOR PROJECT MANAGER
#SELECT QUERIES FOR PROJECT MANAGER
#SELECT QUERIES FOR PROJECT MANAGER
#SELECT QUERIES FOR PROJECT MANAGER

#Some general queries
#Projects assigned to project managers
Select *
from Task as T,
     Does as D,
     Employee as E
where T.TaskId = D.TaskId
  and D.EmpId = E.EmpId
  and D.EmpId = 9;

#Tasks assigned to team lead
Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission
from Task as T,
     Does as D
where D.TaskId = T.TaskId
  and D.EmpId = 9
ORDER BY TaskDeadline;

#Viewing the current tasks on the basis of deadline
Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission, T.ProjectId
from Task as T,
     Does as D
where D.TaskId = T.TaskId
  and D.EmpId = 9
ORDER BY ProjectId;

#Sort tasks on the basis of projects to which they belong
Select *
from Person as P,
     Employee as E
where P.PersonId = E.EmpId
  and E.EmpId in (Select D.EmpId
                  from Task as T,
                       Creates as C,
                       Does as D
                  where T.TaskId = C.TaskId
                    and D.TaskId = T.TaskId
                    and C.EmpId = 9);

#2
#Employees working under team leads and their respective submission
Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission
from Task as T,
     Creates as C,
     Does as D
where T.TaskId = C.TaskId
  and D.TaskId = T.TaskId
  and C.EmpId = 9;

#6
#Viewing an employees work
Select *
from Employee
where Status = 'Unoccupied';

#7
#Get a list of all the free employees
Select *
from Task as T,
     Does as D,
     Employee as E
where T.TaskId = D.TaskId
  and D.EmpId = E.EmpId
  and T.TaskDeadline < T.endDate;

#8
#Record of Employees who havent met their deadline
select FirstName, LastName, Employee.position
from person,
     Employee
where Person.PersonId = Employee.EmpId
  and Employee.Position = 'General Employee';

#SELECT Queries for Company Owner
#SELECT Queries for Company Owner
#SELECT Queries for Company Owner
#SELECT Queries for Company Owner
#SELECT Queries for Company Owner


# 1
select FirstName, LastName, Employee.JoiningDate
from person,
     Employee
where Person.PersonId = Employee.EmpId
  and Employee.JoiningDate = '2019-03-10';

select FirstName, LastName, Employee.DomainType
from person,
     Employee
where Person.PersonId = Employee.EmpId
  and Employee.DomainType = 'Dev';

select Employee.EmpId, FirstName, LastName
from person,
     Employee
where Person.PersonId = Employee.EmpId
  and Employee.EmpId = '6';

select *
from Project
where Status = 'ASSIGNED';

# 2
select *
from Project
where Status = 'DONE';
select *
from Project
where Status = 'Assigned';

# 5
select SUM(cost)
from Project
where ProjectDeadline between '2019-01-01' and '2021-06-30';

# 6
select *
from Project
where ProjectId = 5;

# 7
select abs(datediff(curdate(), ProjectDeadline))
from Project
where ProjectId = 1;

select cast(
               (select count(ALL TaskId)
                from task
                where ProjectId = 1
                  and TaskStatus = 'ASSIGNED') as float) /
       cast(
               (select count(ALL TaskId)
                from task
                where ProjectId = 1) as float) as totalWorkRemaing;

select cast(
               (select count(ALL TaskId)
                from task
                where ProjectId = 1
                  and TaskStatus = 'DONE') as float) /
       cast(
               (select count(ALL TaskId)
                from task
                where ProjectId = 1) as float) as totalWorkRemaing;


select ClientId,
       companyName,
       FirstName,
       LastName,
       EmailId,
       State,
       Country,
       Business
from Client,
     person
where Client.ClientId = Person.PersonId
order by Client.Business DESC;

# 8
select Task.TaskId, Task.TaskStatus, Task.ProjectId, Task.TaskDeadline
from Task,
     Does,
     Employee
where Employee.EmpId = 6
  and Employee.EmpId = Does.EmpId
  and Does.TaskId = Task.TaskId;

#SELECT Queries for an Employee
#SELECT Queries for an Employee
#SELECT Queries for an Employee
#SELECT Queries for an Employee
#SELECT Queries for an Employee


# 4
select Project.ProjectDesc
from Project,
     Task,
     Does,
     Employee
where Employee.EmpId = 6
  and Employee.EmpId = Does.EmpId
  and Does.TaskId = Task.TaskId
  and Task.ProjectId = Project.ProjectId;

# 5
select Description, Resolution, Status
from Queries
where ProjectId = 3;

# 6
select EmpId, Description, Resolution, Status
from Queries,
     asks
where Asks.EmpId = 6
  and Asks.QuestionId = Queries.QuestionId;

# 7
Select *
from Project as P,
     Brings as B,
     Client as C
where P.ProjectId = B.ProjectId
  and B.ClientId = C.ClientId
  and C.ClientId = 1;

#SELECT Queries for Client
#SELECT Queries for Client
#SELECT Queries for Client
#SELECT Queries for Client
#SELECT Queries for Client

#1
Select *
from Authentication;

#2
Select *
from Authentication as EmailCheck
where EmailId = 'Jeff12345@gmail.com'
  and EncryptedPassword = 'drowssap';

Select *
from Person as P,
     Authentication as A
where P.EmailId = 'Jeff12345@gmail.com'
  and P.EmailId = A.EmailId;

Select *
from Project as P,
     Brings as B,
     Client as C
where P.ProjectId = B.ProjectId
  and B.ClientId = C.ClientId
  and C.ClientId = 1;

#3
Select Sum(P.cost)
from Project as P,
     Brings as B,
     Client as C
where P.ProjectId = B.ProjectId
  and B.ClientId = C.ClientId
  and C.ClientId = 1;

#4
select cast((Select Count(*)
             from Project as P,
                  Brings as B,
                  Client as C
             where P.ProjectId = B.ProjectId
               and B.ClientId = C.ClientId
               and C.ClientId = 1
               and P.Status != 'ASSIGNED') as float) / cast((Select Count(*)
                                                             from Project as P,
                                                                  Brings as B,
                                                                  Client as C
                                                             where P.ProjectId = B.ProjectId
                                                               and B.ClientId = C.ClientId
                                                               and C.ClientId = 1) as float) * 100 as totalWorkRemaing;

#5
Select *
from Project as P,
     Gets as G
where P.ProjectId = G.ProjectId
  and G.EmpId = 8;


#2
#Employees working under project manager
Select *
from Does;

Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission
from Task as T,
     Creates as C,
     Does as D
where T.TaskId = C.TaskId
  and D.TaskId = T.TaskId
  and C.EmpId = 8;

#In case task is rejected
Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission
from Task as T,
     Creates as C,
     Does as D
where T.TaskId = C.TaskId
  and D.TaskId = T.TaskId
  and C.EmpId = 8 and T.TaskStatus='DONE';

Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission
from Task as T,
     Creates as C,
     Does as D
where T.TaskId = C.TaskId
  and D.TaskId = T.TaskId
  and C.EmpId = 8 and T.TaskStatus='DONE' and T.TaskId='6';

# UPDATE TASK Set TaskStatus='Assigned' where TaskId=6;
# Insert Into Does(EMPID, TASKID) values(10,6);
#
# UPDATE TASK Set TaskStatus='Assigned' where TaskId=7;
# Insert Into Does(EMPID, TASKID) values(10,7);
#
# UPDATE TASK Set TaskStatus='Assigned' where TaskId=8;
# Insert Into Does(EMPID, TASKID) values(10,8);

#6
#Viewing previous tasks
Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission
from Task as T,
     Creates as C,
     Does as D
where T.TaskId = C.TaskId
  and D.TaskId = T.TaskId
  and C.EmpId = 8;



#7
#Viewing the current tasks on the basis of deadline
Select *
from (Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission
      from Task as T,
           Creates as C,
           Does as D
      where T.TaskId = C.TaskId
        and D.TaskId = T.TaskId
        and C.EmpId = 8) as TaskManage
ORDER BY TaskDeadline;


#8
#Sort tasks on the basis of projects to which they belong
Select *
from (Select D.EmpId, T.TaskId, T.TaskDeadline, T.TaskStatus, T.TaskSubmission, T.ProjectId
      from Task as T,
           Creates as C,
           Does as D
      where T.TaskId = C.TaskId
        and D.TaskId = T.TaskId
        and C.EmpId = 8) as TaskManage
ORDER BY ProjectId;

#9
#View the details of all the team leads working on a specific project
Select *
from Person as P
where PersonId in (Select P.PersonId
                   from Person as P,
                        Task as T,
                        Creates as C,
                        Does as D
                   where T.TaskId = C.TaskId
                     and D.TaskId = T.TaskId
                     and P.PersonId = D.EmpId
                     and C.EmpId = 8
                   ORDER BY P.PersonId);

#SELECT QUERIES FOR TEAM LEAD
#SELECT QUERIES FOR TEAM LEAD
#SELECT QUERIES FOR TEAM LEAD
#SELECT QUERIES FOR TEAM LEAD
#SELECT QUERIES FOR TEAM LEAD

#Some general queries

#queries for all team leads
Select *
from Employee
where Position = 3;
