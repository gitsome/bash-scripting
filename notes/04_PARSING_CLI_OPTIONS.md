# Parsing Command Line Options 

## Case Statements

See [luser-demo09.sh](./../machine-data/linux-course-image-1/luser-demo09.sh)

Here is a way to check multiple values of the first argument:

```bash
if [[ $1 = "start" ]]
then
    echo "starting..."
elif [[ $1 = "stop" ]]
then
    echo "stopped"
elif [[ $1 = "status" ]]
then
    echo "running"
else
    echo "supply a valid option" >&2
fi
```

Here is the same setup, but showing how to use `case` while also adding in some sytnax sugar to make it more readable. Also notice the `|` for catching the `status` or `state` along with the `*` catch all at the end.

```bash
case $1 in 
    start) echo 'starting yoseph..';;
    stop) echo 'stopping yoseph..' ;;
    status|state) # here is where the OR is via a pipe
        echo 'running yoseph..'
        ;;
    *) echo 'supply a valid option yoseph..' >&2;;
esac
```

Some things to remember about `case`:
1. double `;;` finishes a set of statements for a particular case
2. patterns are the key and you can use operators like `|` and patterns that use `*` to get complex

## Functions

BASH functions can be thought of as any old command. So a function can be thought of as a script that gets access to the same arguments a command would have access to.

Why use a function?

1. You want to keep things DRY ( Don't Repeat Yourself )
2. Maintainability - Single purpose

Bash is executed top down. This means functions MUST be defined before used!

Here is an example:

```bash
#!/bin/bash

log () {
    local MESSAGE=${@}
    echo "You called the log function with message: ${MESSAGE}, ${0}, ${1}, ${2}"
}

log "YAYER YO bro"

# You called the log function with message: YAYER YO, ./luser-demo10.sh, YAYER YO,
```

## Parsing Command Line Options with `getopts`

This helps parse options to provide user friendly command argument processing. The secret is to iterate over the params and update variables based on the param:

```bash

LENGTH=48
VERBOSE='false'
USE_SPECIAL_CHARACTER='false'

usage () {
    echo ""
    echo "--------------------------------------------------------------------"
    echo ""
    echo "Usage: ${0} [-vs] [-l LENGTH]"
    echo ""
    echo "Generate a random password"
    echo " -l   LENGTH  Specify the password length ( defaults to ${LENGTH} )."
    echo " -s           Append a special character to the password."
    echo " -v           Increase Verbosity."
    echo ""
}

while getopts vl:s OPTION
do 
    case ${OPTION} in 
        v)
            VERBOSE='true'
            echo 'Verbose mode on.';;
        l)
            LENGTH="${OPTARG}";;
        s)
            USE_SPECIAL_CHARACTER='true';;
        ?)
            echo 'Invalid options.' >&2
            usage
            exit 1;;
    esac
done
```

## Arithemtic Expansion and Arithmetic Operation

There is no floating point by default. Use `bc` or `awk`.

```bash
echo $(( 6 / 4 ))
# 1
echo '6 / 4' | bc -l
# 1.5000000000
awk 'BEGIN {print 6/4}'
# 1.5
```

Assignment of variables is possible in many ways:

```bash
# Assignment using subtitution with arithmetic expression
NUM=$(( 6 / 4 ))
echo $NUM
# 1

# NOTE: No $ here because nothing being substituted
(( NUM++ ))
(( NUM = 4 + 3 ))
```

Use the `let` builtin. It's basically the double paren.

```bash
let NUM='2+3'
let NUM++
```

You might also see `expr`, another common expression evaluator. It sends its output to standard out.

```bash
NUM=$(expr 2 + 3)
```

### Back to GetOpts

NOTE: `getopts` does not change positional parameters.

See [luser-demo11.sh](./../machine-data/linux-course-image-1/luser-demo11.sh)

```bash
echo "Number of args ${#}"
echo "All args: ${@}"
echo "first arg: ${1}"
```

### Deleting and Disabling Linux Accounts

We will want to use `userdel` command. 

Some things to keep in mind. The `userdel` command will allow you to remove a user and keep their home directory. Note when doing an `ls` you will see that the owner is a GID and does not have a user name. This shows we hold onto the files of the user but are now disjointed from the user.

You can add the `-r` to remove their home directory.

Also note that there is a configuration to define GID ranges based on roles.

```bash
cat /etc/login.defs
#
# Min/max values for automatic uid selection in useradd
#
# UID_MIN			 1000
# UID_MAX			60000
# System accounts
#SYS_UID_MIN		  100
#SYS_UID_MAX		  999

#
# Min/max values for automatic gid selection in groupadd
#
# GID_MIN			 1000
# GID_MAX			60000
# System accounts
#SYS_GID_MIN		  100
#SYS_GID_MAX		  999
```

#### Archiving Files

The `tar` command stands for "tape archive" but allows you to archive a file in general.

```bash
type -a tar 
```

Let's take a look at some of the options of `tar`:

Here we are archiving a directory into a file. The `c` means create and the `f` means we will provide a filename and then the target directory. The `v` is verbose.

```bash
tar -cv -f course-data.tar course-data
```

We can list the contents:
```bash
tar -t -f course-data.tar
# course-data/
# course-data/add-local-user.sh
# course-data/add-new-local-user-conventions.sh
# course-data/add-new-local-user.sh
# course-data/luser-demo01.sh
# course-data/luser-demo02.sh
# course-data/luser-demo03.sh
# course-data/luser-demo04.sh
# course-data/luser-demo05.sh
# course-data/luser-demo06.sh
# course-data/luser-demo07.sh
# course-data/luser-demo08.sh
# course-data/luser-demo09.sh
# course-data/luser-demo10.sh
# course-data/luser-demo11.sh
```

We can extract it all back out:

```bash
mkdir course-data-expanded
cd course-data-expanded
tar -x -f ../course-data.tar
```

Most of the time you will also want to save disc space so let's also gzip AFTER we archive. Not it automatically adds the `.gz` extension.

```bash
tar -cv -f course-data.tar course-data
gzip course-data.tar
# results in a course-data.tar.gz
```

You can unzip it using this command:

```bash
gunzip course-data.tar.gz
# resutls in course-data.tar
```


There is also a shortcut during the archiving by adding the `-z` option to the `tar` command. Note that you have to specify the final extension of `.gz` yourself. 

NOTE: There is a convention of using this command and just giving it the `.tgz` exension to indicate it is a gzipped archive.

```bash
tar -zcv -f course-data.tgz course-data
```

Want to ungzip an extract the archive in one go?

```bash
mkdir extract-location
cd extract-location
tar -zx -f ../course-data.tgz 
```

Be careful with `tar` as it will happily overwrite files. If you extract with `tar` in a directory, the extracted directory will overwrite any existing directoy with the same name!



