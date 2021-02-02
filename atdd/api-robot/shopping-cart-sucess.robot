*** Settings ***
Library     RequestsLibrary
Library     Collections
Suite Setup    Create Session   ${session_name}   ${url}
Suite Teardown    Delete All Sessions

# Resource    resource/data.robot

*** Variables ***
${url}=    http://localhost:8000
${session_name}=    toy_store
${text_format}=    application/json
&{accept}=   Accept=${text_format}    Content-Type=${text_format}



*** Test Cases ***

ซื้อสินค้าที่มีชื่อว่า 43 Piece dinner Set จำนวน 1 ชิ้น โดยชำระด้วยบัตรเครดิต แล้วชำระแล้วจะมีข้อความตอบกลับว่า ยืนยันการชำระพร้อม หมายเลขจัดส่ง
    ทำการชำระเงิน    43 Piece dinner Set    ${2}    ${1}    ${14.95}

ซื้อสินค้าที่มีชื่อว่า Balance Training Bicycle จำนวน 2 ชิ้น โดยชำระด้วยบัตรเครดิต แล้วชำระแล้วจะมีข้อความตอบกลับว่า ยืนยันการชำระพร้อม หมายเลขจัดส่ง
    ทำการชำระเงิน    Balance Training Bicycle    ${1}    ${2}    ${241.90}



*** Keywords ***

ค้นหารายการสินค้า
    [Arguments]    ${product_id}    ${product_name}
    ## arrange

    ## act
    # ${productList}=   Get Request   ${session_name}   /api/v1/product    headers=&{accept}
    ${productList}=   Get On Session   ${session_name}   /api/v1/product    headers=&{accept}    expected_status=200
    
    ## assert
    # Status Should Be  200   ${productList}
    Should Be Equal As Integers    ${productList.json()["total"]}    31

    ${products}=    Get From Dictionary     ${productList.json()}    products
    Set Test Variable    ${products}    ${products}
    ${id}=    Set Variable    ${0}
    FOR     ${product}    IN     @{products}
        ${id}=      Set Variable    ${product["id"]}
        Run Keyword If    '${product["product_name"]}' == '${product_name}'   Exit For Loop
        ${id}=      Set Variable    ${0}
    END
    Should Be True     ${id} != 0    product id should not equal 0
    # Set Test Variable    ${product_id}    ${id}

    
เลือกดูรายละเอียดสินค้า
    [Arguments]    ${product_id}    ${product_name}


    # ${productDetail}=   Get Request   ${session_name}   /api/v1/product    headers=&{accept}
    
    # Status Should Be  200   ${productDetail}
    ${productDetail}=   Get On Session   ${session_name}   /api/v1/product/${product_id}    headers=&{accept}    expected_status=200
    Should Be Equal As Integers    ${productDetail.json()["id"]}    ${product_id}
    Should Be Equal As Strings    ${productDetail.json()["product_name"]}    ${product_name}
    
    
    
เพิ่มสินค้าลงตะกร้า
    [Arguments]    ${product_id}    ${quantity}    ${total_price}
    # ${body}=    To Json    {"cart":[{"product_id": 2,"quantity": 1}], "shipping_method": "Kerry", "shipping_address": "405/37 ถ.มหิดล", "shipping_sub_district": "ท่าศาลา", "shipping_district": "เมือง", "shipping_province": "เชียงใหม่", "shipping_zip_code": "50000", "recipient_name": "ณัฐญา ชุติบุตร", "recipient_phone_number": "0970809292"}
    &{cart}=    Create Dictionary    product_id=${product_id}    quantity=${quantity}
    @{carts}=    Create List    ${cart}
    &{body}=    Create Dictionary    cart=${carts}    shipping_method=Kerry    shipping_address=405/37 ถ.มหิดล    shipping_sub_district=ท่าศาลา    shipping_district=เมือง    shipping_province=เชียงใหม่    shipping_zip_code=50000    recipient_name=ณัฐญา ชุติบุตร    recipient_phone_number=0970809292

    ${orderStatus}=    POST On Session    ${session_name}    /api/v1/order    expected_status=200    json=${body}    headers=&{accept}
    
    # Request Should Be Successful    ${orderStatus}
    Should Be Equal As Numbers    ${orderStatus.json()["total_price"]}    ${total_price}
    Set Test Variable    ${order_id}    ${orderStatus.json()["order_id"]}

เลือกวิธีการชำระเงิน และได้รับข้อความแจ้งเตือน
    [Arguments]    ${total_price}
    
    &{body}=    Create Dictionary    order_id=${order_id}    payment_type=credit    type=visa    card_number=4719700591590995    cvv=752    expired_month=${7}    expired_year=${20}    card_name=Karnwat Wongudom    total_price=${total_price}

    ${productList}=   Get On Session   ${session_name}   /mockTime/01032020T13:30:00    headers=&{accept}    expected_status=200
    ${orderStatus}=    POST On Session    ${session_name}    /api/v1/confirmPayment    expected_status=200    json=${body}    headers=&{accept}
    
    # Request Should Be Successful    ${orderStatus}
    Should Be Equal As Strings    ${orderStatus.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ ${order_id} คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900

ทำการชำระเงิน
    [Arguments]    ${product_name}    ${product_id}    ${quantity}    ${total_price}
    ค้นหารายการสินค้า    ${product_id}    ${product_name}
    เลือกดูรายละเอียดสินค้า    ${product_id}    ${product_name}
    เพิ่มสินค้าลงตะกร้า    ${product_id}    ${quantity}    ${total_price}
    เลือกวิธีการชำระเงิน และได้รับข้อความแจ้งเตือน    ${total_price}

