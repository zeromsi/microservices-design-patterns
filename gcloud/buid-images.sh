#!/bin/bash

set -e

BUILD_NEW_DOCKER_IMAGE=false
BUILD_REACT_WEBAPP_IMAGE=false
BUILD_NODE_IMAGE=false
BUILD_AUTHENTICATION_SERVICE_IMAGE=false
BUILD_USER_SERVICE_IMAGE=false
BUILD_PERSON_SERVICE_IMAGE=false
BUILD_KOTLIN_SERVICE_IMAGE=false

echo "Git Diff Files: $DIFF_FILES"

for i in $(echo $DIFF_FILES | tr " " "\n")
do
  if [[ "$BUILD_REACT_WEBAPP_IMAGE" == "false" ]] && [[ "$i" == *"react-webapp/"* ]] ; then
    if [[ "$i" =~ \.(css|js|html)$ ]]; then
      IMAGES_TO_BUILD+="react-webapp;"
      BUILD_NEW_DOCKER_IMAGE=true
      BUILD_REACT_WEBAPP_IMAGE=true
    fi
  elif [[ "$BUILD_NODE_IMAGE" == "false" ]] && [[ "$i" == *"nodejs-service/"*  ]]; then
    if [[ "$i" =~ \.(js)$ ]]; then
      IMAGES_TO_BUILD[1]="nodejs-service"
      BUILD_NEW_DOCKER_IMAGE=true
      BUILD_NODE_IMAGE=true
    fi
  elif [[ "$BUILD_AUTHENTICATION_SERVICE_IMAGE" == "false" ]] && [[ "$i" == authentication-service* ]]; then
    if [[ "$i" =~ \.(java|yml)$ ]]; then
      mvn -f ../authentication-service/pom.xml docker:build
      IMAGES_TO_BUILD+="authentication-service;"
      BUILD_NEW_DOCKER_IMAGE=true
      BUILD_AUTHENTICATION_SERVICE_IMAGE=true
    fi
  elif [[ "$BUILD_USER_SERVICE_IMAGE" == "false" ]] && [[ "$i" == user-service* ]]; then
    if [[ "$i" =~ \.(java|yml)$ ]]; then
      mvn -f ../user-service/pom.xml docker:build
      IMAGES_TO_BUILD+="user-service;"
      BUILD_NEW_DOCKER_IMAGE=true
      BUILD_USER_SERVICE_IMAGE=true
    fi
  elif [[ "$BUILD_PERSON_SERVICE_IMAGE" == "false" ]] && [[ "$i" == person-service* ]]; then
    if [[ "$i" =~ \.(java|yml)$ ]]; then
      mvn -f ../person-service/pom.xml docker:build
      IMAGES_TO_BUILD+="person-service;"
      BUILD_NEW_DOCKER_IMAGE=true
      BUILD_PERSON_SERVICE_IMAGE=true
    fi
  elif [[ "$BUILD_KOTLIN_SERVICE_IMAGE" == "false" ]] && [[ "$i" == kotlin-service* ]]; then
    if [[ "$i" =~ \.(java|yml|kt)$ ]]; then
      mvn -f ../kotlin-service/pom.xml docker:build
      IMAGES_TO_BUILD+="kotlin-service;"
      BUILD_NEW_DOCKER_IMAGE=true
      BUILD_KOTLIN_SERVICE_IMAGE=true
    else
      echo "Here"
    fi
  fi

done

echo "Should build new docker image for react webapp? ${BUILD_REACT_WEBAPP_IMAGE}"

echo "Should build new docker image for nodejs? ${BUILD_NODE_IMAGE}"

echo "Should build new docker image for authentication-service? ${BUILD_AUTHENTICATION_SERVICE_IMAGE}"

echo "Should build new docker image for user-service? ${BUILD_USER_SERVICE_IMAGE}"

echo "Should build new docker image for person-service? ${BUILD_PERSON_SERVICE_IMAGE}"

echo "Should build new docker image for kotlin-service? ${BUILD_KOTLIN_SERVICE_IMAGE}"

echo "List of images to build: $IMAGES_TO_BUILD"

export BUILD_NEW_DOCKER_IMAGE="$BUILD_NEW_DOCKER_IMAGE";
export IMAGES_TO_BUILD="${IMAGES_TO_BUILD}"