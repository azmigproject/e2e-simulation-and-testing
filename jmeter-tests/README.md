# JMeter tests

## Setup Environment - JMeter VM, haproxy VM and Docker VM

Following are the instructions to setup required VMs JMeter tests. Please deploy them in the same order.

1. Setup [JMeter VM](#create-jmeter-vm). Static private IP - `172.17.17.4`
2. Setup [haproxy VM](#create-haproxy-vm). Static private IP - `172.17.17.5`
3. Setup [Docker VM](#create-docker-vm). Static private IP
    - Docker VM 1 with Service2 instance 1 - `172.17.17.6`
    - Docker VM 2 with Service2 instance 2 - `172.17.17.7`

## Create JMeter VM

1. Deploy JMeter VM using the "Deploy to Azure" button given below.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Fjmeter-tests%2Fjmeter-vm%2Fdeploy-jmeter-vm.json)
2. Check if JMeter is installed
    ```bash
    which jmeter
    ```
3. Run JMeter in non-GUI mode.
    ```bash
    jmeter -n -t <test-file.jmx> -l <log-file.jtl>
    ```
4. For JMeter test file check [this sample](https://raw.githubusercontent.com/azmigproject/e2e-simulation-and-testing/master/jmeter-tests/jmeter-vm/sample-test.jmx).
5. [Download JMeter](http://www-eu.apache.org/dist//jmeter/binaries/apache-jmeter-4.0.zip) and run it in GUI mode. (On Windows or mac)
6. Import the given test file and update with new values as required. Check [this](https://www.digitalocean.com/community/tutorials/how-to-use-apache-jmeter-to-perform-load-testing-on-a-web-server) for more information about JMeter.
7. Save and use it in the JMeter VM in non-GUI mode.
8. To verify that the JMeter VM is able to connect to haproxy VM and haproxy is setup correctly, run following command **twice**
    ```bash
    curl <ip-address-of-haproxy-vm>:80/service2/webresources/prime -w '\n'
    ```
    So, as we are using static private IP addresses
    ```bash
    curl 172.17.17.5:80/service2/webresources/prime -w '\n'
    ```
    Output should be like this.
    ```output
    $ curl 172.17.17.5:80/service2/webresources/prime -w '\n'
    [1]: 500th prime number = 3571 [Tue Jun 05 09:10:35 UTC 2018 ]
    $ curl 172.17.17.5:80/service2/webresources/prime -w '\n'
    [2]: 500th prime number = 3571 [Tue Jun 05 09:10:37 UTC 2018 ]
    ```

## Create haproxy VM

1. Vnet and subnet will be same for all the VMs i.e. JMeter VM, haproxy VM and Docker VM.
2. Hence, while creating haproxy VM, use the vnet and subnet name of JMeter VM. E.g.: if Resource group name of JMeter VM = `TestRg` then Vnet name = `TestRg-vnet` and subnet name = `TestRg-subnet`.
3. Now, deploy the haproxy VM using the ARM template in the same resource group with the existing vnet and subnet.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Fjmeter-tests%2Fhaproxy-vm%2Fdeploy-haproxy-vm.json)
4. Check if the haproxy is running
    ```bash
    systemctl status haproxy
    ```
5. Path of haproxy configuration file: `/etc/haproxy/haproxy.cfg`
6. **HTTP keep alive** is enabled by default. You can check using `less` command. For more information about HTTP keep alive check [http-keep-alive](https://cbonte.github.io/haproxy-dconv/1.6/configuration.html#4.2-option%20http-keep-alive)
    ```bash
    less /etc/haproxy/haproxy.cfg
    ```
7. For **HTTP reuse**, edit the haproxy configuration file as per the instruction given below. For more information about HTTP reuse check [http-reuse](https://cbonte.github.io/haproxy-dconv/1.6/configuration.html#4.2-http-reuse)
    - To enable  **HTTP reuse**, uncomment following line in  `backend service2_back` section of `/etc/harpoxy/haproxy.cfg` file by deleting `#` character. It should look like this once uncommented.
        ```cfg
        http-reuse safe
        ```
    - To disable **HTTP reuse**, comment it again.
8. To verify that the haproxy environment is setup correctly, run following command **twice**
    ```bash
    curl localhost:80/service2/webresources/prime -w '\n'
    ```
    Output should be like this.
    ```output
    $ curl localhost:80/service2/webresources/prime -w '\n'
    [1]: 500th prime number = 3571 [Tue Jun 05 09:10:35 UTC 2018 ]
    $ curl localhost:80/service2/webresources/prime -w '\n'
    [2]: 500th prime number = 3571 [Tue Jun 05 09:10:37 UTC 2018 ]
    ```

## Create 2 Docker VMs - each running service 2 on a docker container

1. Vnet and subnet will be same for all the VMs i.e. JMeter VM, haproxy VM and Docker VM.
2. Hence, while creating haproxy VM, use the vnet and subnet name of JMeter VM. E.g.: if Resource group name of JMeter VM = `TestRg` then Vnet name = `TestRg-vnet` and subnet name = `TestRg-subnet`.
3. Now, deploy the Docker VM using the ARM template in the same resource group with the existing vnet and subnet.

    **Docker VM 1 running service 2v1**

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Fjmeter-tests%2Fdocker-vm%2Fdeploy-docker-vm-service2v1.json)

    **Docker VM 2 running service 2v2**

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Fjmeter-tests%2Fdocker-vm%2Fdeploy-docker-vm-service2v2.json)
4. Check if the Docker is running
    ```bash
    systemctl status docker
    ```
5. Check if the processes in Docker are running
    ```bash
    docker ps
    ```
6. To verify that the docker VM and service2 environment is setup correctly, run following
    ```bash
    curl localhost:8882/service2/webresources/prime -w '\n'
    ```
    Output should be like this on
    - Docker VM with service2v1 (first instance of service2)
    ```output
    $ curl localhost:8882/service2/webresources/prime -w '\n'
    [1]: 500th prime number = 3571 [Tue Jun 05 09:10:35 UTC 2018 ]
    ```
    - Docker VM with service2v2 (second instance of service2)
    ```output
    $ curl localhost:8882/service2/webresources/prime -w '\n'
    [2]: 500th prime number = 3571 [Tue Jun 05 09:10:37 UTC 2018 ]
    ```