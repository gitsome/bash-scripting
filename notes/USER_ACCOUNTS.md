# User and Account Creation

## Getting Started: Naming, Permissions, Variables, Builtins

### Naming

You don't have to have the `.sh` extension. What matters most is that you identify the interpreter at the top of the script using the Shabang `#!` and the path to the interpreter. Example:

```bash
#!/bin/bash
```

### Permisions

The default perm used most often in this course is `chmod 755 <filename>`. This will result in:

```bash
-rwxr-xr-x <user> <group> <everyone else>
```

Which is:
- `rwx` for the user ( 7 = 111 )
- `r-x` for the group ( 5 = 101 )
- `r-x` for everyone else ( 5 = 101 )

For review, each bit for read write and execute:
Read = 4 -> 100
Write = 2 -> 010
Execute = 1 -> 001

This makes the script editable for you and executable for everyone.

Now while using `chmod 755 luser-demo01.sh`, you can execute it without using `sh` in front. Note you must use the `./`

```bash
./luser-demo01.sh
```

### Builtins

There are several command built in that do not require referencing the binary directly.

Example to see if something is a builtin is:

```bash
type -a echo
echo is a shell builtin
echo is /usr/bin/echo
echo is /bin/echo

help echo
```

For builtins you can use `help <command>`
For non builtins you can use `man <command>`

Here is one that is not builtin:

```bash
type -a uptime
uptime is /usr/bin/uptime
uptime is /bin/uptime

man uptime
```

### Variables

Variables are storage locations with a name. See [luser-demo01.sh](./../machine-data/linux-course-image-1/luser-demo01.sh).

Rules for variable names:

- Can only consiste of letters, numbers, and the underscore
- Cannot start with a number

Variable interpolation is only accessible using quotes!

```bash
MY_VAR="dope"
echo $MY_VAR
dope
echo '$MY_VAR'
$MY_VAR
echo "$MY_VAR"
dope
echo "Example ${MY_VAR}"
Example dope
```

Note that appending variables requires the use of the `${}` syntax so the interpreter knows how to find the variables. Appending to an existing string is non deterministic because the interpreter can't know where the variable is. Example:

```bash
echo "$MY_VARcool"

```

Here the output is empty because the variable "$MY_VARcool" is empty.

## Special Variables, Pseudocode, Command Substitution, if Statement, Conditionals

### Special Variables

There are many preset variables you can use.
See [luser-demo02.sh](./../machine-data/linux-course-image-1/luser-demo02.sh)

Here are a few:

- `UID`: The user's id

To get information about the user

- You can use `${UID}`
- You can execute the `id` script with options
    - `id` gives `uid=0(root) gid=0(root) groups=0(root)`
    - `id -u` gives `0`
    - `id -u -n` or `id -n -u` or `id -nu` gives `root`
- You can also use `whoami` which is the same as `id -un`

### Command Substitution

You can store results from a command inside a script as well. The interpolation will execute and use the output as the interpolated value.

```bash
USER_NAME=$(id -un)
```

### IF Statements

```bash
if [[ "${UID}" -eq 0 ]]
then 
    echo 'You are root.'
else
    echo 'You are not root.'
fi
```

#### Tests

Let's look at the help by piping the output into a pager program `less`

```bash
help test | less
```

There are operators and tests for different situations including files, strings, arithmetic and more.


## Exit Statuses, Return Codes, String Test Conditionatls, More Special Variables

See [luser-demo03.sh](./../machine-data/linux-course-image-1/luser-demo03.sh)

You can exit a program by typing `exit`. By default it will provide a `0` exit code which means success.

You can provide a non-zero `exit` code which typically means there was an error.

```bash
exit 1 # signifies some type of error
```

You can get the last exit code by using the `"${?}"` code:

```bash
id -unx # the x option is not valid
echo "${?}"
1
```

## Reading Standard Input, Creating Accounts, Username Conventions, More Quoting

See [luser-demo04.sh](./../machine-data/linux-course-image-1/luser-demo04.sh)

### Reading Standard Input

It's possible to read data that the user must supply from standard in.

```bash
read -p 'Type something: ' INPUT_VAR
echo $INPUT_VAR
```

It's also possible to pass standard-in via a pipe. This means some commands allow an override of typical keyboard entries using a pipe.

```bash
echo $SOME_VAR | passwd --stdin ${USER_NAME}
```
