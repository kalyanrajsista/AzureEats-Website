# Configure the App Service deployment to use a GitHub repo
param([Parameter(Mandatory)][string] $GitHubRepo = "https://github.com/kalyanrajsista/AzureEats-Website",
        [string] $branch = "master",
        [Parameter(Mandatory)][string] $SubscriptionId,
        [Parameter(Mandatory)][string] $AppId,
        [Parameter(Mandatory)][string] $Password,
        [Parameter(Mandatory)][string] $TenantId,
        [Parameter(Mandatory)][string] $AppServiceName,
        [Parameter(Mandatory)][string] $ResourceGroupName)

# Set subscription
az account set --subscription $SubscriptionId

# Login to Azure using service principal
az login --service-principal --username $AppId --password \"$Password\" --tenant $TenantId

# Configure GitHub
az webapp deployment source config --branch $branch --manual-integration --name $AppServiceName --repo-url $GitHubRepo --resource-group $ResourceGroupName
