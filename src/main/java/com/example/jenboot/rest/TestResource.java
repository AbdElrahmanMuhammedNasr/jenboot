package com.example.jenboot.rest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestResource {

    @GetMapping("/hi")
    public String getHiMessage(){
        return "Hi Message";
    }
}
