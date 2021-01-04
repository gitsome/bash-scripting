# Password Generation and Shell Script Arguments

## Random Data, Cryptographic Hash Functions, Text and String Manipulation

See [luser-demo05.sh](./../machine-data/linux-course-image-1/luser-demo05.sh)

### Random Data

You don't have to have the `.sh` extension. What matters most is that you identify the interpreter at the top of the script using the Shabang `#!` and the path to the interpreter. Example:

```bash
#!/bin/bash

echo $RANDOM
```

You can look at all the hashing functions available on your system:

```bash
ls /usr/bin/*sum
/usr/bin/b2sum  /usr/bin/md5sum   /usr/bin/sha224sum  /usr/bin/sha384sum  /usr/bin/sum
/usr/bin/cksum  /usr/bin/sha1sum  /usr/bin/sha256sum  /usr/bin/sha512sum
```

To create a nice random hash, you can do the following:

```bash
PASSWORD_HASH=$(date +%s%N | sha256sum | head -c32)
```

Note the `sha256sum` and `head` scripts can accept STDIN piped in if no file is provided. This means we can pipe in a date to get hashed and then pipe that hash into the head to get the first 8 characters.

To introduce additional randomization you can shuffle and add in new characters:

```bash
SPECIAL="@#$%^&"
RANDOM_SPECIAL=$(echo $SPECIAL | fold -w1 | shuf | head -c1 )
```

You can use a combination of folding, shuffling and taking the first character to get a random special character

## Positional Parameters, Arguments, for Loops, Special Parameters

See [luser-demo06.sh](./../machine-data/linux-course-image-1/luser-demo06.sh)

### Positional Parameters

Positional parameters are accessed using the interger based variables like `${0}`

IMPORTANT: The `${0}` variable ( the first positional argument ) stores that actual command used inside a function

```bash
echo "awesome" # awesome
echo $0 # echo "awesome"
```

Note if you run this in your command line it will output:

```bash
echo ${0}
/bin/bash
```

This is because the command that ran to execute the bash terminal was actually `/bin/bash`!

First the $PATH variable can be explored using `man bash` and `/PATH` to search. Hit `n` go next. Here is what we get:

> The search path for commands.  It is a colon-separated list of directories in which  the
> shell  looks for commands (see COMMAND EXECUTION below).  A zero-length (null) directory
> name in the value of PATH indicates the current directory.  A null  directory  name  may
> appear  as two adjacent colons, or as an initial or trailing colon.  The default path is
> system-dependent, and is set by the administrator who installs bash.  A common value is
> ``/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin''.

#### Summary on Command Execution

- The `$PATH` variable is a colon separated list of directories in which the shell looks for commands
- Bash tries to resolve the function typed in the command prompt... 
    - It will check the file
    - It will check built-ins
    - It will check for other commands along the ${PATH} to find the first match
    - `COMMAND NOT FOUND` error

You can use the `which` command to determine which command will run:

```bash
which -a head
/user/bin/head
```

So if we want to mess around... we can add our own head override if we leverage the current $PATH

```bash
echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Note you can see the first priority is in `/usr/local/sbin` so if we create a head script here, it will be picked up first.

```bash
touch /usr/local/sbin/head
chmod 755 /usr/local/sbin/head
vim /usr/local/sbin/head
```

Now try to see where head is executed from:

```bash
which head
/usr/local/sbin/head
```

So if we execute it we get:

```bash
head
override!!!
```

Now delete the script we created:

```bash
rm /usr/local/sbin/head
```

Now if we try to run head... we get an ERROR!

```bash
head
bash: /usr/local/sbin/head: No such file or directory
```

That's because LINUX uses a hash which stores the latest pointers. By deleting we curcumvented the hash so we need to tell the hash to update:

```bash
hash -r
which head
/usr/bin/head
```

Ahhhh... all is well with the world again

#### Adding Scripts to the Path

You can execute scripts you create by not providing the path to the function. You just have to add the directory that contains it to the `$PATH`! Yay!

#### Utilities for Paths

Get an un-validated file name by using this:

```bash
basename /root@19d973f2bd84:/course-data/luser-demo06.sh
luser-demo06.sh
```

Get an unvalidated directory path by using this:

```bash
dirname /root@19d973f2bd84:/course-data/luser-demo06.sh
/root@19d973f2bd84:/course-data
```

#### Positional Arguments Continued...

We know that the first positional argument `${0}` is the command that was run.

The number of parameters that were actually provided can be accessed with `${#}`. Crazy!

Note that arguments are space delimited so:

```bash
./luser-demo06.sh -s cow
# The command used: ./luser-demo06.sh
# You used the . as the path to the luser-demo06.sh script
# You provided 2 arguments
```

You can see that the flag and the value are counted as their own arguments. But what about this?

```bash
./luser-demo06.sh -s "a b" cow
# The command used: ./luser-demo06.sh
# You used the . as the path to the luser-demo06.sh script
# You provided 3 argument(s)
```

Ha ha! argugments don't split at spaces when arguments are enclosed in `"` quotation marks!

You can look at just the arguments string inside a script by doing this:
```bash
echo "Here are the arguments as a single line: ${*}"
```

You can access positional arugments within a script using the `${@}` variable:

The script has this:

```bash
for ARG in ${@}
do
    echo $ARG
done
```

Running the script gives this:

```bash
./luser-demo06.sh -s "a b" cow
# -s
# a
# b
# cow
```

Note that the `${@}` is equivalent to `${1} ${2} ${3}`...


## The while LOOP, Infinite Loops, Shifting, Sleeping

See [luser-demo07.sh](./../machine-data/linux-course-image-1/luser-demo07.sh)


### Shift

Shift moves the positional arguments down by one.

`shift` is equivalent to `shift 1` btw!

Check this out:

```bash
#!/bin/bash

echo "Parameter1: ${1}"
echo "Parameter1: ${2}"
echo "Parameter1: ${3}"

echo ""

X=0

while [[ $X -lt 5 ]] 
do
    echo "yayer ${X}"
    X=$((X+1))
done

echo ""


while [[ ${#} -gt 0 ]] 
do
    echo "The number of parameters: ${#}"
    echo "Parameter1: ${1}"
    echo "Parameter1: ${2}"
    echo "Parameter1: ${3}"
    echo ""
    shift
done
```

This gives the output:

```
Parameter1: john
Parameter1: brian
Parameter1: call

yayer 0
yayer 1
yayer 2
yayer 3
yayer 4

The number of parameters: 3
Parameter1: john
Parameter1: brian
Parameter1: call

The number of parameters: 2
Parameter1: brian
Parameter1: call
Parameter1: 

The number of parameters: 1
Parameter1: call
Parameter1: 
Parameter1:
```