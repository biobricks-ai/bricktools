#' Check whether or not the a brick contains all expected components.
#'
#' This function checks whether or not a brick contains all of the expected components for biobricks–ai. 
#' In order to do this, this function tests for the presence of the following files: dvc.yaml, dvc.lock, 
#' .dvc/config, and README.md.
#'
#' @param Path to the brick directory
#' @return TRUE if the brick passes all tests and FALSE if it does not.
#' @export
check_brick <- function(dir) {
	# check if the directory exists
	dir_exist = file.exists(dir)
	print(sprintf("The directory %s exists: %s.", dir, dir_exist))

	# Check if dvc.yaml exists
	dvc_yaml = file.path(dir, "dvc.yaml")
	dvc_yaml_exist = file.exists(dvc_yaml) 
	print(sprintf("The file %s exists: %s.", dvc_yaml, dvc_yaml_exist))

	# Check if dvc.yaml is not empty 
	yaml_size = file.size(dvc_yaml) != 0L
	print(sprintf("The file %s is not empty: %s.", dvc_yaml, yaml_size))

	# Check if dvc.lock exists
	dvc_lock = file.path(dir, "dvc.lock")
	dvc_lock_exist = file.exists(dvc_lock) 
	print(sprintf("The file %s exists: %s.", dvc_lock, dvc_lock_exist))

	# Check if dvc.lock is not empty 
	lock_size = file.size(dvc_lock) != 0L
	print(sprintf("The file %s is not empty: %s.", dvc_lock, lock_size))

	# Check if .dvc/config exists
	dvc_config = file.path(dir, ".dvc/config")
	dvc_config_exist = file.exists(dvc_config) 
	print(sprintf("The file %s exists: %s.", dvc_config, dvc_config_exist))

	# Check if .dvc/config is not empty 
	config_size = file.size(dvc_config) != 0L
	print(sprintf("The file %s is not empty: %s.", dvc_config, dvc_config_exist))

	# Check if README exists
	README = file.path(dir, "README.md")
	README_exist = file.exists(README) 
	print(sprintf("The file %s exists: %s.", README, README_exist))

	# Check if README is not empty 
	README_size = file.size(README) != 0L
	print(sprintf("The file %s is not empty: %s.", README, README_size))

	# Compile results
	tests <- c(dir_exist, dvc_yaml_exist, yaml_size, dvc_lock_exist, lock_size, 
		dvc_config_exist, config_size, README_exist, README_size)
	
	ifelse(all(tests), return(TRUE), return(FALSE))
}