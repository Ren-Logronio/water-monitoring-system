# Water Monitoring System

[![Capstone](https://img.shields.io/badge/Capstone-008000)](./) ![Status Ongoing](https://img.shields.io/badge/Status-On%20Development-blue) ![Mental Health](https://img.shields.io/badge/Mental%20Health-Sure-orange) 

##### Team Ternary Operators: 
- John Rey Vilbar
- Nielmer Camintoy
- Reinhart Logronio

### Table of Contents
1. [Short Description](#short-description)
2. [Stack](#stack)
3. [Structure](#structure)
4. [Development Setup](#development-setup)

### Short Description
"Water Monitoring System" helps identify the water quality of the shrimp pond. It is IoT-based and shall be used to help shrimp farmers to conduct tests and identify the water quality of the shrimp pond.

### Stack
- **MariaDB:** The choice of database management system for the backend
- **PHP:** The primary language for server-side logic and database framework
- **React:** Static build of Vite React that is served alongside the PHP backend

> It can be considered that React isn't really part of the stack because of the [system's structure](#Structure)

### Structure
The whole application shall be hosted on a single server that serves both the Vite React static build files and the PHP endpoints. 

General structure of the application:

```sh
<server directory>/
├── api/
│   ├── db.php
│   ├── sample.php
│   └── index.php
├── assets/  
│   ├── *.png/svg/png/ico
│   ├── *.css
│   └── *.js
└── index.html
```
To further explain, the index.html, and asset directory and files are generated from React build; React sends requests to */api* url and renders the consumed data. On the other hand, PHP is used to handle the requests from React, manages the internal backend logic and the transactions from the database. *The structure is reasonable enough to warrant the developer to pursue this insanity*

### Development Setup

Requires (*Install on Windows first*):
- [XAMPP] 
- [MariaDB Server] (v. 11.2.2)
- [Node] (v 20.6.1)
- [Yarn] (v 1.22.21)

> **Important**
> Make sure you have successfully installed XAMPP at '*[System Drive]*:\xampp' or 'C:\xampp'

**[1] Cloning the repo**  

Clone the repo and go to the repo directory
```
$ git clone https://github.com/Ren-Logronio/water-monitoring-system.git
$ cd water-monitoring system
```

**[2] Setting up XAMPP and MariaDB**

Remove the xampp htdocs and add a symbolic link from dist directory from the repo to xampp htdocs
> Make sure the command prompt has admin privileges
```
$ rmdir /s /q <directory to your xampp>/htdocs
```
or for instance
```
$ rmdir /s /q C:/xampp/htdocs
```
then
```
$ mklink /D <directory to your xampp>/htdocs <directory to repo>/dist
```

> At this point (after the symbolic link was created) you can now preview the application by turning on xampp and visiting localhost:80

Go to the dist/api directory from the repo and open the db.php file.
Change the variable $host, $username, $password variable to correctly connect to your mariadb server
```
$servername = "localhost";
$username = "your username";
$password = "your password";
```

##### Load the database sql file named 'backup.sql' to MariaDB server and perform a restore.

**[3] Setting up Vite React**

Go to the frontend directory from the repo and install the required dependencies 
```
$ cd <directory of the repo>/frontend
$ yarn install
```
To start developing, run dev script
This creates a local instance of the react app
> The Vite React is already configured to connect with the xampp localhost port when making request to api.. so no further configuration should be needed.
```
$ yarn run dev
```
And when your work is finished, run build script..
This will create static file located in the dist directory which is now linked to xampp/htdocs; The built files should now be reflected on the xampp server.
```
$ yarn run build
```

### Commit

Please refer to the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) when pushing changes to the repository

&nbsp;
&nbsp;
****
###### Graduate lagi ni ah
&nbsp;
****
&nbsp;
&nbsp;

[XAMPP]: <https://www.apachefriends.org/download.html>
[MariaDB Server]: <https://mariadb.org/download/?t=mariadb&p=mariadb&r=11.4.0>
[Node]: <https://nodejs.org/en/download>
[Yarn]: <https://classic.yarnpkg.com/lang/en/docs/install/#windows-stable>
