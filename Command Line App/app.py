from pyfiglet import Figlet
from termcolor import colored, cprint
from PyInquirer import style_from_dict, Token, prompt
from PyInquirer import Validator, ValidationError
from prettytable import PrettyTable
from datetime import datetime
import mysql.connector

import regex
from os import system
import shutil

def print_centre(s, color):
    cprint(s.center(shutil.get_terminal_size().columns), color)

def renderCenter(ftext, color):
    for x in ftext.split("\n"):
        cprint(x.center(shutil.get_terminal_size().columns), color)

style = style_from_dict({
    Token.QuestionMark: '#FF9D00 bold',
    Token.Selected: '#5F819D bold',
    Token.Pointer: '#FF9D00 bold',
    Token.Instruction: '',  # default
    Token.Answer: '#5F819D bold',
    Token.Question: '',
})

class EmailValidator(Validator):
    def validate(self, document):
        ok = regex.match('^(\w|\.|\_|\-)+[@](\w|\_|\-|\.)+[.]\w{2,3}$', document.text)
        if not ok:
            raise ValidationError(
                message='Please enter a valid email address',
                cursor_position=len(document.text))

class DateValidator(Validator):
    def validate(self, document):
        ok = regex.match('^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$', document.text)
        if not ok:
            raise ValidationError(
                message="Enter date in yyyy-mm-dd format",
                cursor_position=len(document.text))

class projectManagerValidator(Validator):
    def validate(self, document):
        if(document.text.isnumeric() == False):
            raise ValidationError(
                message='Please enter a numeric value',
                cursor_position=len(document.text))
        mycursor.execute("select * from person,Employee where Person.PersonId = Employee.EmpId and Employee.EmpId='" + document.text + "' and Employee.Position='Project Manager';")
        if(mycursor.rowcount == 0):
            raise ValidationError(
                message="Given employee ID doesn't belong to a Project Manager",
                cursor_position=len(document.text))

class teamLeadValidator(Validator):
    def validate(self, document):
        if(document.text.isnumeric() == False):
            raise ValidationError(
                message='Please enter a numeric value',
                cursor_position=len(document.text))
        mycursor.execute("select * from person,Employee where Person.PersonId = Employee.EmpId and Employee.EmpId='" + document.text + "' and Employee.Position='Team Lead';")
        if(mycursor.rowcount == 0):
            raise ValidationError(
                message="Given employee ID doesn't belong to a Team Lead",
                cursor_position=len(document.text))

class queryNumberValidator(Validator):
    def validate(self, document):
        if(document.text.isnumeric() == False):
            raise ValidationError(
                message='Please enter a numeric value',
                cursor_position=len(document.text))
        mycursor.execute("select * from gets where ProjectID = Employee.EmpId and Employee.EmpId='" + document.text + "' and Employee.Position='Team Lead';")
        # if(mycursor.rowcount == 0):
        #     raise ValidationError(
        #         message="Given employee ID doesn't belong to a Team Lead",
        #         cursor_position=len(document.text))

class projectManagerProjectValidator(Validator):
    def validate(self, document):
        if(document.text.isnumeric() == False):
            raise ValidationError(
                message='Please enter a numeric value',
                cursor_position=len(document.text))
        mycursor.execute("select * from gets where ProjectID='" + document.text + "'")
        if(mycursor.rowcount == 0):
            raise ValidationError(
                message="Given Project ID doesn't belong to a Project",
                cursor_position=len(document.text))

figfont = Figlet(font='standard')
sfigfont = Figlet(font='small')


def clear():
    _ = system('clear')

mydb=mysql.connector.connect(host="localhost",user="root",passwd="12345678" ,database = "dbmsproject")
mycursor = mydb.cursor(buffered=True)

confirm = [{
        'type': 'input',
        'message': 'Press any key to go back',
        'name': 'back',
        'default': "",
        'validate': lambda val: val != "" or "Enter any key to go back"
    }]
    

