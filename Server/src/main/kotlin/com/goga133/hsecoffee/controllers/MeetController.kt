package com.goga133.hsecoffee.controllers

import com.goga133.hsecoffee.service.EmailService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseStatus

@Controller
class MeetController {

    @RequestMapping(value = ["/api/meet"], method = [RequestMethod.GET])
    fun getMeet(): ResponseEntity<String> {

    }

    @RequestMapping(value = ["/api/meet"], method = [RequestMethod.POST])
    fun findMeet(): ResponseEntity<String> {

    }

    @RequestMapping(value = ["/api/meet"], method = [RequestMethod.DELETE])
    fun stopMeet(): ResponseEntity<String> {

    }


}