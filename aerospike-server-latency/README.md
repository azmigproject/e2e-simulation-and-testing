# Aerospike server latency simulation and testing

## Setup Environment - 2 VM

Following are the instructions to setup 3 VM environment for Aerospike server latency simulation and testing

1. Setup [Aerospike server VM](#create-aerospike-server-vm).
2. Setup [Aerospike Java benchmarking client VM](#create-aerospike-java-benchmarking-client-vm).
3. Create a client VM using Azure portal in the same resource group with the existing vnet and subnet. This VM will be used to ping the Aerospike server VM and Java benchmarking client VM.

## Setup Environment - 3 VM

1. Setup [Aerospike server VM](#create-aerospike-server-vm).
2. Setup [Aerospike Java benchmarking client VM](#create-aerospike-java-benchmarking-client-vm).
3. Setup [hey client VM](#create-hey-client-vm).
4. Create a client VM using Azure portal in the same resource group with the existing vnet and subnet. This VM will be used to ping the Aerospike server VM and Java benchmarking client VM.

## Create Aerospike server VM

1. Deploy Aerospike server VM using the "Deploy to Azure" button given below.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Faerospike-server-latency%2Fdeploy-aerospike-server.json)

2. Check if the Aerospike server and Aerospike management console is running
    ```bash
    sudo systemctl status aerospike
    sudo systemctl status amc
    ```

## Create Aerospike Java benchmarking client VM

1. Vnet and subnet will be same for Aerospike server VM and Java benchmarking VM.
2. While creating Aerospike server VM, vnet name and subnet name will be `%ResourceGroupName%-vnet` and `%ResourceGroupName%-subnet`, respectively. E.g.: if Resource group name of Aerospike server VM = `TestRg` then Vnet name = `TestRg-vnet` and subnet name = `TestRg-subnet`.
3. Now, deploy the Aerospike Java benchmarking client VM using the ARM template in the same resource group with the existing vnet and subnet.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Faerospike-server-latency%2Fdeploy-aerospike-java-benchmark-client.json)

4. To access Java benchmarking client switch to root and change directory
    ```bash
    sudo su -
    cd aerospike-client-java/benchmarks/
    ```
5. Starting Java benchmark client, as the private IP of Aerospike server = `172.17.17.4`
    ```bash
    ./run_benchmarks -h 172.17.17.4 -p 3000 -n test -k 10000000 -b 1 -o B:256 -w RU,80 -g 6000 -T 1 -z 8 -latency ycsb
    ```
    OR
    ```bash
    ./run_benchmarks -h 172.17.17.4 -p 3000 -n test -k 10000000 -b 1 -o B:256 -w RU,80 -g 6000 -T 1 -z 8 -latency alt,7,1,us
    ```

## Create hey client VM

1. Vnet and subnet will be same for Aerospike server VM, Java benchmarking VM and hey client VM.
2. While creating Aerospike server VM, vnet name and subnet name will be `%ResourceGroupName%-vnet` and `%ResourceGroupName%-subnet`, respectively. E.g.: if Resource group name of Aerospike server VM = `TestRg` then Vnet name = `TestRg-vnet` and subnet name = `TestRg-subnet`.
3. Now, deploy the hey client VM using the ARM template in the same resource group with the existing vnet and subnet.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Faerospike-server-latency%2Fdeploy-hey-client.json)

4. hey client will be installed in the `/root/go/bin` directory. To check execute following commands
    ```bash
    sudo su -
    cd /root/go/bin
    ls -l
    ```
5. Before starting hey client, run the following command. This will verify that hey VM is able to access the web application installed on 2nd VM (Java benchmarking client VM) and will write some data in Aerospike server database which be read by hey client.
    ```bash
    curl 172.17.17.5:8882/write -w '\n'
    ```
6. Executing hey client
    ```bash
    ./hey [options...] http://172.17.17.5:8882/read
    ```