# bricktools

bricktools is an R package that is used to check whether or not a brick conforms to the expected format of a brick in biobricks-ai.

# Installation
bricktools can be installed as follows:

`devtools::install_github("biobricks-ai/bricktools")`

# Usage
## check_brick(dir)
bricktools contains a function called check_brick which checks whether or not a brick conforms to the expected format of a brick in biobricks-ai.

The function can be called using:

`bricktools::check_brick(dir) `

where dir is the path of the directory for the brick. The function will print out whether or not dir meets each of the requirements for a brick based on our typical format.

For example:

`bricktools::check_brick("clinvar")

> `[1] "The directory clinvar exists: TRUE."
> [1] "The file clinvar/dvc.yaml exists: TRUE."
> [1] "The file clinvar/dvc.yaml is not empty: TRUE."
> [1] "The file clinvar/dvc.lock exists: TRUE."
> [1] "The file clinvar/dvc.lock is not empty: TRUE."
> [1] "The file clinvar/.dvc/config exists: TRUE."
> [1] "The file clinvar/.dvc/config is not empty: TRUE."
> [1] "The file clinvar/README.md exists: TRUE."
> [1] "The file clinvar/README.md is not empty: TRUE."
> [1] TRUE

A functioning brick should pass all of the checks above. The function will return TRUE if all checks are passed for a given directory. It should be relatively easy to put into a loop to check all of the bricks in biobricks.

## Check all bricks in biobricks-ai
bricktools can be used to check whether or not all bricks in biobricks-ai are formatted correctly as follows:

```
# devtools::install_github("biobricks-ai/bricktools")
bricks <- list.files() # in the biobricks-ai directory
brick_check = lapply(bricks, FUN=bricktools::check_brick)
result = as.data.frame(cbind(directories, brick_check), stringsAsFactors=FALSE)
print(result)
```
