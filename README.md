![carp](deco/carp.png)
# ARY1101-EXAMEN-Cloud — Automóvil Tech

Infraestructura como código (Terraform) para el EFT de Infraestructura Cloud II (DuocUC).
Migra, opera y gobierna en AWS la aplicación **Tienda-vehiculos** (catálogo de vehículos:
frontend Nginx + backend Node/Express + MySQL en RDS).

Este repo parte de mi propio trabajo previo (Prueba 3 / EP3) y se adapta y extiende para
el caso Automóvil Tech: se agrega el módulo ECR, se conecta el despliegue a la app real
(antes solo había un placeholder Nginx) y se reactivan Budgets/CloudTrail.

![line4](deco/line4.webp)
## Módulos incluidos

| Módulo       | Descripción                                                  |
|--------------|---------------------------------------------------------------|
| networking   | VPC, subnets públicas/privadas, IGW, route tables             |
| security     | Security Groups segmentados (ALB / EC2 / RDS)                 |
| ecr          | Repositorios ECR para frontend y backend                      |
| database     | RDS MySQL 8.0 Multi-AZ (db.t4g.small, 50GB gp3, cifrado)       |
| loadbalancer | Application Load Balancer + Target Group                      |
| compute      | EC2 Auto Scaling Group + Launch Template (despliega la app real vía Docker Compose desde ECR) |
| monitoring   | CloudWatch Alarms + SNS + Dashboard                            |
| budgets      | AWS Budgets con alertas 60/70/80/100% vía SNS                  |
| cloudtrail   | Auditoría de eventos + S3 para logs                            |
| governance   | (opcional/desactivado) IAM roles + política de tagging         |

![line3](deco/line3.webp)
## Estructura del repositorio

```
.
├── app/                        # Código fuente de la aplicación
│   ├── tienda-vehiculos-frontend/
│   ├── tienda-vehiculos-backend/
│   ├── tienda-vehiculos-db/init.sql
│   ├── stress_ec2_rds/         # Scripts de prueba de carga
│   └── build-and-push.sh       # Build + push de imágenes a ECR
├── environments/dev/           # Orquestación (main.tf, variables, outputs, backend)
├── modules/                    # Módulos Terraform reutilizables
├── scripts/user-data.sh.tpl    # Bootstrap EC2 (Docker + docker-compose con la app real)
└── .github/workflows/          # CI/CD: plan, apply, destroy
```
![line2](deco/line2.webp)
## Tagging obligatorio

| Tag         | Valor              |
|-------------|--------------------|
| Project     | automovil-tech     |
| Environment | dev                |
| Owner       | Chacon & Corp      |
| CostCenter  | vehiculos          |
| ManagedBy   | terraform          |

![line](deco/line.webp)

## Orden de despliegue (resumen — ver guía paso a paso completa)

1. `terraform apply -target=module.ecr` → crea solo los repos ECR.
2. `bash app/build-and-push.sh` → build + push de las imágenes.
3. `terraform apply` → despliega todo lo demás (red, RDS, ALB, ASG con la app ya en ECR, monitoreo, budgets, cloudtrail).
4. Cargar `app/tienda-vehiculos-db/init.sql` en el RDS.
5. Confirmar el correo de SNS.
6. Prueba de estrés → validar auto scaling y alarmas.
7. `terraform destroy` al terminar, para no gastar créditos del Lab.

![cookie](deco/cookie.png)