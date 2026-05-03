package com.lifeflow.lifeflow.model;

import java.time.LocalDate;

public class DonationCamp {
    private int id;
    private String name;
    private String location;
    private LocalDate date;
    private String organizer;

    public DonationCamp() {
    }

    public DonationCamp(int id, String name, String location, LocalDate date, String organizer) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.date = date;
        this.organizer = organizer;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getOrganizer() {
        return organizer;
    }

    public void setOrganizer(String organizer) {
        this.organizer = organizer;
    }
}
