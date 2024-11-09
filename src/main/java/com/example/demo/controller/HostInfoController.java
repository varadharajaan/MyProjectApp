package com.example.demo.controller;

import com.example.demo.model.HelloWorldBean;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;

@RestController
public class HostInfoController {

    @GetMapping(path = "/hello")
    public String helloWorld() {
        return "Hello World";
    }

    @GetMapping(path = "/hello-bean")
    public HelloWorldBean helloWorldBean() {
        // throw new RuntimeException("Some Error has Happened! Contact Support at
        // ***-***");
        return new HelloWorldBean("Hello World");
    }

    @GetMapping(path = "/hello/{name}")
    public HelloWorldBean helloWorldPathVariable(@PathVariable String name) {
        return new HelloWorldBean(String.format("Hello World, %s", name));
    }

    @GetMapping("/health")
    public String HealthCheck() {
        return "Healthy";
    }

    @GetMapping("/info")
    public String sayHello() {
        try {
            // Get the instance name (hostname) and limit it to the first 5 characters
            String hostname = InetAddress.getLocalHost().getHostName();
            String shortenedHostname = hostname.length() > 5 ? hostname.substring(0, 5) : hostname;
            // Return "Hello World v1" followed by the first 5 characters of the instance name
            return "Hello World - " + shortenedHostname;
        } catch (Exception e) {
            e.printStackTrace();
            return "Hello World - unknown";
        }
    }

    @GetMapping("/info-long")
    public String sayHelloLong() {
        try {
            // Get the instance name (hostname) and limit it to the first 5 characters
            String hostname = InetAddress.getLocalHost().getHostName();
            String shortenedHostname = hostname.length() > 5 ? hostname.substring(0, 5) : hostname;
            // Return "Hello World v1" followed by the first 5 characters of the instance name
            return "Hello World - " + hostname;
        } catch (Exception e) {
            e.printStackTrace();
            return "Hello World - unknown";
        }
    }

}
