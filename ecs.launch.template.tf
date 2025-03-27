resource "aws_launch_template" "ecs_ec2" {
  name                   = "cluster-n8n-qm"
  image_id               = "ami-06576e7f3e9f61770"
  instance_type          = "t4g.small"
  vpc_security_group_ids = [aws_security_group.n8n_cluster_ec2.id]
  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = false }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config;
      
      echo '#!/bin/bash' > /etc/rc.d/init.d/set_sysctl
      echo 'sysctl -w vm.overcommit_memory=1' >> /etc/rc.d/init.d/set_sysctl
      chmod +x /etc/rc.d/init.d/set_sysctl
      
      chkconfig --add set_sysctl
      service set_sysctl start

    EOF
  )
}
