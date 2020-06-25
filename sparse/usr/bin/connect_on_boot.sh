#!/bin/bash

SERVICES=`connmanctl services`
connmanctl connect "${SERVICES##* }"
