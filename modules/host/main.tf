resource "null_resource" "assign_host" {
  count      = var.host_count

  triggers = {
      HOSTNAME       = element(var.host_vms, count.index)
      LOCATION       = var.location_name
      API_KEY        = var.ibmcloud_api_key
      REGION         = var.ibm_region
      RESOURCE_GROUP = var.resource_group
      ENDPOINT       = var.endpoint
      PROVIDER       = var.host_provider
  }

  provisioner "local-exec" {
    when = create
    command = ". ${path.module}/../../modules/host/scripts/host.sh"
    environment = {
      hostname       = element(var.host_vms, count.index)
      index          = count.index
      LOCATION       = var.location_name
      API_KEY        = var.ibmcloud_api_key
      REGION         = var.ibm_region
      RESOURCE_GROUP = var.resource_group
      ENDPOINT       = var.endpoint
      PROVIDER       = var.host_provider
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = ". ${path.module}/../../modules/location/scripts/destroy.sh"
    environment = {
      hostname       = self.triggers.HOSTNAME
      LOCATION       = self.triggers.LOCATION
      API_KEY        = self.triggers.API_KEY
      REGION         = self.triggers.REGION
      RESOURCE_GROUP = self.triggers.RESOURCE_GROUP
      ENDPOINT       = self.triggers.ENDPOINT
    }
  }

}

output "assign_host" {
  value = null_resource.assign_host
}