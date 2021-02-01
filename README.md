# Mini Shopping Cart

## Install newman



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

### Stop Docker Compose

```sh
make stop_service
```
