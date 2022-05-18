Feature: CSX Regression

  @PlaceGetDeleteOrder @Regression
  Scenario Outline: Verify place order , get order  and cancel order api
    Given Placing an order for broker "B2" of type "<type>" side "<side>" instrument "<instrument>" quantityType "<quantityType>" quantity "<quantity>" limitPrice "<limitPrice>" username "<username>"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "data.side" of response "<side>"
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    When Providing request PathUrl "PlaceOrder" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order cancelled"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

    Examples: 
      | type  | side | instrument | quantityType | quantity | limitPrice | username |
      | limit | BUY  | USDT/INR   | QUOTE        |    10000 |        102 | user1    |

  @UpdateOrder @Regression
  Scenario: Verify Update Order api
    Given Placing an order for broker "B2" of type "limit" side "BUY" instrument "USDT/INR" quantityType "QUOTE" quantity "10000" limitPrice "102" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
    Given Update an order for broker "B2" of  instrument "USDT/INR" quantityType "QUOTE" quantity "103.5" limitPrice "103" username "user1" orderType "LIMIT"
    When Providing request PathUrl "PlaceOrder" with method "PATCH"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order updated successfully"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

  @Add_Delete_IP @Regression
  Scenario: Verify Add IP and delete IP
    Given Add IP for a broker "B2"
    When Providing request PathUrl "AddIP" with method "POST"
    Then I verify the  "200" in step
    Then Extracting the data "data"
    When Providing request PathUrl "AddIP" with method "DELETE"
    Then I verify the  "200" in step
    And Verify key "message" of response "IP removed successfully"

  @CancelAllOrder @Regression
  Scenario: Verify CancelAllOrder
    #cancel all order from broker 1
    Given loading the header for broker "B1"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    #Then I verify the  "200" in step
    #And Verify key "message" of response "Orders cancellation in progress"
    #cancel all order from broker 2
    Given loading the header for broker "B2"
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"

  #Then I verify the  "200" in step
  #And Verify key "message" of response "Orders cancellation in progress"
  @GetAllOrder @Regression
  Scenario: Verify GetAllOrder
    Given loading the header for broker "B1"
    When Providing request PathUrl "GetAllOrders" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Orders fetched successfully"

  @GetAllIps @Regression
  Scenario: Verify GetAllIps
    Given loading the header for broker "B1"
    When Providing request PathUrl "AddIP" with method "GET"
    Then I verify the  "200" in step
    And Verify key "message" of response "Listed IPs for the Broker"
