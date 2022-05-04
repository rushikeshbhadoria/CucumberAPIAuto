Feature: Verify funds for diffrent broker



    
    
  @GetBalanceforSameBroker @Regression
  Scenario: Verify funds for same broker in fulfilled case
    Given take balance of "INR" with api "Getbalance" with name "s1b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s1b1btc"
    Given Placing an order of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "5000" limitPrice "3500000" username "user1"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    And Verify key "data.status" of response "OPEN"
  Then give sleep of "20000"
    
    Given Placing an order of type "limit" side "BUY" instrument "btc/inr" quantityType "quote" quantity "10000" limitPrice "3500000" username "user2"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    
    
   
   
    Then give sleep of "20000"
    
    Given take balance of "INR" with api "Getbalance" with name "s2b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s2b1btc"
    #placing 2nd order for matching
    Given Placing an order of type "limit" side "SELL" instrument "btc/inr" quantityType "quote" quantity "5000" limitPrice "3500000" username "user3"
    When Providing request PathUrl "PlaceOrder" with method "POST"
    Then I verify the  "200" in step
    And Verify key "message" of response "Order placed successfully"
    And Verify the "data.orderID" of response "GetOrder"
    #cancel all order from broker 1
    When Providing request PathUrl "CancelAllOrders" with method "DELETE"
    Given take balance of "INR" with api "Getbalance" with name "s3b1inr"
    Given take balance of "BTC" with api "Getbalance" with name "s3b1btc"
    Then Check fees "3" for same broker