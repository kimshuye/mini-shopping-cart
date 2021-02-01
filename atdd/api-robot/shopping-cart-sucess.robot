*** Settings ***
Library     RequestsLibrary


*** Variables ***


*** Test Cases ***
ซื้อสินค้าได้สำเร็จ
    Product list
    # Product detail
    # Submit order
    # Confirm payment



*** Keywords ***

Product list
    # arrange
    Create Session   toy_store   http://localhost:8000
    &{accept}=   Create Dictionary   Accept=application/json

    # act
    ${productList}=   Get Request   toy_store   /api/v1/product    headers=&{accept}
    
    # assert
    Status Should Be  200   ${productList}
    Should Be Equal   ${productList.json()["total"]}   ${31}
    



