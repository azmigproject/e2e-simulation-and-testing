# JMeter tests

## Setup Environment - JMeter VM, haproxy VM and Docker VM

Following are the instructions to setup required VMs JMeter tests

1. Setup [JMeter VM](#create-jmeter-vm).
2. Setup [haproxy VM](#create-haproxy-vm).
3. Setup [Docker VM](#create-docker-vm).

## Create JMeter VM

1. Deploy JMeter VM using the "Deploy to Azure" button given below.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Fjmeter-tests%2Fjmeter-vm%2Fdeploy-jmeter-vm.json)

2. Check if the JMeter is running
    ```bash
    sudo systemctl status jmeter
    ```

## Create haproxy VM

1. Vnet and subnet will be same for all the VMs i.e. JMeter VM, haproxy VM and Docker VM.
2. Hence, while creating haproxy VM, use the vnet and subnet name of JMeter VM. E.g.: if Resource group name of JMeter VM = `TestRg` then Vnet name = `TestRg-vnet` and subnet name = `TestRg-subnet`.
3. Now, deploy the haproxy VM using the ARM template in the same resource group with the existing vnet and subnet.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Fjmeter-tests%2Fhaproxy-vm%2Fdeploy-haproxy-vm.json)

4. Check if the haproxy is running
    ```bash
    sudo systemctl status haproxy
    ```

## Create Docker VM with service 2  - 2VMs, each running 1 instance of service 2 on docker

1. Vnet and subnet will be same for all the VMs i.e. JMeter VM, haproxy VM and Docker VM.
2. Hence, while creating haproxy VM, use the vnet and subnet name of JMeter VM. E.g.: if Resource group name of JMeter VM = `TestRg` then Vnet name = `TestRg-vnet` and subnet name = `TestRg-subnet`.
3. Now, deploy the Docker VM using the ARM template in the same resource group with the existing vnet and subnet.

    **Docker VM 1 running service 2v1**

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Fjmeter-tests%2Fdocker-vm%2Fdeploy-docker-vm-service2v1.json)

    **Docker VM 2 running service 2v2**

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Fjmeter-tests%2Fdocker-vm%2Fdeploy-docker-vm-service2v2.json)

4. Check if the Docker is running
    ```bash
    sudo systemctl status docker
    ```
5. Check if the processes in Docker are running
    ```bash
    docker ps
    ```