# backend: code_analysis_backend run_unittest_backend run_integratetest_backend build_backend start_service run_robot_requests stop_service
backend: code_analysis_backend run_unittest_backend run_integratetest_backend build_backend start_service run_integratetest_backend_by_robot stop_service

run_robot_selinium: 
	python3 -m robot test/ui/shopping_cart_success.robot

run_robot_requests:
	sleep 20
	cat tearup/init.sql | docker exec -i store-database /usr/bin/mysql -u sealteam --password=sckshuhari --default-character-set=utf8  toy
	python3 -m robot test/api/checkout-success-template.robot

code_analysis_backend:
	cd store-service && docker build -t toy-store-service:0.0.2 -f Dockerfile.run .
	docker network create mini-shopping-cart_default
	cd store-service && docker run --name store-service_1 --network=mini-shopping-cart_default --rm -v "${PWD}/store-service":/usr/src/myapp -w /usr/src/myapp toy-store-service:0.0.2 go vet ./...
	# cd store-service && go vet ./...

run_unittest_backend:
	cd store-service && docker run --name store-service_1 --network=mini-shopping-cart_default --rm -v "${PWD}/store-service":/usr/src/myapp -w /usr/src/myapp toy-store-service:0.0.2 go test ./... -v
	# cd store-service && go test ./... -v

run_integratetest_backend:
	docker-compose up -d store-database bank-gateway shipping-gateway
	sleep 20
	cat tearup/init.sql | docker exec -i store-database /usr/bin/mysql -u sealteam --password=sckshuhari --default-character-set=utf8  toy
	sleep 20
	cd store-service && docker run --name store-service_1 --network=mini-shopping-cart_default --rm -v "${PWD}/store-service":/usr/src/myapp -w /usr/src/myapp toy-store-service:0.0.2 go test -tags=integration ./...
	# cd store-service && go test -tags=integration ./...
	docker-compose down | true

build_backend:
	docker-compose build store-service

start_service:
	docker-compose up -d
	sleep 20

status_service:
	docker-compose ps

stop_service:
	docker-compose down

seed:
	cat tearup/init.sql | docker exec -i store-database /usr/bin/mysql -u sealteam --password=sckshuhari --default-character-set=utf8  toy

run_integratetest_backend_by_newman:
	make seed && newman run atdd/api/ซื้อสินค้าได้สำเร็จ_v2.json -d atdd/api/data/test-data.json -e atdd/api/environment/local.json

run_integratetest_backend_by_newman_with_reports:
	make seed && newman run atdd/api/ซื้อสินค้าได้สำเร็จ_v2.json -d atdd/api/data/test-data.json -e atdd/api/environment/local.json -r htmlextra --reporter-htmlextra-export atdd/api/reports/buy_order_sucess.html

run_integratetest_backend_by_robot:
	make seed && robot atdd/api-robot/shopping-cart-sucess.robot
	
run_integratetest_backend_by_robot_change_url:
	make seed && robot -v url:http://127.0.0.1:8000 atdd/api-robot/shopping-cart-sucess.robot
	
run_integratetest_backend_by_robot_select_env_file:
	make seed && robot -V atdd/api-robot/environment/local.yml atdd/api-robot/shopping-cart-sucess.robot
	
run_test_fake:
	robot atdd/api-robot/test-faker.robot
	

