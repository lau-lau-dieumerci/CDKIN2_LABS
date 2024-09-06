# Tutoriel GitHub : Lancer une Infrastructure avec AWS CloudFormation

## Objectif

Créer une infrastructure AWS en utilisant AWS CloudFormation, comprenant deux instances EC2 et un bucket S3.

## Prérequis

- Compte AWS
- Connaissances de base en AWS CloudFormation
- AWS CLI configuré sur votre machine locale (facultatif mais recommandé)

## Étapes

### 1. Créer un Fichier de Modèle CloudFormation

Créez un fichier YAML (par exemple, `infrastructure.yml`) qui définit votre infrastructure. Voici un exemple de modèle CloudFormation pour créer deux instances EC2 et un bucket S3.

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Créer deux instances EC2 et un bucket S3'

Resources:
  # Création du bucket S3
  MyS3Bucket:
    Type: 'AWS::S3::Bucket'
    Properties:
      BucketName: 'my-unique-bucket-name-12345'  # Remplacez par un nom de bucket unique

  # Création de la première instance EC2
  MyEC2Instance1:
    Type: 'AWS::EC2::Instance'
    Properties:
      InstanceType: 't2.micro'
      ImageId: 'ami-0abcdef1234567890'  # Remplacez par l'AMI ID souhaité
      KeyName: 'my-key-pair'  # Remplacez par le nom de votre clé SSH
      Tags:
        - Key: 'Name'
          Value: 'MyEC2Instance1'

  # Création de la deuxième instance EC2
  MyEC2Instance2:
    Type: 'AWS::EC2::Instance'
    Properties:
      InstanceType: 't2.micro'
      ImageId: 'ami-0abcdef1234567890'  # Remplacez par l'AMI ID souhaité
      KeyName: 'my-key-pair'  # Remplacez par le nom de votre clé SSH
      Tags:
        - Key: 'Name'
          Value: 'MyEC2Instance2'

Outputs:
  S3BucketName:
    Description: 'Nom du bucket S3'
    Value: !Ref MyS3Bucket

  EC2Instance1Id:
    Description: 'ID de la première instance EC2'
    Value: !Ref MyEC2Instance1

  EC2Instance2Id:
    Description: 'ID de la deuxième instance EC2'
    Value: !Ref MyEC2Instance2
```

### 2. Déployer le Modèle CloudFormation

#### 2.1. Utiliser la Console AWS

1. Connectez-vous à la [console AWS CloudFormation](https://console.aws.amazon.com/cloudformation).
2. Cliquez sur **Créer une stack**.
3. Sélectionnez **Télécharger un fichier template** et téléchargez le fichier `infrastructure.yml`.
4. Cliquez sur **Suivant**, puis remplissez les informations nécessaires (nom de la stack, paramètres, etc.).
5. Cliquez sur **Créer la stack** pour lancer le déploiement.

#### 2.2. Utiliser l'AWS CLI

Si vous préférez utiliser l'AWS CLI, vous pouvez déployer le modèle CloudFormation avec la commande suivante :

```bash
aws cloudformation create-stack --stack-name my-infrastructure-stack --template-body file://infrastructure.yml
```

### 3. Vérifier le Déploiement

Après le déploiement, vérifiez que les ressources ont été créées correctement :

1. Accédez à la [console AWS EC2](https://console.aws.amazon.com/ec2) pour voir les deux instances EC2.
2. Accédez à la [console AWS S3](https://console.aws.amazon.com/s3) pour voir le bucket S3.
3. Consultez la [console AWS CloudFormation](https://console.aws.amazon.com/cloudformation) pour vérifier l'état de la stack et les sorties.

### 4. Nettoyer les Ressources

Pour supprimer les ressources lorsque vous n'en avez plus besoin :

1. Accédez à la [console AWS CloudFormation](https://console.aws.amazon.com/cloudformation).
2. Sélectionnez la stack que vous avez créée.
3. Cliquez sur **Supprimer** pour supprimer la stack et toutes les ressources associées.

### Conclusion

Ce tutoriel guide la création d'une infrastructure simple avec AWS CloudFormation, comprenant deux instances EC2 et un bucket S3.