# Educación IT - Terraform

## Introducción

El siguiente proyecto propone levantar una máquina virtual en la nube de AWS, y conectarse a la misma a través de una IP pública y utilizando el protocolo SSH, que utilizará un juego de llaves público-privado.

## Credenciales de AWS

Antes que nada, para correr la automatización se requieren unas credenciales `ACCESS_KEY` y `SECRET_KEY` válidas. Las mismas se pueden insertar en la configuración del "provider" dentro del archivo `provider.tf` (la parte comentada) o bien, configurar con AWS-CLI, a través del comando `aws configure`.

## Claves Público-Privado

Ahora, corresponde generar un juego de llaves público-privado con el comando `ssh-keygen -t rsa -f terraform-ec2-key`, dentro de la carpeta del proyecto de Terraform.

## Ejecutar la automatización

Levantar la infraestructura con el comando `terraform init` y luego aplicar automatización con `terraform apply`.

## Conexión final

Cuando termine de correr la automatización, Terraform devolverá la IP pública del servidor en forma de salida, y luego se debe establecer una conexión a la máquina virtual con el comando `ssh -i terraform-ec2-key ubuntu@XXX.XXX.XXX.XXX`, forzando la utilización de la llave privada.
