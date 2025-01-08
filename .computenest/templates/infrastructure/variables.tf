variable "instance_charge_type" {
  type    = string
  default = "PostPaid"
  description = "付费类型"
}

variable "period" {
  type  = number
  default = 1
  description = "购买资源时长"
}

variable "period_unit" {
  type    = string
  default = "Month"
  description = "购买资源时长周期"
}

variable "zone_id" {
  type        = string
  description = "可用区"
}


variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc."
  type        = string
  default     = "192.168.0.0/16"
}


variable "vswitch_cidrs" {
  description = "List cidr blocks used to create several new vswitches when 'new_vpc' is true."
  type        = string
  default     = "192.168.1.0/24"
}

variable "login_password"{
  type        = string
  sensitive   = true
  description = "实例密码"

}

variable "worker_instance_types"{
  type        = string
  default     =  "ecs.g6.large"
  description = "Worker节点规格"
}

variable "worker_disk_category" {
  description = "Worker 系统盘磁盘类型"
  type        = string
  default     = "cloud_essd"
}

variable "worker_disk_size" {
  description = "Worker节点系统盘大小(GB)"
  type        = number
  default     = 120
}

variable "pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them. If vpc's cidr block is `172.16.XX.XX/XX`, it had better to `192.168.XX.XX/XX` or `10.XX.XX.XX/XX`."
  type        = string
  default     = "10.0.0.0/16"
}

variable "service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them. Its setting rule is same as `k8s_pod_cidr`."
  type        = string
  default     = "172.16.0.0/16"
}
