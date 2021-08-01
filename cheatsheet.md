open directory: `:Ex <directory>`, `:Ex` will open the pwd
switch working directory to current file: `:cd %:h`
show current directory: `:pwd`

`:%! command`
pipes the current file's contents to command's stdin, and replaces the file's contents with command's stdout.

So, `:%! sort` is pretty much the same as (from a shell) `cat file | sort > tmp && mv tmp file.`

