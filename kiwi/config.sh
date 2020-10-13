#!/bin/bash
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Handle services
#--------------------------------------

# disable NetworkManager which installed by default
baseRemoveService NetworkManager

# enable connman
baseInsertService connman

#======================================
# Setup default target, multi-user
#--------------------------------------
#baseSetRunlevel 3
