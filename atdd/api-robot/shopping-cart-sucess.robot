*** Settings ***
Library     RequestsLibrary


*** Variables ***


*** Test Cases ***
ซื้อสินค้าได้สำเร็จ
    Product list
    Product detail
    # Submit order
    # Confirm payment



*** Keywords ***

Product list
    ## arrange
    Create Session   toy_store   http://localhost:8000
    &{accept}=   Create Dictionary   Accept=application/json

    ## act
    # ${productList}=   Get Request   toy_store   /api/v1/product    headers=&{accept}
    
    ## assert
    # Status Should Be  200   ${productList}
    ${productList}=   Get On Session   toy_store   /api/v1/product    headers=&{accept}    expected_status=200
    Should Be Equal As Integers    ${productList.json()["total"]}    31
    Should Be Equal As Strings    ${productList.json()["products"][1]["product_name"]}    43 Piece dinner Set
    Should Be Equal As Numbers    ${productList.json()["products"][1]["product_price"]}    12.95
    
Product detail
    ## arrange
    Create Session   toy_store   http://localhost:8000
    &{accept}=   Create Dictionary   Accept=application/json

    ## act
    # ${productList}=   Get Request   toy_store   /api/v1/product    headers=&{accept}
    
    ## assert
    # Status Should Be  200   ${productList}
    ${productList}=   Get On Session   toy_store   /api/v1/product/2    headers=&{accept}    expected_status=200
    Should Be Equal As Integers    ${productList.json()["id"]}    2
    Should Be Equal As Strings    ${productList.json()["product_name"]}    43 Piece dinner Set
    Should Be Equal As Numbers    ${productList.json()["product_price"]}    12.95
    Should Be Equal As Integers    ${productList.json()["quantity"]}    10
    
    


