package cucumber.options;

import org.junit.runner.RunWith;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;

import org.junit.runner.RunWith;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
@RunWith(Cucumber.class)
@CucumberOptions(features="src/test/java/demoFeature",plugin ="json:target/jsonReports/cucumber-report.json" , tags= ("@GetBalanceforSameBroker") ,glue= {"stepDefinations"})
public class JunitTestRunner {
	//tags= ("@UpdateOrder1")
	
	
	
}
