# Jenkins-Android-Infer
Build image:
    docker build -t wisely/jenkins-android-infer:latest .

Start image:
    docker run --name <your_project_name> -u root -d --privileged -v /dev/bus/usb:/dev/bus/usb -p 9090:8080 -p 50000:50000 -v <host_jenkins_path>:/var/jenkins_home -v <host_sdk_path>:/android-sdk/android-sdk-linux wisely/jenkins-android-infer:latest

