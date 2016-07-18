stop_without_message <- function() {
  old_sem <- options("show.error.messages")$show.error.messages
  on.exit(options(show.error.messages = old_sem))
  options(show.error.messages = FALSE)
  stop()
}
