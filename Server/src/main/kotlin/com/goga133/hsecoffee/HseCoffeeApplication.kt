package com.goga133.hsecoffee

import com.goga133.hsecoffee.service.ImageStorageService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.stereotype.Service

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
