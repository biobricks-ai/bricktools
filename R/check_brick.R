#' Check that biobricks::brick_ls_remote() can be run
#' on brick
#' @param brickname the name of the brick check
#' @export
#' @importFrom biobricks local_bblib brick_install brick_ls_remote
#' @return list(valid = boolean, error_msg = string)
brick_ls_works <- function(brickname) {
    tryCatch(
        {
            local_bblib()
            brick_install(brickname)
            brick_ls_remote(brickname)
            return(list(valid = TRUE))
        },
        error = function(e) {
            return(list(valid = FALSE, error_msg = e$message))
        }
    )
}

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
#' @importFrom fs path_real
#' @export
validate <- function(dir) {

    # check that files exist
    result <- c("dvc.yaml", "dvc.lock", ".dvc/config", "README.md") |>
        map(~ {
            x <- list()
            x[[.x]] <- file_exists_check(file.path(dir, .x))
            x
        }) |>
        flatten()
    # check that the brick can list its files
    result <- append(result, list(brick_ls_works = {
        dir |>
            path_real() |>
            basename() |>
            brick_ls_works()
    }))
    return(result)
}

#' Check whether or not the brick is valid
#'
#' This function checks whether or not a brick contains all of the expected
#' components for biobricks–ai.
#' In order to do this, this function tests for the presence of the following
#' files: dvc.yaml, dvc.lock, .dvc/config, and README.md.
#'
#' @param validate_result a list of validation results returned by validate
#' @return TRUE if the brick passes all tests and FALSE if it does not.
#' @importFrom purrr map
#' @export
valid <- function(validate_result) {
    validate_result |>
        map(~ .x$valid) |>
        unlist() |>
        all()
}

#' Return errors associated with a brick
#'
#' @param validate_result a list of validation results returned by validate
#' @return list of errors
#' @importFrom purrr map keep flatten
#' @export
errors <- function(validate_result) {
    errors <- validate_result |>
        purrr::keep(~ isFALSE(.x$valid)) |>
        purrr::map(~ .x$error_msg)
    if (length(errors) == 0) {
        NA
    } else {
        errors
    }
}

#' Check a brick, returns the proper error code
#'
#' @param dir of the brick repo
#' @importFrom purrr map discard walk
#' @importFrom stringr str_flatten
#' @export
check <- function(dir) {
    validate_result <- validate(dir)
    if (valid(validate_result)) {
        cat("All brick checks passed.\n")
        if (interactive()) {
            TRUE
        } else {
            quit(status = 0)
        }
    } else {
        # print errors
        errors(validate_result) |> map(~ {
            cat(paste0(.x, "\n"))
        })
        if (interactive()) {
            FALSE
        } else {
            quit(status = 1)
        }
    }
}