BEGIN { FS = "|" } # 设置字段分隔符为|

{
  if ($1 ~ regex) print $1
}
