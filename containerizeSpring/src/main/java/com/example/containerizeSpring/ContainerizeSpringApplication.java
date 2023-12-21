package com.example.containerizeSpring;

import org.apache.catalina.connector.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.annotation.Bean;
import org.springframework.context.event.EventListener;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.time.format.DateTimeFormatter;
import java.time.Instant;
import java.time.LocalDateTime;
import java.net.http.*;


@SpringBootApplication
@RestController
public class ContainerizeSpringApplication {

	private static final Logger log = LoggerFactory.getLogger(ContainerizeSpringApplication.class);

	@Autowired
	private CompaniesRepository CR;

	@Autowired
	private ComplexRepository CoR;

	@Autowired
	private FruitsRepository FR;

	@Autowired
	private VegetableRepository VR;

	@Autowired
	private VehicleRepository VeR;

	Companies companies = new Companies("Fujitsu");
	Complex complex = new Complex("Fujitsu", "Gurke", "Apfel", 1, 2, 3);
	Fruits fruits = new Fruits("Apfel");
	Vegetable vegetable = new Vegetable("Gurke");
	Vehicle vehicle = new Vehicle("VW");

	private static long startTime = 0;
	private static long endTime = 0;

	public static void main(String[] args) {
		SpringApplication.run(ContainerizeSpringApplication.class, args);
	}

	@GetMapping("/complex")
    public String getComplex(){
		Iterable<Complex> temp = CoR.findAll();
		return temp.toString();
    }

	@GetMapping("/companies")
    public String getCompanies(){
		Iterable<Companies> temp = CR.findAll();
		return temp.toString();
    }

	@GetMapping("/fruits")
    public String getFruits(){
		Iterable<Fruits> temp = FR.findAll();
		return temp.toString();
    }

	@GetMapping("/vegetable")
    public String getVegetable(){
		Iterable<Vegetable> temp = VR.findAll();
		return temp.toString();
    }

	@GetMapping("/Vehicle")
    public String getVehicle(){
		Iterable<Vehicle> temp = VeR.findAll();
		return temp.toString();
    }

	@PostMapping("/complex")
	public String postComplex(@RequestBody String s){
		String[] newS = s.split(",");
		Complex entity = new Complex(newS[0], newS[1], newS[2], Integer.parseInt(newS[3]), Integer.parseInt(newS[4]), Integer.parseInt(newS[5]));
		Complex m = CoR.save(entity);
		return m.toString();
	}

	@PostMapping("/companies")
	public String postCompanies(@RequestBody String s){
		Companies entity = new Companies(s);
		Companies m = CR.save(entity);
		return m.toString();
	}

	@PostMapping("/fruits")
	public String postFruits(@RequestBody String s){
		Fruits entity = new Fruits(s);
		Fruits m = FR.save(entity);
		return m.toString();
	}

	@PostMapping("/vegetable")
	public String postVegetable(@RequestBody String s){
		Vegetable entity = new Vegetable(s);
		Vegetable m = VR.save(entity);
		return m.toString();
	}

	@PostMapping("/vehicle")
	public String postVehicle(@RequestBody String s){
		Vehicle entity = new Vehicle(s);
		Vehicle m = VeR.save(entity);
		return m.toString();
	}

	@DeleteMapping("/complex")
	public void deleteComplex(@RequestBody String s) {
		long ss = Long.parseLong(s);
		CoR.deleteById(ss);
	}

	@DeleteMapping("/companies")
	public void deleteCompanies(@RequestBody String s) {
		long ss = Long.parseLong(s);
		CR.deleteById(ss);
	}

	@DeleteMapping("/fruits")
	public void deleteFruits(@RequestBody String s) {
		System.out.print("here");
		long ss = Long.parseLong(s);
		FR.deleteById(ss);
	}

	@DeleteMapping("/vegetable")
	public void deleteVegetable(@RequestBody String s) {
		long ss = Long.parseLong(s);
		VR.deleteById(ss);
	}

	@DeleteMapping("/vehicle")
	public void deleteVehicle(@RequestBody String s) {
		long ss = Long.parseLong(s);
		VeR.deleteById(ss);
	}
}
