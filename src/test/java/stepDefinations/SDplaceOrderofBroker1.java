package stepDefinations;

import static io.restassured.RestAssured.given;

import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import static io.restassured.RestAssured.given;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONObject;

import java.util.*;
import static org.junit.Assert.*;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.restassured.RestAssured;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.builder.ResponseSpecBuilder;
import io.restassured.filter.log.RequestLoggingFilter;
import io.restassured.filter.log.ResponseLoggingFilter;
import io.restassured.http.ContentType;
import io.restassured.path.json.JsonPath;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import io.restassured.specification.ResponseSpecification;
import resource.Utils;
import resource.APIResources;

public class SDplaceOrderofBroker1 extends Utils {

	RequestSpecification res, res1, res2, res3, res4, res5;
	ResponseSpecification resspec;
	Response response;
	// TestDataBuild data =new TestDataBuild();
	static String order_id;
	String ENUM;
	JSONObject post = new JSONObject();
	// JSONObject postb2 = new JSONObject();

	public SDplaceOrderofBroker1() throws IOException {
		res1 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1());
		res5 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker2());
	}

	@Given("Placing an order of type {string} side {string} instrument {string} quantityType {string} quantity {string} limitPrice {string} username {string}")
	public void placing_an_order_of_type_side_instrument_quantity_type_quantity_limit_price_username(String orderType,
			String orderSide, String instruments, String quantityType, String quantity, String limitPrice,
			String username) throws IOException {

		String placeOrderBody = "{\r\n" + "    \"type\": \"" + orderType + "\",\r\n" + "    \"side\": \"" + orderSide
				+ "\",\r\n" + "    \"instrument\": \"" + instruments + "\",\r\n" + "    \"quantityType\": \""
				+ quantityType + "\",\r\n" + "    \"quantity\": " + quantity + ",\r\n" + "  \"limitPrice\": "
				+ limitPrice + ",    \r\n" + "  \"username\": \"" + username + "\"\r\n" + "}";

		res2 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1()).body(placeOrderBody);
		res1 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1());
		resspec = new ResponseSpecBuilder().expectContentType(ContentType.JSON).build();

	}

	@When("Providing request PathUrl {string} with method {string}")
	public void providing_request_path_url_with_method(String resource, String method) throws IOException {
		APIResources resourceAPI = APIResources.valueOf(resource);
		ENUM = resourceAPI.getResource();
		// System.out.println(resourceAPI.getResource());

		if (method.equalsIgnoreCase("POST"))
			response = res2.when().post(resourceAPI.getResource());
		else if (method.equalsIgnoreCase("GET"))
			response = res1.when().get(resourceAPI.getResource());
		else if (method.equalsIgnoreCase("PATCH"))
			response = res3.when().patch(ENUM + order_id);
		else if (resource.equalsIgnoreCase("CancelAllOrders"))
			response = res1.when().delete(ENUM);
		else if (method.equalsIgnoreCase("DELETE"))
			response = res1.when().delete(ENUM + order_id);

	}

	@Then("I verify the  {string} in step")
	public void i_verify_the_in_step(String string) {
		int statuscode = response.getStatusCode();
		String code = Integer.toString(statuscode);
		assertEquals(code, string);
		System.out.println(response.asPrettyString());
	}

	@Then("Verify key {string} of response {string}")
	public void verify_key_of_response(String string, String string2) {
		JsonPath js = response.jsonPath();
		String side = js.get(string).toString();
		assertEquals(side, string2);
	}

	@Then("Verify the {string} of response {string}")
	public void verify_the_of_response(String orderID, String pathOfAPI) throws IOException {
		order_id = getJsonPath(response, orderID);
		// System.out.println(order_id);
		res = given().spec(requestSpecificationOfBroker1());
		providing_request_path_url_with_method(pathOfAPI, "GET");
		response = res1.when().get(ENUM + order_id);
		String actualName = getJsonPath(response, "data.orderID");
		assertEquals(actualName, order_id);

	}

	@Given("Update an order of  instrument {string} quantityType {string} quantity {string} limitPrice {string} username {string} orderType {string}")
	public void update_an_order_of_instrument_quantity_type_quantity_limit_price_username(String instruments,
			String quantityType, String quantity, String limit_Price, String username, String orderType)
			throws IOException {
		String updateOrder = "{\r\n" + "    \"type\": \"" + orderType + "\",\r\n" + "    \"instrument\": \""
				+ instruments + "\",\r\n" + "    \"quantityType\": \"" + quantityType + "\",\r\n" + "    \"quantity\": "
				+ quantity + ",\r\n" + "  \"limit_Price\": " + limit_Price + ",    \r\n" + "  \"username\": \""
				+ username + "\"\r\n" + "}";
		res3 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1()).body(updateOrder);

	}

	@Given("Add IP for a broker")
	public void add_ip_for_a_broker() throws IOException {
		java.util.Scanner s = new java.util.Scanner(new java.net.URL("https://api.ipify.org").openStream(), "UTF-8")
				.useDelimiter("\\A");
		res2 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker1())
				.body("{\r\n" + "    \"Address\": \"" + s.next() + "\"}");

	}

	// method for extracting the data
	@Then("Extracting the data {string}")
	public void Extracting_the_data(String string) {
		JsonPath js = response.jsonPath();
		order_id = js.get(string).toString();

	}

	@Given("take balance of {string} with api {string} with name {string}")
	public void take_balance_of_with_api_with_name(String asset, String api, String name) throws IOException {

		providing_request_path_url_with_method(api, "GET");
		response = res1.when().get(ENUM + "?asset=" + asset);
		String actualName = getJsonPath(response, "data.balance");
		double balance = Double.parseDouble(actualName);

		post.put(name, balance);
		System.out.println(name + " = " + post.get(name));
	}

	@Then("Calculate fees for same broker")
	public void calculate_fees_for_same_broker() {

		double s1b1inr = (double) post.get("s1b1inr");
		double s3b1inr = (double) post.get("s3b1inr");
		double FEE = s1b1inr - s3b1inr;
		double s1b1btc = (double) post.get("s1b1btc");
		double s3b1btc = (double) post.get("s3b1btc");
		if (s1b1btc - s3b1btc == 0) {
			System.out.println("BTC is Same");
		} else {
			System.out.println("difference between BTC is found");
		}

	}

