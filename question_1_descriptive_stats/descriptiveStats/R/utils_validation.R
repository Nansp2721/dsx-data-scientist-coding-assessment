validate_numeric_input <- function(x) {

  if (is.null(x)) {
    stop("Input `x` must not be NULL.", call. = FALSE)
  }

  if (!is.numeric(x)) {
    stop("Input `x` must be a numeric vector.", call. = FALSE)
  }

  if (length(x) == 0) {
    warning("Input vector is empty.", call. = FALSE)
  }

}
