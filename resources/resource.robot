*** Settings ***
Library           SeleniumLibrary
Library           String
Library           ../libraries/chrome_options.py

*** Variables ***
${BASE_URL}=      https://www.saucedemo.com

*** Keywords ***
Open Browser and Navigate To Page
    ${options}    Get Chrome Options
    Open Browser    browser=chrome    options=${options}
    Go to    ${BASE_URL}