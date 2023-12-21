import java.sql.Date;
import java.text.SimpleDateFormat;
import org.acme.vertx.*;

import javax.enterprise.event.Observes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import io.quarkus.runtime.StartupEvent;
import io.quarkus.runtime.annotations.QuarkusMain;
import java.io.IOException;
import java.net.*;
import java.net.http.*;

public class TestRun {
    public static void main(String[] args) {
        FruitRessource FR = new FruitRessource();
        VehicleRessource VR = new VehicleRessource();
        VegetableRessource VeR = new VegetableRessource();;
        CompaniesRessource CR = new CompaniesRessource();
        ComplexRessource CoR = new ComplexRessource();

        HttpClient client = HttpClient.newHttpClient();

        long insertAll = 0;
        long getAll = 0;
        long deleteAll = 0;

        // POST Http request
        HttpRequest FRPostrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/fruits/"))
            .POST(HttpRequest.BodyPublishers.ofString("orange"))
            .version(HttpClient.Version.HTTP_2)
            .build();

        HttpRequest VRPostrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/vehicle"))
            .POST(HttpRequest.BodyPublishers.ofString("VW"))
            .version(HttpClient.Version.HTTP_2)
            .build();

        HttpRequest VeRPostrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/vegetable"))
            .POST(HttpRequest.BodyPublishers.ofString("Gurke"))
            .version(HttpClient.Version.HTTP_2)
            .build();

        HttpRequest CRPostrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/companies"))
            .POST(HttpRequest.BodyPublishers.ofString("Fujitsu"))
            .version(HttpClient.Version.HTTP_2)
            .build();

        HttpRequest CoRPostrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/complex"))
            .POST(HttpRequest.BodyPublishers.ofString("Orange,VW,Fujitsu,1,2,3"))
            .version(HttpClient.Version.HTTP_2)
            .build();

        //GET Http request
        HttpRequest FRrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/fruits/"))
            .GET()
            .version(HttpClient.Version.HTTP_2)
            .build();

        HttpRequest VRrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/vehicle"))
            .GET()
            .version(HttpClient.Version.HTTP_2)
            .build();

        HttpRequest VeRrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/vegetable"))
            .GET()
            .version(HttpClient.Version.HTTP_2)
            .build();

        HttpRequest CRrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/companies"))
            .GET()
            .version(HttpClient.Version.HTTP_2)
            .build();

        HttpRequest CoRrequest = HttpRequest.newBuilder()
            .uri(URI.create("http://79.125.47.90:8080/complex"))
            .GET()
            .version(HttpClient.Version.HTTP_2)
            .build();

        System.out.println(new java.util.Date());
        for(int j = 0; j < 1; j++){
            //Insert
            System.out.print("Start Insert the " + (j+1) + " time\n");
            long insert1 = System.currentTimeMillis();
            for(int i = 1; i < 1001; i++) {

                try {
                    HttpResponse FRresponse = client.send(FRPostrequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse VRresponse = client.send(VRPostrequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse VeRresponse = client.send(VeRPostrequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse CRresponse = client.send(CRPostrequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse CoRresponse = client.send(CoRPostrequest, HttpResponse.BodyHandlers.ofString());
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            long insert2 = System.currentTimeMillis();
            System.out.print("End Insert the " + (j+1) + " time\n");

            //GET
            System.out.print("Start Get the " + (j+1) + " time\n");
            long get1 = System.currentTimeMillis();
            for(int i = 1; i < 1001; i++) {
                try {
                    HttpResponse FRresponse = client.send(FRrequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse VRresponse = client.send(VRrequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse VeRresponse = client.send(VeRrequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse CRresponse = client.send(CRrequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse CoRresponse = client.send(CoRrequest, HttpResponse.BodyHandlers.ofString());
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            long get2 = System.currentTimeMillis();
            System.out.print("End Get the " + (j+1) + " time\n");

            //DELETE
            System.out.print("Start Delete the " + (j+1) + " time\n");
            long delete1 = System.currentTimeMillis();
            for(int i = 1; i < 1001; i++){
                HttpRequest FRDeleterequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://79.125.47.90:8080/fruits/"))
                    .method("DELETE", HttpRequest.BodyPublishers.ofString(i + ""))
                    .version(HttpClient.Version.HTTP_2)
                    .build();

                HttpRequest VRDeleterequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://79.125.47.90:8080/vehicle"))
                    .method("DELETE", HttpRequest.BodyPublishers.ofString(i + ""))
                    .version(HttpClient.Version.HTTP_2)
                    .build();

                HttpRequest VeRDeleterequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://79.125.47.90:8080/vegetable"))
                    .method("DELETE", HttpRequest.BodyPublishers.ofString(i + ""))
                    .version(HttpClient.Version.HTTP_2)
                    .build();

                HttpRequest CRDeleterequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://79.125.47.90:8080/companies"))
                    .method("DELETE", HttpRequest.BodyPublishers.ofString(i + ""))
                    .version(HttpClient.Version.HTTP_2)
                    .build();

                HttpRequest CoRDeleterequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://79.125.47.90:8080/complex"))
                    .method("DELETE", HttpRequest.BodyPublishers.ofString(i + ""))
                    .version(HttpClient.Version.HTTP_2)
                    .build();

                try {
                    HttpResponse FRresponse = client.send(FRDeleterequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse VRresponse = client.send(VRDeleterequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse VeRresponse = client.send(VeRDeleterequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse CRresponse = client.send(CRDeleterequest, HttpResponse.BodyHandlers.ofString());
                    HttpResponse CoRresponse = client.send(CoRDeleterequest, HttpResponse.BodyHandlers.ofString());
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            long delete2 = System.currentTimeMillis();
            System.out.print("End Delete the " + (j+1) + " time\n");

            insertAll += insert2 - insert1;
            getAll += get2 - get1;
            deleteAll += delete2 - delete1;
        }
        System.out.print("\n\n\n==========\n" +
            "Average Insert Time: " + insertAll + "\n" +
            "Average Get Time: " + getAll + "\n" +
            "Average Delte Time: " + deleteAll + "\n" +
            "==========\n\n\n");
        System.out.println(new java.util.Date());
    }
}