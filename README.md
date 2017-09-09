# ci-eb-deploy

Deploy your app to your elasticbeanstalk by using CircleCI 2.0

## Example

In `.circleci/config.yml` :


```yaml
version: 2
jobs:
  eb_deploy:
    docker:
      - image: hoshinotsuyoshi/ci-eb-deploy
        environment:
          ELASTIC_BEANSTALK_DEPLOY_APP_NAME: your-awesome-app
          ELASTIC_BEANSTALK_DEPLOY_ENV_NAME: staging
          ELASTIC_BEANSTALK_DEPLOY_REGION: ap-northeast-1
          ELASTIC_BEANSTALK_DEPLOY_PLATFORM: '64bit Amazon Linux 2014.03 v1.0.0 running Ruby 2.1 (Puma)'
    steps:
      - checkout
      - run:
          name: run eb deploy command
          command: /eb_deploy.sh
          no_output_timeout: 25m
```

## Environment variables

* DRY_RUN
  * If set, do not deploy
* ELASTIC_BEANSTALK_DEPLOY_APP_NAME
  * **required**
* ELASTIC_BEANSTALK_DEPLOY_ENV_NAME
  * **required**
* ELASTIC_BEANSTALK_DEPLOY_REGION
  * **required**
  * ex. `ap-northeast-1`
* ELASTIC_BEANSTALK_DEPLOY_PLATFORM
  * **required**
  * ex. `64bit Amazon Linux 2014.03 v1.0.0 running Ruby 2.1 (Puma)`
* ELASTIC_BEANSTALK_DEPLOY_TIMEOUT
  * default: `25`
