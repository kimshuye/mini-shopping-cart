*** Settings ***
Library     RequestsLibrary
Library     Collections
Suite Setup    Create Session   ${session_name}   ${url}
Suite Teardown    Delete All Sessions
Test Template    ซื้อสินค้าที่มีชื่อว่า Product

Resource    ./resource/shopping-cart-sucess.robot

*** Test Cases ***          name                        id          quantity    total_price

ซื้อสินค้าที่มีชื่อว่า dinner Set     43 Piece dinner Set         ${2}        ${1}        ${14.95}

ซื้อสินค้าที่มีชื่อว่า Bicycle        Balance Training Bicycle    ${1}        ${2}        ${241.90}


*** Keywords ***

ซื้อสินค้าที่มีชื่อว่า Product
    [Arguments]    ${product_name}    ${product_id}    ${quantity}    ${total_price}
    ค้นหารายการสินค้า    ${product_id}    ${product_name}
    เลือกดูรายละเอียดสินค้า    ${product_id}    ${product_name}
    เพิ่มสินค้าลงตะกร้า    ${product_id}    ${quantity}    ${total_price}
    เลือกวิธีการชำระเงิน และได้รับข้อความแจ้งเตือน    ${total_price}