////////////////////////////////////////////////////////BROKER2 SECTION////////////////////////////////////////////////////////////////////////////////////

	@Given("For_Broker2_Placing an order of type {string} side {string} instrument {string} quantityType {string} quantity {string} limitPrice {string} username {string}")
	public void For_Broker2_placing_an_order_of_type_side_instrument_quantity_type_quantity_limit_price_username(
			String orderType, String orderSide, String instruments, String quantityType, String quantity,
			String limitPrice, String username) throws IOException {

		String placeOrderBody = "{\r\n" + "    \"type\": \"" + orderType + "\",\r\n" + "    \"side\": \"" + orderSide
				+ "\",\r\n" + "    \"instrument\": \"" + instruments + "\",\r\n" + "    \"quantityType\": \""
				+ quantityType + "\",\r\n" + "    \"quantity\": " + quantity + ",\r\n" + "  \"limitPrice\": "
				+ limitPrice + ",    \r\n" + "  \"username\": \"" + username + "\"\r\n" + "}";

		res2 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker2()).body(placeOrderBody);
		res5 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker2());
		resspec = new ResponseSpecBuilder().expectContentType(ContentType.JSON).build();

	}

	@When("For_Broker2_Providing request PathUrl {string} with method {string}")
	public void For_Broker2_providing_request_path_url_with_method(String resource, String method) throws IOException {
		APIResources resourceAPI = APIResources.valueOf(resource);
		ENUM = resourceAPI.getResource();
		// System.out.println(resourceAPI.getResource());

		if (method.equalsIgnoreCase("POST"))
			response = res2.when().post(resourceAPI.getResource());
		else if (method.equalsIgnoreCase("GET"))
			response = res5.when().get(resourceAPI.getResource());
		else if (method.equalsIgnoreCase("PATCH"))
			response = res3.when().patch(ENUM + order_id);
		else if (method.equalsIgnoreCase("DELETE"))
			response = res5.when().delete(ENUM + order_id);

	}

	@Then("For_Broker2_I verify the  {string} in step")
	public void For_Broker2_i_verify_the_in_step(String string) {
		int statuscode = response.getStatusCode();
		String code = Integer.toString(statuscode);
		assertEquals(code, string);
	}

	@Then("For_Broker2_Verify key {string} of response {string}")
	public void For_Broker2_verify_key_of_response(String string, String string2) {
		JsonPath js = response.jsonPath();
		String side = js.get(string).toString();
		assertEquals(side, string2);
	}

	@Then("For_Broker2_Verify the {string} of response {string}")
	public void For_Broker2_verify_the_of_response(String orderID, String pathOfAPI) throws IOException {
		order_id = getJsonPath(response, orderID);
		// System.out.println(order_id);
		res = given().spec(requestSpecificationOfBroker2());
		For_Broker2_providing_request_path_url_with_method(pathOfAPI, "GET");
		response = res5.when().get(ENUM + order_id);
		String actualName = getJsonPath(response, "data.orderID");
		assertEquals(actualName, order_id);

	}

	@Given("For_Broker2_Update an order of  instrument {string} quantityType {string} quantity {string} limitPrice {string} username {string} orderType {string}")
	public void For_Broker2_update_an_order_of_instrument_quantity_type_quantity_limit_price_username(
			String instruments, String quantityType, String quantity, String limit_Price, String username,
			String orderType) throws IOException {
		String updateOrder = "{\r\n" + "    \"type\": \"" + orderType + "\",\r\n" + "    \"instrument\": \""
				+ instruments + "\",\r\n" + "    \"quantityType\": \"" + quantityType + "\",\r\n" + "    \"quantity\": "
				+ quantity + ",\r\n" + "  \"limit_Price\": " + limit_Price + ",    \r\n" + "  \"username\": \""
				+ username + "\"\r\n" + "}";
		res3 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker2()).body(updateOrder);

	}

	@Given("For_Broker2_Add IP for a broker")
	public void For_Broker2_add_ip_for_a_broker() throws IOException {
		java.util.Scanner s = new java.util.Scanner(new java.net.URL("https://api.ipify.org").openStream(), "UTF-8")
				.useDelimiter("\\A");
		res2 = given().relaxedHTTPSValidation().spec(requestSpecificationOfBroker2())
				.body("{\r\n" + "    \"Address\": \"" + s.next() + "\"}");

	}

	// method for extracting the data
	@Then("For_Broker2_Extracting the data {string}")
	public void For_Broker2_Extracting_the_data(String string) {
		JsonPath js = response.jsonPath();
		order_id = js.get(string).toString();

	}

	@Given("For_Broker2_take balance of {string} with api {string} with name {string}")
	public void For_Broker2_take_balance_of_with_api_with_name(String asset, String api, String name)
			throws IOException {

		For_Broker2_providing_request_path_url_with_method(api, "GET");
		response = res5.when().get(ENUM + "?asset=" + asset);
		String actualName = getJsonPath(response, "data.balance");
		double balance = Double.parseDouble(actualName);

		post.put(name, balance);
		System.out.println(name + " = " + post.get(name));
	}

	@Then("For_Broker2_Calculate fees for same broker")
	public void For_Broker2_calculate_fees_for_same_broker() {

		double s1b1inr = (double) post.get("s1b1inr");
		double s3b1inr = (double) post.get("s3b1inr");
		double FEE = s1b1inr - s3b1inr;
		System.out.println(FEE);

	}

	@Then("Calculate fees for diffrent broker")
	public void calculate_fees_for_diffrent_broker() {
		System.out.println("-------------------------------------------------------------------------------------");
		// Deduction_of_INR_from_broker1
		double s1b1inr = (double) post.get("s1b1inr");
		double s3b1inr = (double) post.get("s3b1inr");
		double Deduction_of_INR_from_broker1 = s1b1inr - s3b1inr;
		System.out.println("Deduction_of_INR_from_broker1 = " + Deduction_of_INR_from_broker1);
		System.out.println("-------------------------------------------------------------------------------------");
		// Addition_of_INR_in_broker2
		double s3b2inr = (double) post.get("s3b2inr");
		double s1b2inr = (double) post.get("s1b2inr");
		double Addition_of_INR_in_broker2 = s3b2inr - s1b2inr;
		System.out.println("Addition_of_INR_in_broker2 = " + Addition_of_INR_in_broker2);
		System.out.println("-------------------------------------------------------------------------------------");
		// Addition_of_BTC_to_broker1
		double s3b1btc = (double) post.get("s3b1btc");
		double s1b1btc = (double) post.get("s1b1btc");
		double Addition_of_BTC_to_broker1 = s3b1btc - s1b1btc;
		System.out.println("Addition_of_BTC_to_broker1 = " + Addition_of_BTC_to_broker1);
		System.out.println("-------------------------------------------------------------------------------------");
		// Deduction_of_BTC_to_broker2
		double s1b2btc = (double) post.get("s1b2btc");
		double s3b2btc = (double) post.get("s3b2btc");
		double Deduction_of_BTC_to_broker2 = s1b2btc - s3b2btc;
		System.out.println("Deduction_of_BTC_to_broker2 = " + Deduction_of_BTC_to_broker2);
		System.out.println("-------------------------------------------------------------------------------------");
		// CSX FEE
		double Fee_for_diffrent_broker = Deduction_of_INR_from_broker1 - Addition_of_INR_in_broker2;
		System.out.println("Fee_for_diffrent_broker = " + Fee_for_diffrent_broker);
		System.out.println("-------------------------------------------------------------------------------------");
	}

}
