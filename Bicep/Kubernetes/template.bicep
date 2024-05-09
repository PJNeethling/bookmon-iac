param clusterName string = 'aks101cluster'
param location string = resourceGroup().location
param dnsPrefix string
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0
@minValue(1)
@maxValue(50)
param agentCount int = 3
param agentVMSize string = 'Standard_D2s_v3'
param linuxAdminUsername string
@secure()
param sshRSAPublicKey string

resource clusterName_resource 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
  }
}
output controlPlaneFQDN string =clusterName_resource.properties.fqdn
