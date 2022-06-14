## Californium Proxy Installation

Having a terraform installed is pre requisite for deploying the Californium proxy:

https://learn.hashicorp.com/collections/terraform/aws-get-started

### In order to deploy the Californium jar to the EC2 instance you need an AWS Key Pair set up in your accout

1. In aws console search 'key pair'
2. On the 'Key Pairs' console click 'Create key pair'
3. Choose 'aws_key' as the name
4. Choose .pem for the private key file format
5. Click 'Create key pair' and download the key to your machine.

### Deploy the EC2 instance with terraform.

```
# terraform init
# terrafrom plan
# terraform apply
```

### Verify the EC2 instance is running

SSh into the ec2 instance with the Public IPV4 DNS address

```
# ssh -i "aws_key.pem" ec2-user@ec2-44-201-74-71.compute-1.amazonaws.com
```

### Build and deploy the Californium proxy server

```
~/projects/californium# mvn clean install -DskipTests
~/projects/californium# scp -v -i "aws_key.pem" demo-apps/cf-proxy2/target/cf-proxy2-3.1.0-SNAPSHOT.jar ec2-user@ec2-44-201-74-71.compute-1.amazonaws.com:~/.
```

### Run the proxy

```
# ssh -i "aws_key.pem" ec2-user@ec2-44-201-74-71.compute-1.amazonaws.com
# sudo yum install java
[ec2-user@ip-172-31-83-133 ~]$ java -cp cf-proxy2-3.1.0-SNAPSHOT.jar org.eclipse.californium.examples.ExampleCrossProxy2 &
```

If you want a local web server on the ec2 instance to test with:

```
# python -M SimpleHTTPServer 8001 &
# echo Hello, World! > test.txt
```

### Test

```
# ./coap-client -v 9 -m get http://localhost:8001/test.txt -P coaps://ec2-44-201-74-71.compute-1.amazonaws.com:5684 -k sesame -u password
Hello,World!

#
```

### Build and Run with Docker

```
# docker build -t cali-proxy .
# docker run -p 5684:5684 cali-proxy
```

### On Amazon Linux 2

To Run and Build

```
# sudo yum install java-11-amazon-corretto-headless
# sudo amazon-linux-extras install java-openjdk11
```

cd /tmp
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
sudo tar xf /tmp/apache-maven-\*.tar.gz -C /opt
sudo ln -s /opt/apache-maven-3.8.5 /opt/maven
sudo nano /etc/profile.d/maven.sh

PASTE
export JAVA_HOME=/usr/lib/jvm/jre-11-openjdk
export M2_HOME=/opt/maven
export MAVEN_HOME=/opt/maven
export PATH=${M2_HOME}/bin:${PATH}

sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
mvn -version
mvn clean install -DskipTests
