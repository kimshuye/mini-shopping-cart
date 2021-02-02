*** Settings ***
Library     RequestsLibrary


*** Variables ***


*** Test Cases ***
ซื้อสินค้าได้สำเร็จ
    # ตั้งชื่อ step ให้สื่อ มีข้อมูลอะไร ต้องการอะไร คาดหวังผลลัพธ์อะไร
    Product list
    Product detail
    Submit order
    # Confirm payment



*** Keywords ***

Product list    
    # [Arguments]    {pam1}    {pam2}
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
    Create Session   toy_store   http://localhost:8000
    &{accept}=   Create Dictionary   Accept=application/json

    # ${productDetail}=   Get Request   toy_store   /api/v1/product    headers=&{accept}
    
    # Status Should Be  200   ${productDetail}
    ${productDetail}=   Get On Session   toy_store   /api/v1/product/2    headers=&{accept}    expected_status=200
    Should Be Equal As Integers    ${productDetail.json()["id"]}    2
    Should Be Equal As Strings    ${productDetail.json()["product_name"]}    43 Piece dinner Set
    Should Be Equal As Numbers    ${productDetail.json()["product_price"]}    12.95
    Should Be Equal As Integers    ${productDetail.json()["quantity"]}    10
    
    
Submit order
    Create Session   toy_store   http://localhost:8000
    ${order}=    To Json    {"cart":[{"product_id": 2,"quantity": 1}], "shipping_method": "Kerry", "shipping_address": "405/37 ถ.มหิดล", "shipping_sub_district": "ท่าศาลา", "shipping_district": "เมือง", "shipping_province": "เชียงใหม่", "shipping_zip_code": "50000", "recipient_name": "ณัฐญา ชุติบุตร", "recipient_phone_number": "0970809292"}
    &{post_headers}=    Create Dictionary    Accept=application/json    Content-Type=application/json

    ${orderStatus}=    POST On Session    toy_store    /api/v1/order    expected_status=200    json=${order}    headers=&{post_headers}
    
    # Request Should Be Successful    ${orderStatus}
    Should Be Equal As Numbers    ${orderStatus.json()["total_price"]}    14.95
    Set Test Variable    ${order_id}    ${orderStatus.json()["order_id"]}
    Should Be Equal As Strings    ${order_id}    8004359104

