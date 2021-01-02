# Linux Bash Scripts

All notes are based off this Udemy course:

https://www.udemy.com/course/linux-shell-scripting-projects/learn/lecture/7997500#overview

## Setting Up Docker ENV

Standing up multiple Linux nodes is important during networking aspects so using Docker and Docker Compose will allow for a quicks setup.

### Install Docker

[Install Docker based on your OS and situation](https://docs.docker.com/get-docker/)

### Build the Docker Image

From the root of this project 

```bash
docker build -t linux-course-image
```

### Start-Up the Containers

```bash
docker-compose up
```

## Course Notes

- [User and Account Creation](notes/USER_ACCOUNTS.md)
- [Password Generation and Shell Script Arguments](notes/PASSWORDS.md)
- [Linux Programming Conventions](notes/CONVENTIONS.md)
- [Parsing Command Line Options](notes/PARSING_CLI_OPTIONS.md)
- [Transforming Data / Data Processing / Reporting](notes/DATA_PROCESSING.md)
- [Network Scripting & Automation of Distributed Systems](notes/NETWORKING.md)