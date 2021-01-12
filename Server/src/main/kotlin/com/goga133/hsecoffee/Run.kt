package com.goga133.hsecoffee

import com.goga133.hsecoffee.service.ImageStorageService
import org.springframework.boot.SpringApplication

/**
 * Мейн метод для запуска Spring Boot приложения.
 */
fun main(args: Array<String>) {
    SpringApplication.run(HseCoffeeApplication::class.java, *args)

    ImageStorageService.init()
}