# E2E Simulation and Testing

It includes resources to automate setup and some benchmarking/testing commands for:

1. Aerospike server latency simulation and testing
2. MySQL benchmarking

## Aerospike server latency simulation and testing

### Setup Environment - 2 VM

Following are the instructions to setup 3 VM environment for Aerospike server latency simulation and testing

1. Deploy Aerospike server VM using the "Deploy to Azure" button given below.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Faerospike-server-latency%2Fdeploy-aerospike-server.json)

2. Name of the Vnet and subnet will be `%ResourceGroupName%-vnet` and `%ResourceGroupName%-subnet`, respectively. E.g.: if Resource group name = `TestRg` then Vnet name = `TestRg-vnet` and subnet name = `TestRg-subnet`.
3. Now, deploy the Aerospike Java benchmarking client VM using the ARM template in the same resource group with the existing vnet and subnet.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Faerospike-server-latency%2Fdeploy-aerospike-java-benchmark-client.json)

4. Create a 3rd VM using Azure portal in the same resource group with the existing vnet and subnet. This VM will be used to ping the Aerospike server VM and Java benchmark client VM.

### Executing Java benchmark client

#### Instructions

Following are the instructions to execute Java benchmark client:

1. Login to the Java benchmarking client VM.
2. Switch to root.
    ```bash
    sudo su -
    ```
3. Change directory.
    ```bash
    cd aerospike-client-java/benchmarks/
    ```
4. Check and execute the commands given in the [Commands](###Commands) section below.

#### Commands

If private IP of Aerospike server = `10.0.0.4`

```bash
./run_benchmarks -h 10.0.0.4 -p 3000 -n test -k 10000000 -b 1 -o B:256 -w RU,80 -g 6000 -T 1 -z 8 -latency ycsb
```

OR

```bash
./run_benchmarks -h 10.0.0.4 -p 3000 -n test -k 10000000 -b 1 -o B:256 -w RU,80 -g 6000 -T 1 -z 8 -latency alt,7,1,us
```

### Setup Environment - 3 VM

1. First setup the Aerospike server and Java benchmark client using the instructions in [Setup Environment - 2 VM](###Setup Environment - 2 VM).

2. Now, deploy the hey client VM using the ARM template in the same resource group with the existing vnet and subnet.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Faerospike-server-latency%2Fdeploy-hey-client.json)