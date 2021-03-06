#!/usr/bin/env bash

################################################################################
############# Clean all code base for additonal testing @admiralawkbar #########
################################################################################

###########
# Globals #
###########
GITHUB_WORKSPACE="${GITHUB_WORKSPACE}"  # GitHub Workspace
GITHUB_SHA="${GITHUB_SHA}"              # Sha used to create this branch
TEST_FOLDER='.automation/test'          # Folder where test are stored
CLEAN_FOLDER='.automation/automation'   # Folder to rename to prevent skip

############################
# Source additonal scripts #
############################
# shellcheck source=/dev/null
source "${GITHUB_WORKSPACE}/lib/log.sh" # Source the function script(s)

################################################################################
############################ FUNCTIONS BELOW ###################################
################################################################################
################################################################################
#### Function Header ###########################################################
Header() {
  info "-------------------------------------------------------"
  info "------- GitHub Clean code base of error tests ---------"
  info "-------------------------------------------------------"
}
################################################################################
#### Function CleanTestFiles ###################################################
CleanTestFiles() {
  info "-------------------------------------------------------"
  info "Finding all tests that are supposed to fail... and removing them..."

  ##################
  # Find the files #
  ##################
  mapfile -t FIND_CMD < <(cd "${GITHUB_WORKSPACE}" || exit 1 ; find "${GITHUB_WORKSPACE}" -type f -name "*_bad_*" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    error "ERROR! failed to get list of all files!"
    fatal "ERROR:[${FIND_CMD[*]}]"
  fi

  ############################################################
  # Get the directory and validate it came from tests folder #
  ############################################################
  for FILE in "${FIND_CMD[@]}"; do
    #####################
    # Get the directory #
    #####################
    FILE_DIR=$(dirname "$FILE" 2>&1)

    ##################################
    # Check if from the tests folder #
    ##################################
    if [[ $FILE_DIR == **".automation/test"** ]]; then
      ################################
      # Its a test, we can delete it #
      ################################
      REMOVE_FILE_CMD=$(cd "${GITHUB_WORKSPACE}" || exit 1; rm -f "$FILE" 2>&1)

      #######################
      # Load the error code #
      #######################
      ERROR_CODE=$?

      ##############################
      # Check the shell for errors #
      ##############################
      if [ $ERROR_CODE -ne 0 ]; then
        error "ERROR! failed to remove file:[${FILE}]!"
        fatal "ERROR:[${REMOVE_FILE_CMD[*]}]"
      fi
    fi
  done
}
################################################################################
#### Function CleanTestDockerFiles #############################################
CleanTestDockerFiles() {
  info "-------------------------------------------------------"
  info "Finding all tests that are supposed to fail for Docker... and removing them..."

  ##################
  # Find the files #
  ##################
  mapfile -t FIND_CMD < <(cd "${GITHUB_WORKSPACE}" || exit 1 ; find "${GITHUB_WORKSPACE}" -type f -name "*Dockerfile" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    error "ERROR! failed to get list of all file for Docker!"
    fatal "ERROR:[${FIND_CMD[*]}]"
  fi

  ############################################################
  # Get the directory and validate it came from tests folder #
  ############################################################
  for FILE in "${FIND_CMD[@]}"; do
    #####################
    # Get the directory #
    #####################
    FILE_DIR=$(dirname "$FILE" 2>&1)

    ##################################
    # Check if from the tests folder #
    ##################################
    if [[ $FILE_DIR == **".automation/test/docker/bad"** ]]; then
      ################################
      # Its a test, we can delete it #
      ################################
      REMOVE_FILE_CMD=$(cd "${GITHUB_WORKSPACE}" || exit 1; rm -f "$FILE" 2>&1)

      #######################
      # Load the error code #
      #######################
      ERROR_CODE=$?

      ##############################
      # Check the shell for errors #
      ##############################
      if [ $ERROR_CODE -ne 0 ]; then
        error "ERROR! failed to remove file:[${FILE}]!"
        fatal "ERROR:[${REMOVE_FILE_CMD[*]}]"
      fi
    fi
  done
}
################################################################################
#### Function CleanSHAFolder ###################################################
CleanSHAFolder() {
  info "-------------------------------------------------------"
  info "Cleaning folder named:[${GITHUB_SHA}] if it exists"

  ##################
  # Find the files #
  ##################
  REMOVE_CMD=$(cd "${GITHUB_WORKSPACE}" || exit 1; sudo rm -rf "${GITHUB_SHA}" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    # Error
    error "ERROR! Failed to remove folder:[${GITHUB_SHA}]!"
    fatal "ERROR:[${REMOVE_CMD}]"
  fi
}
################################################################################
#### Function RenameTestFolder #################################################
RenameTestFolder() {
  info "-------------------------------------------------------"
  info "Need to rename [tests] folder as it will be ignored..."

  #####################
  # Rename the folder #
  #####################
  RENAME_FOLDER_CMD=$(cd "${GITHUB_WORKSPACE}" || exit 1; mv "${TEST_FOLDER}" "${CLEAN_FOLDER}" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    error "ERROR! failed to move test folder!"
    fatal "ERROR:[${RENAME_FOLDER_CMD[*]}]"
  fi
}
################################################################################
#### Function CleanPowershell ##################################################
CleanPowershell() {
  # Need to remove the .psd1 templates as they are formally parsed,
  # and will fail with missing modules

  info "-------------------------------------------------------"
  info "Finding powershell template files... and removing them..."

  ##################
  # Find the files #
  ##################
  mapfile -t FIND_CMD < <(cd "${GITHUB_WORKSPACE}" || exit 1 ; find "${GITHUB_WORKSPACE}" -type f -name "*.psd1" 2>&1)

  #######################
  # Load the error code #
  #######################
  ERROR_CODE=$?

  ##############################
  # Check the shell for errors #
  ##############################
  if [ $ERROR_CODE -ne 0 ]; then
    error "ERROR! failed to get list of all file for *.psd1!"
    fatal "ERROR:[${FIND_CMD[*]}]"
  fi

  ############################################################
  # Get the directory and validate it came from tests folder #
  ############################################################
  for FILE in "${FIND_CMD[@]}"; do
    #####################
    # Get the directory #
    #####################
    FILE_DIR=$(dirname "$FILE" 2>&1)

    ##################################
    # Check if from the tests folder #
    ##################################
    if [[ $FILE_DIR == **"TEMPLATES"** ]]; then
      ################################
      # Its a test, we can delete it #
      ################################
      REMOVE_FILE_CMD=$(cd "${GITHUB_WORKSPACE}" || exit 1; rm -f "$FILE" 2>&1)

      #######################
      # Load the error code #
      #######################
      ERROR_CODE=$?

      ##############################
      # Check the shell for errors #
      ##############################
      if [ $ERROR_CODE -ne 0 ]; then
        error "ERROR! failed to remove file:[${FILE}]!"
        fatal "ERROR:[${REMOVE_FILE_CMD[*]}]"
      fi
    fi
  done
}
################################################################################
################################## MAIN ########################################
################################################################################

##########
# Header #
##########
Header

####################
# Clean test files #
####################
CleanTestFiles

###############################
# Clean the test docker files #
###############################
CleanTestDockerFiles

###############################
# Remove sha folder if exists #
###############################
CleanSHAFolder

##################
# Re Name folder #
##################
RenameTestFolder

##############################
# Clean Powershell templates #
##############################
CleanPowershell
