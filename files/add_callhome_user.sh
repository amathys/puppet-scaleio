#!/bin/bash
#******************************************************************************
# 
#  add callhome user, and change initial password of callhome user
#
#
#  31.10.2014 A.Mathys
#
#******************************************************************************
#

#-------------------------------------------------------------------------------
# define some global variables
#-------------------------------------------------------------------------------

# $1 => username
# $2 => user role
# $3 => new password
# $4 => admin user password

# login as admin user
scli --login --username admin --password ${4} >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  exit 1
fi

# create new user
Output=`scli --add_user --username ${1} --user_role ${2}`
if [ $? -ne 0 ] ; then
  exit 1
fi

# get temp password for new user
TempPassword=`echo $Output |  awk -F\' '{print $2}'`

# logout 
scli --logout >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  exit 1
fi

# login with new user
scli --login --username ${1} --password ${TempPassword} >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  exit 1
fi

scli --set_password --old_password ${TempPassword} --new_password ${3} >/dev/null 2>&1
if [ $? -ne 0 ] ; then
  exit 1
fi
