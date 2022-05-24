#' Check that a file exists and is nonempty
#' @param filename to check repo
#' @return list(valid = boolean, error_msg = string)
file_exists_check <- function(filename) {
    result <- list(valid = file.exists(filename))
    if (!result$valid) {
        result$error_msg <- sprintf("The file %s does not exist", filename)
    }
    result
}

#' Validate the brick by running tests
#' @param dir of the brick repo
#' @return a list of test results
#' @importFrom purrr map flatten
#' @export
validate <- function(dir) {
    c("dvc.yaml", "dvc.lock", ".dvc/config", "README.md") |>
        map(~ {
            x <- list()
            x[[.x]] <- file_exists_check(file.path(dir, .x))
            x
        }) |>
        flatten()
}

#' Check whether or not the brick is valid
#'
#' This function checks whether or not a brick contains all of the expected
#' components for biobricks–ai.
#' In order to do this, this function tests for the presence of the following
#' files: dvc.yaml, dvc.lock, .dvc/config, and README.md.
#'
#' @param dir of the brick repo
#' @return TRUE if the brick passes all tests and FALSE if it does not.
#' @importFrom purrr map
#' @export
valid <- function(dir) {
    validate(dir) |>
        map(~ .x$valid) |>
        unlist() |>
        all()
}

#' Return errors associated with a brick
#'
#' @param dir of the brick repo
#' @return list of errors
#' @importFrom purrr map keep flatten
#' @export
errors <- function(dir) {
    errors <- validate(dir) |>
        purrr::keep(~ isFALSE(.x$valid)) |>
        purrr::map(~ .x$error_msg)
    if (length(errors) == 0) {
        NA
    } else {
        errors
    }
}