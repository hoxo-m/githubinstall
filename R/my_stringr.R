# For independence from stringr package

my_str_sub <- function(string, start = 1, end = -1) {
  n <- nchar(string)
  if (start < 0) start <- n + start + 1
  if (end < 0) end <- n + end + 1
  unname(substr(x = string, start = start, stop = end))
}

my_str_replace <- function(string, pattern, replacement, fixed = FALSE) {
  if (length(string) == 0 || length(pattern) == 0) 
    return(character(0))
  mapply(sub, pattern = pattern, replacement = replacement, x = string, 
         fixed = fixed)
}
