#!/usr/bin/env bash

#### FUNCTIONS ####

# Die and exit the script
#
# Usage:
#   - `do_something || die "Something failed to happen!"`
#   - `die "Oopsie-poopsie"`
die () {
    echo $@ && exit 1
}

# Ensure an environment variable exists for use.
# You can provide a default if it doesn't already exist, or
# provide a missing message to die with if the env var is missing.
#
# Usage:
#   - `use_env PLUGIN_NAME "Missing key name: name for use in the template" "World"`
use_env () {
    var_name="$1"
    missing_msg="$2"
    default="$3"

    if [[ -z ${!var_name} ]] ; then
        if [[ -n $default ]] || [[ $# -eq 3 ]] ; then
            export $var_name="$default"
        else
            if [[ -n "$missing_msg" ]] ; then
                die "$missing_msg"
            else
                die "Missing environment variable '\$$var_name' for use!"
            fi
        fi
    fi
}

# Parse the plugin environment variables
parse_env () {
    # Dockerfile provided
    use_env WORKDIR

    # Plugin config
    use_env PLUGIN_TEMPLATE "Missing key template: template to print"        "$DEFAULT_TEMPLATE"
    use_env PLUGIN_NAME     "Missing key name: name for use in the template" "$DEFAULT_NAME"

    # Drone config
    use_env DRONE_REPO_OWNER     "repository owner"          ""
    use_env DRONE_REPO_NAME      "repository name"           ""
    use_env DRONE_COMMIT_SHA     "git commit sha"            ""
    use_env DRONE_COMMIT_REF     "git commit ref"            "refs/heads/master"
    use_env DRONE_COMMIT_BRANCH  "git commit branch"         "master"
    use_env DRONE_COMMIT_AUTHOR  "git commit author name"    ""
    use_env DRONE_PULL_REQUEST   "git pull request"          ""
    use_env DRONE_COMMIT_MESSAGE "git commit message"        ""
    use_env DRONE_BUILD_EVENT    "build event"               "push"
    use_env DRONE_BUILD_NUMBER   "build number"              -1
    use_env DRONE_BUILD_STATUS   "build status"              "success"
    use_env DRONE_BUILD_LINK     "build link"                ""
    use_env DRONE_BUILD_STARTED  "build started epoch"       `date +%s`
    use_env DRONE_BUILD_CREATED  "build created epoch"       `date +%s`
    use_env DRONE_JOB_STARTED    "job started"               `date +%s`
    use_env DRONE_TAG            "build tag"                 ""
    use_env DRONE_DEPLOY_TO      "environment deployed to"   ""
}

#### MAIN ####

# Defaults
DEFAULT_TEMPLATE="Hello, {{ name }}"
DEFAULT_NAME="World"

parse_env

# Run the plugin
$WORKDIR/plugin.sh
