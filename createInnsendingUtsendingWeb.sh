#!/bin/bash

. "$( cd $( dirname $0 ) && pwd )/common_startup.sh"

trap deleteTemporaryEnvironementFile EXIT

function usage() {
  messageSection "Usage"
  message "Not enough parameters"
  message "Usage: "
  messageParameter "e" "<ENVIRONMENT_NAME>"
  messageParameter "v" "<APPLICATION_VERSION>"
  messageParameter "r" "<MAVEN_REPOSITORY>" "$DEFAULT_MAVEN_REPOSITORY"
  messageParameter "d" "<DOMAINS_DIR>" "$DEFAULT_DOMAINS_DIR"
  messageParameter "p" "<PORT_BASE>"
  messageParameter "x" "<JVM_MEMORY_FOR_INSTANCE>"
  messageParameter "y" "<WEB_NODE> <WEB_NODE_PORTBASE>...<WEB_NODE> <WEB_NODE_PORTBASE>"
  message ""
  exitRunning 1
}

function deleteTemporaryEnvironementFile {
  messageSection "Cleaning up temporary environment file (ctx: createInnsendingUtsendingWeb.sh)"
  runCommand "rm -f $TMP_ENV_FILE"
}

# Start run

while getopts ":e:v:r:d:p:x:y:c:" OPTNAME
do
  case "$OPTNAME" in
    "e")
      ENVIRONMENT_NAME=$OPTARG
      ;;
    "v")
      APPLICATION_VERSION=$OPTARG
      ;;
    "r")
      MAVEN_REPOSITORY=$OPTARG
      ;;
    "d")
      DOMAINS_DIR=$OPTARG
      ;;
    "p")
      PORT_BASE=$OPTARG
      ;;
    "x")
      JVM_MEMORY_FOR_INSTANCE=$OPTARG
      ;;
    "y")
      WEB_NODES="$OPTARG"
      ;;
    "?")
      echo "Unknown option $OPTARG"
      ;;
    ":")
      echo "No argument value for option $OPTARG"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

WEB_GROUP="ske.eksternt.mottak"
WEB_ARTIFACT="innsending-utsending-web"
WEB_NODES=${WEB_NODES:-""}

DEFAULT_DOMAINS_DIR="/u01/domains"
DEFAULT_MAVEN_REPOSITORY=""

MAVEN_REPOSITORY=${MAVEN_REPOSITORY:-$DEFAULT_MAVEN_REPOSITORY}
DOMAINS_DIR=${DOMAINS_DIR:-$DEFAULT_DOMAINS_DIR}
ASADMIN_PORT=$(($PORT_BASE+48))
CREATE_CLUSTER=${CREATE_CLUSTER:-"true"}
JVM_MEMORY_FOR_INSTANCE=${JVM_MEMORY_FOR_INSTANCE:-"1"}


messageSection "Starting setup of innsending-utsending-web"

# Check essential parameter
if [ -z "$ENVIRONMENT_NAME" ]; then
  usage
fi

#Kalles to ganger ettersom kall 2 "spiser" output fra funksjonen
resolveEnvironmentSettings $ENVIRONMENT_NAME
ENVIRONMENT_FILE=$(resolveEnvironmentSettings $ENVIRONMENT_NAME)
if [[ $? != 0 ]]; then
  messageError "$ENVIRONMENT_FILE"
  failSilent
fi

. "$ENVIRONMENT_FILE"

findPropertiesMissingValuesAndPromptUserForNewValue $ENVIRONMENT_FILE
TMP_ENV_FILE=$(generateEnvSh $ENVIRONMENT_FILE)
. "$TMP_ENV_FILE"

generateApp2AppCertificate "ekstkom.innsending-utsending-web"

# Check is set after loading from file
if [ -z "$APPLICATION_VERSION" -o -z "$DOMAINS_DIR" -o -z "$PORT_BASE" ]; then
  usage
fi

set -e
set -u


messageSection "Setting up webapplication"
prepareAndCheckAppHome "$APP_HOME_PATH" "$ENVIRONMENT_NAME" "$(webNodesToConnect "$WEB_NODES")"
messageSection "Deployer innsending-utsending-web"
$GFLIBDIR/createDomainClusterAndDeployApplication.sh -r "$MAVEN_REPOSITORY" -g "$WEB_GROUP" -a "$WEB_ARTIFACT" -v "$APPLICATION_VERSION" -d "$DOMAINS_DIR" -p "$PORT_BASE" -e "$ENVIRONMENT_NAME" -q $TMP_ENV_FILE -x "$JVM_MEMORY_FOR_INSTANCE" -y "$WEB_NODES"

message "Setup of innsending-utsending-web completed!"
exitRunning

