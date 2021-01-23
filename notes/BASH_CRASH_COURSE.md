# BASH CRASH COURSE

## stdin / stdout / stderr

The file descriptors used:

- stdin: `0`
- stdout: `1`
- stderr: `2`

## Other Built-in Variables

- `${0}` the command ran
- `${@}` equivalent to `$1 $2 $3 ...`
- `${#}` equal to the total number of params

### Piping

#### Pipe stdout to stderr

Great to do right before you return a non-zero exit

```bash
echo 'Invalid options.' >&2
```


## Interpolation

## Tests

## Conditionals

## Loops

## Functions

## Exit Status

- The `0` exit status typically means success
- Non-zero exit status typically means error, you can provide special codes for each and document them

To get the last exit status from the previous command:

```bash
echo "$?"
```

## Execution Ordering

Information taken from https://www.youtube.com/watch?v=Yx_dCte3dEE

- redirection
- pre-command variable assignment
- expansion
- pipes
- commands


## Finding Things

### `find`

### `locate` && `updatedb`

```bash
sudo locate userdel
```

Locate will search the system's index that is created by the `updatedb` command. It is typically schedule to run once a day. So `locate` is really fast but is not always immediatly up-to-date.

Note using `sudo` if you are not root will show all matches regardless of file permissions.

You can run `updatedb` as root user to update the index. Note, if using docker or a minimal distribution of Linux, this might be missing as it is typically not needed in a container.

### `grep`

Filter based upon a filter.

So as in the example above, if you are locating a binary, you can use `locate` and filter using `grep` on paths that contain `bin`

```bash
root@7e82ad4ef37e:/course-data# locate userdel | grep bin
# /usr/sbin/userdel
```


## Other Useful Bash Commands

### `ls`

- Command also accepts a pattern as its final string param

### `rm`

- You can add the `-r` to force recursive
- You can add a final filter param and only delete matching files

### `awk`

### `sed`

### `tar`

