*** Settings ***
Library    FakerLibrary    locale=th_TH

*** Test Cases ***

FakerLibrary Words Generation
    ${words}=    FakerLibrary.Words
    Log    words: ${words}
    ${words}=    FakerLibrary.Words    nb=3
    Log    words: ${words}