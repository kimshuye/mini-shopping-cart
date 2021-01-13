backend: code_analysis_backend run_unittest_backend run_integratetest_backend build_backend start_service run_robot_requests stop_service

run_robot_selinium: 
	robot test/ui/shopping_cart_success.robot

run_robot_requests:
	sleep 10
	cat tearup/init.sql | docker exec -i store-database /usr/bin/mysql -u sealteam --password=sckshuhari --default-character-set=utf8  toy
	robot test/api/checkout-success-template.robot

code_analysis_backend:
	cd store-service && go vet ./...

run_unittest_backend:
	cd store-service && go test ./... -v

run_integratetest_backend:
	docker-compose up -d store-database bank-gateway shipping-gateway
	sleep 10
	cat tearup/init.sql | docker exec -i store-database /usr/bin/mysql -u sealteam --password=sckshuhari --default-character-set=utf8  toy
	cd store-service && go test -tags=integration ./...
	docker-compose down

build_backend:
	docker-compose build store-service

start_service:
	docker-compose up -d

status_service:
	docker-compose ps

stop_service:
	docker-compose down

seed:
	cat tearup/init.sql | docker exec -i store-database /usr/bin/mysql -u sealteam --password=sckshuhari --default-character-set=utf8  toy

