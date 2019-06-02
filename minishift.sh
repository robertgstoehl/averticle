#!/bin/sh

# show how to build a vertx application
# 	using a fitting s2i / language builder
# show how to use the openshift jenkins integration to facilitate continous integration
minishift delete
minishift start
eval $(minishift oc-env)
oc login -u developer -p developer
oc new-project development
oc new-project staging
oc new-project production
oc new-project management

# initial drop & deploy
oc project development

# load vertx s2i definitions (BuildConfig, Imagestream, Template)
oc create -f https://raw.githubusercontent.com/robertgstoehl/vertx-openshift-s2i/master/vertx-s2i-all.json

#buildconfig.build.openshift.io/vertx-s2i created
#imagestream.image.openshift.io/vertx-centos created
#imagestream.image.openshift.io/vertx-s2i created
#template.template.openshift.io/vertx-helloworld-maven created
#wait till build is complete, like
# oc logs -f vertx-s2i-1-build

# oc get pods
# NAME                READY     STATUS      RESTARTS   AGE
# vertx-s2i-1-build   0/1       Completed   0          32m

#sleep / wait till build of builder is done.
while [ $(oc get build | grep -v Complete | wc -l) -eq 1 ]; do echo "waiting for build to complete"; sleep 5; done
# ok then, now how to instantiate a vertx app?
# oc new-app vertx-s2i~https://github.com/robertgstoehl/averticle.git
oc project development
oc apply -f okd/app.yaml
oc apply -f okd/route.yaml

oc project management
oc apply -f okd/pipeline.yaml
oc project development
