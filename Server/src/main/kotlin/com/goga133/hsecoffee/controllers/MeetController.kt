package com.goga133.hsecoffee.controllers

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.goga133.hsecoffee.data.status.CancelStatus
import com.goga133.hsecoffee.data.status.MeetStatus
import com.goga133.hsecoffee.entity.SearchParams
import com.goga133.hsecoffee.entity.User
import com.goga133.hsecoffee.service.JwtService
import com.goga133.hsecoffee.service.MeetService
import com.goga133.hsecoffee.service.UserService
import io.jsonwebtoken.ExpiredJwtException
import io.jsonwebtoken.JwtException
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod

@Controller
class MeetController {
    @Autowired
    private val jwtService: JwtService? = null

    @Autowired
    private val userService: UserService? = null

    @Autowired
    private val meetService: MeetService? = null

    @RequestMapping(value = ["/api/meet/{token}"], method = [RequestMethod.GET])
    fun getMeet(@PathVariable("token") token: String): ResponseEntity<String> {
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK)
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
        }
        val email: String =
            validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error with validation")

        val meet = meetService?.getMeet(
            userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("Error with user")
        )

        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(meet))
    }

    @RequestMapping(value = ["/api/meet/{token}"], method = [RequestMethod.POST])
    fun findMeet(@PathVariable("token") token: String,  @RequestBody searchParams: SearchParams): ResponseEntity<String> {
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK)
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
        }
        val email: String =
            validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error with validation")


        val meetStatus = meetService?.searchMeet(userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body("Error with user"), searchParams)

        return ResponseEntity.ok(jacksonObjectMapper().writeValueAsString(meetStatus))
    }

    @RequestMapping(value = ["/api/meet/{token}"], method = [RequestMethod.DELETE])
    fun cancelSearch(@PathVariable("token") token: String): ResponseEntity<String> {
        val validator = jwtService?.validateToken(token).apply {
            if (this?.httpStatus != HttpStatus.OK)
                return ResponseEntity.status(this?.httpStatus ?: HttpStatus.BAD_REQUEST).body(this?.message)
        }
        val email: String =
            validator?.email ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error with validation")

        val cancelStatus = meetService?.cancelSearch(userService?.getUserByEmail(email) ?: return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body("Error with user"))

        return when(cancelStatus){
            CancelStatus.SUCCESS -> ResponseEntity.ok("Success")
            else  -> ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Can't cancel search")
        }
    }
}