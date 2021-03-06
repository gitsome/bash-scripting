# Linux Bash Scripts

All notes are based off this Udemy course:

https://www.udemy.com/course/linux-shell-scripting-projects/learn/lecture/7997500#overview

## Course ENV Setup

Standing up multiple Linux nodes is important during networking aspects so using Docker and Docker Compose will allow for a quicks setup.

### Install Docker

[Install Docker based on your OS and situation](https://docs.docker.com/get-docker/)

### Build the Docker Image

From the root of this project 

```bash
docker build -t linux-course-image .
```

### Start the Containers

Get the containers up in `detached` mode

```bash
docker-compose up -d
```

### Navigate the Containers

To shell into a specific container

```bash
docker exec -ti linux-course-image-<1/2/3> /bin/bash
```

## Cleanup

Stop and remove all containers

```bash
docker-compose rm -fsv
```

## Course Notes

- [Quick Reference](notes/BASH_CRASH_COURSE.md)
- [User and Account Creation](notes/01_USER_ACCOUNTS.md)
- [Password Generation and Shell Script Arguments](notes/02_PASSWORDS.md)
- [Linux Programming Conventions](notes/03_CONVENTIONS.md)
- [Parsing Command Line Options](notes/04_PARSING_CLI_OPTIONS.md)
- [Transforming Data / Data Processing / Reporting](notes/05_DATA_PROCESSING.md)
- [Network Scripting & Automation of Distributed Systems](notes/06_NETWORKING.md)