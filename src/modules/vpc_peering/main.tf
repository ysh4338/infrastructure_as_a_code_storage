# Peering connection: ap-northeast-2 <-> us_east_1
resource "aws_vpc_peering_connection" "peering_ap_us" {
  vpc_id        = var.vpc_configs["ap-northeast-2"].vpc_id
  peer_vpc_id   = var.vpc_configs["us-west-2"].vpc_id
  peer_owner_id = var.vpc_configs["us-west-2"].account_id
  peer_region   = var.vpc_configs["us-west-2"].region
  auto_accept   = false

  tags = {
    Name = var.vpc_configs["ap-northeast-2"].peering_name
  }
}
resource "aws_vpc_peering_connection_accepter" "peering_accepter_us" {
  provider = aws.oregon

  vpc_peering_connection_id = aws_vpc_peering_connection.peering_ap_us.id
  auto_accept               = true
}

# dns option setting
resource "aws_vpc_peering_connection_options" "peering_options_ap" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_ap_us.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.peering_accepter_us]
}
resource "aws_vpc_peering_connection_options" "peering_options_us" {
  provider = aws.oregon

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering_accepter_us.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection.peering_ap_us]
}


# routing table setting
resource "aws_route" "ap_to_us" {
  count                     = length(var.vpc_configs["ap-northeast-2"].route_table_ids)
  route_table_id            = var.vpc_configs["ap-northeast-2"].route_table_ids[count.index]
  destination_cidr_block    = var.vpc_configs["ap-northeast-2"].peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_ap_us.id

  depends_on = [aws_vpc_peering_connection_options.peering_options_ap]
}
resource "aws_route" "us_to_ap" {
  provider = aws.oregon
  
  count                     = length(var.vpc_configs["us-west-2"].route_table_ids)
  route_table_id            = var.vpc_configs["us-west-2"].route_table_ids[count.index]
  destination_cidr_block    = var.vpc_configs["us-west-2"].peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peering_accepter_us.id

  depends_on = [aws_vpc_peering_connection_options.peering_options_us]
}
