# Linux Programming Conventions

## Advanced Standard Input, Standard Output, and Standard Error PART I

See [luser-demo08.sh](./../machine-data/linux-course-image-1/luser-demo08.sh)

### Redirecting `STDOUT` to `STDIN`

We have already re-directed the `STDOUT` of a program into the `STDIN` of another program. Note that some functions or programs require a flag to avoid the keyboard input.

Let's do some more fun stuff with redirecting `STDIN`, `STDOUT`, and `STDERR`.

#### Redirect to Files

You can redirect standard out to replace the contents of a file using `>`.

```bash
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}
cat /tmp/data # root:x:0:0:root:/root:/bin/bash
```

Let's redirect some `STDIN`.

```bash
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}
cat /tmp/data # root:x:0:0:root:/root:/bin/bash

read LINE < ${FILE}
```

Here is another example:

```bash
echo "secret" > password
```

```bash
passwd --STDIN jmartin < password
```

You can redirect standard out to append to a file using `>>`.

```bash
touch testfile
echo "foo" > testfile
echo "bar" > testfile
echo "baz" >> testfile 
cat testfile # bar\nbaz
```

## Advanced Standard Input, Standard Output, and Standard Error PART II

File descriptors are important. They represent STDIN(0), STDOUT(1), and STDERR(2).

NOTE: The term file descriptor is also important as they are treated like files.

```bash
read X < /etc/hosts
echo $X
```

You could also use the file descriptor number to explicitely say what you want to do:

```bash
read X 0< /etc/hosts
echo $X
```

For standard out the file descriptor of 1 is used for the `>` sign

```bash
echo "${UID}" 1> uid
cat uid
```

Okay so let's get fancy and redirect `STDOUT` and `STDERR` to different files!

```bash
head -n1 etc/passwd /etc/hosts /fakefile > head.out 2> head.err
cat head.out
# ==> /etc/hosts <==
# 127.0.0.1	localhost
cat head.err
# head: cannot open 'etc/passwd' for reading: No such file or directory
# head: cannot open '/fakefile' for reading: No such file or directory
```

You can dirrect both `STDOUT` and `STDERR` to the same file using this `&` syntax:

```bash
head -n1 /etc/passwd /etc/hosts/ /fakefile &> head.both
cat head.both
# ==> /etc/passwd <==
# root:x:0:0:root:/root:/bin/bash
# head: cannot open '/etc/hosts/' for reading: Not a directory
# head: cannot open '/fakefile' for reading: No such file or directory
```
So the `&` file descriptor incorporates `STDOUT` and `STDERR`.

### What About Pipes?

You would think that `STDOUT` gets piped into the `STDIN` for the next command

This means `STDERR` does not flow through the pipe!

If you want to add both `STDERR` and `STDERR` through the pipe then you need to tweak things:

Without `STDERR`:

```bash
head -n1 /etc/passwd /etc/hosts /fakefile | cat -n
# head: cannot open '/fakefile' for reading: No such file or directory
#      1	==> /etc/passwd <==
#      2	root:x:0:0:root:/root:/bin/bash
#      3	
#      4	==> /etc/hosts <==
#      5	127.0.0.1	localhost
```

With `STDERR`:

```bash
head -n1 /etc/passwd /etc/hosts /fakefile 2>&1 | cat -n
#     1	==> /etc/passwd <==
#     2	root:x:0:0:root:/root:/bin/bash
#     3	
#     4	==> /etc/hosts <==
#     5	127.0.0.1	localhost
#     6	head: cannot open '/fakefile' for reading: No such file or directory
```

With a modern better syntax to include both `STDOUT` and `STDERR`

```bash
head -n1 /etc/passwd /etc/hosts /fakefile |& cat -n
#     1	==> /etc/passwd <==
#     2	root:x:0:0:root:/root:/bin/bash
#     3	
#     4	==> /etc/hosts <==
#     5	127.0.0.1	localhost
#     6	head: cannot open '/fakefile' for reading: No such file or directory
```

Redirect `STDERR` to a file:

```bash
ERR_FILE="temp/data.err"
head -n1 /etc/passwd /etc/hosts /fakefile 2> ERR_FILE
# ==> /etc/passwd <==
# root:x:0:0:root:/root:/bin/bash
#
# ==> /etc/hosts <==
# 127.0.0.1	localhost
cat ERR_FILE
# head: cannot open '/fakefile' for reading: No such file or directory
```

### The NULL device or the `BitBucket`

The NULL device device is designated `/dev/null`, it is a blackhole that swallows the redirected data.

By default STDERR gets mapped to STDOUT inside the bash shell, so typically an error would show up in the terminal as STDOUT. But the command below hides the error:

```bash
head -n1 /etc/passwd /etc/hosts /fakefile 2> /dev/null
# ==> /etc/passwd <==
# root:x:0:0:root:/root:/bin/bash
#
# ==> /etc/hosts <==
# 127.0.0.1	localhost
```

## Exercises

### Goal

The goal of this exercise is to create a shell script that adds users to the same Linux system as the script is executed on.  Additionally this script will conform to Linux program standard conventions.

### Scenario

The help desk team loves the script you created for them.  However, they have just one more request.  They want the script to only display the details that they need to send to the user after they create their account.

You decide that's an easy enough change.  Because you know you'll have to use redirection to accomplish the task, you decide add redirection in other places in the script to make it conform to standard UNIX/Linux program conventions.  Namely, sending errors to STDERR.

### Solution

[User friendly user creation script with conventions](./../machine-data/linux-course-image-1/add-new-local-user-conventions.sh)