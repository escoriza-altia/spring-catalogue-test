package com.example.containerizeSpring;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Vehicle {

  @Id
  @GeneratedValue(strategy=GenerationType.IDENTITY)
  private Long id;
  private String name;

  protected Vehicle() {}

  public Vehicle(String name) {
    this.name = name;
  }

  @Override
  public String toString() {
    return String.format(
        "Vehicle[id=%d, firstName='%s']",
        id, name);
  }

  public Long getId() {
    return id;
  }

  public String getFirstName() {
    return name;
  }
}