#START OF CODE
def loginPage(message):
    clear()
    renderCenter(figfont.renderText('Taskque'), 'green');
    if(message):
        print_centre(message, 'red')
    page1 = [
        {
            'type': 'list',
            'name': 'type',
            'message': 'Sign In or Quit',
            'choices': ['Sign In', 'Quit'],
            'filter': lambda val: val.lower()
        },
        {
            'when': lambda answers: 'type' in answers and answers['type'] == 'sign in',
            'type': 'input',
            'name': 'email',
            'message': 'What\'s your emailID?',
            'default': 'vinay19288@iiitd.ac.in',
            'validate': EmailValidator
        },
        {
            'when': lambda answers: 'type' in answers and answers['type'] == 'sign in',
            'type': 'password',
            'name': 'password',
            'default': 'quertyuiop',
            'message': 'What\'s your password?',
        }
    ]
    answers = prompt(page1, style=style)
    if(answers.get('type') == 'quit'):
        exit()
    mycursor.execute("Select * from Authentication as EmailCheck where EmailId='" + answers.get("email") +  "' and EncryptedPassword='" + answers.get("password") + "';")
    myresult = mycursor.fetchall()
    if not myresult:
        loginPage("Incorrect information, please try again!")
    else:
        mycursor.execute("Select * from Person as P, Employee as E, Authentication as A where P.PersonId=E.EmpId and P.EmailId='"+ answers.get('email') + "' and P.EmailId=A.EmailId;")
        myresult = mycursor.fetchone()
        if not myresult:
            loginPage("Error: Database query returned empty. Login again.")
        else:
            directRole(myresult)


def directRole(pobj):
    clear()
    renderCenter(figfont.renderText('Taskque'), 'green');
    print_centre("Welcome " + pobj[1] + " " + pobj[3] + "!", 'yellow')
    if(pobj[16] == 'Company Owner'):
        companyOwner(pobj)
    elif(pobj[16] == 'Team Lead'):
        teamLead(pobj)
    elif(pobj[16] == 'General Employee'):
        generalEmployee(pobj)
    elif(pobj[16] == 'Project Manager'):
        projectManager(pobj)
    else:
        loginPage("Error: Invalid employee type in database, login again.")


