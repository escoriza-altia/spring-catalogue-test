package com.example.containerizeSpring;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Complex {

  @Id
  @GeneratedValue(strategy=GenerationType.IDENTITY)
  private Long id;
  private String name0;
  private String name1;
  private String name2;
  private int number0;
  private int number1;
  private int number2;

  protected Complex() {}

  public Complex(String name0, String name1, String name2, int number0, int number1, int number2) {
    this.name0 = name0;
    this.name1 = name1;
    this.name2 = name2;
    this.number0 = number0;
    this.number1 = number1;
    this.number2 = number2;
  }

  @Override
  public String toString() {
    return String.format(
        "Complex[id=%d, name0='%s', name1='%s', name2='%s', number0='%d', number1='%d', number2='%d']",
        id, name0, name1, name2, number0, number1, number2);
  }

  public Long getId() {
    return id;
  }

  public String getFirstName() {
    return name0;
  }
}