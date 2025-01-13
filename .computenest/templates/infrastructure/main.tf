resource "alicloud_vpc" "new_vpc" {
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "new_vsw" {
  vpc_id       = alicloud_vpc.new_vpc.id
  cidr_block   = var.vswitch_cidrs
  zone_id      = var.zone_id
}

resource "alicloud_security_group" "security_group" {
  description = "security group"
  vpc_id      = alicloud_vpc.new_vpc.id
}

resource "alicloud_security_group_rule" "allow_80_tcp" {
  type              = "egress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/1"
  priority          = 1
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_pod_cidr" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = var.pod_cidr
}

resource "alicloud_security_group_rule" "allow_service_cidr" {
  type              = "ingress"
  ip_protocol       = "all"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "-1/-1"
  priority          = 1
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = var.service_cidr
}


resource "alicloud_cs_managed_kubernetes" "ack" {
  worker_vswitch_ids = [alicloud_vswitch.new_vsw.id]
  new_nat_gateway      = true
  pod_cidr             = var.pod_cidr
  service_cidr         = var.service_cidr
  slb_internet_enabled = true
  cluster_spec         = "ack.pro.small"
  security_group_id    =  alicloud_security_group.security_group.id
  addons {
    name   = "flannel"
    config = ""
  }
}

resource "alicloud_cs_kubernetes_node_pool" "default_node_pool" {
  name                 = "default_node_pool"
  cluster_id           = alicloud_cs_managed_kubernetes.ack.id
  vswitch_ids          = [alicloud_vswitch.new_vsw.id]
  instance_types       = [var.worker_instance_types]
  system_disk_category = var.worker_disk_category
  system_disk_size     = var.worker_disk_size
  password = var.login_password
  desired_size         = 3
}


data "alicloud_cs_cluster_credential" "auth" {
  cluster_id                 = alicloud_cs_managed_kubernetes.ack.id
  temporary_duration_minutes = 60
  output_file                = "${path.module}/kubeconfig.yaml"
}

provider "helm" {
  kubernetes {
    config_context = ""
    config_path = "${path.module}/kubeconfig.yaml"
    insecure = true
  }
}

resource "helm_release" "springboot" {
  depends_on = [data.alicloud_cs_cluster_credential.auth]
  name  = "springboot"
  chart = "${path.module}/software/spring-boot-chart"
}
