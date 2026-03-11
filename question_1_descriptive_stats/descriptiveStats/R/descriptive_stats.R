#' Calculate arithmetic mean
#'
#' Calculates the arithmetic mean of a numeric vector after removing NA values.
#'
#' @param x A numeric vector.
#' @return A numeric value. Returns NA_real_ if the vector is empty after removing NAs.
#' @examples
#' calc_mean(c(1, 2, 3, 4))
#' calc_mean(c(1, NA, 3))
#' @export
calc_mean <- function(x) {
  validate_numeric_input(x)
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)
  mean(x)
}

#' Calculate median
#'
#' Calculates the median of a numeric vector after removing NA values.
#'
#' @param x A numeric vector.
#' @return A numeric value. Returns NA_real_ if the vector is empty after removing NAs.
#' @examples
#' calc_median(c(1, 2, 3, 4))
#' @export
calc_median <- function(x) {
  validate_numeric_input(x)
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)
  median(x)
}

#' Calculate mode
#'
#' Calculates the mode of a numeric vector after removing NA values.
#' If multiple values tie for highest frequency, all modes are returned.
#' If all values occur only once, returns NA_real_.
#'
#' @param x A numeric vector.
#' @return A numeric vector of mode values, or NA_real_ if there is no mode.
#' @examples
#' calc_mode(c(1, 2, 2, 3))
#' calc_mode(c(1, 1, 2, 2))
#' @export
calc_mode <- function(x) {
  validate_numeric_input(x)
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)
  freq_table <- table(x)
  max_freq <- max(freq_table)
  if (max_freq == 1) return(NA_real_)
  modes <- as.numeric(names(freq_table[freq_table == max_freq]))
  return(modes)
}

#' Calculate first quartile
#'
#' Calculates the first quartile (Q1) of a numeric vector after removing NA values.
#'
#' @param x A numeric vector.
#' @return A numeric value. Returns NA_real_ if the vector is empty after removing NAs.
#' @examples
#' calc_q1(c(1, 2, 3, 4, 5))
#' @export
calc_q1 <- function(x) {
  validate_numeric_input(x)
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)
  as.numeric(stats::quantile(x, probs = 0.25, names = FALSE))
}

#' Calculate third quartile
#'
#' Calculates the third quartile (Q3) of a numeric vector after removing NA values.
#'
#' @param x A numeric vector.
#' @return A numeric value. Returns NA_real_ if the vector is empty after removing NAs.
#' @examples
#' calc_q3(c(1, 2, 3, 4, 5))
#' @export
calc_q3 <- function(x) {
  validate_numeric_input(x)
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)
  as.numeric(stats::quantile(x, probs = 0.75, names = FALSE))
}

#' Calculate interquartile range
#'
#' Calculates the interquartile range (IQR = Q3 - Q1) of a numeric vector.
#'
#' @param x A numeric vector.
#' @return A numeric value. Returns NA_real_ if the vector is empty after removing NAs.
#' @examples
#' calc_iqr(c(1, 2, 3, 4, 5))
#' @export
calc_iqr <- function(x) {
  validate_numeric_input(x)
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_real_)
  calc_q3(x) - calc_q1(x)
}
