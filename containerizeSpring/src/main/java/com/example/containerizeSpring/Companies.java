package com.example.containerizeSpring;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Companies {

  @Id
  @GeneratedValue(strategy=GenerationType.IDENTITY)
  private Long id;
  private String name;

  protected Companies() {}

  public Companies(String firstName) {
    this.name = firstName;
  }

  @Override
  public String toString() {
    return String.format(
        "Companies[id=%d, firstName='%s']",
        id, name);
  }

  public Long getId() {
    return id;
  }

  public String getFirstName() {
    return name;
  }
}