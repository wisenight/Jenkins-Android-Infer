# Jenkins-Android-Infer

Build Image
-----------
docker build -t wisely/jenkins-android-infer:latest .

Start Image
-----------
docker run --name {your_project_name} -u root -d --privileged -v /dev/bus/usb:/dev/bus/usb -p 9090:8080 -p 50000:50000 -v {host_jenkins_path}:/var/jenkins_home -v {host_sdk_path}:/android-sdk/android-sdk-linux wisely/jenkins-android-infer:latest

Jenkins Setup
-------------
Install Git relative plugins

Create a new Free-Style project

In advenced options
> Check custom workspace
> Input workspace pace and name

Input Git repository url and credentials

In build field
> Add Run shell: 
> rm -rf infer-out/*.*

> Add another run shell:
> ./gradlew clean
> infer -- ./gradlew {your_task_name} --stacktrace
> ./gradlew {your_task_name}

In post build filed
> Add package action:
> infer-out/*


