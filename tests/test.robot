*** Settings ***
Documentation     A test suite to test the functionality of e-commerce web app
...
...               This test has a workflow that is created using keywords in
...               the imported resource file.
Resource          ../resources/resource.robot
Resource	  ../resources/keywords.resource
Library           SeleniumLibrary
Test Teardown     Close All Browsers

*** Test Cases ***
Verify Cart Checkout
    Open Browser and Navigate To Page
    Input Username    standard_user
    Input Password    secret_sauce
    Submit Credentials
    Welcome Page Should Be Open
    Click On Product    Sauce Labs Bike Light
    Add To Cart
    Click Shopping Cart
    Click Checkout
    Input FirstName	Tim
    Input LastName	Test
    Input PostalCode	3130
    Click Continue
    Product and Price Should Be Shown
    Click Finish
    Confirm Order Complete
Verify Add All Products then remove Product via Product Selection
    Open Browser and Navigate To Page
    Input Username    standard_user
    Input Password    secret_sauce
    Submit Credentials
    Welcome Page Should Be Open 
    Add All Products to Cart
    Confirm All Products in Cart
    Remove Product From Cart
    Confirm Product Removed from Cart
Verify Product Sorting/Filtering
    Open Browser and Navigate To Page
    Input Username    standard_user
    Input Password    secret_sauce
    Submit Credentials
    Welcome Page Should Be Open
    Select Sorting As	Name (Z to A)
    Verify Sorting Is Correct

Verify Product Sorting/Filtering for Name (A to Z)
    Open Browser and Navigate To Page
    Input Username    standard_user
    Input Password    secret_sauce
    Submit Credentials
    Welcome Page Should Be Open
    Select Sorting As	Price (high to low)
    Select Sorting As	Name (A to Z)
    Verify Sorting Is Correct