*** Settings ***
Documentation     A resource file with reusable keywords and variables.
Library           SeleniumLibrary
Library		      Collections
Library           random

*** Variables ***
${TITLE}=	Swag Labs
@{PRODUCTS}=	sauce-labs-backpack	sauce-labs-bike-light	sauce-labs-bolt-t-shirt	sauce-labs-fleece-jacket	sauce-labs-onesie	test.allthethings()-t-shirt-(red)

*** Keywords ***
Input Username
	[Arguments]    ${username}
	Input Text     user-name    ${username}	
Input Password 
	[Arguments]    ${password}
	Input Text 	password    ${password}		
Submit Credentials
	Click Button 	login-button
Welcome Page Should Be Open
	Location Should Be    ${BASE_URL}/inventory.html
    	Title Should Be   ${TITLE} 
Click On Product
    [Arguments] 	${product}
    Click Link    xpath://div[@class="inventory_item_name" and text()="${product}"]/parent::a
	${price}=	Get Text	xpath://div[@class="inventory_details_price"]
	${price}=	Remove String	${price}	$
	${price}=	Convert to Number	${price}
	${productChoice}=    Get Text    xpath://div[@class="inventory_details_name large_size"]
	${price}=    Set Test Variable    ${price}
	${productChoice}=    Set Test Variable    ${productChoice}
Add To Cart  
	Click Button    xpath://button[text()="Add to cart"]
Click Shopping Cart
	Click Link	xpath://a[@class="shopping_cart_link"]
Click Checkout
	Click Button	checkout
Input FirstName
	[Arguments]    ${firstname}
	Input Text	first-name	${firstname}
Input LastName
	[Arguments]    ${lastname}
	Input Text	last-name	${lastname}
Input PostalCode
	[Arguments]    ${postalcode}
	Input Text	postal-code	${postalcode}
Click Continue
	Click Button	continue
Product and Price Should Be Shown
	${productSelected}=	Get Text	class:inventory_item_name
	Should be Equal	${productSelected}	${productChoice}
    ${ItemTotal}=    Get Text    xpath://div[@class="summary_subtotal_label"]
	Log    ${ItemTotal}
	${ItemTotal}=    Remove String    ${ItemTotal}    Item total: $
	${ItemTotal}=    Convert To Number    ${ItemTotal}
	Should Be Equal    ${ItemTotal}    ${Price}
Click Finish
	Click Button	finish
Confirm Order Complete
	${complete}=	Get Text	xpath://span
	Should Contain	${complete}	Complete
Add All Products to Cart
    ${getProductCount}=	Get Element Count    xpath://div[@class="inventory_item"]
    FOR    ${x}    IN RANGE    1    ${getProductCount} + 1
	    ${product}=    Get Text    xpath://div[@class="inventory_item"][${x}]/div/div/a/div
        Click On Product    ${product}
		Add To Cart
		Click Button    back-to-products
	END
	Set Test Variable    ${getProductCount}
Confirm All Products in Cart
	${productCount}=	Get Text	class:shopping_cart_badge
	${productCount}=    Convert To Number    ${productCount}
	Should be Equal	${productCount}	${getProductCount}
Remove From Cart
    Click Button    xpath://button[text()="Remove"]
Remove Product From Cart
    ${cartCount}=	Get Text	class:shopping_cart_badge
	${cartCount}=    Convert To Integer    ${cartCount}
	Set Test Variable    ${cartCount}
    ${t}=    Evaluate    random.randint(1, ${cartCount})
	Log    ${t}
    ${removeProduct} =    Get Text    xpath://div[@class="inventory_item"][${t}]/div/div/a/div
    Click On Product    ${removeProduct}
    Remove From Cart

Confirm Product Removed from Cart
	${productCount}=	Get Text	class:shopping_cart_badge
	${cartCount}=    Evaluate    ${cartCount} - 1
	Should Be Equal As Integers	${productCount}    ${cartCount}
Select Sorting As
	[Arguments] 	${sortingMethod}
	Select From List By Label	xpath://select	${sortingMethod}
	Set Test Variable    ${sortingMethod}
	Log    ${sortingMethod}
Verify Sorting Is Correct
    IF    '${sortingMethod}' == 'Price (low to high)'    Verify Sorting for Price Low/High
	...    ELSE IF    '${sortingMethod}' == 'Price (high to low)'    Verify Sorting for Price High/Low 
	...    ELSE IF    '${sortingMethod}' == 'Name (A to Z)'   Verify Sorting for Name (A to Z)
	...    ELSE    Verify Sorting for Name (Z to A)    
Verify Sorting for Price Low/High
	${count}=	Get Element Count	class:inventory_item_price
	@{sortedProductsPrices}=	create list
	@{originalProductsPrices}=	Obtain Prices and Sort
	FOR	${i}	IN RANGE	1	${count} + 1
		${sortedPrice}=	Get Text	xpath://div[@class="inventory_item"][${i}]//div[@class="inventory_item_price"]
		${sortedPrice}=	Remove String	${sortedPrice}	$
		${sortedPrice}=	Convert to Number	${sortedPrice}
		Append To List	${sortedProductsPrices}	${sortedPrice}
	END
	FOR	${index}	${var}	IN ENUMERATE	@{sortedProductsPrices}
		Log	${var}
		Log	${originalProductsPrices[${index}]}
		Should be Equal	${var}	${originalProductsPrices[${index}]}
	END
