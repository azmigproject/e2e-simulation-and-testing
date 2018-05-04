# E2E Simulation and Testing

It includes resources to automate setup and some benchmarking/testing commands for:

1. Aerospike server latency simulation and testing
2. MySQL benchmarking

## Aerospike server latency simulation and testing

Following are the instructions to setup 3 VM environment for Aerospike server latency simulation and testing

1. **Deploy Aerospike server VM** using the "Deploy to Azure" button given below.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Faerospike-server-latency%2Fdeploy-aerospike-server.json)

2. Name of the Vnet and subnet will be `%ResourceGroupName%-vnet` and `%ResourceGroupName%-subnet`, respectively. E.g.: if Resource group name = `TestRg` then Vnet name = `TestRg-vnet` and subnet name = `TestRg-subnet`.
3. Now, deploy the Aerospike Java benchmarking client VM using the ARM template in the same resource group with the existing vnet and subnet.

    [![Click to deploy template on Azure](http://azuredeploy.net/deploybutton.png "Click to deploy template on Azure")](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazmigproject%2Fe2e-simulation-and-testing%2Fmaster%2Faerospike-server-latency%2Fdeploy-aerospike-java-benchmark-client.json)

4. Create a 3rd VM using Azure portal in the same resource group with the existing vnet and subnet. This VM will be used to ping the Aerospike server VM and Java benchmark client VM.