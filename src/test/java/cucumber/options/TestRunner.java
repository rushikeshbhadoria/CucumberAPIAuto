package cucumber.options;

import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import io.cucumber.testng.CucumberOptions;
import io.cucumber.testng.FeatureWrapper;
import io.cucumber.testng.PickleWrapper;
import io.cucumber.testng.TestNGCucumberRunner;

@CucumberOptions(features = "src/test/java/features/ETHINR.feature", glue = "stepDefinations", plugin = { "pretty",
"json:target/cucumber.json" } , dryRun = false)
public class TestRunner {
	private TestNGCucumberRunner cucumberRunner;
	
	@BeforeClass(alwaysRun = true)
	public void setUp() {
		cucumberRunner = new TestNGCucumberRunner(this.getClass());
	}

	@Test(dataProvider = "scenarios")
	public void runScenario(PickleWrapper wrapper, FeatureWrapper featureWrapper) {
		cucumberRunner.runScenario(wrapper.getPickle());
	}

	@DataProvider
	public Object[][] scenarios() {
		if (cucumberRunner == null) {
			return new Object[0][0];
		}
		return cucumberRunner.provideScenarios();
	}

	@AfterClass(alwaysRun = true)
	public void destroy() {
		if (cucumberRunner == null) {
			return;
		}
		cucumberRunner.finish();
	}

}
