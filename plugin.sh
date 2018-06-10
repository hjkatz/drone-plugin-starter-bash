#!/usr/bin/env bash

#### FUNCTIONS ####

template () {
    tmpl="$1"
    result="$tmpl"

    # extract a list of vars used in the template
    vars=$(echo "$tmpl" | \
        grep -o -P "{{\s*\w+\s*}}" | \
        grep -o -P "\w+" | \
        tr "\n" " " ) # replace newlines with spaces to use in loop below

    # for each var, replace it in the template
    for var in $(echo ${vars[@]}) ; do
        var_value="${!var}"
        result=`echo "$result" | perl -p -e "s/\\{\\{\s*\Q$var\E\s*\\}\\}/q{$var_value}/e"`
    done

    echo "$result"
}

#### MAIN ####

name="$PLUGIN_NAME"
result=`template "$PLUGIN_TEMPLATE"`
echo "$result"
