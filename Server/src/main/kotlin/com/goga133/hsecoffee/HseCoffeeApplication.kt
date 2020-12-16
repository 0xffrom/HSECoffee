package com.goga133.hsecoffee

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class HseCoffeeApplication {
    companion object{
        @JvmStatic
        fun main(args: Array<String>) {
            runApplication<HseCoffeeApplication>(*args)
        }
    }

}
