# 服务模板说明文档

## 说明

本项目以使用Helm Chart部署SpringBoot为例，介绍快速构建计算巢服务的流程。

## 部署架构

<img src="architecture.png" width="1500" height="700" align="bottom"/>

## 目录说明
.computenest: 计算巢根目录
- docs：相关文档说明
- templates: 模板相关配置
  - infrastructure: 基础设施相关配置
    - main.tf: 资源定义，即需要的云资源
    - output.tf: 输出定义，即服务部署完成后的输出
    - variables.tf: 参数定义，即需要用户填写的部署参数
  - ros_schema.yaml: ROS相关配置，计算巢使用的阿里云ROS托管的Terraform，定义此文件是为了更好的页面渲染效果
  - software：使用 Helm chart 编排容器应用包
  

## 详细说明
本仓库是使用Helm Chart部署SpringBoot的示例，您可根据自身项目架构及资源需求修改以下内容：
- 修改目录 .computenest/templates/infrastructure下的Terraform模板，其中main.tf 中定义要使用的云资源，您可以按需进行调整
- 修改Helm Chart软件配置包，您可根据需要替换为您自己的容器应用。
- 修改参数的页面渲染配置 .computenest/templates/ros_schema.yaml 的文件 ros_schema.yaml中分为三大部分：
  - Parameters： 与ROS类型模板参数（Parameters）语法相同, 其中参数的命名需要与variables.tf中参数命名保持一致，在渲染时则会按照Parameters中的配置进行展示
  - Metadata：与ROS类型模板参数（Metadata）语法相同，支持对Parameters中定义的参数进行分组，以及对自定义参数进行隐藏。
  - Outputs：与ROS类型模板输出（Outputs）语法相同，其中Outputs的value命名需要和output.tf中命令保持一致，需要最终在计算巢概览页中对用户展示的输出