def companyOwner(pobj):
    questions = [
        {
            'type': 'list',
            'name': 'action',
            'message': 'Select Action',
            'choices': [
                'Access Employee Database',
                'View Employee Information',
                'View Client Projects',
                'Review Of Project Manager',
                'Register Project From Client',
                'Revenue Analysis',
                'Comprehensive Project Report',
                'Business Done By Clients',
                'Logout'
                ]
        },
        {
            'type': 'list',
            'name': 'databaseFilter',
            'message': 'Filter By',
            'choices': ['Position', 'Domain Type', 'Joining Date'],
            'when': lambda answers: answers['action'] == 'Access Employee Database'
        },
        {
            'type': 'list',
            'name': 'positionFilter',
            'message': 'Select Position',
            'choices': ['Project Manager', 'Team Lead', 'General Employee'],
            'when': lambda answers: 'databaseFilter' in answers and answers['databaseFilter'] == 'Position'
        },
        {
            'type': 'input',
            'name': 'joiningFilter1',
            'message': 'Enter Start Joining Date',
            'when': lambda answers: 'databaseFilter' in answers and answers['databaseFilter'] == 'Joining Date',
            'validate': DateValidator
        },
        {
            'type': 'input',
            'name': 'joiningFilter2',
            'message': 'Enter End Joining Date',
            'when': lambda answers: 'databaseFilter' in answers and answers['databaseFilter'] == 'Joining Date',
            'validate': DateValidator
        },
        {
            'type': 'list',
            'name': 'domainFilter',
            'message': 'Select Domain',
            'choices': ['Dev', 'Design', 'Dev Ops', 'Tech', 'Logistics'],
            'when': lambda answers: 'databaseFilter' in answers and answers['databaseFilter'] == 'Domain Type' 
        },
        {
            'type': 'input',
            'name': 'employeeSearchID',
            'message': 'Enter EmployeeID:',
            'when': lambda answers: answers['action'] == 'View Employee Information',
            'validate': lambda val: val.isnumeric() or "Enter Valid Employee ID"
        },
        {
            'type': 'list',
            'name': 'projectView',
            'message': 'Select Project Category',
            'choices': ['Past', 'Current'],
            'when': lambda answers: answers['action'] == 'View Client Projects'
        },
        {
            'type': 'input',
            'name': 'projectManagerID',
            'message': 'Provide Project Manager ID -',
            'when': lambda answers: answers['action'] == 'Review Of Project Manager',
            'validate': projectManagerValidator
        },
        {
            'type': 'input',
            'name': 'projectManagerReview',
            'message': 'Enter Performance Review -',
            'when': lambda answers: 'projectManagerID' in answers,
        },
        {
            'type': 'list',
            'name': 'newProjectDomain',
            'message': 'Select Domain',
            'choices': ['Dev', 'Design', 'Dev Ops', 'Tech', 'Logistics'],
            'when': lambda answers: answers['action'] == 'Register Project From Client',
        },
        {
            'type': 'input',
            'name': 'newProjectName',
            'message': 'Enter Project Name:',
            'when': lambda answers: answers['action'] == 'Register Project From Client',
        },
        {
            'type': 'input',
            'name': 'newProjectDesc',
            'message': 'Enter Small Project Description:',
            'when': lambda answers: answers['action'] == 'Register Project From Client',
        },
        {
            'type': 'input',
            'name': 'newProjectDeadline',
            'message': 'Enter Project Deadline:',
            'when': lambda answers: answers['action'] == 'Register Project From Client',
            'validate': DateValidator
        },
        {
            'type': 'input',
            'name': 'newProjectSubDate',
            'message': 'Enter Project Submission Date:',
            'when': lambda answers: answers['action'] == 'Register Project From Client',
            'validate': DateValidator
        },
        {
            'type': 'input',
            'name': 'newProjectCost',
            'message': 'Enter Project Budget:',
            'when': lambda answers: answers['action'] == 'Register Project From Client',
            'validate': lambda val: val.isnumeric() or "Enter Budget In Numeric Values Only"
        },
        {
            'type': 'input',
            'name': 'revenueDate1',
            'message': 'Total Revenue From:',
            'when': lambda answers: answers['action'] == 'Revenue Analysis',
            'validate': DateValidator
        },
        {
            'type': 'input',
            'name': 'revenueDate2',
            'message': 'Total Revenue To:',
            'when': lambda answers: answers['action'] == 'Revenue Analysis',
            'validate': DateValidator
        },

    ]
    answers = prompt(questions, style=style)
    q = answers.get('action')
    if(q == 'Logout'):
        return loginPage("Logged Out Successfully")
    elif(q == 'Access Employee Database'):
        df = answers.get('databaseFilter')
        x = PrettyTable(["Employee ID", "Name", "Email", "Domain", "Status"])
        baseQuery = "select EmpId, FirstName, LastName, EmailID, DomainType, Status from person,Employee where Person.PersonId = Employee.EmpId and "
        if(df == 'Position'):
            mycursor.execute(baseQuery + "Employee.Position = '" + answers.get('positionFilter') + "';")  
        elif(df == 'Joining Date'):
            mycursor.execute(baseQuery + "Employee.JoiningDate >= '" + answers.get('joiningFilter1') + "' and Employee.JoiningDate <= '" + answers.get('joiningFilter2') + "';")
        elif(df == 'Domain Type'):
            mycursor.execute(baseQuery +  "Employee.DomainType = '"+ answers.get('domainFilter') +"';")
            
        for (EmpId, FirstName, LastName, EmailID, DomainType, Status) in mycursor:
            x.add_row([EmpId,FirstName + " " + LastName, EmailID, DomainType, Status])
        xstring = x.get_string(title="Employee: " + answers.get('databaseFilter'))
        for s in xstring.split('\n'):
            print_centre(s, 'cyan')
    elif(q == 'View Employee Information'):
        mycursor.execute("select FirstName, LastName, Gender, DomainType, Status, Position, DateOfBirth from person,Employee where Person.PersonId = Employee.EmpId and Employee.EmpId = '" + answers.get('employeeSearchID') + "';")
        if(mycursor.rowcount == 0):
            print_centre("\n No employee with given EmployeeID exists\n", 'red')
        else:
            x = PrettyTable(["Name", "Gender", "Domain", "Status", "Position", "DOB"])
            for (FirstName, LastName, Gender, DomainType, Status, Position, DateOfBirth) in mycursor:
                x.add_row([FirstName + " " + LastName,Gender,DomainType, Status, Position, DateOfBirth])
            xstring = x.get_string()
            for s in xstring.split('\n'):
                print_centre(s, 'cyan')
    elif(q == 'View Client Projects'):
        f = "DONE" if (answers.get('projectView') == "Past") else "ASSIGNED"
        mycursor.execute("select ProjectId, ProjectName, DomainType, ProjectDeadline, ProjectSubmissionDate, Cost from Project where Status = '" + f + "';")
        if(mycursor.rowcount == 0):
            print_centre("\n No " + answers.get('projectView') + " projects exist!\n", 'red')
        else:
            x = PrettyTable(["ID", "Name", "Domain", "Deadline", "Submission By", "Cost"])
            for (ProjectId, ProjectName, DomainType, ProjectDeadline, ProjectSubmissionDate, Cost) in mycursor:
                x.add_row([ProjectId, ProjectName, DomainType, ProjectDeadline, ProjectSubmissionDate, Cost])
            xstring = x.get_string()
            for s in xstring.split('\n'):
                print_centre(s, 'cyan')
    elif(q == 'Review Of Project Manager'):
        myID = pobj[11]
        curDate = datetime.today().strftime('%Y')
        sql = "insert into performancereview(EmpReviewId, EmpReviewerId, year, review) value ('" + answers.get("projectManagerID") + "', '" + str(myID) +"','" + curDate + "','" +  answers.get("projectManagerReview") + "');"
        mycursor.execute(sql)
        mydb.commit()
        print("\n",mycursor.rowcount, " record inserted.\n")
    elif(q == 'Register Project From Client'):
        sql = "insert into Project (DomainType, ProjectName, ProjectDeadline, Status, ProjectDesc, ProjectSubmissionDate, cost) VALUE ('"
        sql += answers.get("newProjectDomain") + "', '"
        sql += answers.get("newProjectName") + "', '"
        sql += answers.get("newProjectDeadline") + "', 'Assigned', '"
        sql += answers.get("newProjectDesc") + "', '"
        sql += answers.get("newProjectSubDate") + "', '"
        sql += answers.get("newProjectCost") + "');"
        # print(sql)
        mycursor.execute(sql)
        mydb.commit()
        print("\n",mycursor.rowcount, " record inserted.\n")
    elif(q == 'Revenue Analysis'):
        sql = "select SUM(cost) from Project where ProjectDeadline between '" + answers.get("revenueDate1") + "' and '" + answers.get("revenueDate2")+"';"
        mycursor.execute(sql)
        f = mycursor.fetchone()
        s = "\033[1mThe Total Renvue: " + str(f[0]) + "\033[0m"
        print("\n")
        print_centre(s, 'cyan')
        print("\n")
    elif(q == 'Comprehensive Project Report'):
        pass
    elif(q == 'Business Done By Clients'):
        mycursor.execute("select ClientId,companyName,FirstName,LastName,State,Country,Business from Client,person where Client.ClientId = Person.PersonId order by Client.Business DESC;")
        x = PrettyTable(["ID", "Client Name", "Company", "Location", "Business Brought"])
        for (ClientId,companyName,FirstName,LastName,State,Country,Business) in mycursor:
            x.add_row([ClientId, FirstName + " " + LastName, companyName, State + ", " + Country,Business ])
        xstring = x.get_string(title="Clients Sorted By Business Brought In")
        for s in xstring.split('\n'):
            print_centre(s, 'cyan')

    check = prompt(confirm, style=style)
    directRole(pobj)

