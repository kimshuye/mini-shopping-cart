*** Settings ***
Library     RequestsLibrary
Library     Collections

*** Variables ***


*** Test Cases ***
ซื้อสินค้าได้สำเร็จ
    เข้าชมรายการสินค้า โดยค้นหาสินค้า ที่ชื่อว่า 43 Piece dinner Set
    เลือกดูรายละเอียดของสินค้า ที่ชื้อว่า 43 Piece dinner Set ว่าจำนวนของสินค้า คงเหลืออยู่ 10
    เพิ่มสินค้า ที่ชื้อว่า 43 Piece dinner Set ลงในตะกร้าสินค้า พร้อมแจ้งที่อยู่จัดส่ง จะได้รับ หมายเลขคำสั่งซื้อ ที่ 8004359104 และยอดที่จะต้องชำระคือ 14.95
    เลือกวิธีชำระเงินด้วย บัตรเครดิต พร้อมกรอกข้อมูลอื่นๆที่จำเป็น จะได้รับข้อความแจ้งเตือน ระบุหมายเลขจัดส่ง



*** Keywords ***

เข้าชมรายการสินค้า โดยค้นหาสินค้า ที่ชื่อว่า 43 Piece dinner Set    
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
    
เลือกดูรายละเอียดของสินค้าที่ชื้อว่า 43 Piece dinner Set ว่าจำนวนของสินค้า คงเหลืออยู่ 10
    Create Session   toy_store   http://localhost:8000
    &{accept}=   Create Dictionary   Accept=application/json

    # ${productDetail}=   Get Request   toy_store   /api/v1/product    headers=&{accept}
    
    # Status Should Be  200   ${productDetail}
    ${productDetail}=   Get On Session   toy_store   /api/v1/product/2    headers=&{accept}    expected_status=200
    Should Be Equal As Integers    ${productDetail.json()["id"]}    2
    Should Be Equal As Strings    ${productDetail.json()["product_name"]}    43 Piece dinner Set
    Should Be Equal As Numbers    ${productDetail.json()["product_price"]}    12.95
    Should Be Equal As Integers    ${productDetail.json()["quantity"]}    10
    
    
เพิ่มสินค้า ที่ชื้อว่า 43 Piece dinner Set ลงในตะกร้าสินค้า พร้อมแจ้งที่อยู่จัดส่ง จะได้รับ หมายเลขคำสั่งซื้อ ที่ 8004359104 และยอดที่จะต้องชำระคือ 14.95
    Create Session   toy_store   http://localhost:8000
    # ${body}=    To Json    {"cart":[{"product_id": 2,"quantity": 1}], "shipping_method": "Kerry", "shipping_address": "405/37 ถ.มหิดล", "shipping_sub_district": "ท่าศาลา", "shipping_district": "เมือง", "shipping_province": "เชียงใหม่", "shipping_zip_code": "50000", "recipient_name": "ณัฐญา ชุติบุตร", "recipient_phone_number": "0970809292"}

    &{cart}=    Create Dictionary    product_id=${2}    quantity=${1}
    @{carts}=    Create List    ${cart}
    &{body}=    Create Dictionary    cart=@{carts}    shipping_method=Kerry    shipping_address=405/37 ถ.มหิดล    shipping_sub_district=ท่าศาลา    shipping_district=เมือง    shipping_province=เชียงใหม่    shipping_zip_code=50000    recipient_name=ณัฐญา ชุติบุตร    recipient_phone_number=0970809292
    &{post_headers}=    Create Dictionary    Accept=application/json    Content-Type=application/json

    ${orderStatus}=    POST On Session    toy_store    /api/v1/order    expected_status=200    json=${body}    headers=&{post_headers}
    
    # Request Should Be Successful    ${orderStatus}
    Should Be Equal As Numbers    ${orderStatus.json()["total_price"]}    14.95
    Set Test Variable    ${order_id}    ${orderStatus.json()["order_id"]}
    Should Be Equal As Integers    ${order_id}    8004359104

เลือกวิธีชำระเงินด้วย บัตรเครดิต พร้อมกรอกข้อมูลอื่นๆที่จำเป็น จะได้รับข้อความแจ้งเตือน ระบุหมายเลขจัดส่ง
    Create Session   toy_store   http://localhost:8000
    
    &{body}=    Create Dictionary    order_id=${order_id}    payment_type=credit    type=visa    card_number=4719700591590995    cvv=752    expired_month=${7}    expired_year=${20}    card_name=Karnwat Wongudom    total_price=${14.95}
    &{post_headers}=    Create Dictionary    Accept=application/json    Content-Type=application/json

    ${orderStatus}=    POST On Session    toy_store    /api/v1/confirmPayment    expected_status=200    json=${body}    headers=&{post_headers}
    
    # Request Should Be Successful    ${orderStatus}
    Should Be Equal As Strings    ${orderStatus.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ ${order_id} คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900




