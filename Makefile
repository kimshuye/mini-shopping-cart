backend: code_analysis_backend run_unittest_backend run_integratetest_backend build_backend start_service run_robot_requests stop_service

run_robot_selinium: 
	python3 -m robot test/ui/shopping_cart_success.robot

run_robot_requests:
	sleep 10
	#cat tearup/init.sql | docker exec -i store-database /usr/bin/mysql -u sealteam --password=sckshuhari --default-character-set=utf8  toy
	python3 -m robot test/api/checkout-success-template.robot

code_analysis_backend:
	cd store-service && go vet ./...

run_unittest_backend:
	cd store-service && go test ./... -v

run_integratetest_backend:
	docker-compose up -d store-database bank-gateway shipping-gateway
	sleep 10
	#cat tearup/init.sql | docker exec -i store-database /usr/bin/mysql -u sealteam --password=sckshuhari --default-character-set=utf8  toy
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

run_integratetest_backend_by_newman:
	make seed && newman run atdd/api/ซื้อสินค้าได้สำเร็จ_v2.json -d atdd/api/data/test-data.json -e atdd/api/environment/local.json

run_integratetest_backend_by_newman_with_reports:
	make seed && newman run atdd/api/ซื้อสินค้าได้สำเร็จ_v2.json -d atdd/api/data/test-data.json -e atdd/api/environment/local.json -r htmlextra --reporter-htmlextra-export atdd/api/reports/buy_order_sucess.html

