# Task Manager

## Overview
Task Manager is a simple web application built with Flask, a Python web framework, and deployed using Docker. It allows users to manage their personal tasks by providing features to add, edit, complete, and delete tasks. The application includes user authentication (registration, login, and logout) to ensure each user can only access their own tasks.

## Features
- **User Authentication**:
  - Register a new account with a username and password.
  - Log in to access your personal task list.
  - Log out to end your session.
  - Passwords are securely hashed using `werkzeug.security` (using `pbkdf2:sha256`).

- **Task Management**:
  - Add a new task.
  - Mark tasks as completed or uncompleted with a "Done/Undo" button.
  - Edit task details using an "Edit" button.
  - Delete individual tasks with a "Delete" button.
  - Clear all tasks with a "Clear All" button.


## Project Structure
```sh
task-manager/
├── app/
│   ├── __init__.py       # Initializes the Flask app, configures SQLAlchemy and Flask-Login
│   ├── init_db.py        # Initializes the database
│   ├── routes.py         # Routes for task management (index, delete, toggle, clear, edit)
│   ├── auth.py           # Routes for authentication (register, login, logout)
│   ├── models.py         # Defines the User and Task models
│   └── templates/
│       ├── index.html    # Main page
│       ├── register.html # Registration page
│       ├── login.html    # Login page
│       └── edit.html     # Edit task page
├── Dockerfile            # Dockerfile for the app container
├── docker-compose.yml    # Docker Compose configuration
├── requirements.txt      # List of Python dependencies
├── .env                  # Environment variables file
└── README.md             # Project documentation
```


## Technologies Used
- **Backend**:
  - Flask: Web framework for building the application.
  - Flask-SQLAlchemy: For database management.
- **Frontend**:
  - Bootstrap 5: CSS framework for styling.
  - Font Awesome: For action button icons.
- **Containerization**: Dockerfile and Docker Compose.
- **Database**: PostgreSQL.
- **CI/CD**: Github Action.


## Setup Environment

Before setting up the application, ensure your environment has Docker Compose and Docker Buildx installed. Follow these steps to set up the environment on a Linux system:

### 1. Install Docker Compose
```sh
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
### 2. Install Docker Buildx
```sh
VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
curl -L --output docker-buildx "https://github.com/docker/buildx/releases/download/v${VERSION}/buildx-v${VERSION}.linux-amd64"
mkdir -p ~/.docker/cli-plugins
mv docker-buildx ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
```
## Setup Instructions
### 1. Clone the Repository
```sh
git clone <repository-url>
cd task-manager
```

### 2. Configure Environment Variables
Create a `.env` file in the project root with the following content:
```sh
DB_NAME=task_manager_db
DB_USER=postgres
DB_PASS=mypassword123
DB_HOST=db
DB_PORT=5432
```

3. Build and Run with Docker
```sh
# Build the application without cache
docker-compose build --no-cache

# Start the containers
docker-compose up

# View logs 
docker-compose logs -f
```
The application will be accessible at `http://localhost:5000`.

### 4. Stop the Application
```
docker-compose down --rmi all -v
```
