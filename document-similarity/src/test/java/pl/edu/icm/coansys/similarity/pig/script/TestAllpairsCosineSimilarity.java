/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package pl.edu.icm.coansys.similarity.pig.script;

import java.io.IOException;
import org.apache.hadoop.fs.Path;
import org.apache.pig.pigunit.Cluster;
import org.apache.pig.pigunit.PigTest;
import org.apache.pig.tools.parameters.ParseException;
import org.junit.AfterClass;
import org.junit.BeforeClass;


/**
 *
 * @author akawa
 */

public class TestAllpairsCosineSimilarity {

    private PigTest test;
    private static Cluster cluster;
    private static final String PIG_SCRIPT_DIR = "src/main/pig/";
    private static final String[] params = {
        "tfidfPath=null",
        "outputPath=null",
        "commonJarsPath=."
    };

    @BeforeClass
    public static void beforeClass() throws Exception {
        cluster = PigTest.getCluster();
    }

    @AfterClass
    public static void afterClass() throws Exception {
        cluster.delete(new Path("pigunit-input-overriden.txt"));
    }

    @org.testng.annotations.Test(groups = {"fast"})
    public void testSingle() throws IOException, ParseException {

        test = new PigTest(PIG_SCRIPT_DIR + "allpairs_similarity.pig", params);

        String[] input = {
            "d1\tt1\t1",
            "d1\tt2\t2",
            "d2\tt1\t3",
            "d2\tt2\t4"
        };

        // verify intermdiate data
        String[] similaritiesOutput = {
            "(d1,d2," + (3d + 8d) / (Math.sqrt(5) * Math.sqrt(9+16)) + ")"
        };
        test.assertOutput("TFIDF", input, "S1", similaritiesOutput);    
    }
}