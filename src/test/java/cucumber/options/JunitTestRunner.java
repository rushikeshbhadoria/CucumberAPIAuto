package cucumber.options;

import org.junit.runner.RunWith;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;

import org.junit.runner.RunWith;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
@RunWith(Cucumber.class)
@CucumberOptions(features="src/test/java/feature/demo.feature",plugin ="json:target/jsonReports/cucumber-report.json" , tags= ("@CancelAllOrder") ,glue= {"stepDefinations"})
public class JunitTestRunner {
	//tags= ("@UpdateOrder1")
	
	
	
}
