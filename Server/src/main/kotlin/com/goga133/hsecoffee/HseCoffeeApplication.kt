package com.goga133.hsecoffee

import com.goga133.hsecoffee.service.ImageStorageService
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class HseCoffeeApplication {
    companion object{
        @JvmStatic
        fun main(args: Array<String>) {
            runApplication<HseCoffeeApplication>(*args)

            ImageStorageService().init()
        }

    }

}
