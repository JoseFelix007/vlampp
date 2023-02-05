#!/bin/bash

option=$1
default_option='help'

LAMPP="/opt/lampp"
XAMPP=$LAMPP"/xampp"

CURRENT=""
VERSIONS=""
VERSIONS="${VERSIONS} 5"
VERSIONS="${VERSIONS} 8"

function help
{
   # Display Help
   echo
   echo "Lampp switcher versions."
   echo
   echo "Syntax: vlampp [option]"
   echo
   echo "Options:"
   echo "help                   Print this help menu."
   echo "versions               Get installed versions."
   echo "set_default [version]  Set default version."
   echo "start [services]       Start services."
   echo "restart [services]     Restart services."
   echo "stop [services]        Stop services."
   echo
   echo "Services: apache|mysql|all"
   echo
}

function get_current_version
{
    CURRENT=$(readlink '/opt/lampp');
    CURRENT=$(echo $CURRENT | perl -lpe 's/^\/opt\/lampp_(.*)/$1/');
}

function versions
{
    get_current_version
    echo
    echo "Lampp installed versions:"
    echo
    for VERSION in ${VERSIONS}; do
        if [[ $VERSION == $CURRENT ]]; then
            echo "> lampp_${VERSION} (Default)";
        else
            echo "> lampp_${VERSION}";
        fi
    done
    echo
}

function set_default
{
    VERSION=$1
    get_current_version

    echo
    if [[ $VERSION == $CURRENT ]]; then
        echo "lampp_${VERSION} is current version"
    else
        echo "Switching lamp from lampp_${CURRENT} to lampp_${VERSION}"

        LAMPP_VERSION=$VERSION
        checkservices
        checklampplink
    fi
    echo
}

services="apache mysql all"
function start
{
    for service in "$@"
    do
        if [[ $services =~ (^|[[:space:]])$service($|[[:space:]]) ]]; then
            case $service in
                apache) startapache;; mysql) startmysql;; all) startall;;
            esac
        else
            echo "$service is not a service"
        fi
    done
}
function stop
{
    for service in "$@"
    do
        if [[ $services =~ (^|[[:space:]])$service($|[[:space:]]) ]]; then
            case $service in
                apache) stopapache;; mysql) stopmysql;; all) stopall;;
            esac
        else
            echo "$service is not a service"
        fi
    done
}
function restart
{
    for service in "$@"
    do
        if [[ $services =~ (^|[[:space:]])$service($|[[:space:]]) ]]; then
            case $service in
                apache) stopapache; startapache;; mysql) stopmysql; startmysql;; all) stopall; startall;;
            esac
        else
            echo "$service is not a service"
        fi
    done
}

function checkservices 
{
    PIDS_MYSQL=$(ps -C mysqld -C mysqld_safe -o pid=)
    PIDS_APACHE=$(ps -C /opt/lampp/bin/ -o pid=)

    echo
    echo "Stopping services..."
    if [[ -n $PIDS_MYSQL ]];
        then
            stopmysql
        else
            echo "  >  No MYSQL to kill"
    fi
    if [[ -n "$PIDS_APACHE" ]];
        then
            stopapache
        else
            echo "  >  No APACHE to kill"
    fi
}
function checklampplink 
{
    echo
    echo "Checking lampp link ..."
    if [[ -L "$LAMPP" && -d "$LAMPP" ]]
        then
            echo "  >  $LAMPP is a symlink to a directory: try to delete"
            sudo rm -f $LAMPP
        else
            echo "  >  No $LAMPP link was found"
    fi

    # create a new link
    echo "  >  Try to create LAMPP link ..."
    cd /opt
    sudo ln -s "${LAMPP}_${LAMPP_VERSION}" "lampp"

    ## check if is created
    if [[ -L "$LAMPP" && -d "$LAMPP" ]];
        then
            echo "  >  $LAMPP created!"
        else
            echo "  >  ERROR: LINK not created! exit 1"
            exit 1
    fi
}

function startapache {
    sudo $XAMPP startapache
}
function stopapache {
    sudo $XAMPP stopapache
}
function startmysql {
    sudo $XAMPP startmysql
}
function stopmysql {
    sudo $XAMPP stopmysql
}
function startall {
    startapache
    startmysql
}
function stopall {
    stopapache
    stopmysql
}

if [ -z $option ]; then
    option=$default_option
fi

case $option in
    help)
        help
        exit;;
    versions)
        versions
        exit;;
    set_default)
        set_default $2
        exit;;
    start)
        shift 1;
        start $@
        exit;;
    restart)
        shift 1;
        restart $@
        exit;;
    stop)
        shift 1;
        stop $@
        exit;;
    *) # incorrect option
        echo "Error: Invalid option $option"
        exit;;
esac