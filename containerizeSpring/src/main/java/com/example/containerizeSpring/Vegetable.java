package com.example.containerizeSpring;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Vegetable {

  @Id
  @GeneratedValue(strategy=GenerationType.IDENTITY)
  private Long id;
  private String name;

  protected Vegetable() {}

  public Vegetable(String name) {
    this.name = name;
  }

  @Override
  public String toString() {
    return String.format(
        "Vegetable[id=%d, firstName='%s']",
        id, name);
  }

  public Long getId() {
    return id;
  }

  public String getFirstName() {
    return name;
  }
}