Obtain Prices and Sort 
	${count}=	Get Element Count	class:inventory_item_price
        @{sortedProductPrices}=	create list
	FOR	${i}	IN RANGE	1	${count} + 1
		${unsortedPrice}=	Get Text	xpath://div[@class="inventory_item"][${i}]//div[@class="inventory_item_price"]
		${unsortedPrice}=	Remove String	${unsortedPrice}	$
		${unsortedPrice}=	Convert to Number	${unsortedPrice}
		Append To List	${sortedProductPrices}	${unsortedPrice}
	END
	Log	${sortedProductPrices}
	Sort List	${sortedProductPrices}
	Log	${sortedProductPrices}
	RETURN	${sortedProductPrices}
Verify Sorting for Price High/Low
	${count}=	Get Element Count	class:inventory_item_price
	@{sortedProductsPrices}=	create list
	@{originalProductsPrices}=	Obtain Prices and Sort Reverse
	FOR	${i}	IN RANGE	1	${count} + 1
		${sortedPrice}=	Get Text	xpath://div[@class="inventory_item"][${i}]//div[@class="inventory_item_price"]
		${sortedPrice}=	Remove String	${sortedPrice}	$
		${sortedPrice}=	Convert to Number	${sortedPrice}
		Append To List	${sortedProductsPrices}	${sortedPrice}
	END
	FOR	${index}	${var}	IN ENUMERATE	@{sortedProductsPrices}
		Log	${var}
		Log	${originalProductsPrices[${index}]}
		Should be Equal	${var}	${originalProductsPrices[${index}]}
	END
Obtain Prices and Sort Reverse
	${count}=	Get Element Count	class:inventory_item_price
    @{sortedProductPrices}=	create list
	FOR	${i}	IN RANGE	1	${count} + 1
		${unsortedPrice}=	Get Text	xpath://div[@class="inventory_item"][${i}]//div[@class="inventory_item_price"]
		${unsortedPrice}=	Remove String	${unsortedPrice}	$
		${unsortedPrice}=	Convert to Number	${unsortedPrice}
		Append To List	${sortedProductPrices}	${unsortedPrice}
	END
	Log	${sortedProductPrices}
	Sort List	${sortedProductPrices}
	Log	${sortedProductPrices}
	Reverse List    ${sortedProductPrices}
	RETURN	${sortedProductPrices}
Verify Sorting for Name (A to Z)
	${count}=	Get Element Count	class:inventory_item_name
	@{sortedProductsNames}=    create list
	@{originalProductsNames} =    Obtain Product Names and Sort
	FOR	${i}	IN RANGE	1	${count} + 1
	    ${sortedName}=	Get Text	xpath://div[@class="inventory_item"][${i}]//div[@class="inventory_item_name"]
		Append To List	${sortedProductsNames}	${sortedName}
	END
	FOR	${index}	${var}	IN ENUMERATE	@{sortedProductsNames}
		Log	${var}
		Log	${originalProductsNames[${index}]}
		Should be Equal	${var}	${originalProductsNames[${index}]}
	END
Verify Sorting for Name (Z to A)
    ${count}=	Get Element Count	class:inventory_item_name
	@{sortedProductsNames}=    create list
	@{originalProductsNames} =    Obtain Product Names and Sort Reverse
	FOR	${i}	IN RANGE	1	${count} + 1
	    ${sortedName}=	Get Text	xpath://div[@class="inventory_item"][${i}]//div[@class="inventory_item_name"]
		Append To List	${sortedProductsNames}	${sortedName}
	END
	FOR	${index}	${var}	IN ENUMERATE	@{sortedProductsNames}
		Log	${var}
		Log	${originalProductsNames[${index}]}
		Should be Equal	${var}	${originalProductsNames[${index}]}
	END
Obtain Product Names and Sort
    ${count}=	Get Element Count	class:inventory_item_name
	@{sortedProductNames}=	create list
	FOR	${i}	IN RANGE	1	${count} + 1
	    ${unsortedName}=	Get Text	xpath://div[@class="inventory_item"][${i}]//div[@class="inventory_item_name"]
		Append To List	${sortedProductNames}	${unsortedName}
	END
	Log	${sortedProductNames}
	Sort List    ${sortedProductNames}
	RETURN    ${sortedProductNames}
Obtain Product Names and Sort Reverse
    ${count}=	Get Element Count	class:inventory_item_name
	@{sortedProductNames}=	create list
	FOR	${i}	IN RANGE	1	${count} + 1
	    ${unsortedName}=	Get Text	xpath://div[@class="inventory_item"][${i}]//div[@class="inventory_item_name"]
		Append To List	${sortedProductNames}	${unsortedName}
	END
	Log	${sortedProductNames}
	Sort List    ${sortedProductNames}
	Reverse List    ${sortedProductNames}
	RETURN    ${sortedProductNames}