def teamLead(pobj):
    pass

def projectManager(pobj):
    questions = [
        {
            'type': 'list',
            'name': 'action',
            'message': 'Select Action',
            'choices': [
                'View My Projects',
                'Divide Project',
                'Review Submissions and Update Progress',
                'Submit Performance Review for Team Leads',
                'Queries Menu',
                'Tasks Menu',
                'Project Details',
                'Update Deadlines',
                'Logout'
                ]
        },
        {
            'type': 'list',
            'name': 'myProjects',
            'message': 'Filter By',
            'choices': ['Past', 'Current'],
            'when': lambda answers: answers['action'] == 'View My Projects'
        },
        {
            'type': 'input',
            'name': 'teamLeadID',
            'message': 'Provide Team Lead ID -',
            'when': lambda answers: answers['action'] == 'Submit Performance Review for Team Leads',
            'validate': teamLeadValidator
        },
        {
            'type': 'input',
            'name': 'projectManagerReview',
            'message': 'Enter Performance Review -',
            'when': lambda answers: 'teamLeadID' in answers,
        },
        {
            'type': 'list',
            'name': 'queryMenu',
            'message': 'Filter By',
            'choices': ['View Queries', 'Answer Query', 'Raise Query'],
            'when': lambda answers: answers['action'] == 'Queries Menu'
        },
        {
            'type': 'input',
            'name': 'queryResNum',
            'message': 'Enter Query Number:',
            'when': lambda answers: 'queryMenu' in answers and answers['queryMenu'] == 'Answer Query',
            'validate': queryNumberValidator
        },
        {
            'type': 'input',
            'name': 'queryResSol',
            'message': 'Resolution:',
            'when': lambda answers: 'queryResNum' in answers
        },
        {
            'type': 'list',
            'name': 'taskMenu',
            'message': 'Filter By',
            'choices': ['View Completed Tasks', 'On-Going Task Sorted By Deadline', 'View Task By Project'],
            'when': lambda answers: answers['action'] == 'Tasks Menu'
        },
        {
            'type': 'input',
            'name': 'taskByProject',
            'message': 'Enter Project ID:',
            'when': lambda answers: 'taskMenu' in answers and answers['taskMenu'] == 'View Task By Project',
            'validate': projectManagerProjectValidator
        },
        
    ]
    answers = prompt(questions, style=style)
    q = answers.get('action')
    if(q == 'Logout'):
        return loginPage("Logged Out Successfully")
    elif(q == 'View My Projects'):
        f = "DONE" if (answers.get('myProjects') == "Past") else "ASSIGNED"
        s = "Select P.ProjectId, ProjectName, DomainType, ProjectDeadline, ProjectSubmissionDate, Cost from Project as P, Gets as G where P.ProjectId=G.ProjectId and G.EmpId='" + str(pobj[11]) + "' and Status='" + f +"';"
        mycursor.execute(s)
        if(mycursor.rowcount == 0):
            print_centre("\n No " + f + " projects exist!\n", 'red')
        else:
            x = PrettyTable(["ID", "Name", "Domain", "Deadline", "Submission By", "Cost"])
            for (ProjectId, ProjectName, DomainType, ProjectDeadline, ProjectSubmissionDate, Cost) in mycursor:
                x.add_row([ProjectId, ProjectName, DomainType, ProjectDeadline, ProjectSubmissionDate, Cost])
            xstring = x.get_string()
            for s in xstring.split('\n'):
                print_centre(s, 'cyan')
    elif(q == 'Divide Project'):
        print_centre("Clarify", 'red')
    elif(q == "Review Submissions and Update Progress"):
        pass
    elif(q == "'Submit Performance Review for Team Leads'"):
        myID = pobj[11]
        curDate = datetime.today().strftime('%Y')
        sql = "insert into performancereview(EmpReviewId, EmpReviewerId, year, review) value ('" + answers.get("projectManagerID") + "', '" + str(myID) +"','" + curDate + "','" +  answers.get("teamLeadReview") + "');"
        mycursor.execute(sql)
        mydb.commit()
        print("\n",mycursor.rowcount, " record inserted.\n")
    elif(q == 'Queries Menu'):
        # myID = pobj[11]
        # qm = answers.get("queryMenu")
        # if(qm == "View Querries"):
        #     print_centre("Clarify", 'red')
        # elif(qm == "Answer Query"):
        #     sql = "Update Queries Set Resolution='Ask again for submission', Status='Closed' where QuestionId=" +  answers.get("queryResNum") + "';"
        #     mycursor.execute(sql)
        #     sql = "Insert into resolves(EmpId, ProjectId, QuestionId) values("+str(myID)+","++",1);"
        #     mydb.commit()
        pass
    elif(q == 'Task Menu'):
        qm = answers.get("taskMenu")
        if(qm == "View Completed Tasks"):
            pass
        elif(qm == 'On-Going Task Sorted By Deadline'):
            pass
        elif(qm == 'View Task By Project'):
            pass


def generalEmployee(pobj):
    pass


loginPage("")

