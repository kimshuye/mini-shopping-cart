# Mini Shopping Cart

## Install newman

```bashs

npm i -g newman@5.2.2 newman-reporter-htmlextra@1.20.1

```

## Command-line

### Start Docker Compose

```sh
docker-compose up -d
```

### Run Robot Selenium

```sh
cd test/ui
robot shopping_cart_success.robot
```

### Run Robot Requests

```sh
cd test/api
robot checkout-success-template.robot
```

### Stop Docker Compose

```sh
docker-compose down
```

## Make

### Start Docker Compose

```sh
make start_service
```

### Run Robot Selenium

```sh
make run_robot_selinium
```

### Run Robot Requests

```sh
make run_robot_requests
```

### Run newman Integratetestion Test

```sh
make run_integratetest_backend_by_newman
```

### Run newman Integratetestion Test with Reports

```sh
make run_integratetest_backend_by_newman_with_reports
```


### Stop Docker Compose

```sh
make stop_service
```
