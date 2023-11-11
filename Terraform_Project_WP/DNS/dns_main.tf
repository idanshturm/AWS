resource "aws_route53_zone" "WP_DNS_Public_Hosted_Zone" {
  name = "onlysuccess.link"
}


resource "aws_route53_record" "WP_record" {
  zone_id = aws_route53_zone.WP_DNS_Public_Hosted_Zone.zone_id
  name    = "www"
  type    = "A"
  
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.ALB_zone_id 
    evaluate_target_health = true
  }

}



